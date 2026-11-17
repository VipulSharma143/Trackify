#!/usr/bin/env bash
# Calls the three API endpoints and checks status codes and JSON fields.
# Usage: scripts/api-smoke-test.sh <base-url> <up|down>
#   up   : PostgreSQL reachable  -> /api/health/database must return 200 "Healthy"
#   down : PostgreSQL unreachable -> /api/health must still return 200, /api/health/database must return 503 "Unhealthy"
set -uo pipefail
BASE="${1:?base url required, e.g. http://localhost:5000}"
MODE="${2:?mode required: up|down}"
FAIL=0
check() { # description, condition-result
  if [ "$2" = "0" ]; then echo "ok:   $1"; else echo "FAIL: $1" >&2; FAIL=1; fi
}
get() { curl -sS -m 10 -o /tmp/smoke-body.json -w '%{http_code}' "$BASE$1"; }

code="$(get /api/health)"
[ "$code" = "200" ]; check "GET /api/health returns 200" $?
jq -e '.status=="Healthy" and (.applicationName|length>0) and (.version|length>0) and (.timestamp|length>0)' /tmp/smoke-body.json >/dev/null; check "/api/health body has status, applicationName, version, timestamp" $?

code="$(get /api/system/info)"
[ "$code" = "200" ]; check "GET /api/system/info returns 200" $?
jq -e '(.applicationName|length>0) and (.runtime|length>0) and (.version|length>0) and (.environment|length>0) and (.apiVersion|length>0)' /tmp/smoke-body.json >/dev/null; check "/api/system/info body has all fields" $?

code="$(get /api/health/database)"
if [ "$MODE" = "up" ]; then
  [ "$code" = "200" ]; check "GET /api/health/database returns 200 when database is up" $?
  jq -e '.status=="Healthy" and (.provider|test("Npgsql")) and (.timestamp|length>0)' /tmp/smoke-body.json >/dev/null; check "/api/health/database reports Healthy with Npgsql provider" $?
else
  [ "$code" = "503" ]; check "GET /api/health/database returns 503 when database is down" $?
  jq -e '.status=="Unhealthy"' /tmp/smoke-body.json >/dev/null; check "/api/health/database reports Unhealthy" $?
  # The database outage must not leak connection details.
  ! grep -qiE 'password|host=|exception|stacktrace' /tmp/smoke-body.json; check "database failure response exposes no internal details" $?
fi

exit "$FAIL"
