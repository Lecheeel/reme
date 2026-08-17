import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/log_service.dart';
import '../data/settings_service.dart';
import '../models/card.dart';
import '../models/question.dart';
import '../models/rating.dart';
import '../scheduler/fsrs.dart';

/// 单题在当前复习会话中的状态。
class _SessionItem {
  final Question question;
  int streak = 0; // 连续答对（且评「记得/简单」）次数
  _SessionItem(this.question);
}

/// 刷题闭环：读题 → 作答（单选点击即判）→ 判分 → 解析 → FSRS 评分。
/// 模糊/不认识的题会在本次会话中反复出现，直到连续 3 次答对才过关。
class ReviewScreen extends StatefulWidget {
  final String? chapter; // null = 全部科目/章节

  const ReviewScreen({super.key, this.chapter});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  static const int _passTarget = 3; // 连续答对次数达到该值才算过关
  final _fsrs = FSRS();

  bool _loading = true;
  List<_SessionItem> _queue = [];
  int _total = 0;
  int _graduated = 0;
  int _attempts = 0;
  int _correctAttempts = 0;
  bool _shuffle = false;

  // 当前展示的选项与正确答案（可能被打乱顺序）
  List<QuestionOption> _displayOptions = [];
  List<String> _displayAnswer = [];

  Set<String> _selected = {};
  bool _submitted = false;
  List<SchedulingOutcome>? _outcomes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _shuffle = await SettingsService.getShuffleOptions();
    final dailyTarget = await SettingsService.getDailyTarget();
    var qs =
        await DatabaseHelper.instance.getDueQuestions(chapter: widget.chapter);
    if (qs.length > dailyTarget) {
      qs = qs.sublist(0, dailyTarget); // 按每日学习量截断
    }
    if (!mounted) return;
    setState(() {
      _queue = qs.map((q) => _SessionItem(q)).toList();
      _total = _queue.length;
      _graduated = 0;
      _attempts = 0;
      _correctAttempts = 0;
      _loading = false;
      _resetForCurrent();
    });
    LogService.instance.log('info',
        'review start chapter=${widget.chapter ?? "all"} count=${qs.length} target=$dailyTarget shuffle=$_shuffle');
  }

  void _resetForCurrent() {
    _selected = {};
    _submitted = false;
    _outcomes = null;
    _prepareOptions();
  }

  /// 按设置决定是否打乱选项，并同步算出打乱后的正确答案。
  void _prepareOptions() {
    if (_queue.isEmpty) return;
    final q = _queue.first.question;
    if (_shuffle) {
      final texts = q.options.map((o) => o.text).toList()..shuffle();
      _displayOptions = [
        for (var i = 0; i < q.options.length; i++)
          QuestionOption(label: q.options[i].label, text: texts[i]),
      ];
      final correctTexts = q.answer
          .map((l) => q.options.firstWhere((o) => o.label == l).text)
          .toSet();
      _displayAnswer = [
        for (final o in _displayOptions)
          if (correctTexts.contains(o.text)) o.label,
      ];
    } else {
      _displayOptions = q.options;
      _displayAnswer = q.answer;
    }
  }

  bool _isCorrect(Set<String> selected) {
    if (selected.length != _displayAnswer.length) return false;
    return selected.containsAll(_displayAnswer);
  }

  void _onOptionTap(String label) {
    if (_submitted) return;
    final q = _queue.first.question;
    if (q.type == QuestionType.single) {
      setState(() => _selected = {label});
      _submit();
    } else {
      setState(() {
        if (_selected.contains(label)) {
          _selected.remove(label);
        } else {
          _selected.add(label);
        }
      });
    }
  }

  Future<void> _submit() async {
    final item = _queue.first;
    final correct = _isCorrect(_selected);
    setState(() {
      _submitted = true;
      _attempts++;
      if (correct) _correctAttempts++;
    });
    final card = await DatabaseHelper.instance.getCard(item.question.id) ??
        CardState(questionId: item.question.id);
    final outcomes = _fsrs.schedule(card, DateTime.now());
    LogService.instance.log('info',
        'submit ${item.question.id} correct=$correct selected=${_selected.toList()}');
    if (!mounted) return;
    setState(() => _outcomes = outcomes);
  }

  Future<void> _rate(Rating rating) async {
    final item = _queue.first;
    final q = item.question;
    final correct = _isCorrect(_selected);
    final card = await DatabaseHelper.instance.getCard(q.id) ??
        CardState(questionId: q.id);
    final outcome = _outcomes!.firstWhere((o) => o.rating == rating);
    final now = DateTime.now();
    final updated = CardState(
      questionId: q.id,
      difficulty: outcome.difficulty,
      stability: outcome.stability,
      lastReview: now,
      due: now.add(Duration(days: outcome.intervalDays)),
      reps: card.reps + 1,
      lapses: card.lapses + (rating == Rating.again ? 1 : 0),
      seed: card.seed,
    );
    await DatabaseHelper.instance.upsertCard(updated);
    LogService.instance.log('info',
        'rate ${q.id} ${rating.short} '
        'd=${outcome.difficulty.toStringAsFixed(2)} '
        's=${outcome.stability.toStringAsFixed(2)} '
        'ivl=${outcome.intervalDays}d');

    // 过关判定：答对 + 评「记得/简单」记一次过关；否则清零重来
    final pass = correct && (rating == Rating.good || rating == Rating.easy);
    if (!mounted) return;
    setState(() {
      item.streak = pass ? item.streak + 1 : 0;
      if (item.streak >= _passTarget) {
        _queue.removeAt(0); // 过关，移出队列
        _graduated++;
        LogService.instance.log('info', 'graduate ${q.id}');
      } else {
        _queue.add(_queue.removeAt(0)); // 没过关，排到队尾再次出现
      }
      if (_queue.isEmpty) {
        LogService.instance.log('info',
            'review done graduated=$_graduated/$_total attempts=$_attempts correct=$_correctAttempts');
        LogService.instance.upload(); // 自动上传日志
      }
      _resetForCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_total == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('复习')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.done_all, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              const Text('今日没有待复习的题目'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }
    if (_queue.isEmpty) {
      final rate = _attempts == 0 ? '0%' : '${(_correctAttempts * 100 / _attempts).round()}%';
      return Scaffold(
        appBar: AppBar(title: const Text('完成')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text('本轮复习完成！', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('过关 $_graduated / $_total 题 · 答题 $_attempts 次 · 答对 $_correctAttempts 次 ($rate)'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter ?? '复习'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _total == 0 ? 0 : _graduated / _total,
            minHeight: 4,
          ),
        ),
      ),
      body: _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _queue.first.question;
    final streak = _queue.first.streak;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(q.type.label),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              if (streak > 0) ...[
                Chip(
                  label: Text('连续答对 $streak/$_passTarget'),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.green.shade50,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  q.knowledgePoint,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('${_graduated + 1}/$_total'),
            ],
          ),
          const SizedBox(height: 16),
          Text(q.stem, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ..._displayOptions.map(_buildOption),
          const SizedBox(height: 24),
          if (!_submitted && q.type == QuestionType.multiple)
            FilledButton(
              onPressed: _selected.isEmpty ? null : _submit,
              child: const Text('提交答案'),
            )
          else if (_submitted) ...[
            _buildResult(),
            const SizedBox(height: 16),
            if (_outcomes != null) _buildRatingButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(QuestionOption o) {
    final isCorrect = _displayAnswer.contains(o.label);
    final isSelected = _selected.contains(o.label);
    Color? bg;
    Color border = Colors.grey.shade300;
    Widget? trailing;

    if (!_submitted) {
      if (isSelected) {
        bg = Theme.of(context).colorScheme.primaryContainer;
        border = Theme.of(context).colorScheme.primary;
      }
    } else {
      if (isCorrect) {
        bg = Colors.green.shade50;
        border = Colors.green;
        trailing = const Icon(Icons.check_circle, color: Colors.green);
      } else if (isSelected) {
        bg = Colors.red.shade50;
        border = Colors.red;
        trailing = const Icon(Icons.cancel, color: Colors.red);
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: border),
      ),
      child: ListTile(
        leading: CircleAvatar(radius: 14, child: Text(o.label)),
        title: Text(o.text),
        trailing: trailing,
        onTap: _submitted ? null : () => _onOptionTap(o.label),
      ),
    );
  }

  Widget _buildResult() {
    final correct = _isCorrect(_selected);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: correct ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.check_circle : Icons.cancel,
                  color: correct ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Text(
                correct ? '回答正确' : '回答错误',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: correct ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '正确答案：${_displayAnswer.join('、')}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          if (_queue.first.question.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('解析：${_queue.first.question.explanation}'),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('这次记得怎么样？', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: _outcomes!
              .map((o) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _ratingButton(o),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _ratingButton(SchedulingOutcome o) {
    return FilledButton.tonal(
      onPressed: () => _rate(o.rating),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(o.rating.label),
          const SizedBox(height: 2),
          Text(_intervalText(o.intervalDays),
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _intervalText(int days) {
    if (days <= 0) return '待会再看';
    if (days == 1) return '1 天';
    return '$days 天';
  }
}
