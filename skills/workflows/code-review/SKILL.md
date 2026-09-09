---
name: code-review
description: Evidence-first review of a Git diff, merge request, or worktree change that writes a final Markdown report to disk without modifying reviewed code. Use when the user asks to review a change or PR/MR, wants evidence-backed findings with a verdict, or hands a scope to /skill:code-review.
---

# Code Review

Review the Git scope the user names — supplied directly or via `/skill:code-review`. With no scope, review every worktree change relative to `HEAD`. Persist the final report; do not modify the reviewed code.

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

Adjust depth to risk, but record a conclusion for every lens. Prioritize problems introduced or exposed by the diff. Label related pre-existing problems explicitly as `pre-existing`. Under the maintainability lens, report structural findings in seam vocabulary — shallow interfaces, leaked implementation details, misplaced seams — so each recommendation targets the seam that should own the change.

Completion criterion: every change cluster has passed through all four lenses, and each candidate finding points to a changed line and an affected execution path.

### 5. Try to disprove candidate findings

Apply the finding gate in [Evidence and Reporting](references/evidence-and-reporting.md) to every candidate. Check existing guards, type constraints, framework behavior, callers, and tests. When safe, run the narrowest test or read-only command that can reproduce the failure. Avoid external side effects and persistent data changes.

Remove candidates that lack a trigger, execution path, or concrete consequence from Findings; place unresolved but consequential uncertainty under Open questions. Zero findings is a valid result.

Completion criterion: every Finding passes the evidence gate, and its severity matches its evidence strength.

### 6. Establish the pre-review state

A verdict about a diff needs to know whether the code is in a working state at the reviewed scope. Gather that state before the verdict, read-only, from the freshest available source:

- a verification report the user already has — reuse its gate rows when its scope and worktree state match the review;
- otherwise, run the narrowest read-only gates yourself — types, lint, and the affected tests where safe — capturing `git status --short` before and after;
- when neither is possible, record the missing state explicitly — unproven breakage belongs in Open questions or limits the verdict, never in a silent assumption.

Base the gate set on the current stage's verification contract: discover required gates from repository instructions and CI configuration, not from a remembered default list. Run the read-only, narrow ones; for every required gate you do not run — one that needs generated artifacts, a build step, external state, or approval — record the gate and why. Synthesize the single Verification State exactly as the `verification` method does: `READY` only when every required gate due in the current stage is `PASS` or has a credible `N/A` reason; `NOT READY` when any required gate is `FAIL`; `BLOCKED` when a required gate due now cannot be evidenced. Per-gate `PASS` rows record local progress but never re-define the overall state — a partial gate set produces no narrower `READY`. Evidence owned by a later stage remains `PENDING` and does not block this one.

Reserve the final review artifact path (step 7) before running gate commands, so the review's own artifact is not treated as a change under review. Keep one state table: record `Verification State` separately from `Review Verdict`. A proven baseline failure can coexist with `APPROVE WITH COMMENTS`; a change-introduced failure blocks it.

Keep review read-only. Do not install, upgrade, auto-fix, restore, or rewrite reviewed files. The final review artifact is the only expected repository change. An unavailable required gate is `BLOCKED`, not `N/A`; reserve `N/A` for a gate that does not apply.

Completion criterion: the review has one current verification state for its exact scope — from a matching report or its own read-only gates, synthesized under the `verification` rules — with no second, independently maintained gate table.

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
