#!/usr/bin/env bash
# Removes generated folders (packages and build output) so the project can be shared as source only.
# Source code, .env files and user-secrets are never touched.
# Usage: scripts/clean.sh [-y]   (-y skips the confirmation prompt)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TARGETS=(
  node_modules
  mobile/node_modules
  mobile/dist-web
  mobile/android/build
  mobile/android/app/build
  mobile/android/.gradle
  mobile/android/.cxx
  mobile/ios/Pods
  mobile/ios/build
  backend/bin
  backend/obj
)

FOUND=()
for t in "${TARGETS[@]}"; do
  [ -e "$t" ] && FOUND+=("$t")
done

if [ "${#FOUND[@]}" -eq 0 ]; then
  echo "Nothing to clean."
  exit 0
fi

echo "This will delete:"
printf '  %s\n' "${FOUND[@]}"

if [ "${1:-}" != "-y" ]; then
  read -r -p "Continue? [y/N] " answer
  case "$answer" in y|Y|yes|YES) ;; *) echo "Cancelled."; exit 1 ;; esac
fi

for t in "${FOUND[@]}"; do
  rm -rf -- "$t"
  echo "removed $t"
done
echo "Clean complete. Run scripts/build.sh to install and build again."
