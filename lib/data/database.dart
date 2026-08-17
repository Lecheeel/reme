import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/card.dart';
import '../models/mastery.dart';
import '../models/question.dart';
import 'question_bank_loader.dart';

/// 章节统计：名称 + 总题数 + 待复习题数。
class ChapterStat {
  final String name;
  final int total;
  final int due;

  ChapterStat(this.name, this.total, this.due);
}

/// 单题进度：记忆状态 + 掌握程度。
class QuestionProgress {
  final String id;
  final String chapter;
  final String knowledgePoint;
  final String stem;
  final int reps;
  final int lapses;
  final double stability;

  QuestionProgress({
    required this.id,
    required this.chapter,
    required this.knowledgePoint,
    required this.stem,
    required this.reps,
    required this.lapses,
    required this.stability,
  });

  Mastery get mastery => masteryOf(reps: reps, stability: stability);
}

/// SQLite 访问层（单例）。两张表：
///  - questions：题库（题目内容，反规范化存 subject/chapter/knowledge_point）
///  - cards：每题的 FSRS 记忆状态（与 questions 1:1）
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'reme.db');
    return openDatabase(path, version: 3, onCreate: (db, _) async {
      await _createSchema(db);
    }, onUpgrade: (db, oldVersion, _) async {
      if (oldVersion < 2) {
        // v1 → v2：新增 meta 表（存题库种子版本号）
        await db.execute(
            'CREATE TABLE IF NOT EXISTS meta (key TEXT PRIMARY KEY, value TEXT)');
        await db.delete('questions');
      }
      if (oldVersion < 3) {
        // v2 → v3：questions 表加 knowledge_point_id（子章节 id，供 related 关联复习）
        await db.execute(
            'ALTER TABLE questions ADD COLUMN knowledge_point_id TEXT');
      }
    });
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE questions (
        id TEXT PRIMARY KEY,
        subject TEXT NOT NULL,
        chapter TEXT NOT NULL,
        knowledge_point TEXT NOT NULL,
        knowledge_point_id TEXT,
        type TEXT NOT NULL,
        stem TEXT NOT NULL,
        options TEXT NOT NULL,
        answer TEXT NOT NULL,
        explanation TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE cards (
        question_id TEXT PRIMARY KEY,
        difficulty REAL NOT NULL DEFAULT 0,
        stability REAL NOT NULL DEFAULT 0,
        due INTEGER,
        last_review INTEGER,
        reps INTEGER NOT NULL DEFAULT 0,
        lapses INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
        'CREATE TABLE meta (key TEXT PRIMARY KEY, value TEXT)');
  }

  /// 题库种子版本比对（按章节）：每章 JSON 的 version 与库里记录不一致时，
  /// 只清空并重建该章的 questions（其他章和 cards 记忆状态不受影响）。
  Future<void> seedIfNeeded() async {
    final db = await database;
    final loader = QuestionBankLoader();
    for (final path in QuestionBankLoader.chapterFiles) {
      final (chapterId, chapterName, version) =
          await loader.loadChapterMeta(path);
      final stored = await _getSeedVersion(db, chapterId);
      if (stored == version) continue;

      await db
          .delete('questions', where: 'chapter = ?', whereArgs: [chapterName]);
      final questions = await loader.loadChapterQuestions(path);
      await insertQuestions(questions);
      await _setSeedVersion(db, chapterId, version);
    }
  }

  Future<int?> _getSeedVersion(Database db, String chapterId) async {
    final rows = await db.query('meta',
        where: 'key = ?', whereArgs: ['seed_version:$chapterId'], limit: 1);
    if (rows.isEmpty) return null;
    return int.tryParse(rows.first['value'] as String);
  }

  Future<void> _setSeedVersion(Database db, String chapterId, int version) async {
    await db.insert('meta', {'key': 'seed_version:$chapterId', 'value': '$version'},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertQuestions(List<Question> questions) async {
    final db = await database;
    final batch = db.batch();
    for (final q in questions) {
      batch.insert('questions', _questionToRow(q),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  /// 待复习题目：无卡片记录（新题）或已到期。
  /// [relatedKpIds]：子章节 related 关联复习——这些子章节的到期题也会一起拉出。
  Future<List<Question>> getDueQuestions(
      {String? chapter, List<String>? relatedKpIds}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final extra = relatedKpIds ?? const <String>[];
    final hasExtra = extra.isNotEmpty;

    final args = <Object>[now];
    var where = 'c.question_id IS NULL OR c.due <= ?';
    if (chapter != null || hasExtra) {
      final parts = <String>[];
      if (chapter != null) parts.add('q.chapter = ?');
      if (hasExtra) {
        parts.add(
            'q.knowledge_point_id IN (${List.filled(extra.length, '?').join(',')})');
      }
      where += ' AND (${parts.join(' OR ')})';
      if (chapter != null) args.add(chapter);
      args.addAll(extra);
    }

    final rows = await db.rawQuery('''
      SELECT q.* FROM questions q
      LEFT JOIN cards c ON q.id = c.question_id
      WHERE $where
      ORDER BY (c.question_id IS NULL) DESC, c.due ASC
    ''', args);
    return rows.map(_questionFromRow).toList();
  }

  Future<CardState?> getCard(String questionId) async {
    final db = await database;
    final rows = await db.query('cards',
        where: 'question_id = ?', whereArgs: [questionId], limit: 1);
    if (rows.isEmpty) return null;
    return _cardFromRow(rows.first);
  }

  Future<void> upsertCard(CardState card) async {
    final db = await database;
    await db.insert('cards', {
      'question_id': card.questionId,
      'difficulty': card.difficulty,
      'stability': card.stability,
      'due': card.due?.millisecondsSinceEpoch,
      'last_review': card.lastReview?.millisecondsSinceEpoch,
      'reps': card.reps,
      'lapses': card.lapses,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// 全库统计：(总数, 待复习数, 已掌握数, 今日到期复习数)。
  /// dueReview = 有卡片且到期的题（复习负载，估算预计天数时占产能）。
  Future<(int, int, int, int)> getSubjectStats() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final row = (await db.rawQuery('''
      SELECT COUNT(*) AS total,
             SUM(CASE WHEN c.question_id IS NULL OR c.due <= ? THEN 1 ELSE 0 END) AS due,
             SUM(CASE WHEN c.reps > 0 AND c.stability >= ? THEN 1 ELSE 0 END) AS mastered,
             SUM(CASE WHEN c.question_id IS NOT NULL AND c.due <= ? THEN 1 ELSE 0 END) AS due_review
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
    ''', [now, masteredStabilityThreshold, now])).first;
    final total = (row['total'] as num?)?.toInt() ?? 0;
    final due = (row['due'] as num?)?.toInt() ?? 0;
    final mastered = (row['mastered'] as num?)?.toInt() ?? 0;
    final dueReview = (row['due_review'] as num?)?.toInt() ?? 0;
    return (total, due, mastered, dueReview);
  }

  /// 已掌握题的平均作答次数（估算「每掌握一题平均消耗多少次作答」），
  /// 无已掌握数据时返回 null（调用方用兜底值）。
  Future<double?> getAvgRepsForMastered() async {
    final db = await database;
    final row = (await db.rawQuery('''
      SELECT AVG(c.reps) AS avg_reps FROM cards c
      WHERE c.reps > 0 AND c.stability >= ?
    ''', [masteredStabilityThreshold])).first;
    final v = row['avg_reps'];
    return v == null ? null : (v as num).toDouble();
  }

  /// 按章节分组统计。
  Future<List<ChapterStat>> getChapterStats() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await db.rawQuery('''
      SELECT q.chapter AS chapter, COUNT(*) AS total,
             SUM(CASE WHEN c.question_id IS NULL OR c.due <= ? THEN 1 ELSE 0 END) AS due
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      GROUP BY q.chapter ORDER BY q.chapter
    ''', [now]);
    return rows
        .map((r) => ChapterStat(
              r['chapter'] as String,
              (r['total'] as num?)?.toInt() ?? 0,
              (r['due'] as num?)?.toInt() ?? 0,
            ))
        .toList();
  }

  /// 全量题目进度（含未学），按章节→知识点排序。
  Future<List<QuestionProgress>> getProgress() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT q.id, q.chapter, q.knowledge_point, q.stem,
             COALESCE(c.reps, 0) AS reps,
             COALESCE(c.lapses, 0) AS lapses,
             COALESCE(c.stability, 0.0) AS stability
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      ORDER BY q.chapter, q.knowledge_point, q.id
    ''');
    return rows
        .map((r) => QuestionProgress(
              id: r['id'] as String,
              chapter: r['chapter'] as String,
              knowledgePoint: r['knowledge_point'] as String,
              stem: r['stem'] as String,
              reps: (r['reps'] as num).toInt(),
              lapses: (r['lapses'] as num).toInt(),
              stability: (r['stability'] as num).toDouble(),
            ))
        .toList();
  }

  Map<String, dynamic> _questionToRow(Question q) => {
        'id': q.id,
        'subject': q.subject,
        'chapter': q.chapter,
        'knowledge_point': q.knowledgePoint,
        'knowledge_point_id': q.knowledgePointId,
        'type': q.type.name,
        'stem': q.stem,
        'options': jsonEncode(q.options.map((o) => o.toJson()).toList()),
        'answer': jsonEncode(q.answer),
        'explanation': q.explanation,
      };

  Question _questionFromRow(Map<String, dynamic> row) => Question(
        id: row['id'] as String,
        subject: row['subject'] as String,
        chapter: row['chapter'] as String,
        knowledgePoint: row['knowledge_point'] as String,
        knowledgePointId: (row['knowledge_point_id'] as String?) ?? '',
        type: QuestionType.fromName(row['type'] as String),
        stem: row['stem'] as String,
        options: (jsonDecode(row['options'] as String) as List)
            .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        answer: (jsonDecode(row['answer'] as String) as List)
            .map((e) => e as String)
            .toList(),
        explanation: row['explanation'] as String,
      );

  CardState _cardFromRow(Map<String, dynamic> row) => CardState(
        questionId: row['question_id'] as String,
        difficulty: (row['difficulty'] as num).toDouble(),
        stability: (row['stability'] as num).toDouble(),
        due: row['due'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row['due'] as int),
        lastReview: row['last_review'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row['last_review'] as int),
        reps: (row['reps'] as num).toInt(),
        lapses: (row['lapses'] as num).toInt(),
      );
}
