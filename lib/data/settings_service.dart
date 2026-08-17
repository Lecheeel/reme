import 'package:shared_preferences/shared_preferences.dart';

/// 非日志类的 App 设置（如选项打乱）。
class SettingsService {
  SettingsService._();

  static const _kShuffle = 'shuffle_options';

  static Future<bool> getShuffleOptions() async =>
      (await SharedPreferences.getInstance()).getBool(_kShuffle) ?? false;

  static Future<void> setShuffleOptions(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_kShuffle, value);
}
