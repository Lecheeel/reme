import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';

/// 章节题库文件清单。每章一个 JSON，独立 version，
/// 加新科目/章节时在此追加文件（assets/data/politics/ 下）。
const _chapterFiles = [
  'assets/data/politics/01_mkszy.json',
  'assets/data/politics/02_mzt.json',
  'assets/data/politics/03_xi.json',
  'assets/data/politics/04_sg.json',
  'assets/data/politics/05_sx.json',
];

/// 从内置 JSON 题库读取题目。结构：科目 → 章节 → 子章节 → 题目。
/// 每章一个文件（assets/data/politics/），独立 version，便于维护与增量导入。
/// 读取时把 subject/chapter/knowledgePoint 反规范化到每道题上。
class QuestionBankLoader {
  static List<String> get chapterFiles => _chapterFiles;

  /// 读章节文件元信息：返回 (chapterId, chapterName, version)。
  Future<(String, String, int)> loadChapterMeta(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final chapter = json['chapter'] as Map<String, dynamic>;
    return (
      chapter['id'] as String,
      chapter['name'] as String,
      (json['version'] as num).toInt(),
    );
  }

  /// 加载单个章节文件的全部题目（展平 subject/chapter/knowledgePoint）。
  Future<List<Question>> loadChapterQuestions(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final subject = json['subject'] as String;
    final chapter = json['chapter'] as Map<String, dynamic>;
    final chapterName = chapter['name'] as String;

    final questions = <Question>[];
    for (final kp in (chapter['knowledge_points'] as List)) {
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
    return questions;
  }

  /// 全部门店文件 → 章节 version 表（chapterId → version）。
  Future<Map<String, int>> loadChapterVersions() async {
    final result = <String, int>{};
    for (final path in _chapterFiles) {
      final (id, _, v) = await loadChapterMeta(path);
      result[id] = v;
    }
    return result;
  }

  /// 收集指定章节内所有子章节声明的 related 关联子章节 id。
  /// 用于「结合之前内容复习」：复习该章节时把这些关联子章节的到期题也拉进来。
  Future<List<String>> loadRelatedKpIdsForChapter(String chapterName) async {
    final result = <String>{};
    for (final path in _chapterFiles) {
      final raw = await rootBundle.loadString(path);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final chapter = json['chapter'] as Map<String, dynamic>;
      if (chapter['name'] != chapterName) continue;
      for (final kp in (chapter['knowledge_points'] as List)) {
        final related = (kp as Map<String, dynamic>)['related'];
        if (related is List) {
          result.addAll(related.whereType<String>());
        }
      }
    }
    return result.toList();
  }
}
