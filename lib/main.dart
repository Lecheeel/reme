import 'package:flutter/material.dart';

import 'data/database.dart';
import 'data/log_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LogService.instance.init();

  // 全局错误兜底：崩了也能留日志
  FlutterError.onError = (details) {
    LogService.instance
        .log('error', 'flutter: ${details.exception}\n${details.stack}');
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    LogService.instance.log('error', 'uncaught: $error\n$stack');
    return true;
  };

  await DatabaseHelper.instance.seedIfNeeded();
  LogService.instance.log('info', 'app started');
  runApp(const RemeApp());
}

class RemeApp extends StatelessWidget {
  const RemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
      ),
      home: const HomeScreen(),
    );
  }
}
