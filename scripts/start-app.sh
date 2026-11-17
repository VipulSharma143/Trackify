#!/usr/bin/env bash
# Starts Metro and launches the Android app on a connected device or emulator
# (starts the first installed emulator if none is running).
# Usage: scripts/start-app.sh       Stop Metro with Ctrl+C.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
[ -n "$SDK" ] || { echo "ERROR: ANDROID_HOME is not set (see docs/development/NATIVE_DEVELOPMENT.md)." >&2; exit 1; }
export PATH="$SDK/platform-tools:$SDK/emulator:$PATH"
command -v adb  >/dev/null 2>&1 || { echo "ERROR: adb not found in $SDK/platform-tools." >&2; exit 1; }
command -v java >/dev/null 2>&1 || { echo "ERROR: Java (JDK) not found." >&2; exit 1; }

if [ ! -d mobile/node_modules ]; then
  echo "==> mobile/node_modules missing, running npm install"
  npm install --prefix mobile
fi

has_device() { adb devices | awk 'NR>1 && $2=="device"' | grep -q .; }

if ! has_device; then
  AVD="$(emulator -list-avds 2>/dev/null | head -n1 || true)"
  if [ -z "$AVD" ]; then
    echo "ERROR: no Android device connected and no emulator (AVD) found. Create one in Android Studio." >&2
    exit 1
  fi
  echo "==> Starting emulator: $AVD"
  nohup emulator -avd "$AVD" >/dev/null 2>&1 &
  adb wait-for-device
  until [ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do sleep 2; done
fi

adb reverse tcp:8081 tcp:8081 >/dev/null 2>&1 || true

METRO_PID=""
trap '[ -n "$METRO_PID" ] && kill "$METRO_PID" 2>/dev/null || true' EXIT INT TERM

echo "==> Starting Metro"
npm run start --prefix mobile &
METRO_PID=$!
sleep 5

echo "==> Building and launching the Android app"
(cd mobile && npx react-native run-android --no-packager)

echo "==> App launched. Metro keeps running; press Ctrl+C to stop."
wait "$METRO_PID"
