import 'package:shared_preferences/shared_preferences.dart';

/// 非日志类的 App 设置（如选项打乱、每日学习量、新题上限）。
class SettingsService {
  SettingsService._();

  static const _kShuffle = 'shuffle_options';
  static const _kDailyTarget = 'daily_target';
  static const _kNewDailyCap = 'new_daily_cap';
  static const _kWrongPos = 'wrong_review_position';

  /// 错题重现策略：incremental = 递增间隔（2→5→10 题），
  /// nearby = 2~3 题后随机，end = 队尾。
  static const String wrongPosIncremental = 'incremental';
  static const String wrongPosNearby = 'nearby';
  static const String wrongPosEnd = 'end';

  /// 默认每日学习量（日负荷目标，打卡基准）。
  static const int defaultDailyTarget = 50;

  /// 默认每日新题上限（控制新题引入速率）。
  static const int defaultNewDailyCap = 20;

  static Future<bool> getShuffleOptions() async =>
      (await SharedPreferences.getInstance()).getBool(_kShuffle) ?? false;

  static Future<void> setShuffleOptions(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_kShuffle, value);

  static Future<int> getDailyTarget() async =>
      (await SharedPreferences.getInstance()).getInt(_kDailyTarget) ??
          defaultDailyTarget;

  static Future<void> setDailyTarget(int value) async =>
      (await SharedPreferences.getInstance()).setInt(_kDailyTarget, value);

  /// 每天最多引入的新题数。
  static Future<int> getNewDailyCap() async =>
      (await SharedPreferences.getInstance()).getInt(_kNewDailyCap) ??
          defaultNewDailyCap;

  static Future<void> setNewDailyCap(int value) async =>
      (await SharedPreferences.getInstance()).setInt(_kNewDailyCap, value);

  /// 错题重现策略（默认递增间隔：第 1 次错隔 2 题、第 2 次隔 5 题、之后隔 10 题）。
  static Future<String> getWrongReviewPosition() async =>
      (await SharedPreferences.getInstance()).getString(_kWrongPos) ??
          wrongPosIncremental;

  static Future<void> setWrongReviewPosition(String value) async =>
      (await SharedPreferences.getInstance()).setString(_kWrongPos, value);
}
