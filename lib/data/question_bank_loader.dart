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
      final chapterMap = chapter as Map<String, dynamic>;
      final chapterName = chapterMap['name'] as String;
      for (final kp in (chapterMap['knowledge_points'] as List)) {
        final kpMap = kp as Map<String, dynamic>;
        final kpName = kpMap['name'] as String;
        final kpId = kpMap['id'] as String;
        for (final q in (kpMap['questions'] as List)) {
          questions.add(Question.fromJson(
            q as Map<String, dynamic>,
            subject: subject,
            chapter: chapterName,
            knowledgePoint: kpName,
            knowledgePointId: kpId,
          ));
        }
      }
    }
    return questions;
  }

  /// 收集指定章节内所有子章节声明的 related 关联子章节 id。
  /// 用于「结合之前内容复习」：复习该章节时把这些关联子章节的到期题也拉进来。
  Future<List<String>> loadRelatedKpIdsForChapter(String chapterName) async {
    final raw = await rootBundle.loadString('assets/data/politics.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String>{};
    for (final chapter in (json['chapters'] as List)) {
      final chapterMap = chapter as Map<String, dynamic>;
      if (chapterMap['name'] != chapterName) continue;
      for (final kp in (chapterMap['knowledge_points'] as List)) {
        final related = (kp as Map<String, dynamic>)['related'];
        if (related is List) {
          result.addAll(related.whereType<String>());
        }
      }
    }
    return result.toList();
  }
}
