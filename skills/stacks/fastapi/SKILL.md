---
name: fastapi
description: FastAPI application conventions - app factory and lifespan, pydantic-settings configuration, Pydantic v2 request and response schemas, dependency injection, router design, service and persistence seams, and httpx-based app testing. Use when working in a FastAPI service - adding or reviewing endpoints, schemas, dependencies, auth wiring, or settings, when a request-layer change needs the app's structure, or when FastAPI behavior must be reconciled with the project's existing layout. 中文触发：FastAPI、接口开发、路由、依赖注入、Pydantic
---

# FastAPI

Apply conventions that hold in FastAPI applications on top of `python-project`, and adopt whatever this repository already does. This skill owns the web-layer binding: transport, schema, dependency, and route shape. It does not own service boundaries, consistency, or failure policy.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- FastAPI, Starlette, and Pydantic versions from `pyproject.toml` or the lockfile, and whether the codebase is Pydantic v2 or still v1;
- the existing layout: app factory or module-level app, `routers/` or feature packages, where settings, dependencies, and models live;
- the async model: async or sync handlers, the DB driver, and whether sync calls already appear inside async paths;
- the dependency graph already in use (`Depends` providers, settings access, auth dependencies, `yield` dependencies with cleanup);
- error convention: exception handlers, response models, status codes, and the error body shape clients already parse;
- the auth model: authentication mechanism, authorization enforcement point, and the current-user dependency;
- how tests build an app instance today (transport, fixtures, dependency overrides).

Completion criterion: every statement about the app's structure cites a file; anything unverified is marked as an assumption.

### 2. Define the problem and the invariant

Describe the pressure without naming a library: a boundary value that can arrive unvalidated, an authorization check that can be skipped on a new route, a request-scoped resource leaking across requests, a blocking call inside an async path, a response that exposes a stored field it should not. State the invariant in observable terms — status code, body shape, or side effect that must hold.

Completion criterion: the affected route, ownership seam, and observable correctness condition are explicit.

### 3. Select the branch

Read only the references the active branch needs:

| Problem branch | Reference or owner |
|---|---|
| Layout, app factory, lifespan and startup ordering, settings and environment configuration | [references/app-and-configuration.md](references/app-and-configuration.md) |
| Request and response schemas, validation and serialization boundaries, dependency injection, auth wiring, router and endpoint design, status codes and error shape | [references/schemas-dependencies-and-routes.md](references/schemas-dependencies-and-routes.md) |
| Service methods, transaction ownership, session lifecycle, repository seams, persistence access from routes | [references/service-layer-and-persistence.md](references/service-layer-and-persistence.md) |
| App-level testing: transport, fixtures, dependency overrides, lifespan in tests | [references/testing-fastapi-apps.md](references/testing-fastapi-apps.md); consume `python-project` for pytest fundamentals, fixtures, and async test mechanics |
| pytest structure, fixture scopes, parametrization, markers, plugin configuration | Invoke `python-project` and read [references/testing-with-pytest.md](../python-project/references/testing-with-pytest.md) |
| Layering, ownership boundaries, transaction scope, distributed consistency, API and event contract evolution | Invoke `backend-patterns`; the FastAPI shape must express its decision, not replace it |
| Timeouts, retries, cancellation, idempotency of a mutating endpoint, overload behavior, unknown mutation outcomes | Invoke `resilience` |
| Test-first slices, test seam choice, coverage policy, mocking scope | Invoke `tdd` |
| Gate execution and the final verdict | Invoke `verification` |
| Trust boundary: new endpoint, auth flow, input surface, secret handling | Invoke `security-review` |
| Naming, readability, duplication, control flow | Invoke `coding-standards` |

Completion criterion: the route shape follows the branch, not framework habit.

### 4. Adapt to this repository

Prefer the app's existing structure over the reference's example tree: the example is one valid shape, not the required one. Reuse the existing settings object, session dependency, current-user dependency, error shape, and response-model convention. If the change would introduce a second way to access settings, open a session, or shape an error, stop and reconcile with the existing one instead.

Completion criterion: the endpoint is indistinguishable in style from its neighbours, and no second convention for session, settings, or errors was introduced.

### 5. Version-sensitive APIs: repository evidence only

FastAPI and Pydantic behavior differs across versions and is not remembered reliably.

- Read the pin before depending on version-specific behavior; Pydantic v1 and v2 code are not interchangeable.
- Search the repository for an existing endpoint or schema of the same shape and copy it.
- When the exact signature or default decides correctness, mark it unverified and confirm against the installed version rather than writing from recall.
- External documentation lookup is intentionally out of scope here; when it is enabled, this section points at the global `context7-docs` skill.

Completion criterion: no version-dependent claim in the change rests on memory alone.

### 6. Define verification evidence

For each invariant, name the request-level check that would fail if it broke: status code, validated payload, authorization denial, session cleanup after an exception, or a serialization boundary that must not leak a field. Hand sequencing to `plan` and gate execution to `verification`. This skill identifies design gaps; it does not issue `READY`, `NOT READY`, or `BLOCKED`.

## Route Rules

- Keep route handlers thin: parse, authorize, delegate, and serialize. Business decisions belong to the service layer.
- Validate at the boundary with a schema; never trust a raw `dict` or a query parameter shape.
- Distinguish the request schema from the response schema. Returning the ORM object is how stored fields leak.
- Make the authorization check an explicit dependency on every authoritative route rather than an inline conditional.
- Keep request-scoped resources inside `yield` dependencies so cleanup survives exceptions.
- Do not run blocking I/O inside an async handler; match the driver's async or sync model instead of mixing.
- Declare the expected failure as a response model or an exception handler once, and reuse the project's error shape.
- Do not decide transaction scope in the route: `backend-patterns` owns it, the service layer expresses it.
- Do not author retry, timeout, or overload behavior in an endpoint: consume `resilience`.

## Output Contract

Scale depth to scope: a single endpoint needs the invariant, the route shape, and its check. Use the full structure for auth, session, schema-boundary, or cross-service work.

```text
Detected stack and evidence
Problem and invariant
Route, schema, and dependency shape
Service and transaction seam
Failure behavior and error shape
Verification evidence
Unverified API assumptions and open risks
```

The endpoint is not complete until the invariant, the authorization path, the serialization boundary, the failure behavior, and the check are stated.
