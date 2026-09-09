---
name: fix
description: Repair a reproducible defect, failed build, CI failure, or confirmed review finding end to end: pin the failure, prove the cause, correct it minimally, and establish the final verification verdict. Use when the user asks to fix a bug, failing build, CI failure, or review finding, or hands in a proven root cause that needs implementing.
---

# Fix

Repair the defect, build/type failure, CI failure, or confirmed review finding the user names — supplied directly or via `/skill:fix`. Drive each phase to its named evidence; no phase's verdict is duplicated, and none is skipped because its Skill is absent.

Each phase below names a method and the evidence it must produce. When the phase's skill is loaded, follow its procedure — it is the full, authoritative form of that phase and its handoff is the fastest entry; when it is not loaded, execute the phase yourself to the same standard. No gate is reported passed without the evidence it names.

Use another workflow when the request is not a repair. For diagnosis only, stop once the cause is proven and hand off. For evidence-only gate checks, run only the verification phase and stop. When the user wants to change behavior that already matches accepted intent — a new or altered requirement, not a defect — this is not a repair: route it to the spec stage (`spec` when loaded, or `/skill:spec` when the user asks) to establish the behavior contract, or to `plan` for sequenced delivery of an accepted contract.

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

- **Unknown cause:** the report establishes a symptom but not the complete causal chain and violated invariant. Diagnose before any production edit: reproduce, minimize, and prove the causal chain and violated invariant through falsifiable experiments. When `systematic-debugging` is loaded, its procedure is the full form of this phase and its proven-cause handoff is the fastest entry; otherwise run the same loop yourself. Continue to implementation only when the cause is proven; when the diagnosis returns `BLOCKED`, stop production edits and report the blocker with what would resolve it.
- **Proven behavioral cause:** current evidence ties the symptom or confirmed finding to a causal chain and violated behavior or invariant. Revalidate that the same chain reaches the current state before implementation.
- **Direct non-behavioral failure:** a repository-authoritative parser, compiler, type checker, linter, build tool, or artifact check identifies an invalid file, symbol, configuration, or generated state, and the correction need not choose new runtime behavior. Treat ambiguous diagnostics, cascading errors, and proposed public-contract changes as unknown causes.

A review finding is an input, not an automatic cause classification. Reject causal evidence when `HEAD`, relevant files, dependency state, configuration, generated inputs, environment, or failure signature has changed materially since capture.

Completion criterion: the route is supported by current evidence; unknown causes have a completed debugging handoff before production behavior is edited.

### 3. Establish the repair gate

Use the narrowest safe command or observation that is red on the pinned target in the current worktree. Reuse a debugging handoff's gate only when its claim, scope, sequence, worktree state, authority, result, and prerequisites still match; otherwise run it fresh. Match its signature to the reported symptom or authoritative failure. For a behavioral defect, identify the stable public seam where a regression test can witness the violated behavior. For a direct non-behavioral failure, retain the exact diagnostic and location.

Ask for approval before a proving method can mutate persistent data, contact production, send messages, incur material cost, or affect external systems. Use an observational gate only when deterministic reproduction is unsafe or unavailable, and state what it cannot prove.

Completion criterion: fresh pre-change evidence fails for the intended reason and can distinguish a correction from a nearby change.

### 4. Make the smallest safe correction

For a behavioral cause with a runnable RED test, implement through the TDD method: write the regression test that witnesses the violated behavior at the stable seam, watch it fail for the right reason, then make the smallest production change that turns it green, refactoring only while green. When `tdd` is loaded, its procedure is the full form of this phase and its RED/GREEN evidence handoff is the fastest entry; otherwise run the same cycle yourself. Final readiness gates belong to the next phase — do not claim them here.

When the cause is proven but only an alternative observational gate is available, state why TDD cannot apply and ask for approval of the smallest non-TDD implementation path. After approval, preserve that gate, edit one supported cause at a time, and compare the same observation after each change. Return `BLOCKED` when approval or a safe comparison environment is unavailable; never label this route TDD.

For a direct non-behavioral failure:

1. trace the diagnostic to the smallest invalid source;
2. edit one cause at a time;
3. rerun the focused repair gate after each cause;
4. stop when the original signature clears or changes into a newly classified target.

Preserve unrelated work and agent-owned scope. Prefer a root-cause correction over suppression, weakened types, skipped tests, reduced thresholds, or broad refactoring. Treat a changed failure signature as a new target and return to classification rather than stacking patches.

Stop and ask before adding, removing, upgrading, or installing dependencies; changing lockfiles intentionally; modifying a public contract or architecture beyond the pinned repair; running destructive Git operations; or performing migrations and other persistent or external effects. Report `BLOCKED` when approval or a required safe environment is unavailable.

Completion criterion: the focused gate is green on the original target, the diff is limited to the supported cause, no temporary diagnostics remain, and every scope expansion has explicit approval.

### 5. Establish the final verdict

Once implementation is stable, run the verification phase: discover the required gates from repository instructions and CI configuration, run them narrow-to-broad from the final worktree, capture `git status --short` around each command, attribute every non-pass result, and return `READY`, `NOT READY`, or `BLOCKED` from the gate table. Reuse same-state upstream evidence — the debugging record, RED/GREEN results, an earlier verification — where it already proves a gate; rerun what is stale. When the user runs `/skill:verification`, consume its report as this phase and do not run a second gate set.

If a repairable failure appears inside the approved scope, classify it as a new target before another edit. If it is outside scope, baseline, unsafe to reproduce, or unsupported by a proven cause, preserve the verdict and ask for the next decision. Rerun the phase after every subsequent implementation change; an earlier verdict is stale.

Completion criterion: every required final gate for the unchanged final worktree has fresh evidence and exactly one verdict.

### 6. Offer review without duplicating it

Code review remains a separate user decision. When the user requested review, or the repair changes a security boundary, public contract, migration, concurrency behavior, or other high-risk path, provide the exact scope and ask the user to run `/skill:code-review <scope>` (or have the review done in this session when they prefer). If review does not run, record it as `PENDING` with its scope and the evidence it would need. Never issue a review verdict from this workflow or treat `READY` as review approval.

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
