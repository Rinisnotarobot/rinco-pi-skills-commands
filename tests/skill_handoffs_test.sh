#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
SPEC_DIR=${SPEC_DIR:-skills/spec}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local file=$1
  local expected=$2

  grep -F -- "$expected" "$REPO_ROOT/$file" >/dev/null || \
    fail "$file lacks handoff contract: $expected"
}

assert_not_contains() {
  local file=$1
  local rejected=$2

  ! grep -F -- "$rejected" "$REPO_ROOT/$file" >/dev/null || \
    fail "$file retains duplicate ownership: $rejected"
}

assert_contains "$SPEC_DIR/SKILL.md" '`plan` turns evidence intent into the executable verification contract'
assert_contains "$SPEC_DIR/references/artifact-and-handoff.md" 'preserve `REQ`, `INV`, and `AC` identifiers'
assert_contains skills/plan/SKILL.md 'stop and ask the user to invoke `/skill:spec`'
assert_contains skills/plan/SKILL.md 'maps every originating `REQ`, `INV`, and `AC` identifier'
assert_contains skills/plan/SKILL.md 'Planning defines this contract but does not execute it.'
assert_contains skills/plan/SKILL.md 'The `Final Verification` section is the durable verification contract.'
assert_contains skills/plan/SKILL.md 'owner and earliest stage when the evidence is due'
assert_contains skills/systematic-debugging/SKILL.md 'Debugging owns diagnosis and temporary cleanup; TDD owns the regression test and production fix.'
assert_contains skills/tdd/SKILL.md 'use systematic-debugging first when an observed failure has an unproven cause.'
assert_contains skills/systematic-debugging/SKILL.md 'After three consecutive well-formed hypotheses fail to explain the same symptom, stop before a fourth.'
assert_contains skills/systematic-debugging/SKILL.md 'let `verification` decide whether debugging and implementation evidence is fresh'
assert_contains skills/tdd/SKILL.md 'originating `REQ`, `INV`, and `AC` identifiers'
assert_contains skills/tdd/SKILL.md 'For a defect with an unproven cause, invoke `systematic-debugging`'
assert_contains skills/tdd/SKILL.md 'prepare a verification evidence handoff'
assert_contains skills/tdd/SKILL.md 'Let the model-invoked `verification` skill decide'
assert_contains skills/verification/SKILL.md '[Evidence Handoffs](references/evidence-handoffs.md)'
assert_contains skills/verification/SKILL.md 'required command, manual, operational, migration, security-review, or compatibility evidence'
assert_contains skills/verification/references/evidence-handoffs.md '`spec` | desired behavior, authority, `REQ`/`INV`/`AC` identifiers, invariants, and evidence intent'
assert_contains skills/verification/references/evidence-handoffs.md '`systematic-debugging` | symptom, reproduction, causal chain, violated invariant, experiments, and diagnosis blockers'
assert_contains skills/verification/references/evidence-handoffs.md 'Review Verdict'
assert_contains skills/verification/references/evidence-handoffs.md 'Verification State'
assert_contains skills/verification/references/evidence-handoffs.md 'Required evidence owned by a later stage remains `PENDING`'
assert_contains skills/backend-patterns/SKILL.md 'Verification plan'
assert_contains skills/code-review/SKILL.md 'Use the model-invoked `verification` skill as the single owner'
assert_contains skills/code-review/SKILL.md 'The current review itself is a downstream gate and remains `PENDING`'
assert_contains skills/code-review/SKILL.md 'Record `Verification Stage` and `Verification State` separately from `Review Verdict`'
assert_contains skills/code-review/SKILL.md 'explicitly exclude only that path from the pinned verification scope'
assert_contains skills/code-review/references/evidence-and-reporting.md '## Requirement coverage'
assert_contains skills/code-review/references/evidence-and-reporting.md 'A proven baseline-only failure may coexist with `APPROVE`'
assert_not_contains skills/code-review/SKILL.md 'Discover authoritative commands from repository configuration, CI, and scripts.'

printf 'PASS: Skill ownership, evidence handoffs, and verdict separation are explicit\n'
