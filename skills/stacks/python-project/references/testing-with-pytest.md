# Testing with pytest

Use this reference for pytest mechanics: assertion shape, fixtures and scopes, parametrization, markers, async tests, exception tests, side-effect control, file organization, and configuration. It covers how to express a test in this framework. Which tests to write, the test seam, coverage policy, and how much to mock belong to `tdd`; the executable gate and its verdict belong to `verification`.

## Detect the project's test setup

Read the repository before writing a test, and state what you found:

- configuration location and contents: `[tool.pytest.ini_options]` in `pyproject.toml`, or `pytest.ini`, `tox.ini`, `setup.cfg`; note `testpaths`, `addopts`, declared `markers`, and `asyncio_mode`;
- plugins actually installed: `pytest-asyncio`, `anyio`, `pytest-cov`, `pytest-mock`, `httpx`, `respx`, `freezegun`, `time-machine`;
- every `conftest.py` on the path, the fixtures it already provides, and their scopes — an existing fixture is preferred over a new one;
- the file, class, and function naming patterns in effect (`python_files`, `python_classes`, `python_functions`);
- how the repository declares that tests are run, and in which environment.

Completion criterion: no test introduces a plugin, marker, fixture scope, or option the project has not already adopted.

## Assertions

### Plain `assert` with a comparison the failure message explains

`assert result == expected` is the pytest idiom; a bare `assert result` hides the value. Assertions are rewritten by pytest, so keep them simple and let the reported diff speak.

### Pin identity, null, and truthiness deliberately

| Intent | Write | Note |
|---|---|---|
| exactly this object | `assert x is sentinel` | `==` may be overloaded |
| None | `assert x is None` | not `== None` |
| truthiness only | `assert not items` | says nothing about content |
| a float | `pytest.approx(expected)` | compare floats only with a tolerance |

## Fixtures and Scopes

### Fixture scope is a resource-lifetime decision

| Scope | Runs | Appropriate for | Wrong when |
|---|---|---|---|
| `function` (default) | once per test | most fixtures | rarely |
| `class` | once per class | class-wide setup | tests mutate it |
| `module` | once per module | an expensive read-only artifact | state leaks between tests |
| `session` | once per run | a container, server, or migration | a test writes to it |

A wider scope is a correctness trade: it saves setup time and costs isolation. Widen only when the fixture is provably read-only, and say so.

### `yield` fixtures do teardown after the `yield`

Teardown runs even when the test fails, so keep cleanup after `yield` and never swallow there. A fixture that returns instead of yielding provides no teardown at all.

### Keep fixtures explicit and narrow

`autouse=True` is for genuinely global concerns such as resetting configuration, environment, or time; anything that builds the object under test should be requested explicitly so the dependency stays visible in the signature. A fixture returning a half-configured application makes the preconditions unreadable, so prefer several narrow fixtures and let a test override one when it needs a different state. Put a shared fixture in the nearest `conftest.py` to the tests that use it, not the top one: higher directories widen the blast radius of every change.

## Parametrization

### Replace copy-pasted tests with `@pytest.mark.parametrize`

```python
@pytest.mark.parametrize("raw,expected", [("a", "A"), ("B", "B")], ids=["lower", "upper"])
def test_normalize(raw, expected): ...
```

Stacked `parametrize` decorators produce the cross product; use that instead of a loop inside one test.

### Give the cases names when the values do not explain themselves

`ids=` turns a failed run into a readable case name. Compare against a class or a small equality helper rather than asserting many fields in sequence inside one case.

### Parametrize a fixture when the axis is an environment

A `@pytest.fixture(params=[...])` that yields a backend, client, or dialect keeps the test body unchanged while covering the matrix, and reports each parameter as its own test id.

## Markers and Test Selection

### Declare every marker, and mark by cost or environment

An undeclared marker is either an error (`--strict-markers`) or a silent typo, so add it where the project already declares markers. `slow`, `integration`, `e2e`, and `requires_network` describe what a test needs; a marker meaning "we care about this one" carries no execution meaning and will never be selected.

### Never use `skip` or `xfail` to hide an unexplained failure

`xfail` documents a known, tracked defect with a reason; `skip` documents a genuine precondition. Both need the condition inline, not a stale comment.

## Async Tests

### Follow the configured `asyncio_mode`

In `strict` mode an async test needs `@pytest.mark.asyncio`; in `auto` mode it does not. Match the project's setting instead of copying the marker habit from another repository.

### Async fixtures need the plugin's fixture mode

An `async def` fixture only works when the async plugin owns it (`pytest-asyncio` in auto or with the matching decorator, or `anyio` with a backend). A silently un-awaited fixture yields a coroutine object, not the resource.

### Do not block the loop, and await the mock

`time.sleep`, synchronous client libraries, and file-heavy work stall the loop; use the async primitive (`asyncio.sleep`, an async client) or move the work out of the async test. Assert awaited calls with `assert_awaited_once`, not `assert_called_once`.

## Testing Exceptions

### `pytest.raises` with the narrowest type and a message match

```python
with pytest.raises(ConfigError, match="invalid JSON"):
    Config.from_json("{")
```

`match` is a regex applied to `str(exc)`, so escape characters that are special to regex. When the contract includes attributes, use `with pytest.raises(...) as exc_info:` and assert on `exc_info.value`: asserting only the type accepts a wrong code, wrong field, or missing cause. Where an exception is translated, assert the new type and that `__cause__` still points at the original.

## Testing Side Effects

### Use `tmp_path` for every filesystem test

```python
def test_write_report(tmp_path):
    out = tmp_path / "report.txt"
    write_report(out)
    assert out.read_text() == "ok"
```

Never write to a fixed filename, the repository root, or the developer's home; `tmp_path` is unique per test and cleaned up automatically.

### `monkeypatch` for environment, cwd, attributes, and `sys.path`

`monkeypatch.setenv`, `chdir`, `setattr`, `syspath_prepend`, and `delitem` all undo themselves after the test. Prefer it over manual save/restore in a `try/finally`, which leaks on an early failure. Freeze time with the project's clock plugin instead of sleeping: sleeping makes the suite slow and flaky, and a real `sleep` in a test is a signal that the design hides a seam.

## Mocking and Patching

- Prefer `monkeypatch` for your own small seams (a module attribute, an env var, a class attribute).
- Use `mocker` when the project has `pytest-mock` and you need call assertions or a spec'd double; it cleans up automatically.
- Patch the name where it is looked up — the module that imports and calls it — not where it is defined.
- Use `autospec=True` (or `mocker.create_autospec`) so a wrong signature or method name fails the test instead of passing silently.
- Use an async-aware mock (`AsyncMock` or `mocker.AsyncMock`) for awaited callables.
- Whether to mock at all, and how broad a fake is acceptable, is decided by `tdd` (`tdd/references/mocking.md`).

## Test Organization

- Test files mirror the module layout, and `tests/` sits outside the package unless the repository ships tests inside it.
- `unit/`, `integration/`, and `e2e/` split the suite when they need different fixtures or markers; a flat `tests/` directory is fine when they do not.
- Use a test class to group tests that share a fixture or a subject, not to express inheritance.
- Keep helpers in `conftest.py` or a sibling module; a test reaching into another test file for a helper is a sign the helper belongs somewhere shared.
- One behavior per test: a name that needs "and" is usually two tests. Tests are code: assertions over `print`, no conditionals that branch the expectation, and no helper worth testing hidden in a test module.

## Test Configuration

- Read the existing `ini_options`; do not add options, markers, or plugins ad hoc from a tutorial. `addopts` may already inject coverage, strict markers, or warning filters, so a command-line flag can silently contradict it.
- Coverage thresholds are whatever the repository configures. When it configures none, choose tests by uncovered risk rather than inventing a percentage, per `tdd` (`tdd/references/coverage-and-verification.md`).
- Run tests with the command the repository declares, in the environment it declares; execution, evidence, and the verdict belong to `verification`.
- Do not edit a test's expected value to match observed behavior without confirming which side is wrong.

## Verification

- Run the repository-declared test command and show the new tests collected and passing.
- Prove a test can fail: break the production behavior it covers, observe the failure, restore, and re-run — a test that cannot fail is not evidence.
- Confirm isolation by running the new tests alone, with the full suite, and in a different order where the repository supports it.
- Confirm no writes left the workspace: after the suite, the repository tree is unchanged outside ignored directories.
- For fixtures and markers, confirm the scope and the marker name appear in a collection listing rather than only in the source.
- Report any test that was skipped, xfailed, or retried as a review item, not as a pass.
