---
name: verification-loop
description: Run evidence-based build, type, lint, test, security, and diff verification after meaningful code changes or before a pull request. Use to determine whether a change is ready without assuming a language or package manager.
---

# Verification Loop

Use the project's own configuration and scripts to verify a change. Do not assume npm, a JavaScript stack, hooks, or a fixed `/verify` command.

## Principles

- Detect before executing: read manifests, lockfiles, CI configuration, and applicable `AGENTS.md`.
- Prefer canonical project scripts and local tools.
- For Python, use `uv run` or `uvx`; never bare `python`, `pip`, `pytest`, `ruff`, or `pyright`.
- If `uv` is unavailable, install it automatically with Astral's official standalone installer, refresh `PATH`, verify `uv --version`, and continue. This tooling bootstrap does not require approval.
- Do not install, upgrade, or auto-fix project dependencies without approval.
- Do not truncate away the first useful error. Capture complete output when needed, but summarize it.
- A failing required gate means **NOT READY**. Do not mark work complete or create a PR.

## Phase 0: Establish Scope

1. Inspect `git status --short`, `git diff --stat`, and the relevant diff without modifying the worktree.
2. Identify affected languages, services, packages, tests, and generated artifacts.
3. Resolve the authoritative package manager and commands from project evidence.
4. Define required versus optional gates before running them.

## Phase 1: Fast Checks

Run the narrowest applicable checks first:

- formatter/check mode
- lint on affected scope
- type-check on affected package
- focused unit or regression tests

For Python projects, examples are `uv run ruff check <scope>`, `uv run mypy <scope>`, and `uv run pytest <test-path>` only when those tools are configured.

Stop and fix root causes incrementally. Do not hide failures with ignores, broad type escapes, skipped tests, or disabled rules.

## Phase 2: Build

Run the canonical build for each affected package or service. Report exact commands, exit codes, and the first actionable error. If no build exists, mark this gate **N/A** with evidence rather than inventing one.

## Phase 3: Test Suite and Coverage

Run affected unit and integration tests, then the broader relevant suite. Run critical E2E flows when the change affects user journeys or integration boundaries.

Use configured coverage thresholds. If none exist, report measured coverage and uncovered critical paths; do not silently introduce a threshold. Treat skipped or flaky tests as explicit risks.

## Phase 4: Security Review

Inspect the changed boundaries for:

- hardcoded secrets or sensitive data in code, logs, fixtures, and diffs
- missing input validation or authorization
- injection, XSS, CSRF, SSRF, path traversal, unsafe deserialization, and command execution
- dependency or lockfile changes
- unsafe file permissions and accidental generated artifacts

Use configured scanners when available. A grep for key-shaped strings is only a heuristic and is not proof of safety. Never print secret values in the report.

## Phase 5: Diff Review

Review every changed file for unintended edits, contract mismatches, mutation, missing error handling, edge cases, stale documentation, and missing tests. Compare against the approved plan or acceptance criteria when available.

## Report

Produce:

```text
VERIFICATION REPORT
===================
Scope:     [packages/files]
Build:     [PASS/FAIL/N/A] — command and evidence
Types:     [PASS/FAIL/N/A] — error count
Lint:      [PASS/FAIL/N/A] — warning/error count
Tests:     [PASS/FAIL/N/A] — passed/failed/skipped
Coverage:  [PASS/FAIL/N/A] — configured threshold or measured result
Security:  [PASS/FAIL] — findings by severity
Diff:      [PASS/FAIL] — files reviewed
Overall:   [READY/NOT READY]

Blocking issues:
1. ...

Non-blocking risks:
1. ...
```

Run this loop after each logical milestone and before a pull request. For long tasks, prefer meaningful milestones over arbitrary time intervals.
