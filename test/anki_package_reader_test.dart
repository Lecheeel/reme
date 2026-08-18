import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:reme/data/anki_package_reader.dart';

void main() {
  test('真实 2026 1000 题 APKG 使用 anki21 并完整转换', () async {
    const path = r'C:\Users\User\AppData\Local\hermes\cache\documents\doc_436f2e4fab4f_2026_1000_.apkg';
    if (!File(path).existsSync()) return;

    final result = await AnkiPackageReader().readFile(path, bankId: 'anki:sample');

    expect(result.bankName, '1000 题');
    expect(result.questions, hasLength(1247));
    expect(result.skipped, 0);
    expect(result.questions.where((q) => q.type.name == 'single'), hasLength(477));
    expect(result.questions.where((q) => q.type.name == 'multiple'), hasLength(770));
  });
}
