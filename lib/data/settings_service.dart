import 'package:shared_preferences/shared_preferences.dart';

/// 非日志类的 App 设置（如选项打乱、每日学习量、新题上限）。
class SettingsService {
  SettingsService._();

  static const _kShuffle = 'shuffle_options';
  static const _kDailyTarget = 'daily_target';
  static const _kNewDailyCap = 'new_daily_cap';

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
}
