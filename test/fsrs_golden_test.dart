import 'package:flutter_test/flutter_test.dart';

import 'package:reme/models/card.dart';
import 'package:reme/models/rating.dart';
import 'package:reme/scheduler/fsrs.dart';

/// FSRS v6 移植的数值 golden 测试。
///
/// 参考值由 `tools/fsrs_golden_gen.js` 从官方 fsrs4anki_scheduler.js (v6.1.1)
/// 提取纯函数生成，用于验证 Dart 移植在数值上与原实现一致。
///
/// 只对照确定性的 difficulty / stability / retrievability：
/// interval 受 fuzz 随机源影响（官方 seedrandom vs 本移植 Dart Random），
/// 不在数值级对照范围内，其边界性质由 fsrs_test.dart 覆盖。
void main() {
  final fsrs = FSRS();

  Map<Rating, SchedulingOutcome> byRating(List<SchedulingOutcome> o) =>
      {for (final x in o) x.rating: x};

  // 固定参考时间，保证 elapsed 天数精确（避免 DateTime.now() 微秒差导致 inDays 抖动）
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  test('golden: 新卡 d/s 与官方一致', () {
    final o = byRating(fsrs.schedule(CardState(questionId: 'g_new'), now));
    expect(o[Rating.again]!.difficulty, closeTo(6.41, 0.01));
    expect(o[Rating.again]!.stability, closeTo(0.21, 0.01));
    expect(o[Rating.hard]!.difficulty, closeTo(5.11, 0.01));
    expect(o[Rating.hard]!.stability, closeTo(1.29, 0.01));
    expect(o[Rating.good]!.difficulty, closeTo(2.12, 0.01));
    expect(o[Rating.good]!.stability, closeTo(2.31, 0.01));
    expect(o[Rating.easy]!.difficulty, closeTo(1.0, 0.01));
    expect(o[Rating.easy]!.stability, closeTo(8.30, 0.01));
  });

  test('golden: 复习卡 d=3 s=3 elapsed=1', () {
    final card = CardState(
      questionId: 'g_r1',
      difficulty: 3,
      stability: 3,
      reps: 1,
      lastReview: now.subtract(const Duration(days: 1)),
    );
    final o = byRating(fsrs.schedule(card, now));
    expect(fsrs.forgettingCurve(1, 3), closeTo(0.957336, 1e-4));
    expect(o[Rating.again]!.difficulty, closeTo(7.69, 0.01));
    expect(o[Rating.again]!.stability, closeTo(0.65, 0.01));
    expect(o[Rating.hard]!.difficulty, closeTo(5.34, 0.01));
    expect(o[Rating.hard]!.stability, closeTo(5.70, 0.01));
    expect(o[Rating.good]!.difficulty, closeTo(3.0, 0.01));
    expect(o[Rating.good]!.stability, closeTo(7.49, 0.01));
    expect(o[Rating.easy]!.difficulty, closeTo(1.0, 0.01));
    expect(o[Rating.easy]!.stability, closeTo(11.41, 0.01));
  });

  test('golden: 复习卡 d=7 s=30 elapsed=10', () {
    final card = CardState(
      questionId: 'g_r2',
      difficulty: 7,
      stability: 30,
      reps: 3,
      lastReview: now.subtract(const Duration(days: 10)),
    );
    final o = byRating(fsrs.schedule(card, now));
    expect(o[Rating.again]!.difficulty, closeTo(9.0, 0.01));
    expect(o[Rating.again]!.stability, closeTo(2.07, 0.01));
    expect(o[Rating.hard]!.difficulty, closeTo(8.0, 0.01));
    expect(o[Rating.hard]!.stability, closeTo(39.20, 0.01));
    expect(o[Rating.good]!.difficulty, closeTo(6.99, 0.01));
    expect(o[Rating.good]!.stability, closeTo(45.30, 0.01));
    expect(o[Rating.easy]!.difficulty, closeTo(5.99, 0.01));
    expect(o[Rating.easy]!.stability, closeTo(58.65, 0.01));
  });

  test('golden: 复习卡 d=2 s=2 elapsed=3', () {
    final card = CardState(
      questionId: 'g_r3',
      difficulty: 2,
      stability: 2,
      reps: 1,
      lastReview: now.subtract(const Duration(days: 3)),
    );
    final o = byRating(fsrs.schedule(card, now));
    expect(fsrs.forgettingCurve(3, 2), closeTo(0.869825, 1e-4));
    expect(o[Rating.again]!.difficulty, closeTo(7.36, 0.01));
    expect(o[Rating.again]!.stability, closeTo(0.59, 0.01));
    expect(o[Rating.hard]!.difficulty, closeTo(4.68, 0.01));
    expect(o[Rating.hard]!.stability, closeTo(8.85, 0.01));
    expect(o[Rating.good]!.difficulty, closeTo(2.0, 0.01));
    expect(o[Rating.good]!.stability, closeTo(13.39, 0.01));
    expect(o[Rating.easy]!.difficulty, closeTo(1.0, 0.01));
    expect(o[Rating.easy]!.stability, closeTo(23.32, 0.01));
  });

  test('golden: 复习卡 d=1 s=1 elapsed=0（刚复习，R=1 时稳定度不增）', () {
    final card = CardState(
      questionId: 'g_r4',
      difficulty: 1,
      stability: 1,
      reps: 2,
      lastReview: now,
    );
    final o = byRating(fsrs.schedule(card, now));
    expect(fsrs.forgettingCurve(0, 1), closeTo(1.0, 1e-6));
    expect(o[Rating.again]!.difficulty, closeTo(7.03, 0.01));
    expect(o[Rating.again]!.stability, closeTo(0.30, 0.01));
    expect(o[Rating.hard]!.difficulty, closeTo(4.02, 0.01));
    expect(o[Rating.hard]!.stability, closeTo(1.0, 0.01));
    expect(o[Rating.good]!.difficulty, closeTo(1.0, 0.01));
    expect(o[Rating.good]!.stability, closeTo(1.0, 0.01));
    expect(o[Rating.easy]!.difficulty, closeTo(1.0, 0.01));
    expect(o[Rating.easy]!.stability, closeTo(1.0, 0.01));
  });
}
