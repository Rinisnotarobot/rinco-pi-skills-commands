#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
SKILL_ROOT=${SKILL_ROOT:-$REPO_ROOT/skills/systematic-debugging}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local file=$1
  local expected=$2

  grep -F -- "$expected" "$SKILL_ROOT/$file" >/dev/null || \
    fail "$file lacks debugging gate: $expected"
}

[[ -f "$SKILL_ROOT/SKILL.md" ]] || fail "Skill missing: $SKILL_ROOT/SKILL.md"

assert_contains SKILL.md 'a repeatable red signal or a documented alternative evidence gate'
assert_contains SKILL.md 'A confirming result must explain the complete causal chain'
assert_contains SKILL.md 'After three consecutive well-formed hypotheses fail to explain the same symptom, stop before a fourth.'
assert_contains SKILL.md 'Debugging owns diagnosis and temporary cleanup; TDD owns the regression test and production fix.'
assert_contains SKILL.md 'When only an alternative evidence gate is possible, do not claim TDD.'
assert_contains SKILL.md 'Verification runs missing required gates and owns `READY`, `NOT READY`, or `BLOCKED`.'
assert_contains SKILL.md 'ask the user to invoke `/skill:code-review` when review is required.'
assert_contains references/causal-tracing.md '**Root cause:** earliest faulty transition or invalid assumption that must change.'
assert_contains references/diagnostic-instrumentation.md 'Capture `git status --short` before and after the experiment.'
assert_contains references/intermittent-and-unsafe-failures.md 'a later pass does not erase a failure.'
assert_contains references/intermittent-and-unsafe-failures.md 'keep the diagnosis blocked and request it from the authorized operator'

printf 'PASS: systematic-debugging root-cause, experiment, and handoff gates are explicit\n'
