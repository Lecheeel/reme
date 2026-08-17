import 'dart:math';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../data/log_service.dart';
import '../data/question_bank_loader.dart';
import '../data/settings_service.dart';
import '../models/card.dart';
import '../models/question.dart';
import '../models/rating.dart';
import '../scheduler/fsrs.dart';

/// 单题在当前复习会话中的状态。
class _SessionItem {
  final Question question;
  int streak = 0; // 连续答对（且评「认识」）次数
  int attempts = 0; // 本会话内作答次数（用于判断是否初次作答）
  int wrongCount = 0; // 本会话内答错/评模糊/忘记次数（用于递增间隔重现）
  _SessionItem(this.question);
}

/// 撤销记录：恢复上一步评分。
class _UndoRecord {
  final String questionId;
  final CardState? cardBefore; // 评分前的卡片状态（null = 评分前无卡）
  final int graduatedBefore;
  final int attemptsBefore;
  final int correctBefore;
  final int newFirstTriesBefore;
  final _SessionItem item;
  final int insertAt; // item 在队列中的位置（_rate 时恒为队首 0）

  _UndoRecord({
    required this.questionId,
    required this.cardBefore,
    required this.graduatedBefore,
    required this.attemptsBefore,
    required this.correctBefore,
    required this.newFirstTriesBefore,
    required this.item,
    required this.insertAt,
  });
}

/// 刷题闭环：读题 → 作答（单选点击即判）→ 判分 → 解析 → FSRS 评分。
/// 初次作答即答对的题直接过关（首次掌握，复习周期 25 天）；
/// 模糊/不认识的题会在本次会话中反复出现，直到连续 3 次答对才过关。
class ReviewScreen extends StatefulWidget {
  final String? chapter; // null = 全部科目/章节
  final bool weakOnly; // true = 薄弱题专项队列（lapses ≥ 2 且到期）

  const ReviewScreen({super.key, this.chapter, this.weakOnly = false});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  static const int _passTarget = 3; // 连续答对次数达到该值才算过关
  static const double _firstPassStability = 25; // 初次答对直接掌握的稳定度（天）
  final _fsrs = FSRS();

  bool _loading = true;
  List<_SessionItem> _queue = [];
  String _wrongPos = SettingsService.wrongPosIncremental; // 错题重现策略
  _UndoRecord? _undo; // 上一步评分（可撤销）
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
  bool _firstTry = false; // 当前题是否为初次作答
  int _newFirstTries = 0; // 本会话首次作答的题数（埋点用）
  List<SchedulingOutcome>? _outcomes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _shuffle = await SettingsService.getShuffleOptions();
    final dailyTarget = await SettingsService.getDailyTarget();
    final newCap = await SettingsService.getNewDailyCap();
    _wrongPos = await SettingsService.getWrongReviewPosition();
    // 章节复习时，把该章子章节声明的 related 关联子章节（如全面依法治国
    // 关联党的全面领导/人民民主）的到期复习题也一起拉出来复习
    List<String>? related;
    if (widget.chapter != null) {
      final extra =
          await QuestionBankLoader().loadRelatedKpIdsForChapter(widget.chapter!);
      if (extra.isNotEmpty) related = extra;
    }
    // 负荷模型：复习优先全刷（不截断），剩余容量配新题
    // 新题配额 = min(新题上限 N, max(0, 每日目标 − 当天到期复习数))
    final List<Question> qs;
    if (widget.weakOnly) {
      // 薄弱题专项：lapses ≥ 2 且到期的题
      qs = await DatabaseHelper.instance.getWeakQuestions();
    } else {
      final reviews = await DatabaseHelper.instance
          .getReviewQuestions(chapter: widget.chapter, relatedKpIds: related);
      final newLimit = min(newCap, max(0, dailyTarget - reviews.length));
      final newQs = await DatabaseHelper.instance
          .getNewQuestions(chapter: widget.chapter, limit: newLimit);
      qs = [...reviews, ...newQs];
    }
    if (!mounted) return;
    setState(() {
      _queue = qs.map((q) => _SessionItem(q)).toList();
      _total = _queue.length;
      _graduated = 0;
      _attempts = 0;
      _correctAttempts = 0;
      _newFirstTries = 0;
      _undo = null;
      _loading = false;
      _resetForCurrent();
    });
    LogService.instance.log('info',
        'review start chapter=${widget.chapter ?? "all"} weak=${widget.weakOnly} count=${qs.length} target=$dailyTarget cap=$newCap shuffle=$_shuffle related=${related?.join(",") ?? "none"}');
  }

  void _resetForCurrent() {
    _selected = {};
    _submitted = false;
    _firstTry = false;
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
      _firstTry = item.attempts == 0; // 本题在本会话内第一次作答
      if (_firstTry) _newFirstTries++;
      item.attempts++;
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
    final existing = await DatabaseHelper.instance.getCard(q.id);
    final card = existing ?? CardState(questionId: q.id);
    final outcome = _outcomes!.firstWhere((o) => o.rating == rating);
    final now = DateTime.now();
    // 初次作答即答对：认识 = 直接掌握（首轮 25 天）；模糊 = 有点印象（对半约 13 天）；
    // 忘记 = 蒙的，按标准忘记处理（排队重练）。非初次走标准 FSRS 调度。
    final isFirstPass = _firstTry &&
        correct &&
        (rating == Rating.good || rating == Rating.hard);
    final firstPassDays = rating == Rating.good
        ? _firstPassStability.round()
        : (_firstPassStability / 2).round();
    final days = isFirstPass ? firstPassDays : outcome.intervalDays;
    // 记录撤销点（评分前的卡片状态与各项计数）
    _undo = _UndoRecord(
      questionId: q.id,
      cardBefore: existing,
      graduatedBefore: _graduated,
      attemptsBefore: _attempts,
      correctBefore: _correctAttempts,
      newFirstTriesBefore: _newFirstTries,
      item: item,
      insertAt: 0,
    );
    final updated = CardState(
      questionId: q.id,
      difficulty: outcome.difficulty,
      stability: isFirstPass ? days.toDouble() : outcome.stability,
      lastReview: now,
      due: now.add(Duration(days: days)),
      reps: card.reps + 1,
      lapses: card.lapses + (rating == Rating.again ? 1 : 0),
      seed: card.seed,
    );
    await DatabaseHelper.instance.upsertCard(updated);
    LogService.instance.log('info',
        'rate ${q.id} ${rating.short} '
        'd=${outcome.difficulty.toStringAsFixed(2)} '
        's=${updated.stability.toStringAsFixed(2)} '
        'ivl=${days}d${isFirstPass ? ' first-pass' : ''}');

    // 过关判定：初次答对（认识/模糊）直接过关；
    // 其余情况连续答对 + 评「认识」累计，达到 3 次过关；模糊/忘记/答错清零重来
    final pass = correct && rating == Rating.good;
    if (!mounted) return;
    setState(() {
      item.streak = pass ? item.streak + 1 : 0;
      final graduated = isFirstPass || item.streak >= _passTarget;
      if (graduated) {
        _queue.removeAt(0); // 过关，移出队列
        _graduated++;
        LogService.instance.log('info',
            'graduate ${q.id}${isFirstPass ? ' first-pass' : ''}');
      } else {
        _requeueWrong(); // 没过关：按设置插到 2~3 题后随机位置或队尾
      }
      if (_queue.isEmpty) {
        LogService.instance.log('info',
            'review done graduated=$_graduated/$_total attempts=$_attempts correct=$_correctAttempts');
        LogService.instance.upload(); // 自动上传日志
        // 写入今日学习统计（趋势图数据源）
        DatabaseHelper.instance.upsertDailyStat(DailyStat(
          date: DatabaseHelper.dateStr(DateTime.now()),
          newCount: _newFirstTries,
          reviewCount: _attempts,
          correctCount: _correctAttempts,
          graduatedCount: _graduated,
        ));
      }
      _resetForCurrent();
    });
  }

  /// 没过关的题重新入队：按策略——
  /// 递增间隔（默认）：第 1 次错隔 2 题、第 2 次隔 5 题、之后隔 10 题；
  /// 2~3 题后随机；或排到队尾。
  void _requeueWrong() {
    final item = _queue.removeAt(0);
    item.wrongCount++;
    final int offset;
    switch (_wrongPos) {
      case SettingsService.wrongPosIncremental:
        offset = switch (item.wrongCount) {
          1 => 2,
          2 => 5,
          _ => 10,
        };
        break;
      case SettingsService.wrongPosNearby:
        offset = 2 + Random().nextInt(2); // 2 或 3
        break;
      default:
        offset = -1; // 队尾
    }
    if (offset < 0) {
      _queue.add(item);
    } else {
      final idx = offset < _queue.length ? offset : _queue.length;
      _queue.insert(idx, item);
      LogService.instance.log('info',
          'requeue ${item.question.id} at +$offset (wrong #${item.wrongCount})');
    }
  }

  /// 撤销上一步评分：恢复卡片状态与计数，题目回到原位置。
  Future<void> _undoLast() async {
    final u = _undo;
    if (u == null) return;
    final db = DatabaseHelper.instance;
    if (u.cardBefore == null) {
      await db.deleteCard(u.questionId);
    } else {
      await db.upsertCard(u.cardBefore!);
    }
    if (!mounted) return;
    setState(() {
      _queue.removeWhere((e) => identical(e, u.item));
      _queue.insert(min(u.insertAt, _queue.length), u.item);
      _graduated = u.graduatedBefore;
      _attempts = u.attemptsBefore;
      _correctAttempts = u.correctBefore;
      _newFirstTries = u.newFirstTriesBefore;
      _undo = null;
      _resetForCurrent();
    });
    LogService.instance.log('info', 'undo ${u.questionId}');
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
        title: Text(widget.chapter ?? (widget.weakOnly ? '薄弱题专项' : '复习')),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: '撤销上一步',
            onPressed: _undo == null ? null : _undoLast,
          ),
        ],
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
            if (_isCorrect(_selected)) ...[
              // 答对才弹记忆度选项
              if (_outcomes != null) _buildRatingButtons(),
            ] else ...[
              // 答错直接归为「忘记」，只给下一题
              FilledButton(
                onPressed: () => _rate(Rating.again),
                child: const Text('下一题'),
              ),
            ],
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
          children: [
            _ratingButton(Rating.good, '认识', Colors.green),
            _ratingButton(Rating.hard, '模糊', Colors.yellow.shade600),
            _ratingButton(Rating.again, '忘记', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _ratingButton(Rating rating, String label, Color color) {
    final outcome = _outcomes!.firstWhere((o) => o.rating == rating);
    final dark = color.computeLuminance() > 0.5;
    // 初次作答即答对：认识/模糊按钮提示首轮长周期（25/13 天），忘记按标准显示
    int? overrideDays;
    if (_firstTry &&
        _isCorrect(_selected) &&
        (rating == Rating.good || rating == Rating.hard)) {
      overrideDays = rating == Rating.good
          ? _firstPassStability.round()
          : (_firstPassStability / 2).round();
    }
    final days = overrideDays ?? outcome.intervalDays;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: dark ? Colors.black87 : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => _rate(rating),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(_intervalText(days),
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  String _intervalText(int days) {
    if (days <= 0) return '待会再看';
    if (days == 1) return '1 天';
    return '$days 天';
  }
}
