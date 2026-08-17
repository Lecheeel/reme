/// 题型：单选 / 多选。
enum QuestionType {
  single,
  multiple;

  static QuestionType fromName(String name) =>
      name == 'multiple' ? QuestionType.multiple : QuestionType.single;

  String get name => this == QuestionType.multiple ? 'multiple' : 'single';

  String get label => this == QuestionType.multiple ? '多选' : '单选';
}

/// 选项：label 为 A/B/C/D，text 为选项内容。
class QuestionOption {
  final String label;
  final String text;

  const QuestionOption({required this.label, required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
        label: json['label'] as String,
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => {'label': label, 'text': text};
}

/// 一道题。subject/chapter/knowledgePoint 做了反规范化冗余，方便单表查询。
class Question {
  final String id;
  final String subject;
  final String chapter;
  final String knowledgePoint;

  /// 子章节 id（knowledge_points 的 id 字段），用于 related 关联复习等。
  final String knowledgePointId;
  final QuestionType type;
  final String stem;
  final List<QuestionOption> options;
  final List<String> answer; // 正确选项 label 列表，如 ["A"] 或 ["A","B","C"]
  final String explanation;

  const Question({
    required this.id,
    required this.subject,
    required this.chapter,
    required this.knowledgePoint,
    required this.knowledgePointId,
    required this.type,
    required this.stem,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory Question.fromJson(
    Map<String, dynamic> json, {
    required String subject,
    required String chapter,
    required String knowledgePoint,
    required String knowledgePointId,
  }) =>
      Question(
        id: json['id'] as String,
        subject: subject,
        chapter: chapter,
        knowledgePoint: knowledgePoint,
        knowledgePointId: knowledgePointId,
        type: QuestionType.fromName(json['type'] as String),
        stem: json['stem'] as String,
        options: (json['options'] as List)
            .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        answer: (json['answer'] as List).map((e) => e as String).toList(),
        explanation: (json['explanation'] as String?) ?? '',
      );

  /// 判断所选 label 是否与正确答案完全一致（顺序无关）。
  bool checkAnswer(List<String> selected) {
    if (selected.length != answer.length) return false;
    final a = [...answer]..sort();
    final b = [...selected]..sort();
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
