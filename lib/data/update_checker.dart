import 'dart:convert';
import 'dart:io';

/// GitHub Release 版本检查：拉取最新 tag，与本地版本比对。
/// 网络失败/非 200 一律静默返回 null（不打扰用户）。
class UpdateChecker {
  static const apiUrl =
      'https://api.github.com/repos/Lecheeel/reme/releases/latest';
  static const releasesUrl = 'https://github.com/Lecheeel/reme/releases';

  /// 获取 GitHub 最新 release 版本号（如 v2.1.1），失败返回 null。
  static Future<String?> fetchLatestVersion() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8);
    try {
      final req = await client.getUrl(Uri.parse(apiUrl));
      req.headers.set('User-Agent', 'Reme');
      req.headers.set('Accept', 'application/vnd.github+json');
      final resp = await req.close();
      if (resp.statusCode != 200) return null;
      final body = await resp.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['tag_name'] as String?;
    } catch (_) {
      return null; // 超时/断网/解析失败都静默
    } finally {
      client.close();
    }
  }

  /// latest 是否比 current 新（按 x.y.z 比较）。
  static bool isNewer(String latest, String current) {
    final a = _parse(latest);
    final b = _parse(current);
    if (a == null || b == null) return false;
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i] > b[i];
    }
    return false;
  }

  static List<int>? _parse(String v) {
    final m = RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(v);
    if (m == null) return null;
    return [
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    ];
  }
}
