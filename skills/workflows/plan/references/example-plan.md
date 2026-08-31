# Example Plan: Compact Depth, End to End

A worked illustration of the **Compact** output contract. The task is a small CLI
change: add a `--compact` mode to a tool that currently prints one JSON object
per line. Paths, symbols, and commands are illustrative — this file calibrates
the depth and specificity of a Compact plan, not evidence from any real
repository. Note the deliberately small slices, the predictive RED conditions,
and what the plan leaves to the executor.

## Task

`cli/logs.py` currently prints one JSON object per line for each log record. Add
a `--compact` flag that prints one line per record with only `ts`, `level`, and
`message` fields. The default output format is unchanged.

## Goal and Scope

- Outcome: `logs --compact` prints `ts level message` lines; `logs` (no flag)
  prints the current JSON lines.
- In scope: the flag, the compact formatter, and their tests.
- Out of scope: coloring, additional fields, aliases such as `-c`, config-file
  support, and any change to the default JSON output.

## Repository Evidence

```text
Fact: the command is a click CLI in cli/logs.py; render_log() returns a JSON line.
Evidence: cli/logs.py::render_log
Plan implication: the flag changes one render call site; no data layer is involved.

Fact: tests live in tests/test_logs.py and capture stdout through an existing
capsys fixture.
Evidence: tests/test_logs.py::test_logs_output
Plan implication: new tests follow the same capture convention.
```

```text
Command: uv run pytest tests/test_logs.py
Source: pyproject.toml [tool.pytest.ini_options] testpaths
Scope: focused
Requirements: none
```

## Selected Strategy

Add an optional `compact: bool` parameter to `render_log` and thread the click
option through. Rejected: a separate `logs-compact` subcommand, which duplicates
dispatch and breaks the existing single-command shape.

## Change Map

```text
cli/logs.py :: logs command and render_log
Current responsibility: parse args; render one JSON line per record
Planned responsibility: parse --compact; pass to render_log
Interface/data impact: render_log(record, compact=False) — additive, default
preserves current behavior

tests/test_logs.py :: test_logs_output (existing) plus two new tests
```

## Implementation Slices

### 1. Plumb the flag

- Changes: `cli/logs.py` — add the click option; pass it into the render call.
- Interfaces/data: `--compact` flag → `compact: bool`, default False.
- Test seam and RED condition: `test_compact_accepted` asserts the command runs
  with `--compact`; it fails today because the option does not exist.
- Implementation outline: add `@click.option("--compact", is_flag=True)` and pass
  `compact=compact` into the render call; `render_log` ignores the argument for
  now.
- Verification: `uv run pytest tests/test_logs.py`
- Blocked by: none
- Risks: none material

### 2. Compact rendering

- Changes: `cli/logs.py` — branch in `render_log` on `compact`.
- Interfaces/data: with `compact=True`, `render_log` returns a space-joined
  `ts level message` line instead of a JSON line.
- Test seam and RED condition: `test_compact_output` asserts stdout has exactly
  the three fields and no JSON keys; it fails until the branch lands.
- Implementation outline: when compact, join the three record fields in order;
  otherwise keep the existing `json.dumps` output.
- Verification: `uv run pytest tests/test_logs.py`; a manual smoke run
  `uv run python -m cli.logs --compact`.
- Blocked by: slice 1
- Risks: field order is a format decision — the RED test pins it, so it is
  explicit rather than implicit.

## Final Verification

- `uv run pytest tests/`
- `uv run python -m cli.logs` (no flag) still prints JSON lines.

## Assumptions and Open Questions

- Assumption: every record carries `ts`, `level`, and `message`. Confirm at
  `cli/logs.py::LogRecord` when executing slice 2.
- Open question: should `--compact` also accept `-c`? Deferred; not blocking.

## Non-Goals

- No change to default JSON output, no persistent data, no public contract, no
  rollout steps — hence no Migration and Rollback section.
