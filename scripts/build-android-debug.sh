#!/usr/bin/env bash
# Builds a local Android DEBUG APK. Not for Play Store release. No signing credentials are created.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ANDROID_DIR="$ROOT/mobile/android"

if [ ! -d "$ANDROID_DIR" ] || [ ! -f "$ANDROID_DIR/gradlew" ]; then
  echo "ERROR: native Android project not found at mobile/android (or gradlew missing)." >&2
  echo "Expected a committed React Native Android project (mobile/android with gradlew)." >&2
  exit 1
fi
if [ -z "${ANDROID_HOME:-}${ANDROID_SDK_ROOT:-}" ]; then
  echo "ERROR: Android SDK not found. Set ANDROID_HOME (see docs/development/NATIVE_DEVELOPMENT.md)." >&2
  exit 1
fi
if ! command -v java >/dev/null 2>&1; then
  echo "ERROR: Java (JDK) not found." >&2
  exit 1
fi

cd "$ANDROID_DIR"
chmod +x ./gradlew
./gradlew assembleDebug

APK="$ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
  echo "APK built: $APK"
else
  echo "ERROR: Gradle finished but APK not found at $APK" >&2
  exit 1
fi
