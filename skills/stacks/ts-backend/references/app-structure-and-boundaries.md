# App Structure and Boundaries

Use this reference for the Node.js and TypeScript expression of an application shape that has already been chosen.

## Ownership

Layering, dependency direction, the existence of a service or repository seam, transaction boundaries, and consistency requirements are **decided** by `backend-patterns` — `boundaries.md` for dependency direction and seams, `consistency-and-data.md` for transactional scope. This reference owns only the mechanical question: given that decision, what does the running process look like in Node.js, and where does each object come from.

| Decision | Owner |
|---|---|
| Layering, dependency direction, seam existence | `backend-patterns` |
| Transaction boundary, isolation, consistency model | `backend-patterns` |
| Application factory shape, injection scope, middleware order, lifecycle | Here |
| Runtime validation, error shape, identity | [validation-errors-and-identity.md](validation-errors-and-identity.md) |
| Retry, timeout, idempotency, overload | `resilience` |

When a statement here disagrees with the `backend-patterns` decision, that decision wins.

**Keep the transport object at the transport boundary.** Passing a framework request, response, or context object into the application layer is how a framework choice becomes the architecture; a handler should hand inward domain-shaped values, and hand back a value the edge knows how to serialize.

## Composition root

### Build the application in one place

Every process has a single place where configuration is read, clients are constructed, dependencies are wired, and the transport is assembled. One composition root per process role.

- Constructing a dependency at import time, as a module-level singleton, is the most common way a test becomes impossible to isolate and a shutdown leaves a connection open.
- Keeping construction out of the application layer means the application layer can be called with a fake, a real, and a container-backed implementation without changing it.

### One entry point per process role

An HTTP server, a background worker, a scheduler, and a CLI entry point are different processes with different lifecycles. Compose each explicitly rather than starting a listener inside a module that a worker also imports — an accidental listener in a worker process is a resource leak that appears only under load.

## Dependency injection and scope

Node has no ambient container, so scope is whatever the project's mechanism makes it. Establish which mechanism is in force before adding a provider: constructor parameters and a container, an explicit factory function, a module that exports constructed instances, or the framework's own injector (see [nest.md](nest.md)).

### Name the scope of every shared object

| Scope | Valid uses | Misuse |
|---|---|---|
| Singleton | Pooled database client, configuration, logger, telemetry, cache client | Anything carrying per-request identity |
| Request- or context-scoped | Current user, tenant, transaction handle, trace context | Caching it on a long-lived object |
| Transient | Stateless helpers and pure services | Anything holding a connection |

State that belongs to a request must not be stored on a singleton. A module-level `currentUser` is a cross-request data leak that is invisible in single-request tests.

### Inject clients; do not import them

A service that imports a configured database client directly cannot be given a transaction-scoped client, cannot be tested against a substitute, and hides its dependencies. Accept the client as a parameter or provider and let the composition root decide which one.

### Circular dependencies are a boundary symptom

A cycle between two modules means the boundary between them is wrong or a shared piece belongs to one of them. Resolve it by moving the shared concept, not by adding lazy indirection that hides the cycle.

## Module and feature boundaries

### What a feature module owns

Its transport surface, its application operations, its access to the data it owns, and its own input and output shapes. What it must not own is another feature's tables, another feature's errors, or another feature's configuration.

### Depend on the public surface

Import from another feature's entry point, not from its internal file path. Reaching into `other-feature/internal/…` makes every internal move a breaking change and is the mechanism by which dependency direction decays.

### Keep the dependency direction one-way

Transport depends on application; application depends on domain and ports; adapters implement ports. When an application service imports a transport type to build a response, the direction has inverted and the application layer is no longer callable from a worker or a test.

## Transport boundary

Frameworks differ in vocabulary, not in the rule:

| Concept | Common Node forms |
|---|---|
| Transport boundary | Nest controller and guard; Express or Fastify route handler and middleware; queue consumer callback |
| Application operation | Function, command handler, or service method |
| Persistence port | A narrow interface owned by the caller; a direct query for a simple local case |
| Adapter | Database client wrapper, HTTP client, broker producer or consumer |
| Runtime validation | The project's validator, applied at the edge ([validation-errors-and-identity.md](validation-errors-and-identity.md)) |

A class is optional; dependency direction and owned behavior are not. A framework-idiomatic class that reaches for globals has the same problem as a function that does.

## Middleware, hook, and pipeline order

**Order is semantics.** The same set of middleware registered in a different order produces different behavior for authentication, validation, and logging.

- Parse the body before validating it; validate before the handler; resolve identity before checking authorization; register the error handler so it wraps everything that can throw.
- Establish request context — correlation identifier, tenant, start time — before anything that logs.
- In NestJS the request lifecycle is middleware, then guards, then interceptors, then pipes, then the handler, then interceptors again, then filters; read the framework's ordering rather than assuming Express middleware semantics apply (see [nest.md](nest.md)).
- In Express and Fastify, registration order is the pipeline, and a route registered before a parser sees an unparsed body.
- Keep the ordering decision in the composition root, visible in one place, rather than distributed across feature modules that each register their own.

## Lifecycle and shutdown

### Own every long-lived resource

Database pools, cache clients, message consumers, telemetry exporters, and timers all have an owner in the composition root. An object that opens a connection without a closing path keeps the process alive and loses in-flight work.

### Shut down deliberately

Graceful shutdown is a sequence: stop accepting new work, stop claiming new jobs, let in-flight work finish within a bounded period, close clients and flush telemetry, then exit. A process that exits on the first signal loses acknowledged-but-unfinished work and is the usual cause of duplicate processing under deploys.

- Handle signals once, in the entry point, not in each module.
- Define the drain deadline; on expiry, exit rather than hanging.
- Distinguish readiness from liveness: a process that is draining is not ready for new traffic but is not dead.

### A failed startup must be loud

If a mandatory dependency is unreachable at startup, fail with a clear message instead of serving requests that will all fail. Validate configuration ([project-and-runtime-setup.md](project-and-runtime-setup.md)) and connectivity as part of starting, and decide explicitly whether the process should retry or exit.

## Outbound calls

### Carry the deadline through the call chain

The budget — attempts, per-attempt timeout, total deadline, retry classification — is decided by `resilience`. This section owns only how it travels in Node.js: pass the remaining deadline and the cancellation signal down through every call the operation makes, using the runtime's cancellation primitive where the called API accepts one, and hand the same signal to the database client, the HTTP client, and the message producer rather than letting each impose its own timeout.

- Do not open a second timeout owner inside an application or adapter function; a local timeout that fires before the outer budget is a second policy, not a safety net.
- Where a client cannot accept a cancellation signal, bound the call another way and record that the bound is not cooperative.
- Expose the attempt count, elapsed time, and final outcome through the existing telemetry rather than inventing a second metric ([telemetry-and-runtime-health.md](telemetry-and-runtime-health.md)).

## Verification

- Start each process role and confirm the expected resources are opened and no unintended listener or consumer exists in it.
- Send a signal during in-flight work and confirm it completes or is safely retried, and that no client is left open.
- Confirm a request-scoped value cannot leak: run two concurrent requests with different identities against a shared singleton and assert neither observes the other's.
- Confirm every middleware and hook registration appears in one place and that the ordering assertion matches the documented lifecycle.
- Confirm the application layer can be invoked with a substituted dependency and without a transport object.
- Confirm a startup failure path produces a clear error and a non-zero exit rather than a running process serving errors.
