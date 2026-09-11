# Service Layer and Persistence

Use this reference for the FastAPI and SQLAlchemy expression of a persistence and layering design that has already been chosen.

## Ownership

Layering, transaction scope, isolation, consistency requirements, and whether a repository exists at all are **decided** by `backend-patterns` — `consistency-and-data.md` for atomicity, concurrency, and query shape, `boundaries.md` for dependency direction and seams. Invoke it first; do not re-derive those decisions here.

This reference owns only the mechanical question: given that decision, what does it look like in a FastAPI request with SQLAlchemy? When a statement here disagrees with the `backend-patterns` decision, that decision wins.

| Decision | Owner |
|---|---|
| Transaction boundary, isolation, consistency model | `backend-patterns` |
| Whether a service or repository seam exists, and where | `backend-patterns` |
| Session object, dependency lifetime, commit and rollback mechanics | Here |
| Mapping a domain exception to an HTTP response, once | Here |
| Retry, timeout, idempotency, unknown-outcome handling | `resilience` |

**Keep the ORM out of the route.** Passing a `Session` into a route handler is how persistence choices leak into the transport layer; a route should receive what a service exposes, not the machinery underneath.

## Session lifecycle

### One session per request, supplied by a `yield` dependency

```python
async def get_db() -> AsyncIterator[AsyncSession]:
    async with SessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
```

The dependency owns acquire, commit, rollback, and close; nothing else in the request opens or closes a session. This shape makes the whole request one unit of work, which is a valid choice only when that is what the declared boundary says.

### State the consequence of committing after `yield`

Commit in the dependency runs after the handler returned, so a failure during response serialization or in a later dependency's teardown happens after the data is already committed. Where that gap matters, commit inside the service operation that owns the invariant and keep the dependency to rollback-and-close. Either way the commit point is explicit and appears once; a repository method that commits silently gives callers no boundary to reason about.

### Do not return rows past their session

`async with` closes the session at request end, and an ORM instance touched afterwards may be detached or already expired. Convert to a response schema inside the request (see `schemas-dependencies-and-routes`), or configure expiry so attribute access after commit does not trigger an unexpected refresh. A handler that hands an ORM object to a background task is holding a live row across a lifetime it no longer controls.

### Async session for async handlers, sync session for sync handlers

Match the session type to the driver and to the handler. A synchronous `Session` called from an `async def` handler blocks the event loop for the duration of the query; a synchronous driver behind `await` only works when the library actually provides that API. If the project is synchronous, keep handlers `def` so FastAPI runs them off the loop, and do not mix both models in one service.

## Service operations

### The service receives a session; it does not open one

A service method takes the request's session as a parameter. Opening a second session inside a service detaches its writes from the declared boundary, hides a nested commit, and makes the operation impossible to compose into a larger unit of work. Only a worker, scheduler, or CLI entry point that has no request constructs its own session, and it does so explicitly.

### A repository is a narrow, purpose-named interface

```python
class ItemRepository:
    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def by_sku(self, sku: str) -> Item | None:
        return await self.session.scalar(select(Item).where(Item.sku == sku))
```

The seam's value is that callers ask a domain question and cannot reach around it. A generic `BaseRepository[T]` with `get`, `all`, `create`, and `delete` mostly re-exposes the ORM and hands callers the query language back, so it isolates nothing. Add methods that name the operation the caller needs, and let `backend-patterns` decide whether the seam should exist.

### Load what the response needs

**Failure mode:** N+1 — a list response touching a lazy relationship serializes per row and issues one query each, which is invisible in a small test fixture and fatal at production row counts. Choose eager loading (`selectinload` for collections, `joinedload` for many-to-one) or select only the projected columns the response declares, and bound the row count.

```python
stmt = (
    select(Item)
    .options(selectinload(Item.tags))
    .order_by(Item.id)
    .limit(limit)
)
```

### Map the domain exception to HTTP once

Define the failure as a domain exception in the layer that detects it, and translate it in one place — an exception handler registered on the app, or one mapping function used by every router.

```python
@app.exception_handler(DuplicateSkuError)
async def duplicate_sku(request: Request, exc: DuplicateSkuError) -> JSONResponse:
    return JSONResponse(status_code=409, content={"detail": str(exc)})
```

Per-endpoint `try/except` blocks drift: the same condition returns `400` in one route and `409` in another, and clients must handle both. Keep the exception class free of status codes so the persistence layer does not depend on the transport. The error body shape stays the project's, and a unique-constraint violation must be caught where the write happens, since a pre-check alone has a race window.

## Verification

- Send the same mutating request twice against a uniqueness invariant; the second returns `409` and exactly one row exists.
- Force a failure after the first write of a multi-write operation and confirm no partial state is observable and the transaction ends rolled back.
- After an exception path, make a subsequent request on the same pool and confirm the connection was returned, not leaked or left in a failed transaction.
- Assert the statement count for a list endpoint against a fixture with multiple parents: a per-row query is the N+1 signal.
- Confirm no handler commits, opens, or closes a session outside the shared dependency.
- Confirm a detached or expired instance cannot silently load a relationship after the request ends.
- Confirm one condition produces one status code across every route that can raise it.
