# Persistence, Transactions, and Jobs

Use this reference for the Node.js and TypeScript expression of a persistence, transactional, or background-work design that has already been chosen.

## Ownership

Transaction scope, isolation level, the existence of a repository seam, delivery semantics, and the consistency model are **decided** by `backend-patterns` — `consistency-and-data.md` for atomicity and concurrency, `messaging.md` for queues and delivery guarantees. Retry, deadline, idempotency, and overload policy are decided by `resilience`. This reference owns the mechanics of expressing those decisions with Node.js clients.

| Decision | Owner |
|---|---|
| Transaction boundary, isolation, consistency model | `backend-patterns` |
| Whether a repository exists, and where | `backend-patterns` |
| Delivery semantics, ordering scope, dead-letter policy | `backend-patterns` (`messaging.md`) |
| Retry classification, attempt limits, idempotency states, deadlines | `resilience` |
| Passing the transaction-scoped client, closing clients, worker acknowledgement mechanics | Here |

When a statement here disagrees with the consumed decision, that decision wins.

**Never reach for the global client inside a transaction.** Client libraries expose either a callback that supplies a transaction handle or an explicit transaction object; either way the handle must be passed through every operation in the unit of work. A helper that imports the module-level client and runs inside the callback silently executes outside the transaction — the write looks successful, and it is not part of the unit that rolls back.

## Transaction-scoped clients

### Pass the handle, do not look it up

```ts
// The transaction handle travels with the operation.
await db.transaction(async (tx) => {
  const order = await orders.create(tx, input)
  await ledger.record(tx, order)
})
```

- Every function participating in the unit of work accepts the handle as its first parameter or an explicit dependency. A repository method that resolves its own client cannot be composed into a transaction.
- Keep one transaction owner per operation. A nested library call that opens its own transaction produces either an independent commit or a deadlock, depending on the client.
- The isolation level, if it matters, is stated where the transaction is opened, once, and the code that depends on it is documented as such.
- Where `resilience` requires retrying a transaction, the retry wraps the whole unit of work, not an individual statement inside it.

### Know where the commit point is

If the commit happens in a wrapper — middleware, an interceptor, a unit-of-work helper — then a failure during response serialization or a later step occurs after the data is committed. That may be an acceptable choice; what is not acceptable is not knowing it. Where the gap matters, commit inside the operation that owns the invariant.

### Convert before the boundary closes

Return declared output shapes, not rows bound to a closed connection or an expired context ([validation-errors-and-identity.md](validation-errors-and-identity.md)). An entity handed to a background task after the request ends is a live record whose connection no longer belongs to it.

## Transactional messaging and the outbox

When a state change and an event must not disagree, the record of the intent to publish belongs in the same transaction as the state change, and publication happens afterwards.

- Write the outbox row inside the transaction; an event published before commit can announce a change that rolls back.
- The relay claims bounded batches, publishes with a stable event identifier, and records progress — so a crash mid-batch republishes rather than loses.
- Consumers remain duplicate-safe, because publication is at-least-once regardless of what the relay does.
- Observe the age of the oldest unpublished record; a growing backlog is the first signal of a stalled relay.

## Queues and background work

### Verify the guarantee, do not assume it

Queue clients differ in when a job is acknowledged, what happens when a worker exits mid-handler, and how ordering is scoped. Establish each of the following from the project's client and configuration before relying on it:

- when acknowledgement occurs, and whether it is explicit or automatic on handler return;
- what happens if the process exits or is killed after the work but before the acknowledgement;
- how retries, backoff, and dead-lettering are configured, and who owns them — the client or `resilience` policy;
- whether ordering is global, per queue, or per partition key, and whether the project's key choice matches the invariant;
- whether payloads are durable, versioned, and free of secrets, since a queue is a stored record with its own retention.

**Acknowledge only after the result is durable.** Acknowledging before the write completes converts a crash into silent data loss; acknowledging after it makes a crash produce a duplicate, which is recoverable if consumers are duplicate-safe.

### Process-local coordination is process-local

An in-memory queue, a promise-based mutex, or a module-level `Set` of in-flight identifiers coordinates one process only. They are valid for explicitly best-effort, process-local work and invalid as a distributed lock, a global rate limit, or a uniqueness guarantee across replicas. Use the database's uniqueness or version constraint when the invariant is database-owned ([backend-patterns `consistency-and-data.md`]).

### Design the worker's failure path

- Bound the handler's execution; a handler with no deadline holds a lease until the broker times it out, which looks like a stalled queue rather than a hung job.
- Make the job's side effects idempotent or reconcilable, since redelivery is normal.
- Decide what happens to a job that fails permanently: dead-letter with enough context to replay, or record the failure against the entity. A silently dropped job is an incident with no evidence.
- Keep worker concurrency a configured quantity, not an accident of how many handlers were registered.

## Connections and pooling

- One pool per process, owned by the composition root ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)); a pool created per request exhausts the database, and a pool created per module multiplies it.
- Size the pool against the database's connection limit and the number of replicas, not against the request rate; the replica count is part of the arithmetic.
- Release or return connections on every path, including exceptions inside a transaction.
- Surface saturation as a health signal rather than as latency ([telemetry-and-runtime-health.md](telemetry-and-runtime-health.md)).

## Verification

- Force a failure after the first write of a multi-write operation and confirm no partial state is observable and the unit rolls back.
- Instrument the statement count during a transaction and confirm every statement ran on the transaction handle, not the global client.
- Run the same mutating operation twice against a uniqueness invariant and confirm one row and one classified conflict.
- Deliver the same message twice, and out of order where ordering is claimed, and confirm the consumer's result matches the declared guarantee.
- Kill a worker mid-handler and confirm the job is retried or dead-lettered rather than lost.
- Assert the age of the oldest unpublished outbox record after a forced relay failure.
- Confirm a process-local lock is not load-bearing: run two replicas and confirm the invariant still holds.
- Confirm connections return to the pool after an exception path.
