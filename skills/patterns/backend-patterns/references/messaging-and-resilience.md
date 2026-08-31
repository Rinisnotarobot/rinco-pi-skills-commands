# Messaging and Resilience Patterns

Use this reference when dependencies fail, work crosses process boundaries, delivery is asynchronous, or load exceeds capacity.

## Deadlines and failure containment

### Timeout / Deadline

Every remote wait needs an upper bound derived from the caller's end-to-end budget. Propagate remaining deadlines where the protocol supports it. A timeout stops waiting; it does not prove the remote operation stopped or failed.

### Retry with Backoff and Jitter

**Context:** failures are transient and another attempt has a meaningful chance of success.

**Preconditions:** the operation is idempotent or guarded by an idempotency mechanism.

Retry only classified transient failures. Bound attempts by both the caller deadline and a retry budget. Use exponential backoff with jitter. Honor server retry guidance when trustworthy.

**Failure modes:** retrying validation/auth failures, multiplying load during an outage, nested retries across layers, or retrying a timed-out write whose outcome is unknown.

### Circuit Breaker

**Context:** repeated calls to an unhealthy dependency waste capacity and delay callers.

**Shape:** after a failure threshold, fail fast; later allow limited probes to detect recovery.

**Costs:** state tuning, false openings, recovery synchronization, and different behavior across instances. Pair with fallback only when the fallback preserves correctness.

### Bulkhead

Partition concurrency, connections, queues, or worker pools so one workload cannot exhaust all capacity. Define what happens when a partition fills: reject, shed, degrade, or queue within a strict bound.

### Load Shedding

Reject low-priority or excess work before saturation causes unbounded latency. Use explicit admission criteria and observable rejection signals. Unbounded queues postpone and amplify overload.

## Messaging patterns

### Durable Queue

**Context:** work must survive process restart or be retried independently of the request.

**Shape:** persist work before acknowledging acceptance; workers claim, process, acknowledge, and retry according to policy.

Define delivery semantics, visibility/lease behavior, maximum attempts, retention, and ownership of poison jobs.

### Competing Consumers

Several workers consume from the same queue to increase throughput. Handlers must tolerate duplicate delivery and concurrent processing. Ordering, when needed, normally requires partitioning by an ordering key and processing each partition serially.

### Dead Letter Queue

Move repeatedly failing messages to an inspectable quarantine after a bounded policy. A DLQ is not completion: define alerting, diagnosis, replay, expiry, and protection against replaying an unchanged poison message.

### Publish/Subscribe

Use when multiple independent consumers react to the same event. Events describe a completed fact owned by the publisher; consumers own their reactions. Version schemas compatibly and avoid requiring all consumers to deploy in lockstep.

### Request/Reply over Messaging

Use only when asynchronous transport benefits outweigh correlation, timeout, orphan-response, and operational complexity. Persist correlation state when losing the requester process must not lose the workflow.

### Backpressure

A slower consumer must be able to bound or signal upstream production. Apply bounded buffers, demand signals, concurrency caps, or admission control. Track queue age, not only queue length.

## Delivery reasoning

- **At-most-once:** loss is possible; duplicates are avoided.
- **At-least-once:** duplicates are possible; loss is avoided within the broker's durability guarantees.
- **Exactly-once effect:** an end-to-end business property built from idempotency, atomic state transitions, and system-specific guarantees—not a broker label alone.

Acknowledgement should occur only after the state that makes redelivery safe is durable.

## Verification

Test:

- dependency hangs, resets, slow responses, and partial responses;
- duplicate, delayed, reordered, and malformed messages;
- worker death before and after side effects;
- broker unavailability and redelivery after lease expiry;
- queue saturation and downstream recovery;
- retry amplification under concurrent failure.

Observe deadline exhaustion, retry volume, circuit state, rejection rate, queue age, attempt count, and DLQ growth.
