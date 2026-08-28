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

## Retry shape

A reusable retry helper needs:

```typescript
interface RetryPolicy {
  maxAttempts: number
  baseDelayMs: number
  maxDelayMs: number
  shouldRetry(error: unknown): boolean
  remainingTimeMs(): number
}
```

The loop should:

1. count total attempts unambiguously;
2. classify the error before retrying;
3. stop when the remaining deadline cannot accommodate another attempt;
4. use capped exponential backoff with jitter;
5. propagate cancellation through `AbortSignal` where the called API supports it;
6. expose attempt count and final outcome to telemetry.

Prefer a proven project dependency when one already exists. Avoid nested retries in framework, client, and application layers.

## Idempotency and concurrency

Use database uniqueness/version constraints as the final guard when the invariant lives in the database. A process-local `Map`, promise registry, or mutex coordinates only one process.

For an idempotency record, model states such as `in_progress`, `succeeded`, and recoverable failure only when the workflow requires them. Atomically bind the key to a request fingerprint and result/effect. Define concurrent-request behavior and retention.

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
- cancellation and deadline exhaustion;
- retry classification and maximum total attempts;
- duplicate message delivery and worker termination;
- trusted-proxy assumptions;
- sensitive-data redaction.

Type checking proves static relationships; it does not prove runtime validation, transactional atomicity, delivery semantics, or distributed coordination.
