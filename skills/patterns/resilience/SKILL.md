---
name: resilience
description: Model-invoked discipline for designing or reviewing failure behavior across remote dependencies, durable asynchronous work, and shared-capacity boundaries. Use when a change needs deadlines, cancellation, retries, idempotency, overload control, partial-failure recovery, or evidence requirements for these controls.
---

# Resilience

Design and review how a scoped operation fails, sheds load, and recovers. Preserve business correctness before availability: a fast duplicate charge or a successful response for lost work is not resilient.

This Skill owns resilience policy and failure-evidence requirements. `backend-patterns` owns broader architecture integration, `spec` owns desired behavior, `plan` owns the executable verification contract, `security-review` owns exploit paths, and `verification` alone produces the current implementation gate verdict.

## Workflow

### 1. Gate applicability and pin the failure boundary

Apply this Skill when failure crosses a remote dependency, durable queue or worker, multi-step side-effect boundary, or shared capacity limit. Ordinary local exceptions, error type design, response envelopes, user messages, and local async control flow are out of scope: name the relevant owner and stop with `OUT OF SCOPE`. If that stable owner is not loaded, include an exact repository profile or `pi --no-skills --skill ...` restart command. If the owner is still a processing candidate, report the handoff as `PENDING` with its source path rather than pretending it is available.

Inspect the relevant code, configuration, tests, and operational signals. Record:

- caller and dependency or producer and consumer;
- synchronous, asynchronous, scheduled, streaming, or mixed execution;
- side effects and the system that durably owns each one;
- caller latency budget, capacity limit, delivery guarantee, and recovery objective when known;
- existing timeout, cancellation, retry, queue, concurrency, and reconciliation controls.

Mark missing facts as assumptions. If side-effect ownership or the authoritative success condition cannot be established, return a blocked resilience assessment with the exact evidence needed; do not invent a policy.

Completion criterion: every affected boundary, side effect, and authoritative success signal is named or explicitly unresolved.

### 2. Classify attempts and outcomes

For each operation, classify:

- **effect:** read-only, naturally idempotent, idempotency-key guarded, conditionally safe, or non-idempotent;
- **failure:** transient, permanent, overload, deadline exhaustion, cancellation, malformed input, or unknown;
- **outcome:** confirmed success, confirmed failure, or unknown after a timeout, disconnect, worker death, or lost acknowledgement;
- **duplication:** impossible by contract, tolerated, deduplicated, or correctness-breaking.

A timeout bounds the caller's wait; it does not prove that remote work stopped. Treat every timed-out side-effecting attempt as unknown until a durable result, idempotency record, or reconciliation path resolves it.

Completion criterion: no retry or replay decision remains attached to an unclassified effect or outcome.

### 3. Set budgets before controls

Define one end-to-end deadline and allocate remaining time across attempts. State how cancellation propagates and what happens when the downstream operation cannot be cancelled. Bound retries by elapsed time and attempt count. Bound queued work by capacity and age.

Read [Failure budgets and retries](references/failure-budgets-and-retries.md) when the change waits on a remote dependency or may repeat an attempt.

Completion criterion: waiting, retrying, and queueing each have an observable upper bound, or the assessment names the missing owner who must choose it.

### 4. Select the smallest safe control set

Choose controls from the actual failure mode:

| Pressure | Start with | Required safety condition |
|---|---|---|
| Slow or hung dependency | deadline + cancellation propagation | remaining budget reaches each remote wait |
| Transient failed attempt | bounded backoff with jitter | repeat is safe and retry layer is singular |
| Unknown write outcome | idempotency record or status reconciliation | same operation identity returns one effect |
| Capacity saturation | admission control, bounded buffer, concurrency cap | overload is rejected or degraded explicitly |
| Correlated dependency failure | bulkhead; circuit breaker when justified | fallback preserves correctness; probes are bounded |
| Multi-step partial failure | durable state + resume, compensate, or reconcile | every intermediate state has an owner and exit |

Read [Load, isolation, and recovery](references/load-isolation-and-recovery.md) for overload, circuit, backpressure, and partial-failure branches. Prefer the least complex set that preserves the invariant; keeping the current design is a candidate when evidence shows it already does so.

Completion criterion: every selected control names the failure it handles, its safety precondition, its cost, and why a simpler option is insufficient.

### 5. Map controls to enforcement points

Name the concrete call site, queue, transaction, worker, state record, or admission boundary that enforces each decision. Include propagation across layers: nested libraries, clients, service meshes, brokers, and workers can silently add retries or timeouts.

Route adjacent concerns without absorbing them:

| Concern from the retired `error-handling` draft | Owner |
|---|---|
| Error values, cause preservation, catch behavior, cleanup | `coding-standards` |
| Public error behavior, codes, and compatibility | `spec` |
| Unknown cascading failure or silent swallowing diagnosis | `systematic-debugging` |
| Sensitive details exposed in responses or logs | `security-review` |
| Diagnostic context, structured logs, metrics, and traces | `backend-patterns` observability guidance |
| User messaging and render recovery | `PENDING`: `processing/skills/frontend-patterns/` source draft until that Skill is promoted |
| Deadlines, retries, circuit breaking, overload, recovery | `resilience` |

Resilience consumes error signals from those owners; it does not create a universal error hierarchy or response envelope.

Completion criterion: each policy has exactly one enforcement owner, every adjacent concern has a named owner, and aggregate attempts and deadlines across layers are accounted for.

### 6. Define failure-evidence requirements

Read [Failure evidence](references/failure-evidence.md). Select scenarios that must prove the scoped invariant, including the recovery path rather than only initial rejection. Prefer deterministic fakes or controllable test dependencies; require explicit authority and blast-radius controls for production fault injection.

For pre-implementation design, pass these evidence requirements to `plan`, which owns the executable verification contract. For review of an existing implementation, pass commands or procedures, observations, expected signals, scope, assumptions, and worktree state to `verification`. This Skill may report design gaps; it does not issue `READY`, `NOT READY`, or `BLOCKED` for the implementation.

Completion criterion: every claimed control has a required failure scenario, an observable expected result, and a named downstream owner.

## Output Contract

```text
Assessment status: COMPLETE | BLOCKED | OUT OF SCOPE (resilience assessment only)
Boundary and invariant
Operation and outcome classification
Budgets and capacity bounds
Current controls
Selected controls and enforcement owners
Rejected alternatives and costs
Partial-failure and recovery path
Failure-evidence requirements
Assumptions, unresolved facts, and required owners
Verification handoff: PENDING | <existing fresh report reference>
```

A clean assessment is valid. Report it only after the failure-evidence contract covers the affected boundaries; do not manufacture controls or findings.

## Guardrails

- Repeat a side-effecting operation only when idempotency or reconciliation makes the unknown outcome safe.
- Keep one retry owner per call path; include library, proxy, mesh, broker, worker, and client attempts in the aggregate budget.
- Propagate remaining deadlines rather than resetting a full timeout at each layer.
- Bound buffers and concurrency; queueing is load storage, not load removal.
- Define fallback correctness and freshness before calling degradation successful.
- Treat circuit breakers, retries, and queues as stateful operational mechanisms with metrics and recovery behavior, not decorators.
