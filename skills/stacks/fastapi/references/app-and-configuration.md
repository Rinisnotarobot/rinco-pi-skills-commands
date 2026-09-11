# App and Configuration

Use this reference when establishing or reviewing a FastAPI application's entry point: how the app object is constructed, what runs at startup and shutdown, and where configuration comes from. Read the repository's existing layout before proposing one.

## Layout

| Question | What decides it |
|---|---|
| Where does the app object live? | Whether tests or tooling must construct more than one instance |
| Routers or feature packages? | The repository's existing grouping; do not introduce a second |
| Where do settings, sessions, and models live? | The module that already owns that concern today |

The tree below is **one valid shape**, not a required one. Use it only as a starting point when the repository has no convention yet.

```text
app/
  main.py          # app factory, lifespan, middleware
  config.py        # Settings
  dependencies.py  # shared dependencies
  routers/         # APIRouter modules
  models/          # ORM models
  schemas/         # request and response schemas
  services/        # business operations
tests/
```

The tree names seams, not mandatory directories. A single-router service legitimately has no `services/` package; a larger one may group by feature (`users/router.py`, `users/schemas.py`). Adopt the layout already in the repository even when it differs.

## App factory

### Create the app inside a function

`create_app()` returns a configured `FastAPI` instance: routers included, middleware added, lifespan attached.

**Choose it when** tests, workers, or tooling need more than one instance with different configuration, when middleware and router wiring would otherwise run at import time, or when the app is embedded in another ASGI composition.

**Module-level `app = FastAPI()` stays valid** for a single-instance service. Do not migrate it without that pressure.

**Failure mode:** a factory that reads late-bound module globals is not actually instanceable — two calls share state. Pass configuration in.

### Keep import-time side effects out

Engine creation, `create_all`, and network calls at import make the module unusable from migration tooling, tests, and scripts. The factory wires; services and dependencies connect lazily.

### Middleware order is significant

Middleware runs outermost-first, in reverse of the order it was added. Add cross-origin, request-id, and logging middleware in a place where that order is visible, and read allowed origins and credentials from settings rather than literal lists.

## Lifespan

### Initialize before `yield`, release after

```python
@asynccontextmanager
async def lifespan(app: FastAPI):
    await pool.start()
    try:
        yield
    finally:
        await pool.close()
```

Everything before `yield` finishes before the first request is served. `yield` executes exactly once. Everything after runs at shutdown, and the `try/finally` is what makes release survive a failed startup step or an exception later in the process's life.

### Pair acquire and release in the same function

**Failure mode:** a resource acquired before `yield` but released only on the normal path leaks when startup raises, when a later startup step fails, or when the process is asked to stop early. Keep acquisition and release adjacent so a reviewer can check the pairing, and let release tolerate a partial startup.

Ordering worth stating explicitly when the app owns several resources:

- pools, HTTP clients, and caches start before `yield`;
- consumers and background workers stop accepting work before their clients close;
- shutdown hooks are called once, not per worker process, unless the resource is per process.

Stop order is the reverse of start order. An app that starts a worker before its database pool is not ready to serve.

### Replace `@app.on_event` rather than mixing it

`@app.on_event("startup")` and `"shutdown"` are deprecated in favour of the lifespan parameter. Migration is one mechanism at a time: with both present, ordering between them is not what a reader assumes, and cleanup becomes hard to prove. When the repository still uses the old form, migrate the handlers it owns in the same change that touches startup behavior, not as a drive-by rewrite.

## Configuration

### A typed settings object is the only read path

```python
class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_prefix="MYAPP_", extra="ignore"
    )
    database_url: str
    debug: bool = False
```

Reading `os.environ` in a handler or service bypasses validation, typing, and the single place a reviewer can audit. Add a field to the settings model instead of reaching around it.

### `lru_cache` on the accessor, and what it implies

```python
@lru_cache
def get_settings() -> Settings:
    return Settings()
```

Caching yields one instance per process and makes the object safe to use as a FastAPI dependency. Two consequences belong in the review:

- the environment and `.env` are read once, so a test that changes an environment variable after first access sees the stale object;
- changing configuration within a test session requires clearing the cache or overriding the dependency, not re-importing the module.

Keep settings construction free of network calls, file writes, and logging side effects, so building the singleton stays cheap and side-effect free.

### Secrets carry no default value

Required fields — `database_url`, `secret_key`, signing keys, third-party credentials — are declared with no default, so a missing value fails at import with a validation error instead of running silently with a placeholder secret. Non-secret operational values (`debug`, timeouts, token lifetime) may carry explicit defaults.

### Namespace with a prefix, nest with a delimiter

`env_prefix` prevents collisions between this service and the platform's other variables; `env_nested_delimiter` keeps grouped configuration grouped instead of flattening it into a growing name list. Names in the `.env.example` are the contract with whoever deploys the service.

### `.env` is local and untracked

`.env` holds developer-local values and is not committed. Commit a `.env.example` listing variable names and safe placeholders. Deployed configuration comes from the platform's environment or secret store, not from a file baked into an image.

## Verification

- Start the app twice through the factory and confirm the second instance is unaffected by the first (no shared module-level state).
- Prove the startup/shutdown pairing: release runs after a failed startup step and after a normal stop; resources are not left open.
- Confirm both mechanisms are absent or singular: no deprecated startup handler remains alongside the lifespan.
- Change a required secret's value or remove it and observe an immediate validation failure rather than a default.
- Change a non-secret setting through the supported mechanism (cache clear or dependency override) and observe the new value on the next request.
- Confirm `.env` is untracked and deploy-time configuration reaches the process without it.
