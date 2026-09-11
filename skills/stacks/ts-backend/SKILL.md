---
name: ts-backend
description: Node.js and TypeScript backend service conventions - project and runtime setup (tsconfig, module system, ESM/CJS interop, path aliases, build and run), application composition and dependency injection, framework shape for NestJS, Express, or Fastify, runtime validation at the transport edge, error classification and status mapping, request identity and trusted-proxy handling, transaction-scoped database clients, queues and background workers, telemetry and process health, and service testing. Use when working in a Node.js or TypeScript backend - adding or reviewing endpoints, controllers, services, providers, middleware, or workers, configuring tsconfig or the module system, wiring validation, auth, database, or job processing, choosing between NestJS, Express, and Fastify structure, or when a Node change must reconcile with the project's existing backend architecture. 中文触发：Node 后端、TypeScript 服务端、NestJS、Express、Fastify、接口开发、依赖注入
---

# TS Backend

Express backend architecture decisions in Node.js and TypeScript forms on top of `backend-patterns`, and adopt whatever this repository already does. This skill owns the runtime and framework binding: project and module configuration, application composition, dependency injection, transport shape, validation wiring, and worker wiring. It does not own layering, consistency, contract evolution, or failure policy.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- Node.js version from `engines`, `.nvmrc`, CI configuration, or the container base image, and the TypeScript version from `package.json` or the lockfile;
- module posture: `package.json` `type`, `tsconfig` `module`, `moduleResolution`, and `target`, and whether the project is ESM, CommonJS, or mixed;
- framework and shape: NestJS, Express, Fastify, something built on one of them, or no framework — and where bootstrap, route registration, and the composition root live;
- type posture: `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, and whether type checking is a separate CI gate from the build;
- how the app is built and run: `tsc`, a bundler, a dev runner, watch mode, and whether a build artifact is produced at all;
- validation and error convention: the runtime validator in use, how expected failures are represented in code, and the error body shape clients already parse;
- request identity: token verification, where authorization is enforced, and whether the process sits behind a trusted proxy;
- persistence, queue, and telemetry stack, and how each is constructed and shared;
- how tests build an application instance today: runner, request-level harness, provider or dependency overrides, and container or database fixtures.

Completion criterion: every statement about the service's structure cites a file; anything unverified is marked as an assumption.

### 2. Define the problem and the invariant

Describe the pressure without naming a library: a payload that reaches business code unvalidated because a TypeScript type is erased at runtime, an authorization check that a newly added route can skip, a transaction that a nested call escapes because it used the global client, a worker that acknowledges a job before the work is durable, a plugin that serializes a stack trace to a client, an event-loop stall that makes every request slower. State the invariant in observable terms — status code, stored state, delivery count, or latency bound that must hold.

Completion criterion: the affected entry point, ownership seam, and observable correctness condition are explicit.

### 3. Select the branch

Read only the references the active branch needs:

| Problem branch | Reference or owner |
|---|---|
| Project and module configuration: tsconfig, ESM/CommonJS interop, path aliases that must resolve at runtime, build versus run, environment and configuration loading | [references/project-and-runtime-setup.md](references/project-and-runtime-setup.md) |
| Bootstrap and composition root, dependency injection and provider scope, module and feature boundaries, the transport boundary, middleware and hook ordering, lifecycle and graceful shutdown, deadline and cancellation propagation across outbound calls | [references/app-structure-and-boundaries.md](references/app-structure-and-boundaries.md) |
| Runtime validation at the edge, error classification and status mapping, serialization boundaries, token verification, trusted-proxy and client-address handling | [references/validation-errors-and-identity.md](references/validation-errors-and-identity.md) |
| Transaction-scoped clients, outbox relay, queues and background workers, acknowledgement and lease behavior, process-local coordination limits | [references/persistence-transactions-and-jobs.md](references/persistence-transactions-and-jobs.md) |
| Logging, tracing, metrics, redaction, event-loop delay, memory and pool saturation, queue age | [references/telemetry-and-runtime-health.md](references/telemetry-and-runtime-health.md) |
| Service and worker tests: request harness, provider overrides, container and database fixtures, the boundary with end-to-end runs | [references/testing-node-services.md](references/testing-node-services.md) |
| NestJS module, provider, controller, guard, pipe, interceptor, and filter shape | [references/nest.md](references/nest.md) |
| Layering, ownership boundaries, transaction scope, distributed consistency, API and event contract evolution | Invoke `backend-patterns`; the Node shape must express its decision, not replace it |
| Timeouts, retries, cancellation, idempotency of a mutating endpoint, overload behavior, unknown mutation outcomes | Invoke `resilience` |
| Test-first slices, test seam choice, coverage policy, mocking scope | Invoke `tdd` |
| Gate execution and the final verdict | Invoke `verification` |
| Trust boundary: new endpoint, auth flow, input surface, secret handling | Invoke `security-review` |
| Naming, readability, duplication, control flow | Invoke `coding-standards` |

Completion criterion: the service shape follows the branch, not framework habit.

### 4. Adapt to this repository

Prefer the structure already present: the example layout in a reference is one valid shape, not the required one. Reuse the existing configuration object, dependency container or provider registration, error shape, validation entry point, and database and queue clients. Introducing a second way to read configuration, obtain a database client, validate input, or shape an error is a regression even when the new way is better in isolation.

Completion criterion: the change is indistinguishable in style from its neighbours, and no second convention for configuration, database access, validation, or errors was introduced.

### 5. Version-sensitive APIs: repository evidence only

Node.js, TypeScript, the framework, and the surrounding libraries differ in ways that are not remembered reliably, and the differences are frequently load-bearing.

- Read the pinned versions from `package.json` and the lockfile before depending on version-specific behavior; a decorator, option, or configuration key that exists in one major does not exist in the other.
- Search the repository for an existing provider, controller, middleware, or client of the same shape and copy it.
- The `module` and `moduleResolution` settings change which import forms compile, which packages can be imported at all, and whether an alias resolves after the build — treat a change to those four lines as a change to the runtime, not a formatting preference.
- When the exact signature, default, or runtime constraint decides correctness, mark it unverified and confirm against the installed version rather than writing from recall.
- External documentation lookup is intentionally out of scope here; when it is enabled, this section points at the global `context7-docs` skill.

Completion criterion: no version-dependent claim in the change rests on memory alone.

### 6. Define verification evidence

For each invariant, name the check that would fail if it broke: a request-level assertion on status and body, a rejected payload that type checking accepted, a rolled-back transaction after a forced failure, a duplicate-delivery test, a worker-termination test, or a measured event-loop or pool observation. Hand sequencing to `plan` and gate execution to `verification`. This skill identifies design gaps; it does not issue `READY`, `NOT READY`, or `BLOCKED`.

## Service Rules

- Validate at the transport boundary and treat the result as the only trusted input. A TypeScript annotation describes the compiler's view, not what arrived on the wire.
- Keep handlers thin: authenticate, validate, delegate, serialize. Business decisions belong to the application layer.
- Distinguish the input type from the output type. Returning the persistence or ORM entity is how stored fields leak.
- Make authorization an explicit, testable step on every authoritative route rather than an inline conditional that a new route can forget.
- Give every provider, client, and connection an owner and a scope; a module-level singleton created at import time cannot be replaced in a test and cannot be closed at shutdown.
- Pass request-scoped and transaction-scoped clients explicitly through the operation. Reaching for the global client inside a transaction callback silently leaves the transaction.
- Do not perform blocking work — synchronous file, crypto, or CPU-heavy calls — on the request path; match the library's async surface instead of wrapping a synchronous one.
- Acknowledge background work only after the result is durable, and define what happens when the process exits mid-handler.
- Declare the expected failure once, classify it in the application layer, and map it to transport semantics in a single place.
- Never serialize stack traces, dependency messages, or internal identifiers to a client; log them instead.
- Do not decide transaction scope, retry policy, or contract compatibility here: `backend-patterns` and `resilience` own those, and this skill expresses them.
- Carry the operation's deadline and cancellation through every outbound call the runtime's cancellation primitive reaches, and never introduce a second timeout owner inside an application or adapter function.

## Output Contract

Scale depth to scope: a single endpoint needs the invariant, the service shape, and its check. Use the full structure for auth, transaction, worker, module-configuration, or cross-service work.

```text
Detected stack and evidence
Problem and invariant
Project, module, and configuration decisions
Application composition and injection shape
Validation, error, and identity path
Persistence, transaction, and job seam
Runtime health and failure behavior
Verification evidence
Unverified API assumptions and open risks
```

The service change is not complete until the invariant, the composition and injection shape, the validation and authorization path, the transaction or delivery boundary, the failure behavior, and the check are stated.
