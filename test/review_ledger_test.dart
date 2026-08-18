import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reme/data/database.dart';
import 'package:reme/models/card.dart';
import 'package:reme/models/rating.dart';

void main() {
  late DatabaseHelper db;

  setUp(() {
    db = DatabaseHelper.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('评分会原子保存卡片、事件账本和当天统计', () async {
    final now = DateTime(2026, 8, 18, 10);
    final before = CardState(questionId: 'q1');
    final after = CardState(
      questionId: 'q1',
      difficulty: 2.1,
      stability: 25,
      lastReview: now,
      due: now.add(const Duration(days: 25)),
      reps: 1,
    );

    final result = await db.recordReview(
      before: before,
      after: after,
      rating: Rating.good,
      correct: true,
      isNew: true,
      graduated: true,
      reviewedAt: now,
    );

    final card = await db.getCard('q1');
    final event = await db.customSelect('SELECT * FROM review_events WHERE id = ?',
        variables: [Variable.withInt(result.eventId)]).getSingle();

    expect(card?.reps, 1);
    expect(card?.stability, 25);
    final historical = await db.getMonthStats(2026, 8);
    expect(historical['2026-08-18']?.reviewCount, 1);
    expect(historical['2026-08-18']?.newCount, 1);
    expect(historical['2026-08-18']?.correctCount, 1);
    expect(historical['2026-08-18']?.graduatedCount, 1);
    expect(event.read<int>('voided'), 0);
    expect(event.read<String>('event_kind'), 'rating');
  });

  test('撤销会作废事件、还原卡片并回滚当天统计', () async {
    final now = DateTime(2026, 8, 18, 10);
    final before = CardState(questionId: 'q2');
    final after = CardState(
      questionId: 'q2',
      difficulty: 6,
      stability: 0.2,
      lastReview: now,
      due: now,
      reps: 1,
      lapses: 1,
    );
    final result = await db.recordReview(
      before: before,
      after: after,
      rating: Rating.again,
      correct: false,
      isNew: true,
      graduated: false,
      reviewedAt: now,
      eventKind: 'scheduled_review',
    );

    await db.undoReview(
      eventId: result.eventId,
      cardBefore: null,
      delta: result.delta,
    );

    expect(await db.getCard('q2'), isNull);
    final historical = await db.getMonthStats(2026, 8);
    expect(historical['2026-08-18']?.reviewCount, 0);
    expect(historical['2026-08-18']?.newCount, 0);
    final event = await db.customSelect('SELECT voided FROM review_events WHERE id = ?',
        variables: [Variable.withInt(result.eventId)]).getSingle();
    expect(event.read<int>('voided'), 1);
  });
}
