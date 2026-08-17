import 'package:flutter/material.dart';

import '../data/database.dart';
import '../models/mastery.dart';
import '../widgets/charts.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool _loading = true;
  List<QuestionProgress> _items = [];
  List<DailyStat> _trend = [];
  List<int> _dueDistribution = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    final items = await db.getProgress();
    final trend = await db.getDailyStats(14);
    final dueDist = await db.getDueDistribution(7);
    if (!mounted) return;
    setState(() {
      _items = items;
      _trend = trend;
      _dueDistribution = dueDist;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final mastered = _items.where((e) => e.mastery == Mastery.mastered).length;
    final fuzzy = _items.where((e) => e.mastery == Mastery.fuzzy).length;
    final newCount = _items.where((e) => e.mastery == Mastery.newCard).length;

    // 按章节分组统计三态
    final grouped = <String, List<QuestionProgress>>{};
    for (final e in _items) {
      grouped.putIfAbsent(e.chapter, () => []).add(e);
    }
    final chapterStats = <(String, int, int, int)>[
      for (final entry in grouped.entries)
        (
          entry.key,
          entry.value.where((e) => e.mastery == Mastery.mastered).length,
          entry.value.where((e) => e.mastery == Mastery.fuzzy).length,
          entry.value.where((e) => e.mastery == Mastery.newCard).length,
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('学习进度')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(label: '掌握', count: mastered, color: Colors.green),
                  _StatCard(label: '模糊', count: fuzzy, color: Colors.orange),
                  _StatCard(label: '未学', count: newCount, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            MasteryDonutChart(
              mastered: mastered,
              fuzzy: fuzzy,
              newCount: newCount,
            ),
            ChapterStackedBarChart(chapters: chapterStats),
            DueDistributionChart(dueByDay: _dueDistribution),
            MemoryScatterChart(items: _items),
            DailyTrendChart(stats: _trend),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '题目明细',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            for (final entry in grouped.entries) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              ...entry.value.map(_buildItem),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(QuestionProgress e) {
    final color = switch (e.mastery) {
      Mastery.mastered => Colors.green,
      Mastery.fuzzy => Colors.orange,
      Mastery.newCard => Colors.grey,
    };
    final stabilityText = e.reps == 0
        ? '未复习'
        : '稳定度 ${e.stability.toStringAsFixed(1)} 天 · 复习 ${e.reps} 次'
            '${e.lapses > 0 ? ' · 忘过 ${e.lapses} 次' : ''}';

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 13,
        backgroundColor: color.withValues(alpha: 0.15),
        child: Text(e.mastery.label, style: TextStyle(fontSize: 11, color: color)),
      ),
      title: Text(
        e.stem,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text('${e.knowledgePoint} · $stabilityText',
          style: const TextStyle(fontSize: 12)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatCard({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text('$count',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
