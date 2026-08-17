import 'package:flutter_test/flutter_test.dart';

import 'package:reme/models/card.dart';
import 'package:reme/models/rating.dart';
import 'package:reme/scheduler/fsrs.dart';

void main() {
  final fsrs = FSRS();

  test('新卡：good 间隔 2~4 天，easy 更长，again 归零', () {
    final card = CardState(questionId: 't1');
    expect(card.isNew, isTrue);

    final outcomes = fsrs.schedule(card, DateTime.now());
    final byRating = {for (final o in outcomes) o.rating: o};

    expect(byRating[Rating.again]!.intervalDays, 0);
    expect(byRating[Rating.hard]!.intervalDays, 0);
    expect(byRating[Rating.good]!.intervalDays, inInclusiveRange(2, 4));
    expect(
      byRating[Rating.easy]!.intervalDays,
      greaterThan(byRating[Rating.good]!.intervalDays),
    );
  });

  test('复习卡：again 归零，间隔 hard < good < easy', () {
    final card = CardState(
      questionId: 't2',
      difficulty: 5,
      stability: 5,
      lastReview: DateTime.now().subtract(const Duration(days: 5)),
      reps: 1,
    );

    final outcomes = fsrs.schedule(card, DateTime.now());
    final byRating = {for (final o in outcomes) o.rating: o};

    expect(byRating[Rating.again]!.intervalDays, 0);
    expect(
      byRating[Rating.hard]!.intervalDays,
      lessThan(byRating[Rating.good]!.intervalDays),
    );
    expect(
      byRating[Rating.good]!.intervalDays,
      lessThan(byRating[Rating.easy]!.intervalDays),
    );
  });

  test('难度始终约束在 [1, 10]', () {
    for (var d = 1.0; d <= 10; d += 1.5) {
      final card = CardState(
        questionId: 'd$d',
        difficulty: d,
        stability: 3,
        reps: 1,
        lastReview: DateTime.now().subtract(const Duration(days: 2)),
      );
      for (final o in fsrs.schedule(card, DateTime.now())) {
        expect(o.difficulty, inInclusiveRange(1.0, 10.0));
      }
    }
  });

  test('遗忘曲线：0 天时为 1，随时间下降', () {
    expect(fsrs.forgettingCurve(0, 5), closeTo(1.0, 1e-6));
    final r1 = fsrs.forgettingCurve(1, 5);
    final r30 = fsrs.forgettingCurve(30, 5);
    expect(r1, greaterThan(r30));
  });

  test('非 again 评分的间隔至少 1 天', () {
    final card = CardState(
      questionId: 't5',
      difficulty: 3,
      stability: 3,
      reps: 1,
      lastReview: DateTime.now().subtract(const Duration(days: 2)),
    );
    for (final o in fsrs.schedule(card, DateTime.now())) {
      if (o.rating != Rating.again) {
        expect(o.intervalDays, greaterThanOrEqualTo(1));
      }
    }
  });

  test('调度确定性：同一张卡两次调度结果一致（fuzz 种子稳定）', () {
    final now = DateTime.now();
    final card = CardState(
      questionId: 't6',
      difficulty: 4,
      stability: 4,
      reps: 2,
      lastReview: now.subtract(const Duration(days: 3)),
    );
    final a = fsrs.schedule(card, now);
    final b = fsrs.schedule(card, now);
    for (var i = 0; i < a.length; i++) {
      expect(a[i].intervalDays, b[i].intervalDays);
      expect(a[i].difficulty, b[i].difficulty);
      expect(a[i].stability, b[i].stability);
    }
  });
}
