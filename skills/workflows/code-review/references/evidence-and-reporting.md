# Evidence and Reporting

## Finding gate

Answer every question for each candidate finding:

1. **Changed site**: Which changed line introduced or exposed the problem?
2. **Trigger**: What input, state, permission, scale, or timing triggers it?
3. **Path**: Which functions, branches, or external boundaries lead from entry to failure?
4. **Consequence**: What concrete change occurs for users, data, security, latency, or maintenance?
5. **Defenses**: Why do types, validation, callers, framework behavior, tests, or deployment constraints fail to prevent it?
6. **Evidence**: Which command, failing test, static rule, specification clause, or complete code trace lets another engineer verify it?

If questions 1–5 cannot all be answered, remove the candidate or place it under Open questions. When supporting code is pre-existing, explain how the diff makes the problem newly reachable or more dangerous. Otherwise label it `pre-existing` and exclude it from the change verdict.

## Evidence strength

Prefer evidence in this order:

1. **REPRODUCED**: a minimal test or command reliably produces the expected failure.
2. **TRACED**: a complete code/data-flow trace and deterministic constraints prove the failure without destructive execution.
3. **TOOL**: a type checker, linter, build, scanner, or existing test reports a locatable failure.
4. **HEURISTIC**: a pattern is suspicious but lacks trigger or environment evidence. Place it only under Open questions; it cannot block.

Prefer existing repository tests and tools. Put temporary reproductions under `/tmp` or another side-effect-free location and report the path. Do not execute against production data, credentials, paid APIs, network targets, or other side-effecting systems. Use TRACED evidence or request authorization instead.

## Severity

- **CRITICAL**: an exploitable security flaw, irreversible data loss, authorization bypass, or broad outage. Require REPRODUCED evidence, or an end-to-end TRACED path with every existing defense checked.
- **HIGH**: an incorrect result, regression, compatibility break, or significant resource failure reachable through a normal or reasonable scenario. Require REPRODUCED, TOOL, or complete TRACED evidence.
- **MEDIUM**: a real defect in a constrained scenario, a recovery or diagnosability failure, or a design regression with demonstrated cost.
- **LOW**: a localized, non-blocking problem with a clear impact and correction.

Derive severity from impact and reachability, not from the checklist category. Downgrade weakly supported claims or move them to Open questions.

## Verdict rules

Keep `Review Verdict` and `Verification State` separate.

- `BLOCK`: at least one CRITICAL finding.
- `REQUEST CHANGES`: at least one HIGH finding, or verification has a change-introduced or unknown required failure.
- `APPROVE WITH COMMENTS`: only MEDIUM or LOW findings, with no change-introduced or unknown required failure and no blocked evidence that prevents a safe conclusion.
- `APPROVE`: no findings, no change-introduced or unknown required failure, and no blocked evidence that prevents a safe conclusion.
- `INCONCLUSIVE`: the scope cannot be fixed, or required evidence is blocked and could change the review conclusion.

A proven baseline-only failure may coexist with `APPROVE` or `APPROVE WITH COMMENTS`, but `Verification State` remains `NOT READY` and the report must not imply release readiness. Unrelated environment failures require the same explicit separation and become `INCONCLUSIVE` when the missing evidence could change review safety.

## Report format

After the report title and scope metadata, put Findings first. When there are none, write `No findings.` instead of manufacturing filler.

```markdown
# Code Review: <change topic>

- Date: YYYY-MM-DD
- Scope: `<base>..<target>` or worktree vs `HEAD`
- Source specification: `<path or none>`
- Source IDs: `<REQ/INV/AC identifiers or none>`
- Verification exclusion: `<reserved review artifact path only>`
- Verification Stage: `pre-review`
- Verification State: `READY | NOT READY | BLOCKED`

## Findings

### [HIGH] Short title describing the failure
- Location: `path/to/file.ext:42`
- Lens: Correctness | Security | Performance | Maintainability
- Trigger: Concrete input, state, scale, or timing
- Impact: Observable failure or risk
- Evidence: REPRODUCED | TRACED | TOOL — path or command with the key result
- Source IDs: `REQ-NNN`, `INV-NNN`, `AC-NNN`, or `N/A`
- Fix direction: Smallest direction that restores the invariant; omit unrelated refactoring

## Open questions
- Missing evidence and how the answer would change the verdict

## Verification evidence
Copy the applicable rows from the single verification report; do not discover or execute a second gate set.

| Gate | Result | Method / evidence |
|---|---|---|
| Types | PASS/FAIL/N/A/BLOCKED | `...` |
| Lint | PASS/FAIL/N/A/BLOCKED | `...` |
| Tests | PASS/FAIL/N/A/BLOCKED | `...` |
| Build | PASS/FAIL/N/A/BLOCKED | `...` |

## Requirement coverage
- `<source ID>`: satisfied | violated by finding | not implemented | out of scope — <evidence>

## Coverage
- Scope: `<base>..<target>` or worktree vs `HEAD`
- Reviewed: every file, grouped by status
- Skipped/special handling: file and reason

## Review Verdict
`APPROVE | APPROVE WITH COMMENTS | REQUEST CHANGES | BLOCK | INCONCLUSIVE`

One sentence stating the highest severity, separate Verification State, and residual risk.
```

For commands, retain the exit code and first actionable error without pasting large logs. Redact secrets, tokens, personal data, and attack payloads.
