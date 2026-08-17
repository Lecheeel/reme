import 'package:flutter/material.dart';

import '../data/database.dart';
import '../models/card.dart';
import '../models/question.dart';
import '../models/rating.dart';
import '../scheduler/fsrs.dart';

/// 刷题闭环：读题 → 作答 → 判分 → 解析 → FSRS 评分 → 下一题。
class ReviewScreen extends StatefulWidget {
  final String? chapter; // null = 全部科目/章节

  const ReviewScreen({super.key, this.chapter});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _fsrs = FSRS();

  bool _loading = true;
  List<Question> _questions = [];
  int _index = 0;
  Set<String> _selected = {};
  bool _submitted = false;
  List<SchedulingOutcome>? _outcomes;
  int _correct = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qs =
        await DatabaseHelper.instance.getDueQuestions(chapter: widget.chapter);
    if (!mounted) return;
    setState(() {
      _questions = qs;
      _loading = false;
      _index = 0;
      _reset();
    });
  }

  void _reset() {
    _selected = {};
    _submitted = false;
    _outcomes = null;
  }

  Future<void> _submit() async {
    final q = _questions[_index];
    final correct = q.checkAnswer(_selected.toList());
    final card = await DatabaseHelper.instance.getCard(q.id) ??
        CardState(questionId: q.id);
    final outcomes = _fsrs.schedule(card, DateTime.now());
    if (!mounted) return;
    setState(() {
      _submitted = true;
      _outcomes = outcomes;
      if (correct) _correct++;
    });
  }

  Future<void> _rate(Rating rating) async {
    final q = _questions[_index];
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
    if (!mounted) return;
    setState(() {
      _index++;
      _reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_questions.isEmpty) {
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
    if (_index >= _questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('完成')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text('今日复习完成！', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('答对 $_correct / ${_questions.length}'),
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
            value: _questions.isEmpty ? 0 : _index / _questions.length,
            minHeight: 4,
          ),
        ),
      ),
      body: _buildQuestion(),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_index];
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
              Expanded(
                child: Text(
                  q.knowledgePoint,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('${_index + 1}/${_questions.length}'),
            ],
          ),
          const SizedBox(height: 16),
          Text(q.stem, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ...q.options.map((o) => _buildOption(q, o)),
          const SizedBox(height: 24),
          if (!_submitted)
            FilledButton(
              onPressed: _selected.isEmpty ? null : _submit,
              child: const Text('提交答案'),
            )
          else ...[
            _buildResult(q),
            const SizedBox(height: 16),
            _buildRatingButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildOption(Question q, QuestionOption o) {
    final isCorrect = q.answer.contains(o.label);
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
        onTap: _submitted ? null : () => _toggle(o.label),
      ),
    );
  }

  void _toggle(String label) {
    setState(() {
      final q = _questions[_index];
      if (q.type == QuestionType.single) {
        _selected = {label};
      } else {
        if (_selected.contains(label)) {
          _selected.remove(label);
        } else {
          _selected.add(label);
        }
      }
    });
  }

  Widget _buildResult(Question q) {
    final correct = q.checkAnswer(_selected.toList());
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
                '正确答案：${q.answer.join('、')}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          if (q.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('解析：${q.explanation}'),
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
