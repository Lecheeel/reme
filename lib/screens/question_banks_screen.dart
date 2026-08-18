import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/anki_package_reader.dart';
import '../data/database.dart';

class QuestionBanksScreen extends StatefulWidget {
  const QuestionBanksScreen({super.key});

  @override
  State<QuestionBanksScreen> createState() => _QuestionBanksScreenState();
}

class _QuestionBanksScreenState extends State<QuestionBanksScreen> {
  List<QuestionBankInfo> _banks = [];
  String _activeId = 'builtin_politics';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    await db.ensureBuiltInBank();
    final result = await Future.wait([
      db.getQuestionBanks(),
      db.getActiveBankId(),
    ]);
    if (!mounted) return;
    setState(() {
      _banks = result[0] as List<QuestionBankInfo>;
      _activeId = result[1] as String;
      _loading = false;
    });
  }

  Future<void> _switch(QuestionBankInfo bank) async {
    if (bank.id == _activeId) return;
    await DatabaseHelper.instance.setActiveBank(bank.id);
    if (!mounted) return;
    setState(() => _activeId = bank.id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('已切换到「${bank.name}」')));
  }

  Future<void> _delete(QuestionBankInfo bank) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('删除「${bank.name}」？'),
        content: Text('将删除该题库的 ${bank.questionCount} 道题及全部学习进度，其他题库不受影响。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await DatabaseHelper.instance.deleteQuestionBank(bank.id);
    await _load();
  }

  Future<void> _import() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apkg'],
    );
    final path = picked.single.path;
    if (path == null || !mounted) return;
    final id = 'anki:${DateTime.now().millisecondsSinceEpoch}';
    late final AnkiImportResult preview;
    try {
      preview = await AnkiPackageReader().readFile(path, bankId: id);
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('无法解析牌组：$e')));
      }
      return;
    }
    if (!mounted) return;
    final name = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => _ImportPreview(result: preview)),
    );
    if (name == null) {
      return;
    }
    await DatabaseHelper.instance.importQuestionBank(
      id: id,
      name: name,
      source: 'anki',
      subject: preview.bankName,
      questions: preview.questions,
    );
    if (!mounted) return;
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已导入「$name」：${preview.questions.length} 题')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('我的题库')),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _import,
      icon: const Icon(Icons.file_upload),
      label: const Text('导入 Anki'),
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  '各题库的题目与复习进度彼此独立。',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              for (final bank in _banks)
                Card(
                  child: ListTile(
                    leading: Icon(
                      bank.id == _activeId
                          ? Icons.check_circle
                          : Icons.menu_book,
                      color: bank.id == _activeId ? Colors.green : null,
                    ),
                    title: Text(bank.name),
                    subtitle: Text(
                      '${bank.builtIn ? '内置' : 'Anki 导入'} · ${bank.questionCount} 题 · ${bank.subject}',
                    ),
                    trailing: bank.builtIn
                        ? (bank.id == _activeId
                              ? const Text('当前')
                              : const Icon(Icons.chevron_right))
                        : PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'delete') _delete(bank);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('删除题库'),
                              ),
                            ],
                          ),
                    onTap: () => _switch(bank),
                  ),
                ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.public, color: Colors.indigo),
                  title: const Text('发现社区牌组'),
                  subtitle: const Text('在 AnkiWeb 下载 .apkg 后，回到这里导入'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => launchUrl(
                    Uri.parse('https://ankiweb.net/shared/decks'),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ),
            ],
          ),
  );
}

class _ImportPreview extends StatefulWidget {
  final AnkiImportResult result;
  const _ImportPreview({required this.result});
  @override
  State<_ImportPreview> createState() => _ImportPreviewState();
}

class _ImportPreviewState extends State<_ImportPreview> {
  late final TextEditingController _name = TextEditingController(
    text: widget.result.bankName,
  );
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qs = widget.result.questions;
    final single = qs.where((q) => q.type.name == 'single').length;
    return Scaffold(
      appBar: AppBar(title: const Text('导入预览')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '将创建一个独立题库',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: '题库名称',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '可导入题目：${qs.length}\n单项选择题：$single\n多项选择题：${qs.length - single}\n章节：${qs.map((q) => q.chapter).toSet().length}\n跳过：${widget.result.skipped}',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              final name = _name.text.trim();
              if (name.isNotEmpty) Navigator.pop(context, name);
            },
            child: Text('导入 ${qs.length} 题'),
          ),
        ],
      ),
    );
  }
}
