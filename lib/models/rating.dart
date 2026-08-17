/// 评分等级：对应 FSRS 的 Again / Hard / Good / Easy。
enum Rating { again, hard, good, easy }

extension RatingX on Rating {
  /// 中文按钮文案。
  String get label => switch (this) {
        Rating.again => '忘记',
        Rating.hard => '困难',
        Rating.good => '记得',
        Rating.easy => '简单',
      };

  /// 英文标识（用于日志/调试）。
  String get short => switch (this) {
        Rating.again => 'Again',
        Rating.hard => 'Hard',
        Rating.good => 'Good',
        Rating.easy => 'Easy',
      };
}
