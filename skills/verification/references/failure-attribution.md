# Failure Attribution

Classify a failure only after preserving its command, exit status, failure signature, and relevant environment facts.

## Categories

### Change-introduced

Use when the changed path reaches the failure and evidence shows the target or a relevant base state did not fail the same way. Strong evidence includes:

- a focused regression that goes red without the fix and green with it;
- a complete code, configuration, schema, or dependency trace from the diff to the failure;
- an existing passing base result for the same authoritative command and environment.

### Baseline

Use when the same failure is proven on the comparison point or by a trustworthy existing result that predates the change. Match the command, scope, configuration, and meaningful failure signature; a different historical failure is not baseline evidence.

A baseline failure remains a `FAIL`. Attribution explains that the current change did not cause it; it does not make a required gate pass.

### Environment

Use when the gate cannot execute or complete because required tools, services, credentials, network access, platform capabilities, storage, memory, or other infrastructure are unavailable. Include the preflight evidence and the smallest action needed to unblock the gate.

A code-shaped error is not automatically environmental. Trace whether repository code or configuration created the missing prerequisite.

### Unknown

Use when available evidence cannot distinguish change, baseline, or environment causes. Name the exact missing comparison, reproduction, permission, or observation that would resolve the category.

Unknown required failures produce `NOT READY`; uncertainty is not a pass.

## Attribution procedure

1. **Capture:** retain the exact command, exit code, first actionable error, and stable failure signature.
2. **Trace:** map the failing file, package, service, configuration, or dependency to the verification scope.
3. **Compare safely:** prefer existing CI/history evidence. When necessary, use an isolated worktree or disposable copy to run the same command at the base revision without altering the active worktree.
4. **Match:** compare command, environment, scope, and failure signature rather than exit code alone.
5. **Classify:** choose one category and cite the evidence. Use `unknown` when the match is incomplete.

Do not switch revisions in a dirty worktree, reset user changes, overwrite artifacts, use production credentials/data, or install dependencies to manufacture a baseline comparison. Report the missing comparison instead.

## Intermittent results

Treat an initial failure followed by a pass as flaky evidence until a deterministic cause is shown. Record every attempt, order, timing, seed, worker count, and environment difference that matters. Rerun only to test a stated hypothesis; repeated execution until green is not verification.

Follow explicit repository policy when it defines flaky-gate treatment. Without such a policy, keep any required gate with an unexplained observed failure at `FAIL` even when a rerun passes; optional gates remain `FAIL` under residual risks. A gate can return to `PASS` only after evidence identifies and removes the deterministic cause or an authoritative policy supplies another classification.

## Attribution record

```text
Gate: <name and scope>
Result: FAIL | BLOCKED
Command: <exact command and exit status>
Failure signature: <first actionable, stable evidence>
Category: change-introduced | baseline | environment | unknown
Comparison: <base run, CI evidence, trace, or unavailable>
Next action: <repair or evidence needed>
```
