# Messaging Patterns

Use this reference when work crosses an asynchronous transport or must survive the requester process.

For deadlines, retries, idempotency, backpressure, capacity isolation, partial failure, and recovery policy, follow the resilience method — the `resilience` skill, when loaded, is its full form. This reference covers messaging shape and delivery semantics only.

## Durable queue

**Context:** work must survive process restart or be retried independently of the request.

**Shape:** persist work before acknowledging acceptance; workers claim, process, acknowledge, and redeliver according to a declared policy.

Define delivery semantics, visibility or lease behavior, retention, ordering scope, and ownership of poison work. Resilience owns the attempt budget and recovery policy applied to those mechanics.

## Competing consumers

Several workers consume from the same queue to increase throughput. Handlers must tolerate duplicate delivery and concurrent processing. Ordering, when needed, normally requires partitioning by an ordering key and processing each partition serially.

## Dead-letter queue

Move repeatedly failing messages to an inspectable quarantine after the resilience policy exhausts its bounded attempts. A DLQ is not completion: define alerting, diagnosis, replay authority, expiry, and protection against replaying an unchanged poison message.

## Publish/subscribe

Use when multiple independent consumers react to the same event. Events describe a completed fact owned by the publisher; consumers own their reactions. Version schemas compatibly and avoid requiring all consumers to deploy in lockstep.

## Request/reply over messaging

Use only when asynchronous transport benefits outweigh correlation, timeout, orphan-response, and operational complexity. Persist correlation state when losing the requester process must not lose the workflow.

## Delivery reasoning

- **At-most-once:** loss is possible; duplicates are avoided.
- **At-least-once:** duplicates are possible; loss is avoided within the broker's durability guarantees.
- **Exactly-once effect:** an end-to-end business property built from idempotency, atomic state transitions, and system-specific guarantees—not a broker label alone.

Acknowledge only after the state that makes redelivery safe is durable.

## Verification

Test the transport guarantees the architecture relies on:

- duplicate, delayed, reordered, and malformed messages;
- worker death before and after acknowledgement;
- broker unavailability and redelivery after lease expiry;
- partition-key ordering and concurrent consumers;
- schema compatibility across independently deployed publishers and consumers.

Combine these transport checks with the failure scenarios supplied by `resilience`; do not infer retry safety or recovery from broker delivery labels alone.
