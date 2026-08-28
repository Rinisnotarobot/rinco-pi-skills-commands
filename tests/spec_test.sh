#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
SKILL_ROOT=${SKILL_ROOT:-$REPO_ROOT/skills/spec}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local file=$1
  local expected=$2

  grep -F -- "$expected" "$SKILL_ROOT/$file" >/dev/null || \
    fail "$file lacks specification gate: $expected"
}

[[ -f "$SKILL_ROOT/SKILL.md" ]] || fail "Skill missing: $SKILL_ROOT/SKILL.md"
[[ ! -e "$REPO_ROOT/processing/skills/intent-driven-development" ]] || \
  fail 'superseded intent-driven-development draft remains'
[[ ! -e "$REPO_ROOT/processing/skills/product-capability" ]] || \
  fail 'superseded product-capability draft remains'
[[ -f "$REPO_ROOT/processing/skills/product-lens/SKILL.md" ]] || \
  fail 'distinct product-lens draft was removed'
[[ -f "$REPO_ROOT/processing/skills/grilling/SKILL.md" ]] || \
  fail 'distinct grilling draft was removed'

assert_contains SKILL.md 'disable-model-invocation: true'
assert_contains SKILL.md 'Repository behavior does not define desired business policy.'
assert_contains SKILL.md 'Do not persist a final artifact while a decision can materially change required behavior'
assert_contains SKILL.md '`REQ-NNN` for required capabilities or constraints'
assert_contains SKILL.md '`INV-NNN` for conditions that must remain true across transitions'
assert_contains SKILL.md '`AC-NNN` for observable acceptance criteria'
assert_contains SKILL.md 'File paths, symbols, package choices, task slices, and repository commands belong to `plan`'
assert_contains SKILL.md 'append `-2`, `-3`, and so on before `.md` instead of overwriting.'
assert_contains SKILL.md 'contains no unresolved material product or policy decision or assumption'
assert_contains references/acceptance-quality.md 'REQ/INV → AC → evidence intent'
assert_contains references/risk-and-transition-coverage.md 'Existing code can show current behavior and risk, but cannot silently authorize desired policy.'
assert_contains references/artifact-and-handoff.md 'Use `READY FOR PLAN` only when:'
assert_contains references/artifact-and-handoff.md 'When the gate fails, report `BLOCKED` in conversation'
assert_contains references/artifact-and-handoff.md 'remaining assumptions are explicitly classified as non-blocking'
assert_contains references/artifact-and-handoff.md 'preserve `REQ`, `INV`, and `AC` identifiers'
assert_contains references/artifact-and-handoff.md 'Supersedes: <prior artifact path>'
assert_contains references/artifact-and-handoff.md 'Read the full `Supersedes` lineage before assigning identifiers.'
assert_contains references/artifact-and-handoff.md 'Retired identifiers remain permanently reserved.'

printf 'PASS: spec authority, readiness, traceability, persistence, and handoff gates are explicit\n'
