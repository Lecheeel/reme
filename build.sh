#!/usr/bin/env bash
# Reme 一键打包：v8a-only + release 签名，产物复制到桌面。
# 用法：在 reme 项目根目录执行  ./build.sh
set -euo pipefail
cd "$(dirname "$0")"

export PATH="/c/Users/User/flutter/bin:$PATH"
export JAVA_HOME="C:\\Program Files\\Android\\Android Studio\\jbr"
export PATH="$JAVA_HOME/bin:$PATH"

echo "==> flutter pub get"
flutter pub get

echo "==> flutter build apk --release (arm64-v8a + 签名)"
flutter build apk --release

APK="build/app/outputs/flutter-apk/app-release.apk"
OUT="$HOME/Desktop/Reme-release.apk"
cp "$APK" "$OUT"
echo ""
echo "✅ 打包完成: $OUT"
ls -la "$OUT" | awk '{printf "   大小: %.1f MB\n", $5/1024/1024}'
