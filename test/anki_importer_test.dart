import 'package:flutter_test/flutter_test.dart';
import 'package:reme/data/anki_importer.dart';
import 'package:reme/models/question.dart';

void main() {
  test('解析结构化 Anki 选择题字段', () {
    const fields = [
      'abc',
      '12',
      '导论',
      '单项选择题',
      '题干内容',
      '<div class="option"><span class="option-label">A.</span> 选项一</div>'
          '<div class="option correct"><span class="option-label">B.</span> 选项二</div>'
          '<div class="option"><span class="option-label">C.</span> 选项三</div>'
          '<div class="option"><span class="option-label">D.</span> 选项四</div>',
      'B',
      '解析内容',
      '提示内容',
    ];

    final question = AnkiQuestionMapper.fromFields(
      fields,
      bankId: 'anki:test',
      subject: '考研政治',
    );

    expect(question.id, 'anki:test:abc');
    expect(question.chapter, '导论');
    expect(question.type, QuestionType.single);
    expect(question.stem, '题干内容');
    expect(question.options.map((e) => e.label), ['A', 'B', 'C', 'D']);
    expect(question.options[1].text, '选项二');
    expect(question.answer, ['B']);
    expect(question.explanation, '解析内容\n\n提示：提示内容');
  });

  test('多选答案按字母拆分，HTML 实体和标签被安全清理', () {
    const fields = [
      'abc',
      '1',
      '第一章',
      '多项选择题',
      '题 &amp; 干',
      '<div class="option"><span class="option-label">A.</span>甲&nbsp;项</div>'
          '<div class="option"><span class="option-label">B.</span><b>乙项</b></div>'
          '<div class="option"><span class="option-label">C.</span>丙项</div>'
          '<div class="option"><span class="option-label">D.</span>丁项</div>',
      'AC',
      '',
      '',
    ];

    final question = AnkiQuestionMapper.fromFields(
      fields,
      bankId: 'anki:test',
      subject: '考研政治',
    );

    expect(question.type, QuestionType.multiple);
    expect(question.stem, '题 & 干');
    expect(question.options[0].text, '甲 项');
    expect(question.options[1].text, '乙项');
    expect(question.answer, ['A', 'C']);
  });
}
