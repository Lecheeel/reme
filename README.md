# Reme

A spaced-repetition quiz app built with Flutter and FSRS. It schedules *what* to review and *when*, so each problem resurfaces right before you'd forget it — instead of grinding the same list linearly.

**Reme** = "re-member".

## Features

- **FSRS v6.1.1 scheduler** — ported from [fsrs4anki](https://github.com/open-spaced-repetition/fsrs4anki), the state-of-the-art spaced-repetition algorithm (outperforms SM-2 / Anki's default).
- **Load-balanced review queue** — due reviews always come first and are never truncated (no backlog); new questions are introduced within a daily quota, so daily workload stays flat as the review load grows over time.
- **First-try mastery** — a new question answered correctly on the first attempt is scheduled far out (25 days for confident recall, 13 for partial), instead of being repeated in-session. Missed / fuzzy questions loop back through the queue until mastered.
- **Check-in & calendar** — a daily load target with check-in once the day's quota is reached, a monthly check-in calendar with streaks, and a per-day summary view.
- **Progress analytics** — mastery donut chart, per-chapter stacked bars, a due-distribution forecast, an FSRS difficulty/stability scatter plot, and a daily study trend.
- **Hierarchical question bank** — `subject → chapter → knowledge point` structure, stored as per-chapter JSON files with versioned incremental seeding (only changed chapters are re-imported; per-card memory state is preserved by question id).
- SQLite local storage, offline-first.
- Single / multiple choice with explanations and three-level self-grading (认识 / 模糊 / 忘记 — recall / fuzzy / forget).

The app currently ships with a Chinese politics question bank; the bank format is subject-agnostic, so new subjects can be added as additional JSON files without code changes.

## Design background

The scheduling design is grounded in the spaced-repetition / memory-algorithm research curated in [memory-algorithm-papers](https://github.com/Lecheeel/memory-algorithm-papers) — a collection spanning Ebbinghaus's forgetting curve, Cepeda's spacing studies, HLR/DAS3H, and the FSRS / SSP-MMC / DRL-SRS line of modern schedulers. That corpus informed the choice of FSRS and the scheduling policies implemented here.

## Tech

- Flutter 3.47 / Dart 3.13
- `sqflite` (SQLite), `shared_preferences`, `fl_chart`
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
├── models/          # Question, CardState, Rating, Mastery
├── scheduler/       # fsrs.dart — FSRS v6
├── data/            # database.dart (SQLite), question_bank_loader.dart, settings_service.dart, log_service.dart
├── screens/         # home / chapter / review / progress / settings / calendar
└── widgets/         # charts.dart (progress visualizations)
assets/data/politics/ # per-chapter question bank JSON files
test/                # FSRS unit tests
tools/               # add_questions.py (bank authoring), log_receiver.py (debug log server)
```

## Debug logging

The app has an opt-in debug log that auto-uploads to your PC for analysis:

1. On the PC, run the receiver: `python tools/log_receiver.py` (listens on `:8765`, saves to `~/reme-logs/`).
2. In the app, open **设置 (Settings)** → toggle **调试日志**.
3. Logs are captured (review actions, FSRS state, uncaught errors) and uploaded automatically after each review session — or tap **立即上传日志**.

The upload URL defaults to `http://192.168.31.69:8765` and is editable in settings.

## License

MIT
