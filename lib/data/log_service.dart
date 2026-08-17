import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

/// 调试日志服务：启用后把日志追加写入本地文件，并支持 POST 上传到电脑端接收服务。
///
/// 设计要点：
///  - 日志落盘（数据库目录下的 reme_debug.log），崩溃也能保留；
///  - 上传成功后才清空文件；
///  - 所有网络/文件操作都吞异常，绝不因日志功能影响主流程。
class LogService {
  LogService._();
  static final LogService instance = LogService._();

  static const _kEnabled = 'debug_logging_enabled';
  static const _kUrl = 'debug_log_upload_url';
  static const defaultUrl = 'http://192.168.31.69:8765';

  bool _enabled = false;
  String _url = defaultUrl;
  File? _file;
  final StringBuffer _buffer = StringBuffer();

  bool get enabled => _enabled;
  String get url => _url;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_kEnabled) ?? false;
    _url = prefs.getString(_kUrl) ?? defaultUrl;
    final dir = await getDatabasesPath();
    _file = File('$dir/reme_debug.log');
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabled, value);
    log('info', 'debug logging ${value ? "enabled" : "disabled"}');
  }

  Future<void> setUrl(String value) async {
    _url = value.isEmpty ? defaultUrl : value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUrl, _url);
  }

  /// 记录一条日志（未启用时是 no-op）。
  void log(String level, String message) {
    if (!_enabled || _file == null) return;
    _buffer.write('${DateTime.now().toIso8601String()} [$level] $message\n');
    _flushToFile();
  }

  void _flushToFile() {
    try {
      _file!.writeAsStringSync(_buffer.toString(), mode: FileMode.append);
      _buffer.clear();
    } catch (_) {
      // 忽略磁盘错误
    }
  }

  /// 上传日志到电脑端；成功后清空本地日志文件。返回是否成功。
  Future<bool> upload() async {
    if (!_enabled || _file == null) return false;
    _flushToFile();
    try {
      if (!_file!.existsSync()) return false;
      final content = _file!.readAsStringSync();
      if (content.trim().isEmpty) return false;

      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 5);
      final req = await client.postUrl(Uri.parse('$_url/upload'));
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({'device': 'reme-android', 'logs': content}));
      final resp = await req.close();
      final ok = resp.statusCode == 200;
      if (ok) {
        _file!.writeAsStringSync(''); // 成功才清空，失败保留待重传
      }
      client.close();
      return ok;
    } catch (_) {
      return false;
    }
  }
}
