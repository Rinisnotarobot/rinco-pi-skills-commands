---
name: verification
description: Evidence-gated verification of code changes. Use when meaningful implementation or refactoring is complete, before claiming success, before review or release, or when build, type, lint, test, coverage, acceptance, or generated-artifact status must be established from fresh repository evidence.
---

# Change Verification

Prove the current change state with fresh, repository-authoritative evidence. Return `READY`, `NOT READY`, or `BLOCKED`; confidence, stale output, and unverifiable earlier runs are not evidence. `READY` means the verification gates passed for the pinned scope, not that code review, acceptance, merge, or release approval is complete.

Run checks in read-only or check mode. Preserve the worktree, dependency state, lockfiles, snapshots, and generated artifacts. Report failures for repair in a separate implementation cycle, then rerun verification from the changed state.

## Workflow

### 1. Pin the claim and scope

State what must be proven and for which stage: a regression is fixed, an implementation is complete, required gates pass, or the change is ready to enter review or release preparation.

Read applicable repository instructions. Inspect the requested scope, `git status --short`, diff statistics, and the relevant diff. Identify affected packages, services, languages, public contracts, tests, configuration, migrations, and generated outputs.

Collect upstream artifacts and evidence when present: the source specification and originating `REQ`/`INV`/`AC` identifiers, the plan's verification contract, systematic-debugging cause and reproduction handoff, TDD RED/GREEN handoff, backend invariant and risk-specific verification plan, review scope, and explicit user acceptance. Follow [Evidence Handoffs](references/evidence-handoffs.md) to accept only same-state evidence and reject stale or incomplete results.

When no scope is supplied, use all worktree changes relative to `HEAD`. Stop with `BLOCKED` when neither an explicit target nor a meaningful change can be identified.

Completion criterion: the claim, current stage, comparison point, complete change set, acceptance evidence, affected execution surfaces, and reusable upstream results are fixed.

### 2. Discover authoritative gates

Follow [Gate Discovery](references/gate-discovery.md). Derive commands from repository instructions, CI configuration, task definitions, manifests, lockfiles, and tool configuration. Classify each applicable gate as required or optional before running it.

Record the owner, due stage, authority, proving method, and evidence source for every gate. Treat an absent non-applicable gate as `N/A`. Mark required evidence owned by a later stage `PENDING`; it does not block entry into the current stage. Treat required command, manual, operational, migration, security-review, or compatibility evidence due now that cannot be obtained as `BLOCKED`.

Completion criterion: every acceptance condition and affected surface maps to a proving method or a checkable `N/A` reason, with required/optional status, owner, and due stage explicit.

### 3. Run the focused gate

Start with the narrowest command that can disprove the claim: the regression test, affected test file, package type check, scoped lint, or artifact check. Run it fresh and non-interactively. Read the complete exit status and retain the first actionable failure without truncating it away.

A failed focused gate ends dependent expansion. Continue only independent, safe gates that add useful attribution evidence; avoid producing a larger copy of the same failure.

Completion criterion: the most direct claim has fresh `PASS`, `FAIL`, or `BLOCKED` evidence.

### 4. Expand from affected scope to required scope

After focused evidence passes, run affected package or service gates not already covered by reusable same-state evidence, then broader repository gates required by policy or change risk. Typical classes are tests, types, lint/format check, build, configured coverage, generated-artifact consistency, and configured security scanners.

For required non-command evidence due in the current stage, verify the authoritative observation, review artifact, approval record, operational signal, or reconciliation result. Request the authorized actor when the current agent cannot produce it; mark the gate `BLOCKED` rather than simulating approval or substituting a weaker command.

Use configured thresholds and scripts. A test pass does not prove a build, a lint pass does not prove types, and one package does not prove an affected workspace. Verification also does not replace correctness-by-inspection, design, maintainability, product acceptance, or release authorization. Deep reasoning about those concerns belongs to code review, security review, or the applicable approval workflow; this phase runs only configured gates and direct change-integrity checks.

Capture `git status --short` before and immediately after each command. When a gate creates an unapproved tracked change or relevant untracked artifact, stop before running another gate. Do not restore, delete, or accept the mutation automatically. Mark the mutating gate and every unrun required gate `BLOCKED`; use overall `BLOCKED` unless an earlier required gate already failed, in which case use `NOT READY`. Ask for cleanup or approval, then rerun all stale gates from the intended state.

Completion criterion: every required gate due in the current stage has fresh evidence from the final unchanged worktree state, or the first mutating command has produced an explicit blocker; downstream gates remain explicit `PENDING` items.

### 5. Attribute every non-pass result

Follow [Failure Attribution](references/failure-attribution.md). Classify each `FAIL` or `BLOCKED` result as change-introduced, baseline, environment, or unknown. Preserve all attempts when investigating intermittent behavior; a later pass does not erase an earlier failure.

Attribution changes the repair owner and risk explanation, not the observed gate result.

Completion criterion: every non-pass result names its category, supporting evidence, and the next action that would resolve or disambiguate it.

### 6. Apply the verdict gate

Choose the overall result from current evidence:

- `READY`: every required gate due in the current stage is `PASS` or has a credible `N/A` reason, the intended worktree state is unchanged, and optional non-passes plus downstream `PENDING` gates are disclosed.
- `NOT READY`: at least one required gate due in the current stage is `FAIL`, whether change-introduced, baseline, or unknown.
- `BLOCKED`: no required gate due now is known to fail, but missing scope, tools, services, credentials, infrastructure, authorized actor, or other current-stage evidence prevents a conclusion.

When required failures and blockers coexist, use `NOT READY` and list the blocked evidence separately. Never convert an unavailable gate to `N/A` merely to reach `READY`.

Completion criterion: the verdict follows mechanically from the gate table.

### 7. Report evidence before claims

Use this compact report:

```markdown
# Verification Report

- Claim: <what was proved>
- Scope: <comparison point and affected areas>
- Stage: implementation | pre-review | pre-release | other
- Upstream artifacts: <plan, TDD handoff, review scope, or none>
- Overall: READY | NOT READY | BLOCKED

| Gate | Source IDs | Requirement / due stage | Result | Method and evidence | Source / freshness | Attribution |
|---|---|---|---|---|---|---|
| Focused behavior | REQ-001, AC-001 | required / implementation | PASS/FAIL/BLOCKED/N/A/PENDING | `...` — exit N, key result | TDD handoff — same state | change-introduced/baseline/environment/unknown/N/A |

## Blocking issues
- <failure or unavailable required evidence; write "None" when empty>

## Residual risks and downstream gates
- <optional failures, downstream PENDING evidence, skipped risk-based checks, flaky evidence, or assumptions; write "None" when empty>

## Worktree integrity
- Before: <status summary>
- After: <status summary and any command-created artifacts>
```

Include exact commands, exit status, and enough output for another engineer to reproduce the conclusion. Redact secrets, credentials, personal data, and sensitive payloads.

Completion criterion: every success claim in the response points to fresh evidence in the report, and unrun work is named explicitly.
