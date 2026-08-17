import 'package:flutter/material.dart';

import '../data/database.dart';
import 'review_screen.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({super.key});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  bool _loading = true;
  List<ChapterStat> _chapters = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final chapters = await DatabaseHelper.instance.getChapterStats();
    if (!mounted) return;
    setState(() {
      _chapters = chapters;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考研政治 · 章节')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _chapters.length,
              itemBuilder: (context, i) {
                final c = _chapters[i];
                final hasDue = c.due > 0;
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text('待复习 ${c.due} · 共 ${c.total}'),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: hasDue,
                  onTap: hasDue
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReviewScreen(chapter: c.name),
                            ),
                          );
                        }
                      : null,
                );
              },
            ),
    );
  }
}
