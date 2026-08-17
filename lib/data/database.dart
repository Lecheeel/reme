import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/card.dart';
import '../models/question.dart';
import 'question_bank_loader.dart';

/// 章节统计：名称 + 总题数 + 待复习题数。
class ChapterStat {
  final String name;
  final int total;
  final int due;

  ChapterStat(this.name, this.total, this.due);
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
    return openDatabase(path, version: 1, onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE questions (
          id TEXT PRIMARY KEY,
          subject TEXT NOT NULL,
          chapter TEXT NOT NULL,
          knowledge_point TEXT NOT NULL,
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
    });
  }

  /// 首次启动时若题库为空，从内置 JSON 导入示例政治题库。
  Future<void> seedIfEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM questions'),
        ) ??
        0;
    if (count == 0) {
      final loader = QuestionBankLoader();
      final questions = await loader.loadPoliticsBank();
      await insertQuestions(questions);
    }
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
  Future<List<Question>> getDueQuestions({String? chapter}) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final args = chapter == null ? [now] : [now, chapter];
    final chapterFilter = chapter == null ? '' : 'AND q.chapter = ?';
    final rows = await db.rawQuery('''
      SELECT q.* FROM questions q
      LEFT JOIN cards c ON q.id = c.question_id
      WHERE c.question_id IS NULL OR c.due <= ?
      $chapterFilter
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

  /// 全库统计：(总数, 待复习数)。
  Future<(int, int)> getSubjectStats() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final row = (await db.rawQuery('''
      SELECT COUNT(*) AS total,
             SUM(CASE WHEN c.question_id IS NULL OR c.due <= ? THEN 1 ELSE 0 END) AS due
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
    ''', [now])).first;
    final total = (row['total'] as num?)?.toInt() ?? 0;
    final due = (row['due'] as num?)?.toInt() ?? 0;
    return (total, due);
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

  Map<String, dynamic> _questionToRow(Question q) => {
        'id': q.id,
        'subject': q.subject,
        'chapter': q.chapter,
        'knowledge_point': q.knowledgePoint,
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
