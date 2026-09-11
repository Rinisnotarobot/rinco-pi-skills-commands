# Tooling and Layout

Use this reference to read a Python repository before changing it: which toolchain it uses, what each `pyproject.toml` section owns, which package layout it chose, what a package exports, and what the lockfile and `py.typed` promise. The rules here describe how to detect and follow the project's decisions. Running the gates and judging their output belongs to `verification`; typing and testing idioms belong to the sibling references of this skill.

## Detect the toolchain

| Evidence in the repository | Toolchain | Install and run |
|---|---|---|
| `uv.lock`, `[tool.uv]`, `uv` in CI | uv | the project's declared `uv` commands |
| `poetry.lock`, `[tool.poetry]` | Poetry | the project's declared `poetry` commands |
| `requirements.txt` with `requirements.in` or `pip-compile` in CI | pip-tools | compile, then `pip install -r` |
| plain `requirements*.txt`, no lock | bare pip | pinned by the file itself |
| `Pipfile` / `Pipfile.lock` | pipenv | the project's declared pipenv commands |
| `environment.yml` | conda / mamba | the project's declared env commands |

- The toolchain that produced the lockfile in the repository is the one in use. Do not convert, and do not add a second package manager for one new dependency.
- `requires-python` and `.python-version` state the supported floor. Do not raise the floor inside an unrelated change; new syntax can silently break the oldest supported interpreter.
- Before using a version-sensitive API, read the pinned version from the manifest or lockfile instead of assuming the signature.

## What each `pyproject.toml` section owns

| Section | Owns | Reading it tells you |
|---|---|---|
| `[build-system]` | build backend and its requirements | how the package is built and installed |
| `[project]` | name, version, `requires-python`, runtime `dependencies` | what ships and what runs in production |
| `[project.optional-dependencies]` | feature extras (`web`, `postgres`) | optional runtime surfaces |
| `[dependency-groups]` (PEP 735) | development groups (`dev`, `test`, `docs`) | tooling that never ships |
| `[tool.ruff]`, `[tool.black]` | lint and format policy | the declared style, including line length |
| `[tool.mypy]`, `[tool.ty]` | type-checking strictness and roots | how strict the type posture is |
| `[tool.pytest.ini_options]` | test discovery, markers, options | see the testing reference for the details |

```toml
[project]
requires-python = ">=3.11"
dependencies = ["httpx>=0.27"]          # imported by production code

[dependency-groups]
dev = ["pytest>=8", "ruff>=0.6"]       # never shipped to users

[tool.mypy]
strict = true
```

- A library imported by production code belongs in `[project].dependencies`; a test runner, formatter, or type checker belongs in a development group. Putting a dev tool in runtime dependencies ships it to users.
- Do not add a `[tool.*]` block for a tool the project has not adopted; configuration for an unused tool is a false signal.

## Layout: `src/` or flat

| Layout | Prefer when | Consequence |
|---|---|---|
| `src/<pkg>/` | the package is built, published, or imported by tests from the repo root | imports require an install or `src` on the path; the working tree cannot shadow the installed package |
| `<pkg>/` flat | the repo is an application, script collection, or service deployed from source | imports work from the repo root; a stale or shadowing working tree is easier to hit |
| namespace packages (no `__init__.py`) | several distributions deliberately share a namespace | deliberate split; rarely the right default |

- Follow the layout already present. Switching flat to `src/` changes imports, the type checker's roots, packaging data, and test discovery, so it is its own change and not a side effect of a feature.
- Tests live outside the package by default, mirroring the module structure. Keep tests inside the package only if the repository already ships them that way.
- Where the project puts scripts, migrations, and fixtures is a convention to copy, not to invent.

## Package exports in `__init__.py`

- An `__init__.py` should export the public API the package promises, and keep `__all__` in step with it.
- An empty `__init__.py` for an internal package is a valid choice; do not manufacture an API surface nobody imports.
- Do not do work at import time: no connections, no environment reads, no registry mutation, no scanning the filesystem. Import must be cheap and side-effect free.
- Re-exporting is fine, but it must not create an import cycle. Import the submodule inside the function when the cycle is inherent, with a comment.
- Do not eagerly import an optional heavy dependency at package import; make it lazy or keep it in the submodule.
- When the package is built, take `__version__` from installed metadata (`importlib.metadata`) instead of duplicating the literal.

## Imports

- Group in the order stdlib, third-party, local, with one blank line between groups; keep `import x` and `from x import y` sorted within each group.
- Let the project's formatter or linter own the exact ordering and flags. Do not hand-sort against the configured rule.
- Import the package absolutely in public code; relative imports are for the interior of one package, and only where the repository already uses them.
- A local import inside a function is acceptable for an optional dependency or a genuine cycle, and it should carry a comment saying which of the two it is.
- Do not import a private helper across packages, and do not re-export one to make it reachable.

## Lockfile

- The lockfile records resolved versions (and usually hashes) so installs are reproducible; the manifest records intent.
- A dependency change updates the lockfile in the same commit. A manifest that disagrees with the lock fails a frozen install in CI.
- Do not hand-edit the lockfile or resolve a version conflict by deleting the lock.
- CI normally installs from the lock without re-resolving, so a dependency added locally but not locked can pass on your machine and fail everywhere else.

## `py.typed`

- A `py.typed` marker in the package root tells consumers that the package ships inline annotations instead of stubs.
- Add it when the package is published and its public surface is annotated, and configure the build so the marker lands in the wheel; verify it is present in the built artifact, not only in the source tree.
- Do not add it while annotations are partial: consumers will type-check against an incomplete surface and see errors that look like defects in your package.

## Lint and type-check configuration

- The `select` list, `line-length`, `target-version`, and `per-file-ignores` in the ruff configuration are the project's declared policy. Add a rule only with a reason, and expect a separate change: enabling rules surfaces a backlog of violations.
- Ruff's `S` (flake8-bandit style) rules cover security-shaped patterns such as `subprocess` with `shell=True`, hardcoded credentials, and `assert` in production code. Know what they catch; there is no requirement to enable them if the project has not.
- Type-checker strictness lives in the tool's section. Match the existing posture; raising strictness belongs in its own change, and a narrow `# type: ignore` needs a reason or a link to the tracked fix.
- Run the tools the way the repository declares, and treat the verdict as `verification`'s to issue. When a gate fails, report the new diagnostics against the pre-existing baseline rather than fixing unrelated files.

## Verification

- Dependency change: the new package appears in the manifest, is present in the lockfile, and a fresh install by the declared command succeeds; a frozen install would too.
- Layout change: the installed package imports from a clean checkout, not merely from the working tree, and test discovery still collects the suite.
- Packaging change: the built wheel contains the package, its data files, and `py.typed` when the project declares full annotations.
- Import change: the module imports without network or credential access, and importing it twice has no second side effect.
- Style and type gates: run the repository-declared commands and report only diagnostics that are new relative to the baseline.
