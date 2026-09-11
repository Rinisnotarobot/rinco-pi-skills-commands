---
name: python-project
description: Python stack baseline for an arbitrary Python project - detect its toolchain, layout, typing posture, and pytest setup from the repository, then follow that repository's own idiom instead of a generic template. Use when working in any Python project - adding or reviewing Python code, choosing a package layout, configuring uv/ruff/mypy/pytest, or when a FastAPI, Django, script, or library change needs the stack's baseline. 中文触发：Python 项目、Python 常识、pyproject、pytest 配置、类型注解
---

# Python Project

Apply the Python baseline that holds in every Python project, and adopt whatever this repository already does. This skill carries stack conventions, not the project's decisions: when the two disagree, the repository wins and the difference is reported.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- toolchain and pins: `pyproject.toml`, `uv.lock`, `poetry.lock`, `requirements*.txt`, `.python-version`, CI workflow, `Makefile`, `justfile`, `tox.ini`;
- layout: `src/` or flat package, package or namespace package, where tests, scripts, and migrations live;
- configured gates: the exact commands and settings declared for ruff, black, isort, ty, mypy, and pytest — as declared, not as commonly used;
- test stack: runner and plugins present (`pytest-asyncio`, `anyio`, `pytest-cov`, `pytest-mock`, `httpx`, `freezegun`), `asyncio_mode`, and the `conftest.py` fixtures that already exist with their scopes;
- typing posture: strict or gradual, `py.typed`, whether boundaries are annotated and how;
- framework in the dependencies (FastAPI, Django, Click, Airflow, pandas…) and which layer owns the change;
- supported Python floor from `requires-python` and any runtime version pins.

Completion criterion: every claim about "how this project does it" cites a file; anything unverified is marked as an assumption.

### 2. Define the problem and the invariant

Describe the pressure without naming a library: a mutable argument shared across calls, an error swallowed at a boundary, a resource outliving its scope, a duplicate import cycle, a test that passes for the wrong reason. State the invariant any acceptable change must preserve, in observable terms.

Completion criterion: the affected module, ownership seam, and observable correctness condition are explicit.

### 3. Select the branch

Read only the references the active branch needs:

| Problem branch | Reference or owner |
|---|---|
| Idioms, type annotations, error handling, context managers, generators, dataclasses, decorators, concurrency shapes, memory behavior | [references/idioms-and-types.md](references/idioms-and-types.md) |
| pytest structure, fixtures and scopes, parametrization, markers, async tests, test configuration | [references/testing-with-pytest.md](references/testing-with-pytest.md) |
| Toolchain detection, package layout, imports, `pyproject.toml`, formatting and type-check configuration | [references/tooling-and-layout.md](references/tooling-and-layout.md) |
| Framework-specific work in FastAPI | Invoke `fastapi`; the FastAPI transport, DI, and schema forms live there |
| Service boundaries, layering, dependency direction, transactions, consistency, contract evolution | Invoke `backend-patterns` and read only the references its problem branch selects |
| Deadlines, retries, cancellation, overload, idempotency, partial-failure recovery | Invoke `resilience`; do not invent failure policy here |
| Test-first slices, test seam choice, coverage policy, mocking scope | Invoke `tdd`; this skill owns only Python's test mechanics |
| Gate execution, fresh evidence, `READY`/`NOT READY`/`BLOCKED` | Invoke `verification`; do not restate gate commands as policy |
| Naming, readability, duplication, control flow, comments | Invoke `coding-standards` |
| Module depth, interfaces, seams | Consume `codebase-design` vocabulary |
| Trust boundary crossed by the change | Invoke `security-review` |

Completion criterion: the idiom comes from the branch, not from habit or a remembered tutorial.

### 4. Follow this repository's idiom

Prefer the pattern already present: search for an existing call site of the same shape before introducing a new one. Match the project's import style, error taxonomy, async or sync model, typing strictness, logging, and configuration access. A different-but-valid idiom is not a reason to rewrite working code.

Completion criterion: the change reads like the surrounding code and introduces no second convention for the same concern.

### 5. Version-sensitive APIs: repository evidence only

The project's code is the only API source of truth at this stage.

- Read the pinned version from `pyproject.toml` or the lockfile before depending on version-specific behavior; never state a signature or default from memory.
- Search the repository for an existing call site and copy its shape.
- When no call site exists and the exact signature or default matters, mark it unverified and confirm it against the installed package (a REPL or a one-off check) rather than writing from recall.
- External documentation lookup is intentionally out of scope here; when it is enabled, this section points at the global `context7-docs` skill.

Completion criterion: no version-dependent claim in the change rests on memory alone.

### 6. Define verification evidence

Name the check for each invariant: the test, type check, lint rule, or runtime observation that would fail if the invariant broke, and the project-declared command that runs it. Hand file-level sequencing to `plan`, and the executable gate and verdict to `verification`. This skill identifies design gaps; it does not issue `READY`, `NOT READY`, or `BLOCKED`.

## Baseline Rules

- Explicit beats clever: readable names, no hidden side effects in a call, no mutable default argument.
- EAFP over LBYL where the failure is expected; never a bare `except` and never a swallowed error.
- Catch specific exception types, preserve the cause, and translate at boundaries once.
- Manage every resource with a context manager, including locks, sessions, and temporary files.
- Annotate public boundaries; let inference handle locals.
- Choose a data container deliberately: `dataclass` for behavior, `NamedTuple` for a record, `TypedDict` for an external payload shape.
- Default to synchronous, straightforward code; reach for async or threads only when the workload is I/O-bound and the project already models it that way.
- Prefer a generator or streaming path when the input can be large; avoid quadratic string building.
- Treat the declared gate settings as authoritative; do not add a lint rule, formatter, or type-checker the project has not adopted.
- Do not restate the project's test or coverage policy: `tdd` owns test process, `verification` owns gate evidence.

## Output Contract

Scale depth to scope: a small local change needs the invariant, the selected idiom, and its check. Use the full structure for cross-module, packaging, typing, or concurrency work.

```text
Detected stack and evidence
Problem and invariant
Selected idiom and why
Repository conventions followed or deliberately differed
Typing, error handling, and resource ownership
Verification evidence
Unverified API assumptions and open risks
```

A change is not complete until the invariant, the repository convention it follows, its failure behavior, and its check are stated.
