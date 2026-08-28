# Test Runner Detection

Use repository evidence to discover commands. Do not assume `npm test`, pytest, or any preferred tool.

## Evidence order

1. Read repository instructions (`AGENTS.md`, `CONTRIBUTING.md`, README, CI definitions).
2. Identify workspace/package boundaries and the files affected.
3. Inspect task configuration and canonical scripts.
4. Identify the package/environment manager from manifest and lockfiles.
5. Inspect nearby tests and runner configuration.
6. Confirm the narrowest command can list or execute the target without changing dependencies.

When evidence conflicts, ask which source is authoritative rather than guessing.

## Separate three decisions

- **Environment/package manager:** installs and resolves dependencies.
- **Test runner:** discovers and executes tests.
- **Repository command:** wraps the runner with required configuration, services, or workspace scope.

Prefer the repository command. A project using Bun, pnpm, uv, Gradle, or Cargo may still wrap a different runner or custom integration harness.

## Common evidence

### JavaScript and TypeScript

Inspect `package.json#packageManager`, the authoritative lockfile, workspace configuration, and `scripts`. Distinguish:

- `bun test`: Bun's native test runner;
- `bun run test`: the package script named `test`;
- package scripts that invoke Jest, Vitest, Playwright, Node test, or another runner.

Pass filters using the syntax supported by the actual script and runner. Do not bypass a script that prepares environment variables or services.

### Python

Inspect `pyproject.toml`, lockfiles, pytest/unittest configuration, tox/nox sessions, and project instructions. In uv-managed projects, use `uv run` with the configured command. Do not install missing test or coverage dependencies without approval.

### Go

Inspect `go.mod`, workspace files, build tags, Make/task files, and CI. `go test` may require package scope, tags, race detection, generated assets, or external services.

### Rust

Inspect `Cargo.toml`, workspace membership, feature flags, task aliases, and CI. Choose package, test target, and features from project evidence.

### JVM and .NET

Prefer the repository's Gradle/Maven wrapper or `dotnet` solution/project command. Preserve configured profiles, test categories, and integration-test phases.

## Establish command scopes

Resolve commands for:

1. **Focused cycle:** one file, package, class, or test selector for fast RED/GREEN feedback.
2. **Affected scope:** the owning package/module and nearby integration tests.
3. **Repository gate:** configured test, lint, type, build, and coverage checks required for completion.

A focused command does not replace the repository gate. A repository-wide command need not run after every keystroke when a reliable narrower scope exists.

## Safe execution

- Run non-interactive, one-shot commands in agent sessions; avoid watch mode unless explicitly requested.
- Preserve lockfiles and dependency state during test execution.
- Do not auto-install another package manager or silently invoke package executors that download tools.
- Identify required databases, brokers, browsers, credentials, containers, or fixtures before the RED gate.
- Report unavailable infrastructure as a blocker or assumption rather than converting an integration test into a misleading unit test.

## Completion record

Capture:

```text
Focused command: <command and source>
Affected command: <command and source>
Repository gates: <commands and source>
Required services/fixtures: <list>
Unresolved ambiguity: <none or question>
```
