# Diagnostic Instrumentation

Add the smallest probe that distinguishes competing causal explanations.

## Design the probe

Before editing, state:

```text
Question: <unknown the probe resolves>
Placement: <boundary or transition>
Signal: <sanitized value, event, duration, count, or stack>
Expected outcomes: <how each outcome changes the hypothesis>
Lifetime: temporary | proposed durable observability
Cleanup: <files, flags, artifacts, or services to restore>
```

Prefer existing logs, traces, metrics, debugger facilities, test hooks, or check modes. Add code only when existing signals cannot answer the question.

## Boundary probes

At a component boundary, capture enough to pair ingress and egress:

- correlation ID;
- component and operation;
- monotonic duration or ordered timestamp;
- sanitized shape, size, status, and state transition;
- configuration version or feature-flag identity;
- error class and retry/cancellation outcome.

Record presence or hashes instead of secret values. Avoid full payloads when metadata can discriminate the hypothesis.

## Worktree integrity

Capture `git status --short` before and after the experiment. Keep temporary edits narrow and identifiable. Reverse only agent-owned hunks before the next experiment unless the next hypothesis depends on the same probe. Never use checkout, reset, or whole-file restoration when a file may contain unrelated edits. If exact cleanup cannot be proven, stop and ask. If a command creates unexpected tracked or relevant untracked artifacts, stop and report the mutation rather than deleting it automatically.

## Durable instrumentation gate

Retain a probe only when all are true:

- it detects an operationally meaningful condition;
- its volume, latency, cardinality, and storage cost are acceptable;
- data handling follows repository security and privacy policy;
- failure behavior is safe when the telemetry backend is unavailable;
- TDD covers its relevant behavior and code review accepts the trade-off.

Otherwise restore the original code and carry only the captured evidence into the handoff.
