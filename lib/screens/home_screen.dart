import 'package:flutter/material.dart';

import '../data/database.dart';
import 'chapter_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _total = 0;
  int _due = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final (total, due) = await DatabaseHelper.instance.getSubjectStats();
    if (!mounted) return;
    setState(() {
      _total = total;
      _due = due;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reme'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSubjectCard(),
          ],
        ),
      ),
      floatingActionButton: _due > 0
          ? FloatingActionButton.extended(
              onPressed: () => _startReview(null),
              icon: const Icon(Icons.play_arrow),
              label: Text('开始复习 ($_due)'),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('把该刷的题刷够', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'FSRS 间隔重复 · 在遗忘前重现',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSubjectCard() {
    final mastered = _total - _due;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: const Text('考研政治',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('待复习 $_due · 已掌握 $mastered · 共 $_total'),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _total == 0 ? 0 : mastered / _total,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChapterScreen()),
          );
        },
      ),
    );
  }

  void _startReview(String? chapter) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReviewScreen(chapter: chapter)),
    );
  }
}
