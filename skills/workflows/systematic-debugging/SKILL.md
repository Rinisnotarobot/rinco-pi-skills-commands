---
name: systematic-debugging
description: Root-cause-first diagnosis for bugs, unexpected behavior, regressions, flaky tests, performance problems, and build or CI failures. Use when an observed failure has an unproven cause, a TDD RED result fails for the wrong reason, or another fix would be speculative; diagnose before TDD or fixes and hand off once the cause is proven.
---

# Systematic Debugging

Turn an observed failure into a proven root cause through a tight, falsifiable feedback loop. Diagnose before editing production behavior. Temporary diagnostic changes are experiments, not fixes.

## Workflow

### 1. Pin the symptom and state

Read the complete error, stack trace, logs, failing command, and supplied reproduction before changing files. Inspect applicable repository instructions, `git status --short`, the relevant diff, recent changes, and the affected runtime or CI environment.

Record:

- expected and actual behavior;
- exact trigger, frequency, and first known occurrence;
- scope, comparison point, environment, and prerequisites;
- current worktree state and unrelated local changes;
- attempts already made and their observed results.

When a plan, incident report, TDD result, verification report, or review finding exists, treat it as upstream evidence to validate rather than a conclusion to trust.

Completion criterion: the symptom is observable and distinguished from assumptions about its cause.

### 2. Establish a red feedback loop

Find the smallest safe command or observation that goes red on the reported failure. Reproduce from a known state and preserve the full result. Confirm that the signal represents the target symptom rather than syntax, setup, missing dependencies, stale fixtures, or another failure.

For intermittent, unsafe, or performance failures, read [Intermittent and Unsafe Failures](references/intermittent-and-unsafe-failures.md). When deterministic reproduction is unsafe or unavailable, define an alternative evidence gate using existing logs, traces, metrics, recorded inputs, or a controlled observation. Mark what that gate cannot prove.

Do not install, upgrade, remove, or auto-fix dependencies. For Python, use repository-configured `uv run`; if `uv` is unavailable, use the repository's documented fallback or report the blocker.

Completion criterion: a repeatable red signal or a documented alternative evidence gate can distinguish progress from guesswork.

### 3. Minimize and trace causality

Reduce the input, execution path, component set, timing window, or changed-file range while preserving the same failure signature. Compare the broken path with the closest working example and list material differences without dismissing small ones.

Trace backward from the symptom to the earliest incorrect value, state transition, boundary, or assumption. Read [Causal Tracing](references/causal-tracing.md) for deep stacks, state pollution, or multi-component paths. Read [Diagnostic Instrumentation](references/diagnostic-instrumentation.md) before adding logs, probes, counters, or traces.

Completion criterion: the failure is localized to the narrowest supported boundary and the causal chain identifies the next unknown.

### 4. Test one hypothesis

Write one specific hypothesis:

```text
Because <evidence>, <cause> produces <mechanism>, which explains <symptom>.
If true, <minimal experiment> will produce <discriminating result>.
```

Run the smallest experiment that can separate this hypothesis from plausible alternatives. Change one variable. Prefer observation or temporary instrumentation over production-behavior edits. Capture the exact command or method, result, worktree state, and decision in the evidence log.

A confirming result must explain the complete causal chain, not merely make the symptom disappear. A refuting result becomes evidence for the next hypothesis. Reverse only agent-owned diagnostic hunks before continuing; never use checkout, reset, or whole-file restoration to clean a file that may contain unrelated edits. Stop and ask when exact cleanup cannot be proven.

Completion criterion: the hypothesis is confirmed with a causal explanation or refuted with a recorded result.

### 5. Reassess instead of thrashing

Repeat minimization, tracing, and one-hypothesis experiments as new evidence arrives. After three consecutive well-formed hypotheses fail to explain the same symptom, stop before a fourth. Recheck the reproduction, hidden shared state, environment parity, component boundaries, and architectural assumptions; ask for an architectural decision when the evidence suggests the current design is unsound.

Do not stack speculative patches or reinterpret a changed failure signature as progress. A new signature starts a newly pinned symptom and evidence loop.

Completion criterion: either the root cause and violated invariant are proven, or the investigation is explicitly blocked with the missing evidence or decision named.

### 6. Hand the proven cause to TDD

Once the cause is proven, hand off:

- minimal reproduction or alternative evidence gate;
- root cause, causal chain, and violated invariant;
- stable public seam where a regression test can observe the behavior;
- expected RED signature before the fix;
- confirmed and refuted hypotheses;
- temporary instrumentation and required cleanup;
- scope, prerequisites, worktree state, and residual uncertainty.

Remove temporary instrumentation before handoff, reversing only agent-owned changes. Pass a durable-observability proposal onward only when the repository needs the signal and its risks are explicit.

When a runnable RED is possible, invoke the model-invoked `tdd` skill to create the regression RED, implement the smallest root-cause fix, and reach GREEN. Debugging owns diagnosis and temporary cleanup; TDD owns the regression test and production fix.

When only an alternative evidence gate is possible, do not claim TDD. Report the smallest enabling step or obtain explicit approval for an implementation path that preserves the observational gate for post-fix comparison.

Completion criterion: the next implementation actor can reproduce the defect at a stable seam or use an explicitly approved alternative gate without rediscovering the causal path.

### 7. Preserve downstream evidence

After the fix completes, let `verification` decide whether debugging and implementation evidence is fresh for the pinned scope and final worktree. Verification runs missing required gates and owns `READY`, `NOT READY`, or `BLOCKED`. Code review separately decides whether the fix addresses the root cause without creating new risks; because `code-review` is user-invoked, report the review scope and verification artifact, then ask the user to invoke `/skill:code-review` when review is required.

Report the investigation:

```text
Symptom and scope
Red feedback loop
Minimal reproduction
Root cause and violated invariant
Causal chain
Hypotheses and experiments
TDD handoff and cleanup
Verification handoff
Residual uncertainty
```

Completion criterion: every root-cause and completion claim points to reproducible evidence, while unproven conclusions and downstream gates remain explicit.

## Guardrails

- Preserve unrelated work and compare `git status --short` around experiments.
- Use sanitized diagnostics. Never print secrets, credentials, personal data, or sensitive payloads.
- Ask before an experiment can mutate persistent data, contact production, send messages, incur material cost, or affect external systems.
- Keep durable observability only when it has operational value, follows repository policy, and passes implementation testing and review; otherwise remove agent-owned instrumentation before handoff.
- Distinguish root cause from contributing condition, trigger, and detection gap.
