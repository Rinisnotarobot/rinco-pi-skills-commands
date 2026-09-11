# Idioms and Types

Use this reference for the language-level shape of Python code: annotations, error flow, resource ownership, iteration, data containers, decorators, concurrency choice, and memory behavior. Each rule states the language default with the smallest counterexample that disambiguates it. Where the repository already differs, the repository wins and the difference is reported. Framework seams, service boundaries, and test mechanics stay with the skills named in the routing table.

## Typing

### Annotate the boundary, infer the interior

Annotate public signatures, module-level constants that are part of the contract, and anything a checker cannot infer. Locals and short private helpers read better unannotated.

```python
def parse_row(raw: str, *, strict: bool = False) -> Row | None: ...
```

Counterexample: annotating every local assignment buries the interface in noise and adds no safety.

### Match generic syntax to the declared floor

`list[str]`, `dict[str, int]`, and `str | None` work at runtime from 3.9/3.10. Read `requires-python` first; below the floor they fail at runtime, and `from __future__ import annotations` only defers evaluation — it does not fix runtime uses such as `TypeAlias`, `cast`, or a dataclass field default.

### Protocol over ABC for structural contracts

A `Protocol` documents a one-method dependency without forcing inheritance. Use an ABC when callers genuinely share implementation or need explicit registration.

Counterexample: an ABC used only as an interface check forces every caller to import and inherit a class it only duck-types. Bind a `TypeVar` to the smallest scope that needs it, and name aliases after the domain (`JSONValue`), not the mechanism.

## Error Handling

### Catch the specific exception you can handle

```python
try:
    config = Config.load(path)
except FileNotFoundError as exc:
    raise ConfigError(path) from exc
```

Counterexample: `except Exception: return None` collapses a missing file, a malformed file, and a typo in the loader into one indistinguishable result.

### Preserve the cause, translate once

`raise ... from exc` keeps the traceback chain. Translate at exactly one layer — the boundary that owns the domain taxonomy — and let inner layers propagate the original exception.

### One exception hierarchy per boundary

A base error per package or service boundary, subclasses for the cases callers actually branch on — not a class per call site. A bare `except:` also swallows `KeyboardInterrupt` and `SystemExit`; `except Exception: pass` is acceptable only with a comment stating why ignoring is correct, and that is rare: log and re-raise, or narrow the type.

## Context Managers

### Every resource goes through `with`

Files, locks, DB sessions, temporary directories, HTTP clients, and any acquired handle. Prefer `with lock, session.begin():` over nesting.

Counterexample: manual `open` plus `try/finally` restates what `with` guarantees and is easy to get wrong when a second resource is added.

### `@contextmanager` for simple, a class for stateful

`contextlib.contextmanager` with a single `yield` covers setup/teardown without state. A class with `__enter__`/`__exit__` is for reusable managers that expose attributes. `__exit__` returns `False` unless swallowing the exception is deliberate and documented.

Reach for the stdlib before writing your own: `contextlib.suppress(FileNotFoundError)` for a narrow ignore, `contextlib.ExitStack` for a dynamic number of resources.

## Comprehensions and Generators

### One transform with at most one condition: comprehension

```python
names = [user.name for user in users if user.is_active]
```

Counterexample: chained `if`s, nested loops, and side effects inside the brackets — expand that to a loop so the reader can see the order of operations.

### Generator expression when the result is only aggregated

`sum(x * x for x in range(n))` never builds the intermediate list. Use a list when the result is indexed, mutated, or iterated more than once; a consumed generator silently yields nothing the second time.

### Generator function when the producer owns state or the input is large

A `yield`-based reader streams a file or paginated API without holding the whole result. Document whether the generator must be closed and whether it is safe to resume after partial consumption, and prefer it over materializing a list when the only consumer aggregates.

## Data Containers

| Need | Use | Why |
|---|---|---|
| Data with behavior, defaults, validation | `@dataclass` | generated `__init__`/`__eq__`/`__repr__`, mutable by design |
| Immutable record, tuple compatibility | `typing.NamedTuple` | hashable, unpackable, indexing preserved |
| External payload shape, no runtime cost | `TypedDict` | describes a dict the boundary does not own |
| Schema with coercion across a boundary | the project's validation library | hand-written checks do not validate untrusted input |

### Never a mutable default argument

```python
@dataclass
class Job:
    tags: list[str] = field(default_factory=list)  # not `tags: list[str] = []`
```

The same trap applies to functions: an `items=[]` parameter is shared across every call in the process. Cheap invariants (range, format) belong in `__post_init__`; anything needing I/O, a service, or configuration is construction logic for the owning object, not a container. Use `frozen=True` when immutability or hashability is a requirement, not by default.

## Decorators

### Always `functools.wraps`, and never a hidden side effect

Without `functools.wraps` the wrapper loses `__name__` and `__doc__`, which breaks pytest collection, logging, and introspection of the decorated callable. A parameterized decorator is three levels — factory → decorator → wrapper — each returning the next and the innermost keeping `wraps`.

Registration, connection opening, argument mutation, or import-time work inside a decorator is an implicit contract. Make it visible in the name or move it to explicit code at the call site.

## Concurrency

Default to synchronous code; concurrency needs a measured latency or throughput reason, not fashion.

| Workload | Reach for | Principal pitfall |
|---|---|---|
| I/O-bound, sync codebase | `ThreadPoolExecutor` | the GIL is not the problem here; shared mutable state still needs a lock |
| CPU-bound | `ProcessPoolExecutor` / `multiprocessing` | pickling cost, no shared memory, start-method differences |
| I/O-bound, project already async | `asyncio` | one blocking call stalls the whole loop; cancellation is not automatic |
| Mixed compute and I/O | processes for compute, threads or async inside each worker | nested pools exhaust workers |

- Threads for waiting, processes for computing, async only where the project already models it.
- Bound the pool and the wait: an `as_completed` without a timeout can hang a build forever.
- Worker exceptions do not propagate until the result is consumed; a future whose result is never read turns a crash into silence.
- Prove the invariant with concurrent writers, not only the sequential path.

## Memory and Performance

### Build strings by joining, not by `+=` in a loop

Repeated concatenation is quadratic because strings are immutable. `"".join(...)` or `io.StringIO` is linear. The same reasoning applies to repeatedly extending a list with `list(...)` inside a loop.

### Optimize only after a measurement names the cost

`__slots__`, caches, manual inlining, and micro-tuned loops need a profile, allocation count, or benchmark behind them. Otherwise they buy unmaintainable code for an unmeasured gain.

## Anti-Patterns

| Avoid | Because | Instead |
|---|---|---|
| Mutable default argument | shared across every call | `None` sentinel or `default_factory` |
| `type(x) == list` | breaks on subclasses and proxies | `isinstance(x, list)` |
| `x == None` | `__eq__` can be overloaded | `x is None` |
| `from mod import *` | shadows names, defeats static tools | explicit names |
| Bare `except:` | also catches `KeyboardInterrupt`, `SystemExit` | the specific type |
| `except Exception: pass` | turns failures into wrong results | log and re-raise |

## Verification

- After adding annotations, run the repository-declared type check and confirm no new diagnostics; report pre-existing ones as pre-existing.
- For each error path, add or point to a test that triggers it and asserts the specific exception type, and that `__cause__` is preserved when translated.
- Prove resource release by asserting the cleanup ran after an exception (a closed flag, a released lock, an empty temp directory), not by reading the source.
- For a concurrency change, exercise the race with concurrent writers and show the invariant holds; record the pool bound and timeout used.
- For a memory or performance claim, cite the before/after measurement (profile, allocation count, timing) rather than a reasoned estimate.
