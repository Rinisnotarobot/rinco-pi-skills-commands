# Node.js and TypeScript Implementation Map

Read this only after selecting a pattern from the language-neutral references. Inspect the project before choosing libraries; use its framework, validation, database, queue, telemetry, and test conventions.

## Boundary mapping

| Concept | Typical Node.js/TypeScript forms |
|---|---|
| Transport boundary | Express/Fastify middleware and handler; Nest controller/guard; Next route handler; queue consumer |
| Application use case | Function, module, command handler, or service class |
| Persistence port | Narrow function/object interface owned by the caller; direct query for simple local cases |
| Adapter | Database client wrapper, HTTP client, broker producer/consumer |
| Runtime validation | Existing schema validator or explicit parser; infer TypeScript types from the runtime schema where supported |

Keep framework request/response objects at the transport boundary. Pass domain-shaped values inward. A class is optional; dependency direction and owned behavior matter.

## Error mapping

Represent expected failures as typed outcomes or classified errors according to project convention. Map them to transport semantics once at the boundary. Treat caught values as `unknown`, preserve causes, and avoid exposing stack traces or dependency messages.

For HTTP, distinguish malformed input, failed authentication, denied authorization, missing resources, conflicts, rate limits, and unexpected faults. Do not assume one status code model applies to queues or scheduled jobs.

## Resilience mapping

Invoke the `resilience` skill before implementing retries, idempotency, deadlines, cancellation, or concurrency controls. Map its selected policy to the project's existing Node.js primitives without changing budgets or adding another retry owner:

- carry remaining deadlines and cancellation through `AbortSignal` where the called API supports it;
- expose aggregate attempt count, elapsed time, and final outcome through the existing telemetry stack;
- prefer an established project dependency when it can enforce the selected policy;
- use database uniqueness or version constraints when the selected invariant is database-owned;
- use process-local promises or mutexes only for explicitly process-local coordination.

The resilience policy, not this language map, decides retry classification, attempt limits, idempotency states, concurrent duplicate behavior, retention, and recovery.

## Transactions and outbox

Use the database client's callback or explicit transaction API and pass the transaction-scoped client through the operation. Do not accidentally call a global client inside the transaction callback.

An outbox relay should claim bounded batches, publish with a stable event ID, record progress, and tolerate duplicate publication. Consumers remain duplicate-safe. Observe oldest-unpublished age.

## HTTP identity and client address

Validate tokens/credentials at runtime, including required claims; a TypeScript cast does not validate decoded data. Load secrets through the project's configuration boundary and fail startup clearly when mandatory configuration is absent.

Derive client IP only through the framework's trusted-proxy configuration. Reading `x-forwarded-for` directly trusts caller-controlled input when the proxy chain is not constrained.

## Queues and background work

BullMQ, broker clients, cloud queues, and framework job modules differ in lease and acknowledgement behavior. Verify:

- when acknowledgement occurs;
- what happens when the process exits mid-handler;
- how retries and dead letters are configured;
- whether ordering is global, per queue, or per partition/key;
- whether job payloads are durable, versioned, and free of secrets.

An in-memory queue is suitable only for explicitly best-effort, process-local work.

## Telemetry

Use the project's logger and OpenTelemetry/instrumentation stack when present. Propagate trace/context through promises and message metadata. Use stable event names; keep unbounded identifiers out of metric labels.

Node process health should include event-loop delay, memory pressure, connection-pool saturation, queue age, and dependency latency where relevant—not only CPU and request count.

## Verification

Use the project's runner and integration infrastructure. Add focused tests for:

- rejected runtime input despite compile-time types;
- concurrent writes and uniqueness/version conflicts;
- the cancellation, deadline, retry, and idempotency scenarios required by the consumed `resilience` assessment;
- duplicate message delivery and worker termination;
- trusted-proxy assumptions;
- sensitive-data redaction.

Type checking proves static relationships; it does not prove runtime validation, transactional atomicity, delivery semantics, or distributed coordination.
