#!/usr/bin/env bash
# Starts the backend API (if .NET is installed) and the browser app, then opens the browser.
# Usage: scripts/start-dev.sh [--no-api]       Stop everything with Ctrl+C.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WEB_URL="http://localhost:5173"
API_URL="http://localhost:5000"
PIDS=()

cleanup() {
  trap - EXIT INT TERM
  for pid in "${PIDS[@]:-}"; do
    [ -n "$pid" ] && kill "$pid" 2>/dev/null || true
  done
}
trap cleanup EXIT INT TERM

open_browser() {
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 &
  elif command -v open >/dev/null 2>&1; then open "$1"
  elif command -v start >/dev/null 2>&1; then start "$1"
  else echo "Open this URL in your browser: $1"; fi
}

if [ ! -d mobile/node_modules ]; then
  echo "==> mobile/node_modules missing, running npm install"
  npm install --prefix mobile
fi

if [ "${1:-}" != "--no-api" ]; then
  if command -v dotnet >/dev/null 2>&1; then
    echo "==> Starting API at $API_URL (Swagger: $API_URL/swagger)"
    ( cd backend && ASPNETCORE_ENVIRONMENT=Development ASPNETCORE_URLS="$API_URL" \
        exec dotnet watch run --no-launch-profile ) &
    PIDS+=("$!")
  else
    echo "WARNING: dotnet not found; starting the browser app without the API."
  fi
fi

echo "==> Starting browser app at $WEB_URL"
npm run dev --prefix mobile &
PIDS+=("$!")

for _ in $(seq 1 60); do
  if curl -s -o /dev/null -m 2 "$WEB_URL"; then
    open_browser "$WEB_URL"
    break
  fi
  sleep 1
done

wait
