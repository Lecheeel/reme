import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/question.dart';
import 'anki_importer.dart';

class AnkiImportResult {
  final String bankName;
  final List<Question> questions;
  final int skipped;
  final List<String> warnings;

  const AnkiImportResult({
    required this.bankName,
    required this.questions,
    required this.skipped,
    required this.warnings,
  });
}

/// 读取 Anki .apkg。优先使用新格式数据库，避免 collection.anki2 的升级占位数据。
class AnkiPackageReader {
  static const databaseNames = [
    'collection.anki21b',
    'collection.anki21',
    'collection.anki2',
  ];

  Future<AnkiImportResult> readFile(
    String path, {
    required String bankId,
    String? subject,
  }) async {
    final bytes = await File(path).readAsBytes();
    return readBytes(bytes, bankId: bankId, subject: subject);
  }

  Future<AnkiImportResult> readBytes(
    Uint8List bytes, {
    required String bankId,
    String? subject,
  }) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final entry = _selectDatabase(archive);
    if (entry == null) {
      throw const FormatException('APKG 中没有可识别的 collection 数据库');
    }

    final temp = await Directory.systemTemp.createTemp('reme_anki_');
    final dbPath = '${temp.path}${Platform.pathSeparator}collection.anki';
    try {
      await File(dbPath).writeAsBytes(entry.content as List<int>);
      final db = sqlite3.open(dbPath, mode: OpenMode.readOnly);
      try {
        final deckName = subject ?? _readDeckName(db) ?? 'Anki 题库';
        final rows = db.select('SELECT flds FROM notes ORDER BY id');
        final questions = <Question>[];
        var skipped = 0;
        final warnings = <String>[];
        for (final row in rows) {
          try {
            final fields = (row['flds'] as String).split('\x1f');
            questions.add(
              AnkiQuestionMapper.fromFields(
                fields,
                bankId: bankId,
                subject: deckName,
              ),
            );
          } on FormatException catch (e) {
            skipped++;
            if (warnings.length < 10) warnings.add(e.message);
          }
        }
        if (questions.isEmpty) {
          throw const FormatException('APKG 中没有可导入的结构化选择题');
        }
        return AnkiImportResult(
          bankName: deckName,
          questions: questions,
          skipped: skipped,
          warnings: warnings,
        );
      } finally {
        db.close();
      }
    } finally {
      await temp.delete(recursive: true);
    }
  }

  ArchiveFile? _selectDatabase(Archive archive) {
    for (final name in databaseNames) {
      for (final entry in archive.files) {
        if (entry.name == name && entry.isFile) return entry;
      }
    }
    return null;
  }

  String? _readDeckName(Database db) {
    try {
      final row = db.select('SELECT decks FROM col LIMIT 1').first;
      final decks = jsonDecode(row['decks'] as String) as Map<String, dynamic>;
      final named = decks.values
          .whereType<Map<String, dynamic>>()
          .map((e) => e['name'])
          .whereType<String>()
          .where((name) => name != 'Default')
          .toList();
      return named.isEmpty ? null : named.first;
    } on Object {
      return null;
    }
  }
}
