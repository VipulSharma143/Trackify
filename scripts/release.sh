#!/usr/bin/env bash
# Computes the next semantic version from Conventional Commits and writes release notes.
#
# Usage: scripts/release.sh [--dry-run]
# Reads git history since the latest vMAJOR.MINOR.PATCH tag (or all history if none exists).
# Outputs (in $RELEASE_OUT_DIR, default ./release-out):
#   version.txt        next version without "v" (only when a release is needed)
#   release-notes.md   notes for the GitHub Release
#   changelog-entry.md entry to insert into CHANGELOG.md
# Exit codes: 0 = release needed or nothing to release (see "release=" line), 1 = error.
# Prints "release=true|false", "version=X.Y.Z" and "tag=vX.Y.Z" (also appended to $GITHUB_OUTPUT when set).
#
# Bump rules: BREAKING CHANGE / "type!:" -> major; feat -> minor; fix, perf, security, deps -> patch.
# Other types (docs, chore, refactor, test, build, ci, style) alone do not create a release.
# First release (no tag yet) is 1.0.0.
set -euo pipefail

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1
OUT_DIR="${RELEASE_OUT_DIR:-release-out}"
REPO_URL="${RELEASE_REPO_URL:-}"   # e.g. https://github.com/owner/repo (for compare links), optional
HEAD_REF="${RELEASE_HEAD_REF:-HEAD}"

emit() {
  echo "$1"
  [ -n "${GITHUB_OUTPUT:-}" ] && echo "$1" >> "$GITHUB_OUTPUT"
  return 0
}

HEAD_SHA="$(git rev-parse "$HEAD_REF")"

# Idempotency: if this commit already carries a release tag, do nothing.
EXISTING_TAG="$(git tag --points-at "$HEAD_SHA" --list 'v[0-9]*.[0-9]*.[0-9]*' | head -n1)"
if [ -n "$EXISTING_TAG" ]; then
  echo "Commit $HEAD_SHA is already released as $EXISTING_TAG."
  emit "release=false"
  exit 0
fi

LAST_TAG="$(git describe --tags --match 'v[0-9]*.[0-9]*.[0-9]*' --abbrev=0 "$HEAD_REF" 2>/dev/null || true)"
if [ -n "$LAST_TAG" ]; then RANGE="$LAST_TAG..$HEAD_REF"; else RANGE="$HEAD_REF"; fi

BREAKING=(); FEAT=(); FIX=(); PERF=(); SEC=(); DEPS=(); DOCS=(); REFACTOR=(); OTHER=()
SUBJECT_RE='^([a-z]+)(\(([^)]+)\))?(!)?: (.+)$'

while IFS= read -r -d $'\x1e' record; do
  record="${record#$'\n'}"
  [ -z "$record" ] && continue
  sha="${record%%$'\x1f'*}"; rest="${record#*$'\x1f'}"
  subject="${rest%%$'\x1f'*}"; body="${rest#*$'\x1f'}"
  short="${sha:0:7}"
  [[ "$subject" =~ $SUBJECT_RE ]] || continue
  type="${BASH_REMATCH[1]}"; scope="${BASH_REMATCH[3]}"; bang="${BASH_REMATCH[4]}"; desc="${BASH_REMATCH[5]}"
  line="$desc"
  [ -n "$scope" ] && line="**$scope:** $desc"
  line="$line ($short)"
  if [ -n "$bang" ] || printf '%s' "$body" | grep -qE '^BREAKING[ -]CHANGE:'; then
    BREAKING+=("$line")
  fi
  case "$type" in
    feat) FEAT+=("$line") ;;
    fix) FIX+=("$line") ;;
    perf) PERF+=("$line") ;;
    security) SEC+=("$line") ;;
    deps) DEPS+=("$line") ;;
    docs) DOCS+=("$line") ;;
    refactor) REFACTOR+=("$line") ;;
    *) OTHER+=("$line") ;;
  esac
done < <(git log --no-merges --format='%H%x1f%s%x1f%b%x1e' "$RANGE")

BUMP="none"
[ "${#FIX[@]}" -gt 0 ] || [ "${#PERF[@]}" -gt 0 ] || [ "${#SEC[@]}" -gt 0 ] || [ "${#DEPS[@]}" -gt 0 ] && BUMP="patch"
[ "${#FEAT[@]}" -gt 0 ] && BUMP="minor"
[ "${#BREAKING[@]}" -gt 0 ] && BUMP="major"

if [ "$BUMP" = "none" ]; then
  echo "No releasable commits (feat/fix/perf/security/deps/breaking) since ${LAST_TAG:-the beginning}."
  emit "release=false"
  exit 0
fi

if [ -z "$LAST_TAG" ]; then
  NEXT="1.0.0"
else
  IFS=. read -r MAJ MIN PAT <<< "${LAST_TAG#v}"
  case "$BUMP" in
    major) NEXT="$((MAJ + 1)).0.0" ;;
    minor) NEXT="$MAJ.$((MIN + 1)).0" ;;
    patch) NEXT="$MAJ.$MIN.$((PAT + 1))" ;;
  esac
fi

if git rev-parse -q --verify "refs/tags/v$NEXT" >/dev/null; then
  echo "ERROR: tag v$NEXT already exists but is not on this commit." >&2
  exit 1
fi

section() { # title, items...
  local title="$1"; shift
  [ "$#" -eq 0 ] && return 0
  printf '### %s\n' "$title"
  printf -- '- %s\n' "$@"
  printf '\n'
}

DATE="$(date -u +%Y-%m-%d)"
BODY="$(
  section "Breaking Changes" "${BREAKING[@]}"
  section "Added" "${FEAT[@]}"
  section "Fixed" "${FIX[@]}"
  section "Security" "${SEC[@]}"
  section "Performance" "${PERF[@]}"
  section "Dependencies" "${DEPS[@]}"
  section "Changed" "${REFACTOR[@]}"
  section "Documentation" "${DOCS[@]}"
)"

if [ "$DRY_RUN" = 0 ]; then
  mkdir -p "$OUT_DIR"
  echo "$NEXT" > "$OUT_DIR/version.txt"
  { printf '## [%s] - %s\n\n' "$NEXT" "$DATE"; printf '%s\n' "$BODY"; } > "$OUT_DIR/changelog-entry.md"
  {
    printf '%s\n' "$BODY"
    if [ -n "$LAST_TAG" ] && [ -n "$REPO_URL" ]; then
      printf '**Full changelog:** %s/compare/%s...v%s\n' "$REPO_URL" "$LAST_TAG" "$NEXT"
    fi
  } > "$OUT_DIR/release-notes.md"
fi

echo "Previous tag: ${LAST_TAG:-none}; bump: $BUMP; next: v$NEXT"
emit "release=true"
emit "version=$NEXT"
emit "tag=v$NEXT"
