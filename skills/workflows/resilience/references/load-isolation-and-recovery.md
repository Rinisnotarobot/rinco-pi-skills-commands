# Load, Isolation, and Recovery

Read this reference for overload, circuit-breaker, backpressure, and partial-failure branches.

## Overload is a boundary decision

Set capacity from the constrained resource: connections, memory, CPU, external quota, worker concurrency, or downstream throughput. Enforce the limit before work consumes that resource.

Choose an explicit full-state behavior:

- reject with a retryable signal and truthful retry guidance;
- shed lower-priority work;
- degrade to a correctness-preserving response;
- queue within a bounded count and maximum age;
- block the producer only when the protocol supports demand propagation without deadlock.

Observe saturation, admitted and rejected work, in-flight concurrency, queue age, and completion latency. Queue length alone can look stable while old work violates its usefulness deadline.

## Backpressure and bulkheads

Backpressure lets slower consumers bound or signal upstream production through demand, concurrency caps, bounded buffers, or admission control. When the producer cannot slow down, shedding or durable bounded buffering must absorb the mismatch explicitly.

Bulkheads partition a scarce resource so one workload cannot exhaust all capacity. Choose the partition key from failure isolation — tenant, dependency, priority, or workload class — and reserve enough capacity for recovery and health probes. Static partitions can waste capacity; shared overflow can erase isolation.

## Circuit breaker gate

A circuit breaker is justified when repeated calls to a failing dependency consume meaningful caller or system capacity after deadlines and bounded retries are already correct.

Define:

- counted failures and exclusions;
- sample window, threshold, and minimum volume;
- open behavior and whether the fallback is correct;
- bounded half-open probes and probe ownership;
- state scope across threads, processes, and instances;
- recovery synchronization and observability.

A breaker does not repair the dependency or make an unsafe fallback correct. Avoid adding one when ordinary deadline, concurrency, or admission limits already contain the failure.

## Partial-failure state machine

For each multi-step operation, enumerate durable states and transitions rather than writing only a happy-path sequence. For every intermediate state, name:

- durable owner and authoritative record;
- safe resume point;
- duplicate or concurrent transition behavior;
- compensation when an effect can be semantically reversed;
- reconciliation when it cannot;
- operator action and audit trail for terminal exceptions.

Prefer forward recovery when compensation would lie about irreversible external effects. A compensating action is a new business action, not a distributed rollback; it can fail and needs its own idempotency and recovery.

## Queues, poison work, and replay

For asynchronous work, define delivery semantics, claim or lease behavior, acknowledgement point, maximum attempts, retention, ordering scope, and poison-message ownership.

A dead-letter queue is quarantine, not completion. Define alerting, diagnosis, repair, replay authorization, expiry, and protection against replaying an unchanged poison message. Acknowledge only after the state that makes redelivery safe is durable.

## Degraded modes

A fallback is acceptable only when its correctness, freshness, authorization, and capacity behavior are explicit. Cached or default data must tell callers what guarantees changed when that affects decisions. Disable a fallback that amplifies load, exposes stale authorization, or converts an unknown write into apparent success.
