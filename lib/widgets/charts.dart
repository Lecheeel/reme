import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/database.dart';
import '../models/mastery.dart';

/// 进度可视化图表集合。配色与全局语义一致：绿=掌握、橙=模糊、灰=未学。

const _masteredColor = Colors.green;
const _fuzzyColor = Colors.orange;
const _newColor = Colors.grey;
const _dueColor = Colors.indigo;
const _trendCountColor = Colors.indigo;
const _trendAccuracyColor = Colors.teal;

/// 图表卡片外壳：标题 + 图例 + 内容。
class ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final double height;

  const ChartCard({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 220,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
            const SizedBox(height: 12),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

/// 图例小点 + 文字。
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

/// 1. 掌握状态环形图：中心显示掌握率。
class MasteryDonutChart extends StatelessWidget {
  final int mastered;
  final int fuzzy;
  final int newCount;

  const MasteryDonutChart({
    super.key,
    required this.mastered,
    required this.fuzzy,
    required this.newCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = mastered + fuzzy + newCount;
    if (total == 0) {
      return const Center(child: Text('暂无题目'));
    }
    final rate = mastered / total;
    return ChartCard(
      title: '掌握状态',
      subtitle: '已掌握 $mastered / $total（${(rate * 100).toStringAsFixed(0)}%）',
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 52,
              sections: [
                if (mastered > 0)
                  PieChartSectionData(
                    value: mastered.toDouble(),
                    color: _masteredColor,
                    radius: 44,
                    title: mastered == 0 ? '' : '$mastered',
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                if (fuzzy > 0)
                  PieChartSectionData(
                    value: fuzzy.toDouble(),
                    color: _fuzzyColor,
                    radius: 44,
                    title: fuzzy == 0 ? '' : '$fuzzy',
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                if (newCount > 0)
                  PieChartSectionData(
                    value: newCount.toDouble(),
                    color: _newColor,
                    radius: 44,
                    title: newCount == 0 ? '' : '$newCount',
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${(rate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('掌握率', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. 章节掌握堆叠条形图：每章一根，绿/橙/灰三段。
class ChapterStackedBarChart extends StatelessWidget {
  final List<(String, int, int, int)> chapters; // (名称, 掌握, 模糊, 未学)

  const ChapterStackedBarChart({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    final data = chapters;
    if (data.isEmpty) {
      return const ChartCard(title: '章节掌握分布', child: Center(child: Text('暂无数据')));
    }
    final maxTotal =
        data.map((c) => c.$2 + c.$3 + c.$4).fold(0, (a, b) => a > b ? a : b);
    final maxY = (maxTotal * 1.1).ceilToDouble().clamp(10, double.infinity).toDouble();

    return ChartCard(
      title: '章节掌握分布',
      subtitle: '各章 掌握(绿) / 模糊(橙) / 未学(灰)',
      height: 240,
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final c = data[group.x];
                      return BarTooltipItem(
                        '${c.$1}\n掌握 ${c.$2} · 模糊 ${c.$3} · 未学 ${c.$4}',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (maxY / 4).ceilToDouble().clamp(1, double.infinity).toDouble(),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text((idx + 1).toString(),
                              style: const TextStyle(fontSize: 11)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: (maxY / 4).ceilToDouble(),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < data.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          width: 22,
                          toY: (data[i].$2 + data[i].$3 + data[i].$4).toDouble(),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3)),
                          rodStackItems: [
                            if (data[i].$2 > 0)
                              BarChartRodStackItem(
                                  0, data[i].$2.toDouble(), _masteredColor),
                            if (data[i].$3 > 0)
                              BarChartRodStackItem(
                                  data[i].$2.toDouble(),
                                  (data[i].$2 + data[i].$3).toDouble(),
                                  _fuzzyColor),
                            if (data[i].$4 > 0)
                              BarChartRodStackItem(
                                  (data[i].$2 + data[i].$3).toDouble(),
                                  (data[i].$2 + data[i].$3 + data[i].$4)
                                      .toDouble(),
                                  _newColor),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < data.length; i++) ...[
                Text((i + 1).toString(), style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 2),
                Text(data[i].$1.length > 4 ? data[i].$1.substring(0, 4) : data[i].$1,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 3. 未来到期分布柱状图：每天到期题数。
class DueDistributionChart extends StatelessWidget {
  final List<int> dueByDay; // [今天, +1天, +2天, ...]

  const DueDistributionChart({super.key, required this.dueByDay});

  @override
  Widget build(BuildContext context) {
    final days = dueByDay.length;
    final maxV = dueByDay.fold(0, (a, b) => a > b ? a : b);
    final maxY = maxV == 0 ? 5.0 : (maxV * 1.2).ceilToDouble();
    return ChartCard(
      title: '未来 $days 天到期分布',
      subtitle: '每天需要复习的题数（今天起）',
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: maxY > 20 ? maxY / 4 : 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= days) return const SizedBox.shrink();
                  final d = DateTime.now().add(Duration(days: idx));
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      idx == 0 ? '今天' : '${d.month}/${d.day}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY > 20 ? maxY / 4 : 1,
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (var i = 0; i < days; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: dueByDay[i].toDouble(),
                    width: 16,
                    color: _dueColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(3)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// 4. 记忆成熟度散点图：x=难度(1~10)，y=稳定度(天)。每点一题（已学）。
class MemoryScatterChart extends StatelessWidget {
  final List<QuestionProgress> items;

  const MemoryScatterChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final studied =
        items.where((e) => e.reps > 0).toList();
    if (studied.isEmpty) {
      return const ChartCard(
        title: '记忆成熟度',
        child: Center(child: Text('刷过题后这里会出现散点分布')),
      );
    }
    final maxStability = studied
        .map((e) => e.stability)
        .fold(0.0, (a, b) => a > b ? a : b);
    final maxY = (maxStability * 1.2).clamp(7.0, double.infinity).toDouble();

    Color colorOf(QuestionProgress e) => switch (e.mastery) {
          Mastery.mastered => _masteredColor,
          Mastery.fuzzy => _fuzzyColor,
          Mastery.newCard => _newColor,
        };

    return ChartCard(
      title: '记忆成熟度',
      subtitle: '每点一题 · 越靠右上越稳越简单，左下是薄弱题',
      height: 220,
      child: ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: 10,
          minY: 0,
          maxY: maxY,
          scatterSpots: [
            for (final e in studied)
              ScatterSpot(
                e.difficulty.clamp(0, 10).toDouble(),
                e.stability.clamp(0, maxY).toDouble(),
                dotPainter: FlDotCirclePainter(
                  radius: 5,
                  color: colorOf(e),
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
              ),
          ],
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: (maxY / 4).ceilToDouble().clamp(1, double.infinity).toDouble(),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: 2,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(value.toInt().toString(),
                      style: const TextStyle(fontSize: 10)),
                ),
              ),
            ),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: (maxY / 4).ceilToDouble(),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

/// 5. 近 N 天学习趋势：刷题数（左轴）+ 正确率%（右轴）。
class DailyTrendChart extends StatelessWidget {
  final List<DailyStat> stats; // 含空天占位，升序

  const DailyTrendChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final n = stats.length;
    final maxCount = stats
        .map((s) => s.reviewCount)
        .fold(0, (a, b) => a > b ? a : b);
    final maxY = maxCount == 0 ? 5.0 : (maxCount * 1.2).ceilToDouble();
    final hasData = stats.any((s) => s.reviewCount > 0);

    return ChartCard(
      title: '近 $n 天学习趋势',
      subtitle: '刷题数（靛蓝，左轴）· 正确率（青绿，右轴 %）',
      height: 220,
      child: hasData
          ? LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < n; i++)
                        FlSpot(i.toDouble(), stats[i].reviewCount.toDouble()),
                    ],
                    color: _trendCountColor,
                    isCurved: true,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < n; i++)
                        FlSpot(i.toDouble(), stats[i].accuracy * 100),
                    ],
                    color: _trendAccuracyColor,
                    isCurved: true,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: 25,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: (maxY / 4).ceilToDouble().clamp(1, double.infinity).toDouble(),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: (n / 7).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= n) return const SizedBox.shrink();
                        final d = DateTime.now()
                            .subtract(Duration(days: n - 1 - idx));
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('${d.month}/${d.day}',
                              style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval:
                      (maxY / 4).ceilToDouble().clamp(1, double.infinity).toDouble(),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          s.barIndex == 0
                              ? '刷题 ${s.y.toInt()} 次'
                              : '正确率 ${s.y.toStringAsFixed(0)}%',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: Text('刷题后这里会出现每日趋势', style: TextStyle(fontSize: 13)),
            ),
    );
  }
}

/// 图例行（供页面顶部/底部统一使用）。
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _LegendDot(_masteredColor, '掌握'),
          SizedBox(width: 12),
          _LegendDot(_fuzzyColor, '模糊'),
          SizedBox(width: 12),
          _LegendDot(_newColor, '未学'),
        ],
      ),
    );
  }
}
