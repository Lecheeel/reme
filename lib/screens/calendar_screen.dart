import 'package:flutter/material.dart';

import '../data/database.dart';

/// 日历打卡页：自绘月历，每天格子显示打卡状态，
/// 点击某天查看当天详情，顶部显示连续打卡天数。
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late int _year;
  late int _month;
  Map<String, DailyStat> _stats = {};
  bool _loading = true;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _load();
  }

  Future<void> _load() async {
    final stats = await DatabaseHelper.instance.getMonthStats(_year, _month);
    final streak = await DatabaseHelper.instance.getCheckInStreak();
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _streak = streak;
      _loading = false;
    });
  }

  void _shiftMonth(int delta) {
    var m = _month + delta;
    var y = _year;
    while (m < 1) {
      m += 12;
      y--;
    }
    while (m > 12) {
      m -= 12;
      y++;
    }
    setState(() {
      _year = y;
      _month = m;
      _loading = true;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('打卡日历'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_available),
            tooltip: '今日打卡',
            onPressed: () => _shiftMonthToToday(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 8),
                _buildStreakBar(),
                _buildMonthHeader(),
                _buildWeekHeader(),
                Expanded(child: _buildGrid()),
              ],
            ),
    );
  }

  void _shiftMonthToToday() {
    final now = DateTime.now();
    setState(() {
      _year = now.year;
      _month = now.month;
      _loading = true;
    });
    _load();
  }

  Widget _buildStreakBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.deepOrange),
          const SizedBox(width: 6),
          Text(
            '连续打卡 $_streak 天',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _shiftMonth(-1),
          ),
          Text(
            '$_year 年 $_month 月',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _shiftMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (final w in weekdays)
            Expanded(
              child: Center(
                child: Text(
                  w,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(_year, _month, 1);
    // 周一为每周第一天：weekday 1=周一 ... 7=周日，前导空格 = weekday - 1
    final leading = firstDay.weekday - 1;
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final today = DateTime.now();
    final isCurrentMonth = today.year == _year && today.month == _month;

    final cells = <Widget>[
      for (var i = 0; i < leading; i++) const SizedBox(),
      for (var day = 1; day <= daysInMonth; day++) _buildDayCell(day, today, isCurrentMonth),
    ];

    return GridView.count(
      crossAxisCount: 7,
      padding: const EdgeInsets.all(8),
      children: cells,
    );
  }

  Widget _buildDayCell(int day, DateTime today, bool isCurrentMonth) {
    final date = DateTime(_year, _month, day);
    final key = DatabaseHelper.dateStr(date);
    final stat = _stats[key];
    final isToday = isCurrentMonth && day == today.day;
    final checked = stat?.checkedIn ?? false;
    final hasStudy = (stat?.reviewCount ?? 0) > 0;

    Color? bg;
    Color fg = Colors.black87;
    if (checked) {
      bg = Colors.green;
      fg = Colors.white;
    } else if (hasStudy) {
      bg = Colors.orange.withValues(alpha: 0.15);
    }

    return GestureDetector(
      onTap: () => _showDayDetail(day, stat),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: fg)),
            const SizedBox(height: 2),
            if (checked)
              const Icon(Icons.check_circle, size: 12, color: Colors.white)
            else if (hasStudy)
              Text('${stat!.reviewCount}',
                  style: TextStyle(fontSize: 9, color: Colors.orange.shade800))
            else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showDayDetail(int day, DailyStat? stat) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$_year 年 $_month 月 $day 日'),
        content: stat == null
            ? const Text('当天没有学习记录')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stat.checkedIn)
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 6),
                        Text('已打卡', style: TextStyle(color: Colors.green)),
                      ],
                    )
                  else
                    const Text('未打卡'),
                  const SizedBox(height: 10),
                  Text('刷题 ${stat.reviewCount} 次 · 新学 ${stat.newCount} · 过关 ${stat.graduatedCount}'),
                  const SizedBox(height: 4),
                  Text('正确率 ${(stat.accuracy * 100).toStringAsFixed(0)}%'),
                  if (stat.checkInTime != null) ...[
                    const SizedBox(height: 4),
                    Text('打卡时间 '
                        '${stat.checkInTime!.hour.toString().padLeft(2, '0')}:'
                        '${stat.checkInTime!.minute.toString().padLeft(2, '0')}'),
                  ],
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
