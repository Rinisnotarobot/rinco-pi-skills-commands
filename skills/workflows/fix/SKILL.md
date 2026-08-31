---
name: fix
description: Run explicitly when repairing a reproducible defect, failed build, CI failure, or confirmed review finding.
compatibility: Requires the systematic-debugging, tdd, and verification skills to be discoverable in the same Pi session.
disable-model-invocation: true
---

# Fix

Repair the defect, build/type failure, CI failure, or confirmed review finding supplied after `/skill:fix`. Orchestrate existing evidence owners instead of creating parallel diagnosis, test, review, or verification verdicts.

Before starting, confirm that `systematic-debugging`, `tdd`, and `verification` appear in the current session's available Skills. Stop with `BLOCKED` and name every missing Skill when the core set is incomplete; Pi discovers Skills at startup, so instructions cannot make an unloaded dependency available.

Check each conditional downstream Skill immediately before handoff. A missing `spec` or `plan` blocks a required reroute: name the missing Skill and provide a relaunch command that preserves the loaded core set and adds it. A missing `code-review` leaves that downstream gate `PENDING` rather than changing the completed repair verdict; provide the corresponding relaunch command and exact review scope. Never claim a handoff to an unavailable Skill.

Use another workflow when the request is not a repair. For diagnosis only, invoke `systematic-debugging` and stop at its proven-cause handoff. For evidence-only gate checks, invoke `verification`. When behavior already matches accepted intent and the user wants it changed, confirm `spec` is available and ask the user to invoke `/skill:spec` if no accepted behavior contract exists; otherwise confirm `plan` is available and hand that contract to `plan`.

## Workflow

### 1. Pin the request and repository state

Read the complete report, command output, stack trace, review finding, specification or acceptance IDs, and prior attempts. Read applicable repository instructions. Record:

- expected and actual result;
- exact target and requested scope;
- reproduction or failing command, environment, and prerequisites;
- branch, `HEAD`, `git status --short`, relevant diff, and unrelated local work;
- upstream artifact paths and the state in which their evidence was captured.

Use all worktree changes relevant to the failure when the user names no narrower comparison point. Stop with `BLOCKED` when no observable failure, confirmed finding, or exact repair target can be identified.

Completion criterion: the repair target, comparison point, current worktree, allowed scope, and upstream evidence are fixed without treating an earlier conclusion as current proof.

### 2. Classify the cause

Place the target in exactly one route:

- **Unknown cause:** the report establishes a symptom but not the complete causal chain and violated invariant. Invoke `systematic-debugging` with `fix` named as the downstream implementation and verification owner. Require its proven-cause handoff before TDD or production edits. Continue only when the handoff proves the cause or names a blocker.
- **Proven behavioral cause:** current evidence ties the symptom or confirmed finding to a causal chain and violated behavior or invariant. Revalidate that the same chain reaches the current state before implementation.
- **Direct non-behavioral failure:** a repository-authoritative parser, compiler, type checker, linter, build tool, or artifact check identifies an invalid file, symbol, configuration, or generated state, and the correction need not choose new runtime behavior. Treat ambiguous diagnostics, cascading errors, and proposed public-contract changes as unknown causes.

A review finding is an input, not an automatic cause classification. Reject causal evidence when `HEAD`, relevant files, dependency state, configuration, generated inputs, environment, or failure signature has changed materially since capture.

Completion criterion: the route is supported by current evidence; unknown causes have a completed debugging handoff before production behavior is edited.

### 3. Establish the repair gate

Use the narrowest safe command or observation that is red on the pinned target in the current worktree. Reuse a debugging handoff's gate only when its claim, scope, sequence, worktree state, authority, result, and prerequisites still match; otherwise run it fresh. Match its signature to the reported symptom or authoritative failure. For a behavioral defect, identify the stable public seam where a regression test can witness the violated behavior. For a direct non-behavioral failure, retain the exact diagnostic and location.

Ask for approval before a proving method can mutate persistent data, contact production, send messages, incur material cost, or affect external systems. Use an observational gate only when deterministic reproduction is unsafe or unavailable, and state what it cannot prove.

Completion criterion: fresh pre-change evidence fails for the intended reason and can distinguish a correction from a nearby change.

### 4. Make the smallest safe correction

For a behavioral cause with a runnable RED test, invoke `tdd` with the pinned symptom, proven cause, violated invariant, stable seam, RED signature, allowed scope, current worktree state, and `fix` explicitly named as the final verification owner. Let TDD own the regression test, RED/GREEN cycle, production edit, and refactor decision, then require its evidence handoff before it invokes verification.

When the cause is proven but only an alternative observational gate is available, state why TDD cannot apply and ask for approval of the smallest non-TDD implementation path. After approval, preserve that gate, edit one supported cause at a time, and compare the same observation after each change. Return `BLOCKED` when approval or a safe comparison environment is unavailable; never label this route TDD.

For a direct non-behavioral failure:

1. trace the diagnostic to the smallest invalid source;
2. edit one cause at a time;
3. rerun the focused repair gate after each cause;
4. stop when the original signature clears or changes into a newly classified target.

Preserve unrelated work and agent-owned scope. Prefer a root-cause correction over suppression, weakened types, skipped tests, reduced thresholds, or broad refactoring. Treat a changed failure signature as a new target and return to classification rather than stacking patches.

Stop and ask before adding, removing, upgrading, or installing dependencies; changing lockfiles intentionally; modifying a public contract or architecture beyond the pinned repair; running destructive Git operations; or performing migrations and other persistent or external effects. Report `BLOCKED` when approval or a required safe environment is unavailable.

Completion criterion: the focused gate is green on the original target, the diff is limited to the supported cause, no temporary diagnostics remain, and every scope expansion has explicit approval.

### 5. Delegate the final verdict

Invoke `verification` once implementation is stable. Supply the pinned claim and scope, source IDs, debugging handoff, TDD RED/GREEN evidence or direct repair evidence, exact final worktree state, and any observational limitations. Let verification discover required gates, decide evidence freshness, attribute failures, protect worktree integrity, and return `READY`, `NOT READY`, or `BLOCKED`.

If verification exposes a repairable failure inside the approved scope, classify it as a new target before another edit. If it is outside scope, baseline, unsafe to reproduce, or unsupported by a proven cause, preserve the verification verdict and ask for the next decision. Rerun verification after every subsequent implementation change; an earlier verdict is stale.

Completion criterion: one verification report owns every required final gate for the unchanged final worktree.

### 6. Offer review without duplicating it

Code review remains a separate user decision. When the user requested review or the repair changes a security boundary, public contract, migration, concurrency behavior, or other high-risk path, provide the exact scope. When `code-review` is available, ask the user to run `/skill:code-review <scope>`; otherwise record the review as `PENDING` and provide a relaunch command that adds it. Do not issue a review verdict from this workflow or treat `READY` as review approval.

Completion criterion: required follow-up review has a reproducible handoff and is recorded as `PENDING` or completed; optional review is recorded as not requested; no second review or verification verdict exists.

### 7. Report the repair

Return:

```markdown
# Fix Report

- Target: <reported failure or finding>
- Scope: <comparison point and affected paths>
- Cause route: unknown→proven | proven behavioral | direct non-behavioral
- Root cause: <causal chain and violated invariant, or N/A for direct diagnostic>
- Pre-change evidence: <command or method, signature, result>
- Correction: <smallest implemented change>
- Focused result: <command or method, result>
- Verification: READY | NOT READY | BLOCKED — <report or compact evidence>
- Review: not requested | PENDING | completed — <scope>
- Worktree: <final branch, HEAD, status, unrelated changes>
- Residual risks: <limitations, pending decisions, or none>
```

Completion criterion: every causal, repair, and readiness claim points to current evidence; blocked work, stale evidence, unapproved effects, and residual risk remain explicit.
