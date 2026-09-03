# Implementation Plan: Remaining Skill Portfolio — Security Review, Resilience, Frontend Patterns

## Goal and Scope

Continue the Skill portfolio with the three surviving targets from the superseded
2026-08-28 roadmap. Each Skill stays small, composable, and evidence-gated under the
same promotion discipline as the rest of the repository: draft under
`processing/skills/`, review, then promote to a category under `skills/`.

Dropped targets (not carried forward):

| Dropped target | Disposition |
|---|---|
| `codebase-onboarding` | Dropped; `processing/skills/codebase-onboarding/` removed. |
| `migration` | Dropped; planning guidance remains under `skills/workflows/plan/references/migrations-and-rollout.md`. |
| `release-readiness` | Dropped; no standalone draft existed. Shared sources (`deployment-patterns`, `git-workflow`, `github-ops`) remain in `processing/` for their other consumers. |

## Current State

| Skill | Invocation | Existing sources |
|---|---|---|
| `security-review` | model-invoked | `processing/skills/security-review/` — large cookbook; must be rewritten around decisions and gates |
| `resilience` | model-invoked | `processing/skills/error-handling/` plus the backend resilience reference |
| `frontend-patterns` | model-invoked | `processing/skills/frontend-patterns/` and `processing/skills/react-patterns/` |

## Responsibility

| Skill | Responsibility |
|---|---|
| `security-review` | Review changed trust boundaries and report only evidence-backed exploit paths. |
| `resilience` | Design and review deadlines, retries, idempotency, partial failure, and recovery. |
| `frontend-patterns` | Apply framework-neutral frontend boundaries with disclosed React guidance. |

## Implementation Slices

### 1. Promote `security-review`

- **Delivers:** high-confidence findings tied to a changed trust boundary, attacker control, exploit path, and concrete impact.
- **Changes:** rewrite `processing/skills/security-review/` into a concise core with disclosed trust-boundary, web, data, and supply-chain references; promote it and update README.
- **Manual gate:** retain a traced authorization bypass and injection path while rejecting framework-protected input, prevalidated internal input, and generic missing-control claims without an attacker path.
- **Risk:** overlap with `code-review`. Keep broad review in `code-review`; invoke this Skill only for deep trust-boundary analysis.
- **Blocked by:** none.

### 2. Add `resilience`

- **Delivers:** design and review gates for deadlines, cancellation, retries, idempotency, partial failure, backpressure, and recovery.
- **Changes:** create `processing/skills/resilience/`, drawing from `error-handling` and the backend resilience reference; promote it, update README, then retire `error-handling` after mapping unique behavior.
- **Manual gate:** reject unprotected retries for non-idempotent unknown-outcome writes, detect retry amplification, and require timeout/cancellation propagation at remote boundaries.
- **Blocked by:** `verification` and security evidence contracts.

### 3. Promote consolidated `frontend-patterns`

- **Delivers:** framework-neutral frontend boundaries with disclosed React-specific composition, state, accessibility, performance, and client/server guidance.
- **Changes:** rewrite `processing/skills/frontend-patterns/`, incorporate only validated material from `react-patterns`, promote it, update README, and retire the superseded React pattern draft.
- **Manual gate:** choose local state for local interaction, reject unconditional memoization, preserve accessible semantics, and keep server-only data outside client boundaries.
- **Blocked by:** `spec` and `resilience`.

## Promotion Gate

For every remaining Skill:

1. research the required first-party sources and ecosystem candidates (`npx skills find <query>`, then crawl the selected README and exact `SKILL.md`);
2. draft or rewrite under `processing/skills/<name>/`;
3. review frontmatter, invocation contract, completion criteria, evidence gates, and local references;
4. exercise one positive trigger, one non-trigger, one blocked scenario, and one clean scenario;
5. promote the directory to the matching category under `skills/` (`workflows/`, `patterns/`, `tools/`, or `meta/`);
6. update README and remove superseded drafts only after unique material is accounted for;
7. run `git diff --check` and inspect `git status --short`.

## Rollback

For any slice: remove the new README entry; move the promoted directory back to
`processing/skills/` or restore the superseded source from version control; recheck local
links and repository state; preserve unrelated promoted Skills and local work.

## Completion Evidence

- all three target Skills promoted;
- zero superseded duplicate candidates for migrated responsibilities;
- frontmatter names agree with directory names;
- invocation modes are explicit;
- every local Markdown path exists;
- README inventory is complete;
- each manual scenario gate has recorded evidence;
- every source URL was actually consulted;
- `git diff --check` passes.
