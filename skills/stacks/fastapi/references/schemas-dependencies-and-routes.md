# Schemas, Dependencies, and Routes

Use this reference for the web-layer binding of a FastAPI service: what crosses the request boundary, how dependencies assemble a handler's inputs, how authorization attaches to routes, and how a route is shaped. Layering and transaction ownership are decided elsewhere.

## Schemas are the validation boundary

### Separate input from output, per operation

One schema per operation direction, not one model for the entity.

```python
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8)

class UserUpdate(BaseModel):
    email: EmailStr | None = None

class UserRead(BaseModel):
    id: int
    email: EmailStr
    model_config = {"from_attributes": True}
```

| Schema | Question it answers |
|---|---|
| Create | Which fields may a client set on first write? |
| Update | Which fields are patchable, and what means "unchanged"? |
| Read | Which stored fields may leave the process? |
| List envelope | How are items, total, and cursor returned? |

**Failure mode:** a shared `User` schema used for create, update, and response is simultaneously over-permissive on input and over-exposing on output. Splitting is not duplication; the fields genuinely differ.

### `from_attributes` reads objects, `extra` rejects unknowns

`from_attributes` (or `from_orm` in Pydantic v1) lets a response schema accept an ORM object or dataclass attribute-by-attribute. Set the unknown-field policy deliberately: input schemas typically forbid or ignore extras, and either choice belongs on the class so it is visible at the boundary rather than implicit.

### Return a schema, not the ORM object

**Failure mode:** returning the ORM instance makes every mapped column a candidate for serialization. A later migration that adds `hashed_password`, `internal_notes`, or a tenant identifier silently widens the response. Attribute-heavy ORM state, lazy relationships, and per-request session lifetime are the other reasons the response object should be a value, not a live row.

### `response_model` and a return annotation differ

A declared `response_model` filters and re-validates the returned value, so extra fields on the object are dropped and the OpenAPI document describes the real payload; a failing model turns a leaked shape into a server-side error. Annotating only the return type (`-> ItemRead`) documents intent and feeds type checkers but does not filter what is serialized. Use both: `response_model` where the wire shape matters, the annotation for the reader and the checker.

### Validate with the schema, not with handler conditionals

Length, range, format, enum membership, and cross-field consistency belong in the schema (field constraints, validators). A handler that manually checks `if len(payload.name) > 50` duplicates the declaration, skips OpenAPI, and returns a shape clients cannot predict. A check that cannot be expressed as a field constraint is still a schema-level `model_validator`, not route code.

## Dependencies

### Declare dependencies on the parameter

An `Annotated` alias such as `DbDep = Annotated[AsyncSession, Depends(get_db)]` keeps the dependency visible in the signature, is reusable across routers, and keeps the resolved type available to tooling. The older default-value style (`db: AsyncSession = Depends(get_db)`) works but reads as an ordinary default argument and composes worse with further parameter metadata. Pass resolved values explicitly (`item_id`, `user`, `svc`) rather than resolving the same provider inside the handler body.

### `yield` dependencies define their own cleanup

```python
async def get_db() -> AsyncIterator[AsyncSession]:
    async with SessionLocal() as session:
        try:
            yield session
        except Exception:
            await session.rollback()
            raise
```

Code after `yield` runs when the request ends, including when the handler raises or a response fails to serialize. Raising inside the `except`/`finally` block propagates after the handler's own exception, so cleanup that must not mask the original error has to be written carefully.

**Invariant:** a request-scoped resource is released exactly once per request, whatever the outcome.

**Failure mode:** acquiring a session, file handle, or client inside the handler body rather than a `yield` dependency — leaked on the exception path and invisible to the test that overrides the dependency.

### Dependency results are cached per request

A dependency called by two dependencies is resolved once per request, and its result is reused. That is what makes sessions and current-user lookups safe to depend on from several places — and what makes a dependency a poor place for work that must happen per call site. Use the caching explicitly: a shared `yield` dependency is a per-request resource, not a per-handler one.

### Dependencies are the override seam

`app.dependency_overrides[provider] = replacement` replaces a provider for the app instance, which is how tests inject a session, a fake clock, or a current user without touching route code. Keep providers reachable as module-level callables so tests can name them; a dependency built inline inside a route cannot be overridden.

## Authorization

### Make the check an explicit dependency

Authorization belongs in a dependency attached to the route, not in an `if` inside the handler body.

```python
def require_role(role: str) -> Callable[..., User]:
    async def dep(user: Annotated[User, Depends(get_current_user)]) -> User:
        if role not in user.roles:
            raise HTTPException(status_code=403, detail="Forbidden")
        return user
    return dep

AdminUser = Annotated[User, Depends(require_role("admin"))]
```

A dependency is declared in the signature, visible in OpenAPI, overridable in tests, and auditable by grepping the router.

### Deny by default

Attach the requirement at the router (`APIRouter(prefix="/admin", dependencies=[Depends(CurrentUser)])`) or through a route-level dependency list, so a new endpoint inherits it instead of re-declaring it. Keep authentication and authorization as separate steps so `401` (no valid identity) and `403` (identity lacks permission) stay distinguishable.

**Failure mode:** the adjacent route that forgot the dependency. An auth check copied into each handler is correct until one endpoint in the same router omits it, and the omission is invisible in review because every visible route looks protected. Prefer router-level enforcement plus per-route narrowing, and make the authorization decision observable in a test rather than inferred.

A missing check is a design gap; reasoning about the trust boundary itself — session handling, token validation, secret storage, injection surface — belongs to `security-review`. Route-level enforcement shape stays here.

## Route shape

### Group with `prefix` and `tags`

Compose routers with a stable `prefix` and `tags` so the OpenAPI document groups operations and the URL structure has one owner. Do not repeat the path segment inside every route decorator.

### Declare the status code

State the intended success code (`status.HTTP_201_CREATED` for creation, `204` for a delete with no body) instead of accepting the default. Declare failure responses through the project's exception handlers or a documented response model, once, so clients parse one error shape.

### Keep the handler thin

A handler does four things: parse the validated input, authorize, delegate to the service, and return a response model.

```python
@router.post("/", response_model=ItemRead, status_code=201)
async def create_item(
    payload: ItemCreate,
    svc: ItemServiceDep,
    user: EditorUser,
) -> ItemRead:
    return ItemRead.model_validate(await svc.create(payload, actor=user))
```

Otherwise the same operation is reachable only through HTTP: a background job, a CLI, or a second endpoint reimplements it, and the tests must go through the transport to cover business rules. Mapping a domain exception to a status code in the route is the boundary's job; deciding the operation's logic is not.

### Give pagination and filters an explicit shape

Type query parameters with bounds (`Annotated[int, Query(ge=1, le=100)]`) so invalid input fails at the boundary rather than in the query builder. Return an envelope carrying the total or cursor alongside items, and require a deterministic ordering key in the underlying query — offset pagination without a stable sort silently repeats and skips rows. For changing datasets or deep scans, prefer cursor pagination and take its encoding and snapshot semantics from `backend-patterns`.

## Verification

- Send a request with an omitted, unknown, wrong-type, and out-of-range field; confirm a `422` with field-level detail and no handler-side branch.
- Read a resource and assert the response body's exact key set: no stored secret, hash, internal flag, or tenant identifier appears.
- Send a payload containing an extra field and confirm the declared `extra` policy decides the outcome.
- Call a protected route with no credentials (`401`) and with valid credentials lacking the permission (`403`); the denial happens before any domain side effect. Add a probe endpoint under the same router and confirm it inherits the requirement.
- Exercise a route whose handler raises through its shared `yield` dependency; the resource is released and the original error is what the client sees.
- Override the current-user and session providers in a test and confirm the route body needed no change.
