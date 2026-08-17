/// 一道题的记忆调度状态（FSRS 的 Card 状态）。
class CardState {
  final String questionId;
  double difficulty; // D
  double stability; // S
  DateTime? lastReview;
  DateTime? due;
  int reps;
  int lapses;
  int seed; // 用于 fuzz 的确定性随机种子

  CardState({
    required this.questionId,
    this.difficulty = 0,
    this.stability = 0,
    this.lastReview,
    this.due,
    this.reps = 0,
    this.lapses = 0,
    int? seed,
  }) : seed = seed ?? _seedFromId(questionId);

  /// 从未复习过 = 新卡。
  bool get isNew => reps == 0;

  /// 是否已到期（到期时间 <= 现在，或尚无到期时间）。
  bool get isDue => due == null || !due!.isAfter(DateTime.now());

  /// 基于题目 id 的确定性 hash，保证同一题 fuzz 结果稳定。
  static int _seedFromId(String id) {
    var h = 0;
    for (final c in id.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }
}
