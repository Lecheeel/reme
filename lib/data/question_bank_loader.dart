import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';

/// 从内置 JSON 题库读取题目。结构：科目 → 章节 → 知识点 → 题目。
/// 读取时把 subject/chapter/knowledgePoint 反规范化到每道题上。
class QuestionBankLoader {
  /// 题库种子版本号：题库 JSON 结构/内容变更时 +1，触发数据库重建题库表。
  Future<int> loadBankVersion() async {
    final raw = await rootBundle.loadString('assets/data/politics.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['version'] as num).toInt();
  }

  Future<List<Question>> loadPoliticsBank() async {
    final raw = await rootBundle.loadString('assets/data/politics.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final subject = json['subject'] as String;

    final questions = <Question>[];
    for (final chapter in (json['chapters'] as List)) {
      final chapterName = (chapter as Map<String, dynamic>)['name'] as String;
      for (final kp in (chapter['knowledge_points'] as List)) {
        final kpName = (kp as Map<String, dynamic>)['name'] as String;
        for (final q in (kp['questions'] as List)) {
          questions.add(Question.fromJson(
            q as Map<String, dynamic>,
            subject: subject,
            chapter: chapterName,
            knowledgePoint: kpName,
          ));
        }
      }
    }
    return questions;
  }
}
