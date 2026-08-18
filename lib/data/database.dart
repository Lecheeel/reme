import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/card.dart';
import '../models/mastery.dart';
import '../models/question.dart';
import '../models/rating.dart';
import 'question_bank_loader.dart';

part 'database.g.dart';

@DataClassName('QuestionRow')
class Questions extends Table {
  @override
  String get tableName => 'questions';

  TextColumn get id => text()();
  TextColumn get subject => text()();
  TextColumn get chapter => text()();
  TextColumn get knowledgePoint => text().named('knowledge_point')();
  TextColumn get knowledgePointId => text().named('knowledge_point_id').nullable()();
  TextColumn get type => text()();
  TextColumn get stem => text()();
  TextColumn get options => text()();
  TextColumn get answer => text()();
  TextColumn get explanation => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CardRow')
class Cards extends Table {
  @override
  String get tableName => 'cards';

  TextColumn get questionId => text().named('question_id')();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  RealColumn get stability => real().withDefault(const Constant(0))();
  IntColumn get due => integer().nullable()();
  IntColumn get lastReview => integer().named('last_review').nullable()();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  IntColumn get suspended => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {questionId};
}

@DataClassName('MetaEntryRow')
class MetaEntries extends Table {
  @override
  String get tableName => 'meta';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('DailyStatRow')
class DailyStats extends Table {
  @override
  String get tableName => 'daily_stats';

  TextColumn get date => text()();
  IntColumn get newCount => integer().named('new_count').withDefault(const Constant(0))();
  IntColumn get reviewCount => integer().named('review_count').withDefault(const Constant(0))();
  IntColumn get correctCount => integer().named('correct_count').withDefault(const Constant(0))();
  IntColumn get graduatedCount => integer().named('graduated_count').withDefault(const Constant(0))();
  IntColumn get checkedIn => integer().named('checked_in').withDefault(const Constant(0))();
  IntColumn get checkInTime => integer().named('check_in_time').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

/// 不可变的复习账本。统计与未来 FSRS 个体化优化均以它为准；撤销时只标记 voided。
@DataClassName('ReviewEventRow')
class ReviewEvents extends Table {
  @override
  String get tableName => 'review_events';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text().named('card_id')();
  IntColumn get reviewedAt => integer().named('reviewed_at')();
  IntColumn get rating => integer()();
  IntColumn get correct => integer()();
  IntColumn get isNew => integer().named('is_new')();
  IntColumn get graduated => integer()();
  TextColumn get eventKind => text().named('event_kind').withDefault(const Constant('rating'))();
  RealColumn get elapsedDays => real().named('elapsed_days')();
  RealColumn get previousDifficulty => real().named('previous_difficulty')();
  RealColumn get previousStability => real().named('previous_stability')();
  IntColumn get previousDue => integer().named('previous_due').nullable()();
  IntColumn get previousReps => integer().named('previous_reps')();
  IntColumn get previousLapses => integer().named('previous_lapses')();
  RealColumn get nextDifficulty => real().named('next_difficulty')();
  RealColumn get nextStability => real().named('next_stability')();
  IntColumn get nextDue => integer().named('next_due').nullable()();
  IntColumn get nextReps => integer().named('next_reps')();
  IntColumn get nextLapses => integer().named('next_lapses')();
  IntColumn get voided => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at')();
}

/// 章节统计：名称 + 总数 + 三栏队列（新题/学习中/复习）。
class ChapterStat {
  final String name;
  final int total;
  final int newCount;
  final int learningCount;
  final int reviewCount;

  ChapterStat(this.name, this.total, this.newCount, this.learningCount, this.reviewCount);

  int get due => newCount + learningCount + reviewCount;
}

/// 单日学习统计（由 review_events 实时物化，必要时可从事件账本重建）。
class DailyStat {
  final String date;
  final int newCount;
  final int reviewCount;
  final int correctCount;
  final int graduatedCount;
  final bool checkedIn;
  final DateTime? checkInTime;

  const DailyStat({
    required this.date,
    required this.newCount,
    required this.reviewCount,
    required this.correctCount,
    required this.graduatedCount,
    this.checkedIn = false,
    this.checkInTime,
  });

  double get accuracy => reviewCount == 0 ? 0 : correctCount / reviewCount;
}

class QuestionProgress {
  final String id;
  final String chapter;
  final String knowledgePoint;
  final String stem;
  final int reps;
  final int lapses;
  final double stability;
  final double difficulty;
  final bool suspended;

  QuestionProgress({
    required this.id,
    required this.chapter,
    required this.knowledgePoint,
    required this.stem,
    required this.reps,
    required this.lapses,
    required this.stability,
    required this.difficulty,
    this.suspended = false,
  });

  Mastery get mastery => masteryOf(reps: reps, stability: stability);
}

/// 评分写入后的事件 id。撤销必须使用该 id，保证卡片、统计和事件账本一致。
class ReviewWriteResult {
  final int eventId;
  final DailyStat delta;

  const ReviewWriteResult(this.eventId, this.delta);
}

@DriftDatabase(tables: [Questions, Cards, MetaEntries, DailyStats, ReviewEvents])
class DatabaseHelper extends _$DatabaseHelper {
  DatabaseHelper._() : super(_openConnection());

  /// 仅供测试使用的内存数据库入口。
  DatabaseHelper.forTesting(super.executor);

  static final DatabaseHelper instance = DatabaseHelper._();

  static DatabaseConnection _openConnection() => driftDatabase(
        name: 'reme',
        native: DriftNativeOptions(
          shareAcrossIsolates: true,
          databasePath: _databasePath,
        ),
      );

  /// 兼容旧版 Android 的数据库目录；新安装则使用 Drift 的文档目录。
  /// 下一次成功打开后仍由 Drift 直接管理同一个文件。
  static Future<String> _databasePath() async {
    final documents = await getApplicationDocumentsDirectory();
    final legacy = File(p.join(documents.parent.path, 'databases', 'reme.db'));
    if (await legacy.exists()) return legacy.path;
    return p.join(documents.path, 'reme.sqlite');
  }

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          // 兼容历史 schema（v1-v6）；v7 开始由 Drift 管理。
          if (from < 2) {
            await customStatement('CREATE TABLE IF NOT EXISTS meta (key TEXT PRIMARY KEY, value TEXT)');
            await customStatement('DELETE FROM questions');
          }
          if (from < 3) {
            await customStatement('ALTER TABLE questions ADD COLUMN knowledge_point_id TEXT');
          }
          if (from < 4) {
            await customStatement('''
              CREATE TABLE IF NOT EXISTS daily_stats (
                date TEXT PRIMARY KEY,
                new_count INTEGER NOT NULL DEFAULT 0,
                review_count INTEGER NOT NULL DEFAULT 0,
                correct_count INTEGER NOT NULL DEFAULT 0,
                graduated_count INTEGER NOT NULL DEFAULT 0
              )
            ''');
          }
          if (from < 5) {
            await customStatement('ALTER TABLE daily_stats ADD COLUMN checked_in INTEGER NOT NULL DEFAULT 0');
            await customStatement('ALTER TABLE daily_stats ADD COLUMN check_in_time INTEGER');
          }
          if (from < 6) {
            await customStatement('ALTER TABLE cards ADD COLUMN suspended INTEGER NOT NULL DEFAULT 0');
          }
          if (from < 7) {
            await customStatement('''
              CREATE TABLE IF NOT EXISTS review_events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                card_id TEXT NOT NULL,
                reviewed_at INTEGER NOT NULL,
                rating INTEGER NOT NULL,
                correct INTEGER NOT NULL,
                is_new INTEGER NOT NULL,
                graduated INTEGER NOT NULL,
                event_kind TEXT NOT NULL DEFAULT 'rating',
                elapsed_days REAL NOT NULL,
                previous_difficulty REAL NOT NULL,
                previous_stability REAL NOT NULL,
                previous_due INTEGER,
                previous_reps INTEGER NOT NULL,
                previous_lapses INTEGER NOT NULL,
                next_difficulty REAL NOT NULL,
                next_stability REAL NOT NULL,
                next_due INTEGER,
                next_reps INTEGER NOT NULL,
                next_lapses INTEGER NOT NULL,
                voided INTEGER NOT NULL DEFAULT 0,
                created_at INTEGER NOT NULL
              )
            ''');
          }
          await _createIndexes();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    await customStatement('CREATE INDEX IF NOT EXISTS cards_due_active_idx ON cards(due, suspended)');
    await customStatement('CREATE INDEX IF NOT EXISTS questions_chapter_idx ON questions(chapter)');
    await customStatement('CREATE INDEX IF NOT EXISTS review_events_card_time_idx ON review_events(card_id, reviewed_at)');
    await customStatement('CREATE INDEX IF NOT EXISTS review_events_time_idx ON review_events(reviewed_at, voided)');
  }

  /// Drift 的 customSelect 使用 [Variable]；customStatement 则需要原始 SQLite 值。
  Future<void> _exec(String sql, List<Variable<Object>> variables) =>
      customStatement(sql, [for (final variable in variables) variable.value]);

  Future<void> seedIfNeeded() async {
    final loader = QuestionBankLoader();
    for (final assetPath in QuestionBankLoader.chapterFiles) {
      final (chapterId, chapterName, version) = await loader.loadChapterMeta(assetPath);
      final stored = await _getSeedVersion(chapterId);
      if (stored == version) continue;
      final questions = await loader.loadChapterQuestions(assetPath);
      await transaction(() async {
        await _exec('DELETE FROM questions WHERE chapter = ?', [Variable.withString(chapterName)]);
        await _insertQuestions(questions);
        await _setSeedVersion(chapterId, version);
      });
    }
  }

  Future<int?> _getSeedVersion(String chapterId) async {
    final rows = await customSelect(
      'SELECT value FROM meta WHERE key = ? LIMIT 1',
      variables: [Variable.withString('seed_version:$chapterId')],
    ).get();
    return rows.isEmpty ? null : int.tryParse(rows.first.read<String>('value'));
  }

  Future<void> _setSeedVersion(String chapterId, int version) => _exec(
        'INSERT INTO meta (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value',
        [Variable.withString('seed_version:$chapterId'), Variable.withString('$version')],
      );

  Future<void> insertQuestions(List<Question> questions) => transaction(() => _insertQuestions(questions));

  Future<void> _insertQuestions(List<Question> questions) async {
    for (final q in questions) {
      await _exec('''
        INSERT OR IGNORE INTO questions
          (id, subject, chapter, knowledge_point, knowledge_point_id, type, stem, options, answer, explanation)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''', _questionVariables(q));
    }
  }

  List<Variable<Object>> _questionVariables(Question q) => [
        Variable.withString(q.id),
        Variable.withString(q.subject),
        Variable.withString(q.chapter),
        Variable.withString(q.knowledgePoint),
        Variable.withString(q.knowledgePointId),
        Variable.withString(q.type.name),
        Variable.withString(q.stem),
        Variable.withString(jsonEncode(q.options.map((o) => o.toJson()).toList())),
        Variable.withString(jsonEncode(q.answer)),
        Variable.withString(q.explanation),
      ];

  Future<List<Question>> getDueQuestions({String? chapter, List<String>? relatedKpIds}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final filters = <String>['(c.question_id IS NULL OR (c.due <= ? AND c.suspended = 0))'];
    final vars = <Variable<Object>>[Variable.withInt(now)];
    final related = relatedKpIds ?? const <String>[];
    if (chapter != null || related.isNotEmpty) {
      final parts = <String>[];
      if (chapter != null) {
        parts.add('q.chapter = ?');
        vars.add(Variable.withString(chapter));
      }
      if (related.isNotEmpty) {
        parts.add('q.knowledge_point_id IN (${List.filled(related.length, '?').join(',')})');
        vars.addAll(related.map(Variable.withString));
      }
      filters.add('(${parts.join(' OR ')})');
    }
    final rows = await customSelect('''
      SELECT q.* FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      WHERE ${filters.join(' AND ')}
      ORDER BY (c.question_id IS NULL) DESC, c.due ASC
    ''', variables: vars).get();
    return rows.map(_questionFromRow).toList();
  }

  Future<CardState?> getCard(String questionId) async {
    final rows = await customSelect(
      'SELECT * FROM cards WHERE question_id = ? LIMIT 1',
      variables: [Variable.withString(questionId)],
    ).get();
    return rows.isEmpty ? null : _cardFromRow(rows.first);
  }

  Future<void> upsertCard(CardState card) => _upsertCard(card);

  Future<void> _upsertCard(CardState card) => _exec('''
    INSERT INTO cards (question_id, difficulty, stability, due, last_review, reps, lapses)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(question_id) DO UPDATE SET
      difficulty = excluded.difficulty,
      stability = excluded.stability,
      due = excluded.due,
      last_review = excluded.last_review,
      reps = excluded.reps,
      lapses = excluded.lapses
  ''', [
    Variable.withString(card.questionId),
    Variable.withReal(card.difficulty),
    Variable.withReal(card.stability),
    Variable<int>(card.due?.millisecondsSinceEpoch),
    Variable<int>(card.lastReview?.millisecondsSinceEpoch),
    Variable.withInt(card.reps),
    Variable.withInt(card.lapses),
  ]);

  /// 每次评分原子写入：卡片状态、事件账本、当天汇总要么同时成功，要么同时失败。
  Future<ReviewWriteResult> recordReview({
    required CardState before,
    required CardState after,
    required Rating rating,
    required bool correct,
    required bool isNew,
    required bool graduated,
    required DateTime reviewedAt,
    String eventKind = 'rating',
  }) {
    final delta = DailyStat(
      date: dateStr(reviewedAt),
      newCount: isNew ? 1 : 0,
      reviewCount: 1,
      correctCount: correct ? 1 : 0,
      graduatedCount: graduated ? 1 : 0,
    );
    final elapsed = before.lastReview == null
        ? 0.0
        : reviewedAt.difference(before.lastReview!).inMilliseconds / Duration.millisecondsPerDay;
    return transaction(() async {
      await _upsertCard(after);
      await _exec('''
        INSERT INTO review_events (
          card_id, reviewed_at, rating, correct, is_new, graduated, event_kind, elapsed_days,
          previous_difficulty, previous_stability, previous_due, previous_reps, previous_lapses,
          next_difficulty, next_stability, next_due, next_reps, next_lapses, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
        Variable.withString(after.questionId),
        Variable.withInt(reviewedAt.millisecondsSinceEpoch),
        Variable.withInt(rating.index + 1),
        Variable.withInt(correct ? 1 : 0),
        Variable.withInt(isNew ? 1 : 0),
        Variable.withInt(graduated ? 1 : 0),
        Variable.withString(eventKind),
        Variable.withReal(elapsed),
        Variable.withReal(before.difficulty),
        Variable.withReal(before.stability),
        Variable<int>(before.due?.millisecondsSinceEpoch),
        Variable.withInt(before.reps),
        Variable.withInt(before.lapses),
        Variable.withReal(after.difficulty),
        Variable.withReal(after.stability),
        Variable<int>(after.due?.millisecondsSinceEpoch),
        Variable.withInt(after.reps),
        Variable.withInt(after.lapses),
        Variable.withInt(DateTime.now().millisecondsSinceEpoch),
      ]);
      final eventId = (await customSelect('SELECT last_insert_rowid() AS id').getSingle()).read<int>('id');
      await _applyDailyDelta(delta, add: true);
      return ReviewWriteResult(eventId, delta);
    });
  }

  /// 撤销保留审计记录，并以同一事务回滚卡片与日统计。
  Future<void> undoReview({
    required int eventId,
    required CardState? cardBefore,
    required DailyStat delta,
  }) => transaction(() async {
        await _exec('UPDATE review_events SET voided = 1 WHERE id = ? AND voided = 0', [Variable.withInt(eventId)]);
        if (cardBefore == null) {
          await deleteCard(await _eventCardId(eventId));
        } else {
          await _upsertCard(cardBefore);
        }
        await _applyDailyDelta(delta, add: false);
      });

  Future<String> _eventCardId(int eventId) async {
    final row = await customSelect('SELECT card_id FROM review_events WHERE id = ?', variables: [Variable.withInt(eventId)]).getSingle();
    return row.read<String>('card_id');
  }

  Future<void> _applyDailyDelta(DailyStat delta, {required bool add}) {
    final sign = add ? 1 : -1;
    return _exec('''
      INSERT INTO daily_stats (date, new_count, review_count, correct_count, graduated_count)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(date) DO UPDATE SET
        new_count = MAX(0, new_count + ?),
        review_count = MAX(0, review_count + ?),
        correct_count = MAX(0, correct_count + ?),
        graduated_count = MAX(0, graduated_count + ?)
    ''', [
      Variable.withString(delta.date),
      Variable.withInt(delta.newCount * sign),
      Variable.withInt(delta.reviewCount * sign),
      Variable.withInt(delta.correctCount * sign),
      Variable.withInt(delta.graduatedCount * sign),
      Variable.withInt(delta.newCount * sign),
      Variable.withInt(delta.reviewCount * sign),
      Variable.withInt(delta.correctCount * sign),
      Variable.withInt(delta.graduatedCount * sign),
    ]);
  }

  Future<void> setSuspended(String questionId, bool value) async {
    final existing = await getCard(questionId);
    if (existing == null && value) {
      await _exec('INSERT INTO cards (question_id, suspended) VALUES (?, 1)', [Variable.withString(questionId)]);
    } else if (existing != null && !value && existing.reps == 0) {
      await deleteCard(questionId);
    } else if (existing != null) {
      await _exec('UPDATE cards SET suspended = ? WHERE question_id = ?', [Variable.withInt(value ? 1 : 0), Variable.withString(questionId)]);
    }
  }

  Future<void> deleteCard(String questionId) => _exec('DELETE FROM cards WHERE question_id = ?', [Variable.withString(questionId)]);

  Future<(int, int, int)> getQueueCounts() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final row = await customSelect('''
      SELECT
        SUM(CASE WHEN (c.question_id IS NULL OR c.reps = 0) AND COALESCE(c.suspended, 0) = 0 THEN 1 ELSE 0 END) AS new_cnt,
        SUM(CASE WHEN c.question_id IS NOT NULL AND c.suspended = 0 AND c.due <= ?
                  AND (c.reps = 0 OR c.stability < ?) THEN 1 ELSE 0 END) AS learning_cnt,
        SUM(CASE WHEN c.question_id IS NOT NULL AND c.suspended = 0 AND c.due <= ?
                  AND c.reps > 0 AND c.stability >= ? THEN 1 ELSE 0 END) AS review_cnt
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
    ''', variables: [
      Variable.withInt(now),
      Variable.withReal(masteredStabilityThreshold),
      Variable.withInt(now),
      Variable.withReal(masteredStabilityThreshold),
    ]).getSingle();
    return (_int(row, 'new_cnt'), _int(row, 'learning_cnt'), _int(row, 'review_cnt'));
  }

  Future<List<Question>> getWeakQuestions() async {
    final rows = await customSelect('''
      SELECT q.* FROM questions q INNER JOIN cards c ON q.id = c.question_id
      WHERE c.lapses >= 2 AND c.due <= ? AND c.suspended = 0 ORDER BY c.due ASC
    ''', variables: [Variable.withInt(DateTime.now().millisecondsSinceEpoch)]).get();
    return rows.map(_questionFromRow).toList();
  }

  Future<(int, int, int, int)> getSubjectStats() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final row = await customSelect('''
      SELECT COUNT(*) AS total,
        SUM(CASE WHEN (c.question_id IS NULL OR c.reps = 0) AND COALESCE(c.suspended, 0) = 0
                 OR (c.question_id IS NOT NULL AND c.reps > 0 AND c.due <= ? AND c.suspended = 0)
            THEN 1 ELSE 0 END) AS due,
        SUM(CASE WHEN c.reps > 0 AND c.stability >= ? AND c.suspended = 0 THEN 1 ELSE 0 END) AS mastered,
        SUM(CASE WHEN c.question_id IS NOT NULL AND c.reps > 0 AND c.due <= ? AND c.suspended = 0 THEN 1 ELSE 0 END) AS due_review
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
    ''', variables: [Variable.withInt(now), Variable.withReal(masteredStabilityThreshold), Variable.withInt(now)]).getSingle();
    return (_int(row, 'total'), _int(row, 'due'), _int(row, 'mastered'), _int(row, 'due_review'));
  }

  Future<double?> getAvgRepsForMastered() async {
    final row = await customSelect('SELECT AVG(reps) AS avg_reps FROM cards WHERE reps > 0 AND stability >= ?', variables: [Variable.withReal(masteredStabilityThreshold)]).getSingle();
    return row.readNullable<double>('avg_reps');
  }

  Future<List<ChapterStat>> getChapterStats() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await customSelect('''
      SELECT q.chapter AS chapter, COUNT(*) AS total,
        SUM(CASE WHEN (c.question_id IS NULL OR c.reps = 0) AND COALESCE(c.suspended, 0) = 0 THEN 1 ELSE 0 END) AS new_cnt,
        SUM(CASE WHEN c.question_id IS NOT NULL AND c.suspended = 0 AND c.due <= ?
                 AND (c.reps = 0 OR c.stability < ?) THEN 1 ELSE 0 END) AS learning_cnt,
        SUM(CASE WHEN c.question_id IS NOT NULL AND c.suspended = 0 AND c.due <= ?
                 AND c.reps > 0 AND c.stability >= ? THEN 1 ELSE 0 END) AS review_cnt
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      GROUP BY q.chapter ORDER BY q.chapter
    ''', variables: [
      Variable.withInt(now), Variable.withReal(masteredStabilityThreshold),
      Variable.withInt(now), Variable.withReal(masteredStabilityThreshold),
    ]).get();
    return rows.map((r) => ChapterStat(r.read<String>('chapter'), _int(r, 'total'), _int(r, 'new_cnt'), _int(r, 'learning_cnt'), _int(r, 'review_cnt'))).toList();
  }

  Future<List<QuestionProgress>> getProgress() async {
    final rows = await customSelect('''
      SELECT q.id, q.chapter, q.knowledge_point, q.stem,
        COALESCE(c.reps, 0) AS reps, COALESCE(c.lapses, 0) AS lapses,
        COALESCE(c.stability, 0.0) AS stability, COALESCE(c.difficulty, 0.0) AS difficulty,
        COALESCE(c.suspended, 0) AS suspended
      FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      ORDER BY q.chapter, q.knowledge_point, q.id
    ''').get();
    return rows.map((r) => QuestionProgress(
      id: r.read<String>('id'), chapter: r.read<String>('chapter'), knowledgePoint: r.read<String>('knowledge_point'), stem: r.read<String>('stem'),
      reps: _int(r, 'reps'), lapses: _int(r, 'lapses'), stability: r.read<double>('stability'), difficulty: r.read<double>('difficulty'), suspended: _int(r, 'suspended') == 1,
    )).toList();
  }

  Future<void> upsertDailyStat(DailyStat stat) => _applyDailyDelta(stat, add: true);

  Future<List<DailyStat>> getDailyStats(int days) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).subtract(Duration(days: days - 1));
    final rows = await customSelect('SELECT * FROM daily_stats WHERE date >= ? ORDER BY date', variables: [Variable.withString(dateStr(start))]).get();
    final map = {for (final r in rows) r.read<String>('date'): _dailyFromRow(r)};
    return [for (var i = 0; i < days; i++) map[dateStr(start.add(Duration(days: i)))] ?? DailyStat(date: dateStr(start.add(Duration(days: i))), newCount: 0, reviewCount: 0, correctCount: 0, graduatedCount: 0)];
  }

  Future<Map<String, DailyStat>> getMonthStats(int year, int month) async {
    final prefix = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-';
    final rows = await customSelect('SELECT * FROM daily_stats WHERE date LIKE ? ORDER BY date', variables: [Variable.withString('$prefix%')]).get();
    return {for (final r in rows) r.read<String>('date'): _dailyFromRow(r)};
  }

  Future<DailyStat?> getTodayStat() async {
    final rows = await customSelect('SELECT * FROM daily_stats WHERE date = ? LIMIT 1', variables: [Variable.withString(dateStr(DateTime.now()))]).get();
    return rows.isEmpty ? null : _dailyFromRow(rows.first);
  }

  Future<void> checkIn(String date) => _exec('UPDATE daily_stats SET checked_in = 1, check_in_time = ? WHERE date = ?', [Variable.withInt(DateTime.now().millisecondsSinceEpoch), Variable.withString(date)]);

  Future<int> getCheckInStreak() async {
    final rows = await customSelect('SELECT date FROM daily_stats WHERE checked_in = 1 ORDER BY date DESC').get();
    final checked = {for (final r in rows) r.read<String>('date')};
    var day = DateTime.now();
    if (!checked.contains(dateStr(day))) day = day.subtract(const Duration(days: 1));
    var streak = 0;
    while (checked.contains(dateStr(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<List<Question>> getReviewQuestions({String? chapter, List<String>? relatedKpIds}) async {
    final related = relatedKpIds ?? const <String>[];
    final parts = <String>[];
    final vars = <Variable<Object>>[Variable.withInt(DateTime.now().millisecondsSinceEpoch)];
    if (chapter != null) { parts.add('q.chapter = ?'); vars.add(Variable.withString(chapter)); }
    if (related.isNotEmpty) { parts.add('q.knowledge_point_id IN (${List.filled(related.length, '?').join(',')})'); vars.addAll(related.map(Variable.withString)); }
    final scope = parts.isEmpty ? '' : ' AND (${parts.join(' OR ')})';
    final rows = await customSelect('''
      SELECT q.* FROM questions q INNER JOIN cards c ON q.id = c.question_id
      WHERE c.reps > 0 AND c.due <= ? AND c.suspended = 0$scope ORDER BY c.due ASC
    ''', variables: vars).get();
    return rows.map(_questionFromRow).toList();
  }

  Future<List<Question>> getNewQuestions({String? chapter, int? limit}) async {
    final vars = <Variable<Object>>[];
    var scope = '';
    if (chapter != null) { scope = ' AND q.chapter = ?'; vars.add(Variable.withString(chapter)); }
    vars.add(Variable.withInt(limit ?? 999999));
    final rows = await customSelect('''
      SELECT q.* FROM questions q LEFT JOIN cards c ON q.id = c.question_id
      WHERE (c.question_id IS NULL OR c.reps = 0) AND COALESCE(c.suspended, 0) = 0$scope
      ORDER BY q.id LIMIT ?
    ''', variables: vars).get();
    return rows.map(_questionFromRow).toList();
  }

  Future<List<int>> getDueDistribution(int days) async {
    final now = DateTime.now();
    final rows = await customSelect('SELECT due FROM cards WHERE reps > 0 AND due > ? AND due <= ? AND suspended = 0', variables: [Variable.withInt(now.millisecondsSinceEpoch), Variable.withInt(now.add(Duration(days: days)).millisecondsSinceEpoch)]).get();
    final buckets = List<int>.filled(days + 1, 0);
    for (final row in rows) {
      final index = ((row.read<int>('due') - now.millisecondsSinceEpoch) / Duration.millisecondsPerDay).floor().clamp(0, days);
      buckets[index]++;
    }
    return buckets;
  }

  static String dateStr(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  int _int(QueryRow row, String column) => row.readNullable<int>(column) ?? 0;

  DailyStat _dailyFromRow(QueryRow r) => DailyStat(
    date: r.read<String>('date'), newCount: _int(r, 'new_count'), reviewCount: _int(r, 'review_count'), correctCount: _int(r, 'correct_count'), graduatedCount: _int(r, 'graduated_count'),
    checkedIn: _int(r, 'checked_in') == 1,
    checkInTime: r.readNullable<int>('check_in_time') == null ? null : DateTime.fromMillisecondsSinceEpoch(r.read<int>('check_in_time')),
  );

  Question _questionFromRow(QueryRow row) => Question(
    id: row.read<String>('id'), subject: row.read<String>('subject'), chapter: row.read<String>('chapter'), knowledgePoint: row.read<String>('knowledge_point'),
    knowledgePointId: row.readNullable<String>('knowledge_point_id') ?? '', type: QuestionType.fromName(row.read<String>('type')), stem: row.read<String>('stem'),
    options: (jsonDecode(row.read<String>('options')) as List).map((e) => QuestionOption.fromJson(e as Map<String, dynamic>)).toList(),
    answer: (jsonDecode(row.read<String>('answer')) as List).map((e) => e as String).toList(), explanation: row.read<String>('explanation'),
  );

  CardState _cardFromRow(QueryRow row) => CardState(
    questionId: row.read<String>('question_id'), difficulty: row.read<double>('difficulty'), stability: row.read<double>('stability'),
    due: row.readNullable<int>('due') == null ? null : DateTime.fromMillisecondsSinceEpoch(row.read<int>('due')),
    lastReview: row.readNullable<int>('last_review') == null ? null : DateTime.fromMillisecondsSinceEpoch(row.read<int>('last_review')),
    reps: _int(row, 'reps'), lapses: _int(row, 'lapses'),
  );
}
