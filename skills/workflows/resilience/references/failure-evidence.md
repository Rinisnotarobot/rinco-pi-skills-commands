# Failure Evidence

Read this reference when turning a resilience policy into a verification handoff.

## Scenario matrix

Select the rows that cross the changed boundary. Each scenario must name the injected condition, expected business result, expected timing or capacity bound, durable state after the event, and observable signals.

| Risk | Inject or arrange | Prove |
|---|---|---|
| Hung dependency | connection accepts but never completes | caller exits within its deadline; capacity is released or bounded |
| Slow response | completion near and beyond the budget | remaining deadlines propagate; late success cannot corrupt caller state |
| Transient failure | controlled reset or retryable response | bounded retry occurs with backoff; final result and attempt count are visible |
| Permanent failure | validation, auth, or deterministic rejection | zero automatic retries |
| Unknown write outcome | commit then lose acknowledgement | same operation identity produces one business effect and a recoverable result |
| Concurrent duplicate | send the same operation identity in parallel | one durable effect; duplicates receive defined in-progress or completed behavior |
| Retry amplification | fail a dependency while all retry layers are enabled | aggregate executions stay within the documented budget |
| Saturation | exceed concurrency or queue capacity | excess work is rejected, shed, or degraded as designed; memory and latency remain bounded |
| Partial failure | stop between durable transitions | resume, compensation, or reconciliation reaches an owned terminal state |
| Worker death | terminate before and after side effect or acknowledgement | redelivery is safe and acknowledgement follows durable safety |
| Poison work | repeat a deterministic worker failure | attempts stop; quarantine, alert, and replay controls activate |
| Recovery | restore a failed dependency or drain overload | probes and traffic return gradually without a retry storm |

## Evidence quality

Prefer, in order:

1. deterministic tests using a controllable dependency, clock, scheduler, or broker;
2. component or integration tests against isolated infrastructure;
3. staging failure injection with explicit blast radius;
4. production experiments only with authorization, abort conditions, and observability.

A test that only asserts an exception type does not prove timing, duplicate safety, resource release, or recovery. Pair functional assertions with bounded time, durable state, attempt counts, and saturation signals as applicable.

## Required signals

Select signals that distinguish the failure modes rather than one generic error counter:

- deadline and cancellation reason;
- attempt number, retry cause, delay, and total elapsed time;
- operation or idempotency identity with sensitive values redacted;
- in-flight work, admission rejection, saturation, and queue age;
- circuit state and half-open probes;
- durable workflow state, reconciliation age, and compensation result;
- delivery count, lease expiry, acknowledgement, and quarantine growth.

Keep metric labels bounded; operation identities belong in trace or structured-log fields, not high-cardinality metric dimensions.

## Verification handoff

Pass:

```text
Claim and invariant
Scope and comparison point
Scenario and injected condition
Command or procedure
Expected business, timing, capacity, and durable-state result
Expected metrics, traces, or logs
Required environment and authority
Abort and cleanup procedure
Known limits
Pinned worktree state
```

The receiving `verification` owner decides whether the evidence is fresh and sufficient, runs approved gates, attributes failures, and issues the implementation verdict.
