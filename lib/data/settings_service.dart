import 'package:shared_preferences/shared_preferences.dart';

/// 非日志类的 App 设置（如选项打乱、每日学习量）。
class SettingsService {
  SettingsService._();

  static const _kShuffle = 'shuffle_options';
  static const _kDailyTarget = 'daily_target';

  /// 默认每日学习量。
  static const int defaultDailyTarget = 50;

  static Future<bool> getShuffleOptions() async =>
      (await SharedPreferences.getInstance()).getBool(_kShuffle) ?? false;

  static Future<void> setShuffleOptions(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_kShuffle, value);

  static Future<int> getDailyTarget() async =>
      (await SharedPreferences.getInstance()).getInt(_kDailyTarget) ??
          defaultDailyTarget;

  static Future<void> setDailyTarget(int value) async =>
      (await SharedPreferences.getInstance()).setInt(_kDailyTarget, value);
}
