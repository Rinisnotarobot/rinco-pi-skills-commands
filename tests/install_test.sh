#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
INSTALLER="$REPO_ROOT/install.sh"
TEST_ROOT=$(mktemp -d)
trap 'rm -rf "$TEST_ROOT"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file_matches() {
  local expected=$1
  local actual=$2

  [[ -f "$actual" ]] || fail "missing file: $actual"
  cmp -s -- "$expected" "$actual" || fail "file differs: $actual"
}

PI_AGENT_DIR="$TEST_ROOT/pi-agent" bash "$INSTALLER"

assert_file_matches \
  "$REPO_ROOT/skills/coding-standards/SKILL.md" \
  "$TEST_ROOT/pi-agent/skills/coding-standards/SKILL.md"
assert_file_matches \
  "$REPO_ROOT/commands/review.md" \
  "$TEST_ROOT/pi-agent/prompts/review.md"

printf 'keep me\n' > "$TEST_ROOT/pi-agent/skills/local-skill.md"
printf 'outdated\n' > "$TEST_ROOT/pi-agent/prompts/review.md"

(
  cd "$TEST_ROOT"
  PI_AGENT_DIR="$TEST_ROOT/pi-agent" bash "$INSTALLER"
)

assert_file_matches \
  "$REPO_ROOT/commands/review.md" \
  "$TEST_ROOT/pi-agent/prompts/review.md"
[[ $(<"$TEST_ROOT/pi-agent/skills/local-skill.md") == 'keep me' ]] || \
  fail 'installer removed an unrelated existing skill'

(
  unset PI_AGENT_DIR
  HOME="$TEST_ROOT/home" bash "$INSTALLER"
)
assert_file_matches \
  "$REPO_ROOT/skills/coding-standards/SKILL.md" \
  "$TEST_ROOT/home/.pi/agent/skills/coding-standards/SKILL.md"
assert_file_matches \
  "$REPO_ROOT/commands/review.md" \
  "$TEST_ROOT/home/.pi/agent/prompts/review.md"

printf 'PASS: installer copies skills and commands without removing unrelated files\n'
