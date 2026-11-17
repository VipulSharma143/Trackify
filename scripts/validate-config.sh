#!/usr/bin/env bash
# Validates committed configuration. Read-only; used by CI. Exit 1 on any problem.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FAIL=0
fail() { echo "FAIL: $1" >&2; FAIL=1; }
ok() { echo "ok:   $1"; }

for f in backend/appsettings.json backend/appsettings.Development.json; do
  if jq empty "$f" 2>/dev/null; then ok "$f is valid JSON"; else fail "$f is not valid JSON"; fi
done

# No credentials or connection strings in committed settings files.
for f in backend/appsettings*.json; do
  if jq -e '.ConnectionStrings' "$f" >/dev/null 2>&1; then fail "$f contains ConnectionStrings (use environment variables or user-secrets)"; fi
  pw="$(jq -r '.Database.Password // ""' "$f")"
  [ -z "$pw" ] && ok "$f has no Database:Password" || fail "$f contains a Database:Password value"
  user="$(jq -r '.Database.Username // ""' "$f")"
  [ -z "$user" ] && ok "$f has no Database:Username" || fail "$f contains a Database:Username value"
done

# Production CORS must be restrictive.
if jq -e '.Cors.AllowedOrigins // [] | map(select(. == "*")) | length > 0' backend/appsettings.json >/dev/null; then
  fail "backend/appsettings.json allows every CORS origin (\"*\")"
else
  ok "production CORS has no wildcard origin"
fi

# .env.example must exist and hold no secret values.
if [ -f .env.example ]; then
  ok ".env.example exists"
  if grep -E '^(Database__Password|Database__Username)=.+' .env.example >/dev/null; then fail ".env.example contains a credential value"; else ok ".env.example has no credential values"; fi
else
  fail ".env.example is missing"
fi

# No hard-coded LAN IP committed in the mobile config.
if grep -q 'API_HOST_OVERRIDE: string | null = null' mobile/src/constants/config.ts; then
  ok "mobile API_HOST_OVERRIDE is unset"
else
  fail "mobile/src/constants/config.ts: API_HOST_OVERRIDE must be null in committed code"
fi

# Environment variable names documented in .env.example must exist in backend settings classes.
for key in Host Port Database Username Password; do
  grep -q "public .* $key " backend/Configuration/DatabaseSettings.cs && ok "Database__$key matches DatabaseSettings.$key" || fail "Database__$key missing in DatabaseSettings"
done

exit "$FAIL"
