import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reme/data/database.dart';
import 'package:reme/models/question.dart';

void main() {
  late DatabaseHelper db;

  setUp(() {
    db = DatabaseHelper.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('题库创建与当前题库切换会隔离题目查询', () async {
    final builtin = await db.ensureBuiltInBank();
    final imported = await db.createQuestionBank(
      id: 'anki:test',
      name: '测试 Anki',
      source: 'anki',
      subject: '考研政治',
    );
    await db.insertQuestions([
      _question('builtin-q', '内置题', builtin.id),
      _question('anki-q', '导入题', imported.id),
    ]);

    await db.setActiveBank(imported.id);
    expect((await db.getNewQuestions()).map((q) => q.id), ['anki:test:anki-q']);

    await db.setActiveBank(builtin.id);
    expect((await db.getNewQuestions()).map((q) => q.id), [
      'builtin_politics:builtin-q',
    ]);
  });

  test('删除导入题库不会影响其他题库', () async {
    final builtin = await db.ensureBuiltInBank();
    final imported = await db.createQuestionBank(
      id: 'anki:test',
      name: '测试 Anki',
      source: 'anki',
      subject: '考研政治',
    );
    await db.insertQuestions([_question('anki-q', '导入题', imported.id)]);
    await db.deleteQuestionBank(imported.id);

    expect(await db.getQuestionBanks(), hasLength(1));
    expect((await db.getNewQuestions(bankId: builtin.id)), hasLength(0));
  });
}

Question _question(String id, String stem, String bankId) => Question(
  id: '$bankId:$id',
  subject: '测试',
  chapter: '章节',
  knowledgePoint: '',
  knowledgePointId: '',
  type: QuestionType.single,
  stem: stem,
  options: const [
    QuestionOption(label: 'A', text: '正确'),
    QuestionOption(label: 'B', text: '错误'),
  ],
  answer: const ['A'],
  explanation: '',
);
