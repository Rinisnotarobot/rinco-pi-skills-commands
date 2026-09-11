# Telemetry and Runtime Health

Use this reference for the Node.js and TypeScript expression of the observability and process-health requirements a service has already been given.

## Ownership

What must be audited, which signals are required, and the retention and privacy obligations are **decided** by `backend-patterns` — `security-and-observability.md` — and by the project's operational requirements. This reference owns the Node.js mechanics: how records are emitted, how context propagates, and which process signals are worth watching.

| Decision | Owner |
|---|---|
| Required audit records, sensitive-data policy, retention | `backend-patterns`, `security-review` for changed trust boundaries |
| Required failure signals and observable requirements | `resilience` |
| Logger, tracing, and metrics wiring; context propagation; process health signals | Here |

When a statement here disagrees with the consumed decision, that decision wins.

## Structured logging

### Log events, not sentences

A log record is data: a stable event name, the fields that make it useful, and a correlation identifier. Prose messages cannot be aggregated, filtered, or alerted on, and they change wording whenever someone edits them.

```ts
logger.info({ event: 'order.created', orderId, tenantId, correlationId }, 'order created')
```

- Keep the event name stable; treat it as an identifier that dashboards depend on.
- Keep identifiers out of the message text and in fields, where they can be queried.
- Log once per failure, at the layer that has the context to classify it ([validation-errors-and-identity.md](validation-errors-and-identity.md)). Logging the same error at every layer produces a multiplier on every incident.

### One logger, injected

A logger imported directly from a module cannot be replaced in a test and cannot be given request context. Inject it, or use the project's established accessor, and let the composition root configure transports and levels.

### Propagate context explicitly

Correlation across an HTTP request, a queue consumer, and a scheduled job requires the identifier to travel with the work: through a request context, through function parameters, or through message metadata. A queue payload that does not carry the originating correlation identifier breaks the chain exactly where debugging is hardest.

- Prefer the project's existing mechanism — an async-context store, a framework request-scoped provider, or explicit parameters — over introducing a second one.
- Be aware that an async-context store only covers work started inside it; work handed to a callback invoked later, or to a worker in another process, needs the context passed explicitly.
- When the context is empty, emit a record that says so rather than a plausible-looking default identifier.

### Levels carry meaning

Establish what each level means in this project and use them consistently: an expected validation rejection is not an error, and a handled business conflict is not a warning that pages someone. Confirm which levels are shipped in production before relying on one for diagnosis.

### Redaction belongs in the logger

Credentials, authorization headers, cookies, tokens, session identifiers, and password fields are removed by the logging and tracing configuration, not by remembering to omit them at each call site. A serialization helper that dumps the whole object is the most common leak path.

## Tracing and metrics

### Propagate trace context through the stack

The project's instrumentation, when present, must see the context across HTTP boundaries, database calls, and message publication. Confirm that a trace initiated by an incoming request continues into asynchronous work rather than starting a new root span.

- Keep span and metric names stable and low-cardinality in their dimensions.
- Keep unbounded values — user identifiers, request identifiers, raw URLs with parameters, error messages — out of metric labels; they belong in logs and traces, where cardinality is expected.
- Record the outcome, not only the attempt: an operation counted only on entry cannot distinguish success from failure.

### Count the things that decide incidents

Rate, errors, and duration per operation are the baseline. For a service with dependencies and workers, add the signals that explain a stall rather than merely showing it: dependency latency, retry counts by classification, queue age, and pool saturation.

## Process health

### Node-specific signals

A Node.js process saturates in ways that CPU and request count do not show, because the runtime executes application code on one thread.

| Signal | What it reveals |
|---|---|
| Event-loop delay | Synchronous or CPU-heavy work blocking every request |
| Heap and external memory growth | Retention, unbounded caches, growing buffers |
| Connection-pool saturation and wait time | Requests queued behind a pool too small, or connections not returned |
| Queue age of the oldest item | A stalled or under-provisioned consumer |
| Handles and timers | Leaked intervals, sockets, or listeners keeping the process alive |
| Unhandled rejections and uncaught exceptions | Failures that would otherwise be silent |

- Prefer sampling over per-request measurement for delay and memory; the measurement must not be the load.
- Emit these as the same kind of signal as the transport metrics, so an operator can see a stall and its cause in one place.
- A blocked event loop is a design finding, not a tuning note: find the synchronous call ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)) rather than raising a timeout.

### Unhandled failures

An unhandled rejection or an uncaught exception leaves the process in an unknown state. Decide, once, what the process does — record and exit, or record and continue — and confirm the decision is implemented rather than defaulted by the runtime.

### Health endpoints

Expose readiness and liveness as different questions: liveness answers "is this process functioning", readiness answers "should traffic be sent here". A process that is starting, draining, or missing a dependency is not ready even though it is alive ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)).

## Background work

A worker's telemetry is not the same as a server's: a worker's health is queue age, processing duration, retry and dead-letter counts, and acknowledgement latency, not request rate. Confirm that a job failure is observable without reading the broker's own console, and that a dead-lettered job is recorded where a human will find it.

## Verification

- Confirm a full request produces a coherent record set: one correlation identifier across transport, application, persistence, and any published message.
- Confirm a log line for an authentication failure does not contain the credential, token, or cookie value.
- Confirm a metric label does not carry an unbounded identifier, and check the resulting series count after a load run.
- Inject a synchronous block into the request path and confirm the event-loop delay signal reports it.
- Confirm a saturated pool appears as a health signal and not only as elevated latency.
- Confirm a killed worker's job is visible as a retry or dead-letter count rather than only as a missing outcome.
- Confirm readiness reports not-ready while draining, and liveness does not.
- Confirm a trace started at the transport boundary continues into asynchronous and queued work.
