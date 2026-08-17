# Reme

A spaced-repetition quiz app for China's graduate school entrance exam (考研), built with Flutter + FSRS.

**Reme** = "re-member". It schedules *what* to review and *when* — so you see each problem right before you'd forget it, instead of grinding the same list linearly.

## Features

- **FSRS v6.1.1 scheduler** — ported from [fsrs4anki](https://github.com/open-spaced-repetition/fsrs4anki), the state-of-the-art spaced-repetition algorithm (outperforms SM-2 / Anki's default).
- **科目 → 章节 → 知识点** hierarchical question bank, imported from JSON.
- SQLite local storage, offline-first.
- Single / multiple choice with explanations and self-graded recall (Again / Hard / Good / Easy).
- Seeded with 考研政治 (politics) sample questions.

## Tech

- Flutter 3.47 / Dart 3.13
- `sqflite` (SQLite)
- FSRS ported to Dart in `lib/scheduler/fsrs.dart` (with unit tests)

## Build

```bash
./build.sh   # pub get + release APK (arm64-v8a, signed) → ~/Desktop/Reme-release.apk
```

or:

```bash
flutter build apk --release
```

The release APK is arm64-v8a only and signed with the `memento` keystore (not committed; see `android/keystore.properties`).

## Structure

```
lib/
├── models/          # Question, CardState, Rating
├── scheduler/       # fsrs.dart — FSRS v6
├── data/            # database.dart (SQLite), question_bank_loader.dart
└── screens/         # home / chapter / review
assets/data/         # politics.json (question bank)
test/                # FSRS unit tests
```

## Debug logging

The app has an opt-in debug log that auto-uploads to your PC for analysis:

1. On the PC (HWS), run the receiver: `python tools/log_receiver.py` (listens on `:8765`, saves to `~/reme-logs/`).
2. In the app, open **设置 (Settings)** → toggle **调试日志**.
3. Logs are captured (review actions, FSRS state, uncaught errors) and uploaded automatically after each review session — or tap **立即上传日志**.

The upload URL defaults to `http://192.168.31.69:8765` and is editable in settings.

## License

MIT
