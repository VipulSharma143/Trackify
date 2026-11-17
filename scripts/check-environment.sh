#!/usr/bin/env bash
# Reports tool availability and versions. Read-only: installs nothing, changes nothing.
report() { # name, command...
  local name="$1"; shift
  if command -v "$1" >/dev/null 2>&1; then
    printf '%-14s OK       %s\n' "$name" "$("$@" 2>&1 | head -n1)"
  else
    printf '%-14s MISSING\n' "$name"
  fi
}
report "Node.js" node --version
report "npm" npm --version
report ".NET SDK" dotnet --version
report "Java" java -version
report "PostgreSQL" psql --version
report "Gradle/adb" adb --version
if [ -n "${ANDROID_HOME:-}${ANDROID_SDK_ROOT:-}" ]; then
  echo "Android SDK    SET      ${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
else
  echo "Android SDK    MISSING  (ANDROID_HOME / ANDROID_SDK_ROOT not set)"
fi
if [ "$(uname -s)" = "Darwin" ]; then
  report "Xcode tools" xcodebuild -version
else
  echo "Xcode tools    N/A      (requires macOS)"
fi
