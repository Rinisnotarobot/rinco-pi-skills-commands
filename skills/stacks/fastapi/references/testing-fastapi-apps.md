# Testing FastAPI Apps

Use this reference for the FastAPI-specific half of app testing: transport choice, lifespan, dependency overrides, fixture levels, and database isolation.

**Not here:** pytest fundamentals, fixture design and scope semantics, async test mechanics, markers, and parametrization belong to `python-project` (its `references/testing-with-pytest.md`). Coverage policy belongs to `tdd`: preserve the project's configured threshold and choose tests by uncovered risk rather than inventing a number. Mocking scope and test-seam choice are also `tdd`'s decision; this file only says what the seam looks like in a FastAPI app.

## Transport

| | `AsyncClient(transport=ASGITransport(app=app))` | `TestClient` |
|---|---|---|
| Test function | `async def`, run by the async plugin | plain `def` |
| Lifespan | Not run by the transport; trigger it yourself | Runs startup/shutdown when used as a context manager |
| Style | Matches the app's async nature; one client used from async fixtures | Convenient when the suite is otherwise synchronous |
| Reach for it | Async app, async DB driver, multiple in-flight requests | Quick sync checks, or a codebase with no async test setup |

Both drive the real ASGI app in-process: routing, validation, dependency resolution, and serialization all execute. Choose one per repository; two transports in one suite means two behaviours to keep in sync.

```python
async with AsyncClient(
    transport=ASGITransport(app=app), base_url="http://test"
) as client:
    response = await client.get("/items/1")
```

Always set `base_url`; relative URLs are error-prone without it.

## Lifespan in tests

### A transport that skips lifespan leaves startup resources missing

If startup creates a pool, loads a cache, or starts a consumer, a client that never ran lifespan will fail on any route touching that resource, or silently take a code path the real app does not.

```python
async with app.router.lifespan_context(app):
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client
```

The attribute that exposes the app's lifespan context is version-sensitive: confirm it against the installed version, or use a Starlette/ASGI lifespan manager if the project already depends on one. `TestClient(app)` as a context manager handles this for you.

### Decide once whether the app instance is per session or per test

State created at startup outlives the tests that share one app. That is the point of preferring it to a fresh app per test. Startup cost, in-process global state, and open connections are the trade; a test that mutates a startup-built resource needs a fresh instance or an explicit reset.

## Overrides

### Override providers, not modules

```python
app.dependency_overrides[get_settings] = lambda: test_settings
app.dependency_overrides[get_current_user] = lambda: fake_user
try:
    ...
finally:
    app.dependency_overrides.clear()
```

This is the FastAPI-native seam: the route body is untouched, and the replacement is visible in one place per test.

### Overrides leak across tests

`dependency_overrides` is a dictionary on the app instance. A test that forgets to remove its override changes the behaviour of every later test sharing that app — the classic cause of an order-dependent pass. Clear overrides in teardown, and prefer a fixture whose `finally` runs even when the test fails.

### Override what you cannot control

Use overrides for configuration, the current user, the clock, and external clients — not for the service under test. Replacing the service a route calls turns an integration test into a test of the mock.

## conftest fixture levels

Two levels, in one place:

| Level | Owns | Examples |
|---|---|---|
| Session | Expensive, shared, read-mostly setup | engine, schema or migrations, settings overrides, cleanup policy |
| Function | Per-test isolation and identity | app instance, client, created rows, authentication headers |

Build the app in a fixture rather than importing a module-level `app` when tests need different overrides per test; that is the primary payoff of the app factory.

```python
@pytest.fixture(scope="session")
def app() -> FastAPI:
    return create_app()

@pytest_asyncio.fixture
async def client(app):
    async with AsyncClient(
        transport=ASGITransport(app=app), base_url="http://test"
    ) as c:
        yield c
```

The engine, schema, and settings overrides sit at session level; the client, created rows, and authentication headers at function level. Keep the client function-scoped unless the suite proves that shared client state is safe.

## Database isolation

| Strategy | What it proves | Cost |
|---|---|---|
| Outer transaction plus savepoint, rolled back at test end | Route behaviour against a real engine, fast | The app must join the outer transaction; direct commits can release the savepoint; commit-boundary bugs stay hidden |
| Separate test database, reset between runs | Real commit, rollback, and unique-constraint behaviour | Provisioning and migration time; cross-test leakage unless reset is reliable |
| In-memory database | Fastest startup, no external service | Dialect differences from production: constraint, type, and function behaviour can diverge; an unpinned connection may not share the same database |

Pick the cheapest strategy that still proves the invariant under test. A test asserting a uniqueness violation or a rollback outcome needs real commit semantics; a test asserting a status code and body shape usually does not. Whatever is chosen, the production dialect is what a constraint-related failure must be interpreted against.

## Do not mock the route layer

Calling the endpoint function directly, or swapping the router for a stub, bypasses exactly the mechanisms a FastAPI test exists to check: request parsing, schema validation, dependency resolution, authorization, and the serialization boundary. Drive the ASGI app.

Replace dependencies at volatile system boundaries — external HTTP, mail, payment, clock — and leave the route, the schemas, and the service in the path.

**Failure mode:** a suite full of passing handler-level unit tests and no request made through the transport. The untested part is the wiring: a route whose dependency was never attached, a response model that still carries a field, a status code that differs from the documented one.

## Verification

- Each test asserts a status code and the response body's shape, not only that the call did not raise.
- Authorization tests cover anonymous (`401`), authenticated but unauthorized (`403`), and authorized requests for at least one protected route.
- An override is installed and removed in the same test, and running the suite in a shuffled order still passes.
- A test covering a startup-created resource runs with lifespan active and fails when it is not.
- Database isolation is proven by running one test that commits and asserting the next test does not observe its rows.
- No test calls a route handler directly or overrides the service it is meant to exercise.
