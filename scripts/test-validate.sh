#!/usr/bin/env bash
# Exercise the real validator CLI in an isolated, minimal repository.
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p "$fixture/scripts" "$fixture/skills/tools/example" "$fixture/home"
cp "$REPO_ROOT/scripts/validate.sh" "$fixture/scripts/validate.sh"
git -c init.templateDir= init -q "$fixture"
printf '[example](skills/tools/example/)\n' > "$fixture/README.md"

assert_validation() { # <expected exit> <diagnostic>
  local expected=$1 diagnostic=$2 output status=0
  output=$(HOME="$fixture/home" bash "$fixture/scripts/validate.sh" 2>&1) || status=$?
  if [[ $status -ne $expected || "$output" != *"$diagnostic"* ]]; then
    printf 'FAIL: expected exit %s and diagnostic "%s"; got exit %s\n%s\n' \
      "$expected" "$diagnostic" "$status" "$output" >&2
    exit 1
  fi
}

printf '%s\n' '---' 'name: example' 'description: Use when testing.' '---' \
  '# Example' > "$fixture/skills/tools/example/SKILL.md"
assert_validation 0 'RESULT: 0 failure(s)'
printf 'PASS: well-formed frontmatter is accepted\n'

# Reproduce the real defect: the apparent close is attached to description text.
printf '%s\n' '---' 'name: example' 'description: Use when testing.---' \
  '# Example' > "$fixture/skills/tools/example/SKILL.md"
assert_validation 1 'skills/tools/example/SKILL.md: frontmatter missing closing delimiter'
printf 'PASS: unclosed frontmatter is rejected\n'

printf '%s\n' '---' 'name: example' 'description: Use when testing.' \
  > "$fixture/skills/tools/example/SKILL.md"
assert_validation 1 'skills/tools/example/SKILL.md: frontmatter missing closing delimiter'
printf 'PASS: EOF without a closing delimiter is rejected\n'

# Preserve the existing closing-line whitespace policy and allow EOF after it.
printf '%s\n' '---' 'name: example' 'description: Use when testing.' \
  > "$fixture/skills/tools/example/SKILL.md"
printf '%s' $'--- \t' >> "$fixture/skills/tools/example/SKILL.md"
assert_validation 0 'RESULT: 0 failure(s)'
printf 'PASS: closing delimiter at EOF with trailing whitespace is accepted\n'
