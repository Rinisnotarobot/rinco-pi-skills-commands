---
name: code-review
description: Evidence-first review of Git diffs that writes a final Markdown report to disk.
compatibility: Requires the verification skill to be discoverable in the same Pi session.
disable-model-invocation: true
---

# Code Review

Review the Git scope supplied after `/skill:code-review`. With no scope, review every worktree change relative to `HEAD`. Persist the final report; do not modify the reviewed code.

Before starting, confirm that `verification` appears in the current session's available Skills. Stop with `BLOCKED`, name the missing Skill, and provide a relaunch command when it is unavailable.

## Workflow

### 1. Pin the review scope

Read the applicable `AGENTS.md`, contribution guide, and repository rules. Follow [Scope and Context](references/scope-and-context.md) to parse the arguments, verify refs, record the base and target, and list modified, deleted, renamed, and untracked files.

Stop when the scope cannot be resolved or the diff is empty. Report the exact commands and results instead of guessing the user's intent.

Completion criterion: the base, target, diff command, and complete review file list are fixed.

### 2. Reconstruct the change intent

Extract expected behavior and constraints from the user request, source specification and its `REQ`/`INV`/`AC` identifiers, implementation plan, commit messages, change description, tests, and related documentation. State assumptions when evidence is missing. Ask the user only when the missing information could change the review verdict.

Completion criterion: every change cluster maps to an expected behavior, constraint, or explicitly identified unknown.

### 3. Read the full context

Read the diff and full contents of every file in scope. Trace affected callers, callees, types, configuration, migrations, and tests. Read deleted files from the base revision. Classify generated files, vendored code, lockfiles, and binaries separately, and state how each was reviewed.

Completion criterion: every file in scope has been examined or has a checkable reason for special handling.

### 4. Apply four review lenses

Read [Review Lenses](references/review-lenses.md). Examine every change cluster through all four lenses:

1. correctness;
2. security;
3. performance;
4. maintainability.

Adjust depth to risk, but record a conclusion for every lens. Prioritize problems introduced or exposed by the diff. Label related pre-existing problems explicitly as `pre-existing`. Under the maintainability lens, report structural findings in the `codebase-design` vocabulary — shallow interfaces, leaked implementation details, misplaced seams — so each recommendation targets the seam that should own the change.

Completion criterion: every change cluster has passed through all four lenses, and each candidate finding points to a changed line and an affected execution path.

### 5. Try to disprove candidate findings

Apply the finding gate in [Evidence and Reporting](references/evidence-and-reporting.md) to every candidate. Check existing guards, type constraints, framework behavior, callers, and tests. When safe, run the narrowest test or read-only command that can reproduce the failure. Avoid external side effects and persistent data changes.

Remove candidates that lack a trigger, execution path, or concrete consequence from Findings; place unresolved but consequential uncertainty under Open questions. Zero findings is a valid result.

Completion criterion: every Finding passes the evidence gate, and its severity matches its evidence strength.

### 6. Consume the verification state

Use the model-invoked `verification` skill as the single owner of gate discovery, freshness, execution, attribution, and `READY`/`NOT READY`/`BLOCKED`. Before verification, reserve the final review artifact path using step 7's path rules and explicitly exclude only that path from the pinned verification scope. Reuse an existing report only when the remaining review scope and current worktree state match; otherwise run verification once for the `pre-review` stage. The current review itself is a downstream gate and remains `PENDING` during that run. Do not rerun a reusable passed gate merely to duplicate ownership.

Keep review read-only. Do not install, upgrade, auto-fix, restore, or rewrite reviewed files. The final review artifact is the only expected repository change. An unavailable required gate is `BLOCKED`, not `N/A`; reserve `N/A` for a gate that does not apply.

Record `Verification Stage` and `Verification State` separately from `Review Verdict`, including every command or non-command method, result, attribution, downstream gate, and residual risk.

Completion criterion: the review has one current verification state for its exact scope, with no independently maintained second gate table.

### 7. Persist and report the verdict

Use the format in [Evidence and Reporting](references/evidence-and-reporting.md). Order Findings by severity. Include `file:line`, trigger, impact, evidence, and the smallest viable fix direction. Follow with Open questions, verification results, and file coverage.

Only confirmed problems caused by the reviewed change affect the findings verdict. Apply the verification-to-review mapping in [Evidence and Reporting](references/evidence-and-reporting.md): change-introduced or unknown required failures prevent approval; proven baseline failures remain a separate `Verification State`; blocked evidence produces `INCONCLUSIVE` when it prevents a safe review conclusion.

Choose the artifact path in this order:

1. an exact path supplied by the user;
2. an authoritative review directory defined by the repository;
3. `docs/reviews/YYYY-MM-DD-<slug>.md`.

Build `<slug>` from the change topic or branch name as lowercase ASCII kebab-case; use `code-review` when no safe slug remains. Use the current local date. Preserve existing artifacts: if the path exists, append `-2`, `-3`, and so on before `.md` rather than overwriting it.

After the verdict is final, create the parent directory, write the complete report as one Markdown file, read it back, and confirm that no Findings, validation evidence, requirement coverage, or file coverage entries were truncated. Confirm that this reserved artifact is the only post-verification worktree mutation; otherwise mark the verification evidence stale and rerun it for the corrected scope. Return the artifact path, verdict, finding counts, and verification summary in the conversation instead of duplicating the full report.

Completion criterion: the final review exists at the reported path, and another engineer can reproduce every conclusion from its scope, locations, and commands.
