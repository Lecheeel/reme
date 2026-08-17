import 'dart:math';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/log_service.dart';
import '../data/settings_service.dart';
import 'calendar_screen.dart';
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
  int _newCount = 0; // 队列三栏：新题
  int _learningCount = 0; // 学习中（未掌握且到期）
  int _reviewCount = 0; // 复习（已掌握且到期）
  double _k = 1.5; // 每掌握一题平均作答次数（估算用，真实数据兜底）
  int _effectiveDaily = 0; // 每天用于推进掌握的净产能（扣除到期复习）
  DailyStat? _today; // 今日学习统计（打卡用）
  int _streak = 0; // 连续打卡天数
  bool _showHomeOverride = false; // 打卡后点「加强巩固」临时回到主页（下次进 App 仍默认小结页）

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final db = DatabaseHelper.instance;
    final (total, due, mastered, dueReview) = await db.getSubjectStats();
    final target = await SettingsService.getDailyTarget();
    final avgReps = await db.getAvgRepsForMastered();
    final today = await db.getTodayStat();
    final streak = await db.getCheckInStreak();
    final (newCnt, learnCnt, reviewCnt) = await db.getQueueCounts();
    if (!mounted) return;
    setState(() {
      _total = total;
      _due = due;
      _mastered = mastered;
      _dailyTarget = target;
      _newCount = newCnt;
      _learningCount = learnCnt;
      _reviewCount = reviewCnt;
      // 每掌握一题平均消耗的作答次数：真实统计（clamp 1~4），无数据兜底 1.5
      final k = ((avgReps ?? 1.5).clamp(1.0, 4.0)).toDouble();
      _k = k;
      // 每天到期复习占用产能（上限 60%，防止复习爆炸时算出 0 天）
      final reviewLoad = (dueReview).clamp(0, (target * 0.6).round()).toInt();
      _effectiveDaily = max(target - reviewLoad, 1);
      final remaining = max(total - mastered, 0);
      _estimateDays =
          remaining == 0 ? 0 : (remaining * k / _effectiveDaily).ceil();
      _today = today;
      _streak = streak;
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
            helperText: '打卡基准：当天刷题次数达到该值即可打卡',
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
              if (v == null || v <= 0) {
                ScaffoldMessenger.of(ctx)
                  ..clearSnackBars()
                  ..showSnackBar(const SnackBar(content: Text('请输入正整数')));
                return;
              }
              Navigator.pop(ctx, v);
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

  Future<void> _doCheckIn() async {
    final todayDone = _today?.reviewCount ?? 0;
    if (todayDone < _dailyTarget) {
      _snack('还差 ${_dailyTarget - todayDone} 题才能打卡，加油！');
      return;
    }
    await DatabaseHelper.instance.checkIn(DatabaseHelper.dateStr(DateTime.now()));
    LogService.instance.log('info', 'check-in done');
    await _refresh();
    _snack('🎉 今日打卡成功！连续打卡 ${_streak + 1} 天');
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final checkedInToday = _today?.checkedIn ?? false;
    final showSummary = checkedInToday && !_showHomeOverride;
    final today = min(_due, _dailyTarget);
    return Scaffold(
      appBar: AppBar(
        title: Text(showSummary ? '今日小结' : 'Reme'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: '打卡日历',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
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
        child: showSummary ? _buildTodaySummary() : _buildHomeBody(),
      ),
      floatingActionButton: (!showSummary && _due > 0)
          ? FloatingActionButton.extended(
              onPressed: () => _startReview(null),
              icon: const Icon(Icons.play_arrow),
              label: Text('开始复习 (今天 $today 题)'),
            )
          : null,
    );
  }

  Widget _buildHomeBody() {
    final todayDone = _today?.reviewCount ?? 0;
    final progress = _dailyTarget == 0 ? 0.0 : (todayDone / _dailyTarget).clamp(0.0, 1.0);
    final canCheckIn = todayDone >= _dailyTarget;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildSubjectCard(),
        const SizedBox(height: 12),
        _buildPlanCard(),
        const SizedBox(height: 12),
        _buildCheckInCard(todayDone, progress, canCheckIn),
        const SizedBox(height: 12),
        _buildProgressCard(),
      ],
    );
  }

  /// 已打卡：当日统计页。
  Widget _buildTodaySummary() {
    final t = _today;
    final done = t?.reviewCount ?? 0;
    final acc = t?.accuracy ?? 0;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Icon(Icons.check_circle, size: 64, color: Colors.green),
        const SizedBox(height: 8),
        const Center(
          child: Text('今日已打卡',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text('连续打卡 $_streak 天',
              style: TextStyle(color: Colors.deepOrange.shade400)),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SummaryRow(label: '今日刷题', value: '$done 次'),
                _SummaryRow(label: '新学题目', value: '${t?.newCount ?? 0} 道'),
                _SummaryRow(label: '过关题目', value: '${t?.graduatedCount ?? 0} 道'),
                _SummaryRow(
                    label: '正确率', value: '${(acc * 100).toStringAsFixed(0)}%'),
                if (t?.checkInTime != null)
                  _SummaryRow(
                    label: '打卡时间',
                    value:
                        '${t!.checkInTime!.hour.toString().padLeft(2, '0')}:'
                        '${t.checkInTime!.minute.toString().padLeft(2, '0')}',
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CalendarScreen()),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('打卡日历'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => setState(() => _showHomeOverride = true),
                icon: const Icon(Icons.bolt),
                label: const Text('加强巩固'),
              ),
            ),
          ],
        ),
      ],
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
              Text('新题 $_newCount · 学习中 $_learningCount · 复习 $_reviewCount · 已掌握 $_mastered'),
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
            subtitle: const Text('当天刷题次数达到该值即可打卡'),
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

  Widget _buildCheckInCard(int todayDone, double progress, bool canCheckIn) {
    final alreadyChecked = _today?.checkedIn ?? false;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag,
                    color: alreadyChecked ? Colors.green : Colors.deepOrange),
                const SizedBox(width: 6),
                Text('今日打卡',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                Text('连续 $_streak 天',
                    style: TextStyle(
                        fontSize: 12, color: Colors.deepOrange.shade400)),
              ],
            ),
            const SizedBox(height: 10),
            Text(alreadyChecked
                ? '今天已打卡，可继续加强巩固'
                : '今天已刷 $todayDone / $_dailyTarget 题'),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: canCheckIn ? Colors.green : Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: alreadyChecked
                  ? FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.verified),
                      label: const Text('今日已打卡 ✓'),
                    )
                  : FilledButton.icon(
                      onPressed: canCheckIn ? _doCheckIn : null,
                      icon: const Icon(Icons.verified),
                      label: Text(canCheckIn ? '打卡' : '还差 ${_dailyTarget - todayDone} 题'),
                    ),
            ),
          ],
        ),
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
        subtitle: const Text('图表可视化：掌握分布 / 到期规划 / 记忆成熟度'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          );
        },
      ),
    );
  }

  void _startReview(String? chapter) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ReviewScreen(chapter: chapter)),
    );
    if (mounted) _refresh(); // 复习完回来刷新今日进度/打卡状态
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
