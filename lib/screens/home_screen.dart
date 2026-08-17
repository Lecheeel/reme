import 'dart:math';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/settings_service.dart';
import 'chapter_screen.dart';
import 'progress_screen.dart';
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
  int _mastered = 0;
  int _dailyTarget = SettingsService.defaultDailyTarget;
  int _estimateDays = 0;
  double _k = 1.5; // 每掌握一题平均作答次数（估算用，真实数据兜底）
  int _effectiveDaily = 0; // 每天用于推进掌握的净产能（扣除到期复习）

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final (total, due, mastered, dueReview) =
        await DatabaseHelper.instance.getSubjectStats();
    final target = await SettingsService.getDailyTarget();
    final avgReps = await DatabaseHelper.instance.getAvgRepsForMastered();
    if (!mounted) return;
    setState(() {
      _total = total;
      _due = due;
      _mastered = mastered;
      _dailyTarget = target;
      // 每掌握一题平均消耗的作答次数：真实统计（clamp 1~4），无数据兜底 1.5
      final k = ((avgReps ?? 1.5).clamp(1.0, 4.0)).toDouble();
      _k = k;
      // 每天到期复习占用产能（上限 60%，防止复习爆炸时算出 0 天）
      final reviewLoad = (dueReview).clamp(0, (target * 0.6).round()).toInt();
      _effectiveDaily = max(target - reviewLoad, 1);
      final remaining = max(total - mastered, 0);
      _estimateDays =
          remaining == 0 ? 0 : (remaining * k / _effectiveDaily).ceil();
    });
  }

  Future<void> _editDailyTarget() async {
    final controller = TextEditingController(text: '$_dailyTarget');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('每日学习量'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            helperText: '每天复习的题目数（默认 50）',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              if (v != null && v > 0) Navigator.pop(ctx, v);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      await SettingsService.setDailyTarget(result);
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = min(_due, _dailyTarget);
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
            const SizedBox(height: 12),
            _buildPlanCard(),
            const SizedBox(height: 12),
            _buildProgressCard(),
          ],
        ),
      ),
      floatingActionButton: _due > 0
          ? FloatingActionButton.extended(
              onPressed: () => _startReview(null),
              icon: const Icon(Icons.play_arrow),
              label: Text('开始复习 (今天 $today 题)'),
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
    final remaining = _total - _mastered;
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
              Text('待复习 $_due · 已掌握 $_mastered · 待学 $remaining · 共 $_total'),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _total == 0 ? 0 : _mastered / _total,
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

  Widget _buildPlanCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.track_changes, color: Colors.indigo),
            title: const Text('每日学习量'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$_dailyTarget 题',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 16, color: Colors.grey),
              ],
            ),
            onTap: _editDailyTarget,
          ),
          ListTile(
            leading: const Icon(Icons.event_available, color: Colors.teal),
            title: const Text('预计学习天数'),
            subtitle: Text(_estimateDays == 0
                ? '全部掌握，无待学'
                : '剩余 ${_total - _mastered} 题 · 每掌握一题约 ${_k.toStringAsFixed(1)} 次作答 · 每天净学 $_effectiveDaily 题（已扣到期复习）'),
            trailing: Text(
              _estimateDays == 0 ? '—' : '$_estimateDays 天',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.insights, color: Colors.teal),
        title: const Text('学习进度',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('掌握 / 模糊 / 未学'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
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
