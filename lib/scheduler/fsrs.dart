import 'dart:math';

import '../models/card.dart';
import '../models/rating.dart';

/// FSRS v6 调度器（移植自 fsrs4anki_scheduler.js v6.1.1）。
/// 参考：https://github.com/open-spaced-repetition/fsrs4anki
///
/// 核心职责：给定一张卡当前记忆状态（难度 D、稳定度 S），算出四种评分
/// （Again/Hard/Good/Easy）分别对应的新状态与下次复习间隔。
class FSRS {
  /// 默认 FSRS 权重（21 个参数，可用 FSRS optimizer 按个人数据优化）。
  static const List<double> _defaultW = [
    0.212, 1.2931, 2.3065, 8.2956, 6.4133, 0.8334, 3.0194, 0.001,
    1.8722, 0.1666, 0.796, 1.4835, 0.0614, 0.2629, 1.6483, 0.6014,
    1.8729, 0.5425, 0.0912, 0.0658, 0.1542,
  ];

  final double requestRetention;
  final int maximumInterval;
  final List<double> w;

  FSRS({
    this.requestRetention = 0.9,
    this.maximumInterval = 36500,
    List<double>? w,
  }) : w = w ?? _defaultW;

  double get _decay => -w[20];
  double get _factor => pow(0.9, 1 / _decay).toDouble() - 1;

  static int _ratingIndex(Rating r) => switch (r) {
        Rating.again => 1,
        Rating.hard => 2,
        Rating.good => 3,
        Rating.easy => 4,
      };

  static double _round2(double x) => (x * 100).roundToDouble() / 100;

  double _constrainDifficulty(double d) => min(max(_round2(d), 1.0), 10.0);

  /// 遗忘曲线：经过 [elapsedDays] 天后，稳定度为 [stability] 的卡的可提取概率。
  double forgettingCurve(double elapsedDays, double stability) =>
      pow(1 + _factor * elapsedDays / stability, _decay).toDouble();

  double _linearDamping(double deltaD, double oldD) => deltaD * (10 - oldD) / 9;

  double _initDifficulty(Rating rating) =>
      _constrainDifficulty(w[4] - exp(w[5] * (_ratingIndex(rating) - 1)) + 1);

  double _initStability(Rating rating) => max(w[_ratingIndex(rating) - 1], 0.1);

  double _meanReversion(double init, double current) =>
      w[7] * init + (1 - w[7]) * current;

  double _nextDifficulty(double d, Rating rating) {
    final deltaD = -w[6] * (_ratingIndex(rating) - 3);
    final nextD = d + _linearDamping(deltaD, d);
    return _constrainDifficulty(
        _meanReversion(_initDifficulty(Rating.easy), nextD));
  }

  double _nextRecallStability(double d, double s, double r, Rating rating) {
    final hardPenalty = rating == Rating.hard ? w[15] : 1.0;
    final easyBonus = rating == Rating.easy ? w[16] : 1.0;
    return _round2(s *
        (1 +
            exp(w[8]) *
                (11 - d) *
                pow(s, -w[9]) *
                (exp((1 - r) * w[10]) - 1) *
                hardPenalty *
                easyBonus));
  }

  double _nextForgetStability(double d, double s, double r) {
    final sMin = s / exp(w[17] * w[18]);
    return _round2(min(
      w[11] * pow(d, -w[12]) * (pow(s + 1, w[13]) - 1) * exp((1 - r) * w[14]),
      sMin,
    ));
  }

  double _nextInterval(double stability, int seed) {
    final raw =
        stability / _factor * (pow(requestRetention, 1 / _decay) - 1);
    return min(
        max(_applyFuzz(raw, seed).roundToDouble(), 1), maximumInterval.toDouble());
  }

  /// 确定性 fuzz：同一题每次得到相同偏移，避免大量卡片扎堆同一天复习。
  double _applyFuzz(double ivl, int seed) {
    if (ivl < 2.5) return ivl;
    final rnd = Random(seed).nextDouble();
    final rIvl = ivl.round();
    final minIvl = max(2, (rIvl * 0.95 - 1).round());
    final maxIvl = (rIvl * 1.05 + 1).round();
    return (rnd * (maxIvl - minIvl + 1) + minIvl).toDouble();
  }

  /// 调度一张卡，返回四种评分对应的下一步状态与间隔（天数）。
  List<SchedulingOutcome> schedule(CardState card, DateTime now) {
    final seed = card.seed;

    if (card.isNew) {
      final outcomes = <SchedulingOutcome>[];
      final goodInterval = _nextInterval(_initStability(Rating.good), seed).round();
      for (final rating in Rating.values) {
        final d = _initDifficulty(rating);
        final s = _initStability(rating);
        final interval = switch (rating) {
          Rating.again || Rating.hard => 0,
          Rating.good => goodInterval,
          Rating.easy =>
            max(_nextInterval(s, seed).round(), goodInterval + 1),
        };
        outcomes.add(SchedulingOutcome(
          rating: rating,
          difficulty: d,
          stability: s,
          intervalDays: interval,
        ));
      }
      return outcomes;
    }

    // 复习卡：根据当前记忆状态重算难度与稳定度。
    final elapsed =
        max(now.difference(card.lastReview ?? now).inDays, 0).toDouble();
    final r = forgettingCurve(elapsed, card.stability);
    final d = card.difficulty;
    final s = card.stability;

    final outcomes = <SchedulingOutcome>[];
    for (final rating in Rating.values) {
      final newD = _nextDifficulty(d, rating);
      final newS = switch (rating) {
        Rating.again => _nextForgetStability(d, s, r),
        _ => _nextRecallStability(d, s, r, rating),
      };
      final interval = rating == Rating.again
          ? 0
          : _nextInterval(newS, seed).round();
      outcomes.add(SchedulingOutcome(
        rating: rating,
        difficulty: newD,
        stability: newS,
        intervalDays: interval,
      ));
    }

    // 保证间隔严格递增：hard < good < easy。
    final hard = outcomes[1];
    final good = outcomes[2];
    final easy = outcomes[3];
    hard.intervalDays = min(hard.intervalDays, good.intervalDays);
    good.intervalDays = max(good.intervalDays, hard.intervalDays + 1);
    easy.intervalDays = max(easy.intervalDays, good.intervalDays + 1);

    return outcomes;
  }
}

/// 某一种评分对应的调度结果。
class SchedulingOutcome {
  final Rating rating;
  final double difficulty;
  final double stability;
  int intervalDays;

  SchedulingOutcome({
    required this.rating,
    required this.difficulty,
    required this.stability,
    required this.intervalDays,
  });
}
