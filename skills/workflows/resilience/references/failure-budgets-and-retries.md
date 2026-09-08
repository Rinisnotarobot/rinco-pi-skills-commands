# Failure Budgets and Retries

Read this reference when an operation waits on a remote dependency or may repeat an attempt.

## Deadline chain

Start from the caller's end-to-end budget. Reserve time for local work, each dependency, retry delay, and the response path. Pass remaining time downstream where the protocol supports deadlines; otherwise set the next timeout below the remaining budget and leave cleanup margin.

Distinguish:

- **timeout:** this caller stops waiting;
- **deadline:** the latest useful completion time shared across work;
- **cancellation:** a request to stop work, which may arrive late or be ignored;
- **abandonment:** the caller no longer observes work that may still complete.

After timeout or abandonment, a remote write can still commit. Record the outcome as unknown until the system can query, deduplicate, or reconcile it.

## Retry gate

Approve a retry only when all rows are answered:

| Question | Safe answer |
|---|---|
| Is the failure transient? | Evidence identifies a condition another attempt can outlive. |
| Is another attempt useful? | Enough deadline remains for backoff, execution, and response. |
| Is repetition safe? | The operation is read-only, naturally idempotent, or guarded by a durable idempotency mechanism. |
| Who owns retries? | One layer; every hidden or broker retry is included in the count. |
| Is overload respected? | Backoff uses jitter and trustworthy server retry guidance where available. |
| Is exhaustion visible? | Attempt count, elapsed time, final outcome, and cause are observable. |

Validation, authentication, authorization, malformed requests, invariants, and deterministic business rejection are permanent until input or state changes. Retrying them spends capacity without changing the outcome.

## Idempotency contract

An idempotency key is an operation identity, not merely a request header. Define:

- who creates the key and the scope in which it is unique;
- which request fields are bound to it and how conflicting reuse is rejected;
- where the key, status, and result are stored durably;
- how concurrent first attempts serialize;
- whether failures are cached, retriable, or reconciled;
- retention long enough to cover all client, broker, and operator replays;
- the response returned for an in-progress or completed duplicate.

The business effect and idempotency record need an atomic relationship. Use a local transaction when they share a store; otherwise use a durable state machine, outbox/inbox, or reconciliation process that closes the gap explicitly.

## Retry amplification

Multiply attempts across every layer. Three client attempts through a proxy with three attempts into a worker with three deliveries can produce 27 executions. Collapse retries toward the layer that understands idempotency and transient failure best.

Check synchronized recovery too: exponential backoff without jitter can turn an outage into waves of simultaneous retries.

## Unsafe examples

Reject:

- retrying a timed-out payment write with a new operation identity;
- resetting a 30-second timeout inside each of five attempts when the caller owns a 30-second total budget;
- stacking application, SDK, proxy, and worker retries without an aggregate limit;
- retrying every exception or every HTTP 5xx without checking operation semantics;
- acknowledging success before the durable state that makes replay safe exists.
