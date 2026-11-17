#!/usr/bin/env bash
# Installs Node packages and restores/builds the backend.
# Usage: scripts/build.sh [--android]   (--android also builds the debug APK)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WITH_ANDROID=0
[ "${1:-}" = "--android" ] && WITH_ANDROID=1

step() { printf '\n==> %s\n' "$1"; }
SKIPPED=()

command -v node >/dev/null 2>&1 || { echo "ERROR: Node.js is required." >&2; exit 1; }
command -v npm  >/dev/null 2>&1 || { echo "ERROR: npm is required." >&2; exit 1; }

step "Installing mobile packages (npm install)"
npm install --prefix mobile

step "Type-checking mobile"
npm run typecheck --prefix mobile

if command -v dotnet >/dev/null 2>&1; then
  step "Restoring and building backend"
  dotnet restore backend
  dotnet build backend --no-restore
else
  echo "WARNING: dotnet not found; backend restore/build skipped (.NET 10 SDK required)."
  SKIPPED+=("backend")
fi

if [ "$(uname -s)" = "Darwin" ] && command -v pod >/dev/null 2>&1; then
  step "Installing iOS pods"
  (cd mobile/ios && pod install)
fi

if [ "$WITH_ANDROID" = 1 ]; then
  step "Building Android debug APK"
  bash scripts/build-android-debug.sh
fi

step "Done"
if [ "${#SKIPPED[@]}" -gt 0 ]; then
  echo "Skipped: ${SKIPPED[*]}"
fi
