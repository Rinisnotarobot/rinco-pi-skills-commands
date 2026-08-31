# Implementation Plan: Complete Skill Portfolio Roadmap

## Goal and Scope

Build a small, composable, evidence-gated Skill portfolio around the validated `plan → code-review → verification` flow. Deliver ten independently promotable Skills:

1. `verification`
2. `systematic-debugging`
3. `spec`
4. `fix`
5. `security-review`
6. `codebase-onboarding`
7. `resilience`
8. `migration`
9. `frontend-patterns`
10. `release-readiness`

Each Skill must:

- start as a draft under `processing/skills/<name>/`;
- use progressive disclosure (`SKILL.md` plus only necessary references);
- declare an explicit user- or model-invocation contract;
- contain checkable phase completion criteria and evidence gates;
- be reviewed before promotion to `skills/<name>/`;
- be listed in `README.md` only after promotion;
- preserve source attribution for the eventual commit or PR description.

The roadmap covers Skills only. It does not add repository validation infrastructure or change distribution behavior.

Completion evidence:

- all ten target Skill directories are promoted;
- frontmatter, directory names, invocation modes, local references, and README entries agree;
- each Skill passes its documented manual scenario review;
- superseded processing drafts are removed only after replacement responsibilities are mapped;
- all required source URLs and local adaptations are recorded.

## Current State

Promoted targets:

- `verification`
- `systematic-debugging`
- `spec`

Remaining targets:

- `fix`
- `security-review`
- `codebase-onboarding`
- `resilience`
- `migration`
- `frontend-patterns`
- `release-readiness`

Repository facts:

- `processing/skills/` holds drafts while `skills/` holds promoted Skills.
- Project policy requires first-party research through mattpocock/skills, ECC, and the Skills CLI before creating or rewriting a Skill.
- Existing security, error-handling, and frontend candidates are large cookbook-style documents and must be rewritten around decisions and gates.
- Migration planning already exists in `skills/workflows/plan/references/migrations-and-rollout.md`; migration execution remains a separate responsibility.

## Selected Strategy

Use one top-level Skill per independent invocation concept. Keep orchestration user-invoked and reusable disciplines model-invoked.

| Skill | Invocation | Responsibility |
|---|---|---|
| `verification` | model-invoked | Discover and execute repository quality gates; return READY/NOT READY evidence |
| `systematic-debugging` | model-invoked | Reproduce, isolate, and prove the root cause of an observed failure |
| `spec` | user-invoked | Convert a sufficiently explored idea into a durable acceptance specification |
| `fix` | user-invoked | Orchestrate diagnosis, minimal repair, verification, and optional review without duplicating verdicts |
| `security-review` | model-invoked | Review changed trust boundaries and report only evidence-backed exploit paths |
| `codebase-onboarding` | user-invoked | Build an evidence-cited repository map and optional onboarding artifact |
| `resilience` | model-invoked | Design and review deadlines, retries, idempotency, partial failure, and recovery |
| `migration` | model-invoked | Govern execution and review of data, API, dependency, and runtime migrations |
| `frontend-patterns` | model-invoked | Apply framework-neutral frontend boundaries with disclosed React guidance |
| `release-readiness` | user-invoked | Produce a readiness verdict from verification, migration, rollback, and observability evidence |

Design rules:

- Keep each `SKILL.md` focused on ordered behavior; move branch-specific material to `references/`.
- Reuse the evidence vocabulary already present in `plan`, `code-review`, and `verification`.
- Retire duplicate processing candidates only after the replacement is promoted and their unique material is accounted for.
- Keep `release-readiness` read-only: it determines readiness but does not push, publish, or deploy.
- Keep `migration` focused on execution and review gates; retain `plan` guidance for transition design.
- Keep framework-specific APIs behind disclosed references verified against current official documentation.

## Source and Retirement Map

| Target | Primary existing sources | Superseded processing content after promotion |
|---|---|---|
| `verification` | promoted implementation and repository gate-discovery references | none |
| `systematic-debugging` | promoted implementation and terminal evidence rules | none |
| `spec` | promoted implementation, `product-lens`, `grilling` | keep `product-lens` and `grilling` distinct |
| `fix` | `processing/commands/fix.md`, `systematic-debugging`, `verification`, `code-review` | reduce the command to a compatibility pointer after promotion |
| `security-review` | `processing/skills/security-review/`, backend security reference | remove the processing source after promotion |
| `codebase-onboarding` | `processing/skills/codebase-onboarding/` | remove the processing source after promotion |
| `resilience` | `processing/skills/error-handling/`, backend messaging/resilience reference | remove `error-handling` after behavior mapping |
| `migration` | `skills/workflows/plan/references/migrations-and-rollout.md` | none; planning and execution remain separate |
| `frontend-patterns` | `frontend-patterns`, `react-patterns` | retire both drafts after consolidation |
| `release-readiness` | verification, deployment-patterns, git-workflow, gh, github-ops | none in this roadmap |

## Remaining Implementation Slices

### 1. Add `fix`

- **Delivers:** one explicit entry point for repairing a reported defect, build/type failure, CI failure, or evidence-backed review finding.
- **Changes:** create `processing/skills/fix/SKILL.md`, review it, promote it to `skills/fix/`, update README, then reduce `processing/commands/fix.md` to a compatibility pointer.
- **Workflow:** pin repository state and requested failure; classify the cause as unknown, proven, or non-behavioral; route unknown causes to `systematic-debugging`; make the smallest safe correction; delegate final evidence to `verification`; leave optional review to `code-review`.
- **Manual gate:** unknown causes cannot reach implementation before causal evidence exists; stale evidence is rejected; unsafe external effects and unapproved dependency changes stop the workflow.
- **Blocked by:** promoted `systematic-debugging`, `spec`, and `verification` contracts.

### 2. Promote `security-review`

- **Delivers:** high-confidence findings tied to a changed trust boundary, attacker control, exploit path, and concrete impact.
- **Changes:** rewrite `processing/skills/security-review/` into a concise core with disclosed trust-boundary, web, data, and supply-chain references; promote it and update README.
- **Manual gate:** retain a traced authorization bypass and injection path while rejecting framework-protected input, prevalidated internal input, and generic missing-control claims without an attacker path.
- **Risk:** overlap with `code-review`. Keep broad review in `code-review`; invoke this Skill only for deep trust-boundary analysis.

### 3. Promote `codebase-onboarding`

- **Delivers:** an evidence-cited repository map for an unfamiliar codebase, with unknowns and confidence separated from facts.
- **Changes:** rewrite `processing/skills/codebase-onboarding/` with architecture-mapping and artifact references; promote it and update README.
- **Manual gate:** a repository with multiple entry points must expose each path and label opaque external boundaries as unknown; package-manager commands cannot be inferred without repository evidence.
- **Risk:** overlap with plan exploration. Onboarding creates a reusable map; planning remains change-specific.

### 4. Add `resilience`

- **Delivers:** design and review gates for deadlines, cancellation, retries, idempotency, partial failure, backpressure, and recovery.
- **Changes:** create `processing/skills/resilience/`, drawing from `error-handling` and the backend resilience reference; promote it, update README, then retire `error-handling` after mapping unique behavior.
- **Manual gate:** reject unprotected retries for non-idempotent unknown-outcome writes, detect retry amplification, and require timeout/cancellation propagation at remote boundaries.
- **Blocked by:** verification and security evidence contracts.

### 5. Add `migration`

- **Delivers:** preflight, rollout, reconciliation, stop, rollback, and cleanup gates for data, API/protocol, dependency, and runtime migrations.
- **Changes:** create `processing/skills/migration/` with data, API, and dependency references; promote it and update README while retaining planning guidance under `skills/workflows/plan/`.
- **Manual gate:** destructive migrations stop without backup or recovery evidence; resumable batches prove repeated execution is safe and reconciliation catches divergence.
- **Blocked by:** `spec`, `verification`, and `resilience`.

### 6. Promote consolidated `frontend-patterns`

- **Delivers:** framework-neutral frontend boundaries with disclosed React-specific composition, state, accessibility, performance, and client/server guidance.
- **Changes:** rewrite `processing/skills/frontend-patterns/`, incorporate only validated material from `react-patterns`, promote it, update README, and retire the superseded React pattern draft.
- **Manual gate:** choose local state for local interaction, reject unconditional memoization, preserve accessible semantics, and keep server-only data outside client boundaries.
- **Blocked by:** `spec` and `resilience`.

### 7. Add `release-readiness`

- **Delivers:** an evidence-based readiness verdict without performing push, release, deployment, or other externally consequential actions.
- **Changes:** create `processing/skills/release-readiness/` with rollout, rollback, and reporting references; promote it and update README.
- **Output:** `READY`, `READY WITH ACCEPTED RISKS`, `NOT READY`, or `BLOCKED`.
- **Manual gate:** block on failed required gates, incomplete irreversible migrations, or absent rollback ownership; avoid imposing irrelevant deployment checks on documentation-only releases.
- **Blocked by:** `verification`, `security-review`, and `migration`.

## Promotion Gate

For every remaining Skill:

1. research the required first-party sources and ecosystem candidates;
2. draft or rewrite under `processing/skills/<name>/`;
3. review frontmatter, invocation contract, completion criteria, evidence gates, and local references;
4. exercise one positive trigger, one non-trigger, one blocked scenario, and one clean scenario;
5. promote the directory to `skills/<name>/`;
6. update README and remove superseded drafts only after unique material is accounted for;
7. run `git diff --check` and inspect `git status --short`.

Rollback for any slice:

- remove the new README entry;
- move the promoted directory back to `processing/skills/` or restore the superseded source from version control;
- recheck local links and repository state;
- preserve unrelated promoted Skills and local work.

## Final Verification

Review the completed portfolio against this matrix:

- 10/10 target Skills promoted;
- zero superseded duplicate candidates for migrated responsibilities;
- frontmatter names agree with directory names;
- invocation modes are explicit;
- every local Markdown path exists;
- README inventory is complete;
- each manual scenario gate has recorded evidence;
- every source URL was actually consulted;
- `git diff --check` passes.

Distribution, installation, upgrade, rollback, and global-state validation remain deferred until the target portfolio is complete and the repository designs a dedicated delivery phase.

## Assumptions and Non-Goals

- English remains the implementation language for new Skill bodies and references; `README.md` keeps its Chinese catalog style.
- `spec` remains user-invoked.
- `migration` is a top-level model-invoked execution discipline, while planning guidance remains in `plan`.
- `release-readiness` reports readiness and performs no external mutation.
- Commands remain out of scope except compatibility pointers updated after replacement Skills are promoted.
- No installation or distribution mechanism is added before the complete portfolio passes integration review.
- No automatic Git commit, push, PR, release, or deployment behavior is added.
- Existing promoted Skills are not rewritten by this roadmap.

## Reference Sources

Sources already consulted while shaping this roadmap:

- https://github.com/mattpocock/skills
- https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md
- https://github.com/affaan-m/everything-claude-code
- https://skills.sh/obra/superpowers/systematic-debugging
- https://skills.sh/github/awesome-copilot/create-specification
- https://skills.sh/getsentry/skills/security-review

Before implementing each slice, rerun `npx skills find <focused query>` and crawl the selected first-party README and exact `SKILL.md`. Record install count, repository reputation, security-audit status, borrowed patterns, and local adaptations. Treat conflicting evidence or failed audits as a reason to wrap or rewrite rather than install directly.
