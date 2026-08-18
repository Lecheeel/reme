import '../models/question.dart';

/// 将 Anki 结构化选择题笔记转换为 Reme 题目。
///
/// 当前支持本项目样本使用的 9 字段格式：
/// id / no / section / type / question / options / answer / analysis / tip
class AnkiQuestionMapper {
  static const int expectedFieldCount = 9;

  static Question fromFields(
    List<String> fields, {
    required String bankId,
    required String subject,
  }) {
    if (fields.length < expectedFieldCount) {
      throw const FormatException('Anki 笔记字段不足，无法识别为结构化选择题');
    }

    final id = fields[0].trim();
    final chapter = _plainText(fields[2]);
    final typeName = _plainText(fields[3]);
    final stem = _plainText(fields[4]);
    final options = _parseOptions(fields[5]);
    final answer = _parseAnswer(fields[6], options);
    final analysis = _plainText(fields[7]);
    final tip = _plainText(fields[8]);

    if (id.isEmpty || stem.isEmpty || options.isEmpty || answer.isEmpty) {
      throw const FormatException('Anki 笔记缺少题目、选项或答案');
    }
    if (!answer.every((label) => options.any((o) => o.label == label))) {
      throw const FormatException('Anki 答案引用了不存在的选项');
    }

    final explanation = [
      if (analysis.isNotEmpty) analysis,
      if (tip.isNotEmpty) '提示：$tip',
    ].join('\n\n');

    return Question(
      id: '${bankId.startsWith('anki:') ? bankId : 'anki:$bankId'}:$id',
      subject: subject,
      chapter: chapter.isEmpty ? '未分类' : chapter,
      knowledgePoint: '',
      knowledgePointId: '',
      type: typeName.contains('多') || answer.length > 1
          ? QuestionType.multiple
          : QuestionType.single,
      stem: stem,
      options: options,
      answer: answer,
      explanation: explanation,
    );
  }

  static List<QuestionOption> _parseOptions(String raw) {
    final result = <QuestionOption>[];
    final pattern = RegExp(
      r'<div[^>]*class=["\x27][^"\x27]*option[^"\x27]*["\x27][^>]*>\s*'
      r'<span[^>]*class=["\x27][^"\x27]*option-label[^"\x27]*["\x27][^>]*>\s*([A-Z])\s*\.\s*'
      r'</span>(.*?)</div>',
      caseSensitive: false,
      dotAll: true,
    );
    for (final match in pattern.allMatches(raw)) {
      final label = match.group(1)!.toUpperCase();
      final text = _plainText(match.group(2)!);
      result.add(QuestionOption(label: label, text: text));
    }
    if (result.isNotEmpty) return result;

    // 兼容没有 option div、但仍使用 A. 文本格式的牌组。
    final fallback = RegExp(
      r'(?:^|\n)\s*([A-Z])\s*[.、．]\s*(.*?)(?=\n\s*[A-Z]\s*[.、．]|$)',
      dotAll: true,
    );
    return [
      for (final match in fallback.allMatches(_plainText(raw)))
        QuestionOption(label: match.group(1)!, text: match.group(2)!.trim()),
    ];
  }

  static List<String> _parseAnswer(String raw, List<QuestionOption> options) {
    final letters = RegExp(r'[A-Z]')
        .allMatches(raw.toUpperCase())
        .map((m) => m.group(0)!)
        .toList();
    final valid = options.map((o) => o.label).toSet();
    final seen = <String>{};
    return [
      for (final letter in letters)
        if (valid.contains(letter) && seen.add(letter)) letter,
    ];
  }

  static String _plainText(String raw) {
    var value = raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>', dotAll: true), '');
    value = _decodeEntities(value);
    value = value.replaceAll('\u00a0', ' ');
    value = value.replaceAll(RegExp(r'[ \t]+'), ' ');
    value = value.replaceAll(RegExp(r'\n[ \t]+'), '\n');
    return value.trim();
  }

  static String _decodeEntities(String value) {
    const named = {
      'amp': '&',
      'lt': '<',
      'gt': '>',
      'quot': '"',
      'apos': "'",
      'nbsp': ' ',
    };
    return value.replaceAllMapped(
      RegExp(r'&(#x?[0-9a-f]+|[a-z]+);', caseSensitive: false),
      (m) {
        final token = m.group(1)!;
        if (token.startsWith('#x') || token.startsWith('#X')) {
          return String.fromCharCode(int.parse(token.substring(2), radix: 16));
        }
        if (token.startsWith('#')) {
          return String.fromCharCode(int.parse(token.substring(1)));
        }
        return named[token.toLowerCase()] ?? m.group(0)!;
      },
    );
  }
}
