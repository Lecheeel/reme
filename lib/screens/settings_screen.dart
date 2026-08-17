import 'package:flutter/material.dart';

import '../data/log_service.dart';
import '../data/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enabled = false;
  String _url = LogService.defaultUrl;
  bool _shuffle = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final shuffle = await SettingsService.getShuffleOptions();
    if (!mounted) return;
    setState(() {
      _enabled = LogService.instance.enabled;
      _url = LogService.instance.url;
      _shuffle = shuffle;
    });
  }

  Future<void> _toggleLog(bool value) async {
    await LogService.instance.setEnabled(value);
    setState(() => _enabled = value);
    _snack(value ? '调试日志已开启，日志将自动上传' : '调试日志已关闭');
  }

  Future<void> _toggleShuffle(bool value) async {
    await SettingsService.setShuffleOptions(value);
    setState(() => _shuffle = value);
    _snack(value ? '已开启选项打乱' : '已关闭选项打乱');
  }

  Future<void> _editUrl() async {
    final controller = TextEditingController(text: _url);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('上传地址'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            hintText: 'http://192.168.31.69:8765',
            helperText: '电脑端日志接收服务的地址',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      await LogService.instance.setUrl(result);
      setState(() => _url = LogService.instance.url);
    }
  }

  Future<void> _uploadNow() async {
    setState(() => _uploading = true);
    final ok = await LogService.instance.upload();
    if (!mounted) return;
    setState(() => _uploading = false);
    _snack(ok ? '日志已上传到 $_url' : '上传失败（检查电脑端服务是否运行、网络是否可达）');
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionHeader('复习'),
          SwitchListTile(
            title: const Text('打乱选项'),
            subtitle: const Text('每次出现时选项顺序随机，避免记住位置'),
            value: _shuffle,
            onChanged: _toggleShuffle,
          ),
          const Divider(),
          const _SectionHeader('调试日志'),
          SwitchListTile(
            title: const Text('调试日志'),
            subtitle: const Text('开启后记录运行日志，自动上传到电脑供分析'),
            value: _enabled,
            onChanged: _toggleLog,
          ),
          ListTile(
            title: const Text('上传地址'),
            subtitle: Text(_url),
            trailing: const Icon(Icons.edit),
            onTap: _editUrl,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton.icon(
              onPressed: _uploading ? null : _uploadNow,
              icon: _uploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_uploading ? '上传中…' : '立即上传日志'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '说明：开启调试日志后，App 会在复习完成后自动把日志上传到电脑端。'
              '电脑端运行 tools/log_receiver.py 即可接收，日志保存在 ~/reme-logs/。',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
