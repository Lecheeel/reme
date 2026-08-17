/// 掌握程度三态：未学 / 模糊 / 掌握。
enum Mastery { newCard, fuzzy, mastered }

extension MasteryX on Mastery {
  String get label => switch (this) {
        Mastery.newCard => '未学',
        Mastery.fuzzy => '模糊',
        Mastery.mastered => '掌握',
      };
}

/// 稳定度 >= 该天数视为「掌握」（FSRS 稳定度 ≈ 能记住的天数）。
const double masteredStabilityThreshold = 7;

Mastery masteryOf({required int reps, required double stability}) {
  if (reps == 0) return Mastery.newCard;
  if (stability >= masteredStabilityThreshold) return Mastery.mastered;
  return Mastery.fuzzy;
}
