# Implementation Plan: Complete Skill Portfolio Roadmap

## Goal and Scope

Build a small, composable, evidence-gated Skill portfolio around the validated `plan → tdd → code-review` flow. Deliver ten independently promotable Skills in this order:

1. `verification`
2. `systematic-debugging`
3. `spec`
4. `security-review`
5. `codebase-onboarding`
6. `resilience`
7. `migration`
8. `testing-adapters`
9. `frontend-patterns`
10. `release-readiness`

Each Skill must:

- start as a draft under `processing/skills/<name>/`;
- use progressive disclosure (`SKILL.md` plus only necessary references);
- declare an explicit user- or model-invocation contract;
- contain checkable phase completion criteria and behavioral gates;
- be validated before promotion to `skills/<name>/`;
- be listed in `README.md` only after promotion;
- preserve source attribution for the eventual commit or PR description.

The roadmap covers Skills only. It does not change anything under `processing/commands/`.

Acceptance evidence:

- all ten promoted Skill directories pass the repository Skill contract test;
- each Skill passes its scenario-specific manual gate described below;
- `README.md` identifies invocation type and purpose without duplicating the full Skill body;
- superseded processing drafts are removed only after their replacement passes all gates.

## Repository Evidence

```text
Fact: only backend-patterns, code-review, plan, and tdd were validated Skills when this roadmap was written.
Evidence: skills/*/SKILL.md and README.md::已处理并验证
Plan implication: every roadmap item needs a processing draft, validation, promotion, and README update.
```

```text
Fact: `processing/skills/` holds drafts while `skills/` holds promoted, repository-validated Skills.
Evidence: AGENTS.md::新 Skill 的产出规则 and README.md::目录结构
Plan implication: a processing-only candidate cannot satisfy acceptance; promotion is a required step in every slice.
```

```text
Fact: project policy requires first-party research through mattpocock/skills, ECC, and the Skills CLI before creating or rewriting a Skill.
Evidence: AGENTS.md::构建新 Skill 必须先查参考源
Plan implication: each Skill slice begins with a recorded research gate and must prefer wrapping a mature implementation over self-development when quality evidence supports it.
```

```text
Fact: the current verification draft already has scope, fast-check, build, test, security, diff, and report phases.
Evidence: processing/skills/verification-loop/SKILL.md::Phase 0–5 and Report
Plan implication: refactor and rename this candidate instead of introducing a second overlapping verification Skill.
```

```text
Fact: runner detection and migration planning already exist as disclosed references in promoted Skills.
Evidence: skills/tdd/references/runner-detection.md and skills/plan/references/migrations-and-rollout.md
Plan implication: verification and migration should reuse the established evidence vocabulary while owning distinct execution gates.
```

```text
Fact: the security, error-handling, testing, and frontend candidates are large cookbook-style documents (377–817 lines for several candidates).
Evidence: processing/skills/security-review/SKILL.md, error-handling/SKILL.md, python-testing/SKILL.md, react-testing/SKILL.md, frontend-patterns/SKILL.md
Plan implication: rewrite around decisions and gates; do not promote these files unchanged.
```

```text
Fact: the repository initially lacked a portfolio-wide Skill contract test.
Evidence: tests/ directory history and the roadmap's first implementation slice
Plan implication: add a Skill contract test before scaling the promoted portfolio so every later slice has the same RED/GREEN gate.
```

## Selected Strategy

Use one top-level Skill per independent invocation concept. Keep orchestration user-invoked and reusable disciplines model-invoked.

| Skill | Invocation | Selected responsibility |
|---|---|---|
| `verification` | model-invoked | Discover and execute repository quality gates; return READY/NOT READY evidence |
| `systematic-debugging` | model-invoked | Reproduce, isolate, test one hypothesis, fix root cause, and prove regression coverage |
| `spec` | user-invoked | Convert a sufficiently explored idea into a durable acceptance specification |
| `security-review` | model-invoked | Review changed trust boundaries and report only evidence-backed exploit paths |
| `codebase-onboarding` | user-invoked | Build an evidence-cited repository map and optional onboarding artifact |
| `resilience` | model-invoked | Design and review deadlines, retries, idempotency, partial failure, and recovery |
| `migration` | model-invoked | Govern execution and review of data/API/dependency migrations after planning |
| `testing-adapters` | model-invoked | Supply stack-specific test seams and runner details without duplicating TDD |
| `frontend-patterns` | model-invoked | Apply framework-neutral frontend boundaries with disclosed React guidance |
| `release-readiness` | user-invoked | Produce a readiness verdict from verification, migration, rollback, and observability evidence |

Selected design rules:

- Keep each `SKILL.md` focused on ordered behavior; move branch-specific material to `references/`.
- Reuse the evidence vocabulary already present in `plan`, `tdd`, and `code-review`.
- Retire duplicate processing candidates only after the replacement is promoted.
- Keep `release-readiness` read-only: it determines readiness but does not push, publish, or deploy.
- Keep `migration` focused on execution/review gates; retain `plan`'s migration reference for planning.
- Implement `testing-adapters` as one Skill with Python and React references, not as multiple always-discoverable top-level Skills.

Rejected alternatives:

- **Promote all processing candidates unchanged:** rejected because several are oversized, stack-specific cookbooks with stale or absolute guidance.
- **One engineering mega-Skill:** rejected because invocation becomes ambiguous and every task pays irrelevant cognitive load.
- **Copy external Skills verbatim:** rejected because Pi tooling, `uv`, repository lifecycle, security-audit results, and local evidence gates require adaptation.
- **Split every language/framework into a top-level Skill now:** rejected until a real stack needs an independent invocation trigger.

## Change Map

```text
tests/skills_manifest.tsv :: promoted Skill contract
Current responsibility: does not exist
Planned responsibility: declare each promoted Skill name and invocation mode
Interface/data impact: tab-separated test fixture consumed by tests/skills_test.sh
```

```text
tests/skills_test.sh :: static Skill validation
Current responsibility: does not exist
Planned responsibility: validate frontmatter, directory/name agreement, invocation mode, local references, README listing, and manifest completeness
Interface/data impact: executable repository gate; accepts repository state only
```

```text
processing/skills/<name>/ -> skills/<name>/ :: Skill lifecycle
Current responsibility: processing candidates are unvalidated drafts
Planned responsibility: draft, validate, promote, then remove superseded processing sources
Interface/data impact: promotion marks repository validation only; distribution is deferred until the portfolio is complete
```

```text
README.md :: promoted Skill index
Current responsibility: lists backend-patterns, code-review, plan, and tdd
Planned responsibility: list each promoted Skill with invocation type, purpose, and durable artifact behavior where applicable
Interface/data impact: user-facing discovery only
```

Per-Skill source and retirement map:

| Target | Primary existing sources | Superseded processing content after promotion |
|---|---|---|
| `verification` | `processing/skills/verification-loop/`, `skills/tdd/references/coverage-and-verification.md` | `processing/skills/verification-loop/` |
| `systematic-debugging` | `processing/skills/terminal-ops/`, defect branch in `skills/tdd/` | none; keep terminal operations separate |
| `spec` | `intent-driven-development`, `product-capability`, `product-lens`, `grilling` | retire `intent-driven-development` and `product-capability` after traceability review; keep `product-lens` and `grilling` distinct |
| `security-review` | `processing/skills/security-review/`, backend security reference | `processing/skills/security-review/` |
| `codebase-onboarding` | `processing/skills/codebase-onboarding/` | `processing/skills/codebase-onboarding/` |
| `resilience` | `processing/skills/error-handling/`, backend messaging/resilience reference | `processing/skills/error-handling/` after behavior coverage is mapped |
| `migration` | `skills/plan/references/migrations-and-rollout.md` | none; planning and execution responsibilities remain separate |
| `testing-adapters` | `python-testing`, `react-testing`, TDD runner detection | retire `python-testing`, `react-testing`, and legacy `tdd-workflow` after adapter coverage is proven |
| `frontend-patterns` | `frontend-patterns`, `react-patterns`, `react-testing` | retire both frontend/react pattern drafts after consolidation |
| `release-readiness` | verification, deployment-patterns, git-workflow, gh, github-ops | none in this roadmap; mechanics remain separate candidates |

## Implementation Slices

### 1. Add a repository-wide Skill contract gate

- **Delivers:** one deterministic test for every promoted Skill, enabling each later slice to prove RED before promotion.
- **Changes:** create `tests/skills_manifest.tsv` and `tests/skills_test.sh`.
- **Interfaces/data:** each manifest row records Skill name and `model` or `user` invocation; the test treats `disable-model-invocation: true` as the user-invoked contract.
- **Test seam and RED condition:** add a temporary manifest fixture naming a nonexistent Skill; `./tests/skills_test.sh` must fail with the missing directory and then pass after the fixture is removed. Add malformed local-link and invocation-mode fixtures to prove those checks fail for the expected reason.
- **Implementation outline:** validate required frontmatter, name/directory agreement, description presence, invocation mode, relative Markdown links, one manifest row per promoted Skill, and one README entry per row. Keep the script dependency-free Bash using repository-local files.
- **Verification:** `bash -n tests/skills_test.sh`; `./tests/skills_test.sh`.
- **Blocked by:** none.
- **Risks:** brittle Markdown parsing. Limit parsing to the repository's documented frontmatter and relative-link conventions instead of implementing a general Markdown/YAML parser.

### 2. Promote `verification`

- **Delivers:** repository-evidence-driven focused and broad quality gates with an explicit `READY`, `NOT READY`, or `BLOCKED` result.
- **Changes:** draft `processing/skills/verification/SKILL.md` plus disclosed references for gate detection and failure attribution; validate and move to `skills/verification/`; remove `processing/skills/verification-loop/`; update manifest and README.
- **Interfaces/data:** model-invoked description covers meaningful code changes, pre-review/pre-release checks, and failed quality gates. The report records scope, command, exit status, attribution, and required/optional status.
- **Test seam and RED condition:** add `verification` to the manifest before promotion; Skill contract test fails because the promoted directory is missing. Manual scenarios must distinguish a passing focused gate, a change-caused failure, a pre-existing failure, an unavailable optional gate, and an unavailable required gate.
- **Implementation outline:** preserve narrow-to-broad execution and PASS/FAIL/N/A honesty; remove automatic `uv` installation; derive commands from repository evidence; delegate deep vulnerability reasoning instead of duplicating security review; add phase completion criteria.
- **Verification:** `./tests/skills_test.sh`; scenario review against one small fixture repository with pass/fail/baseline cases.
- **Blocked by:** slice 1.
- **Risks:** overlap with `tdd` and `code-review`. Keep this Skill responsible for execution and attribution, while the other Skills own development and review reasoning.

### 3. Add `systematic-debugging`

- **Delivers:** a root-cause workflow for runtime defects, build/CI failures, regressions, and intermittent behavior.
- **Changes:** create `processing/skills/systematic-debugging/SKILL.md` with references for causal tracing, instrumentation, and intermittent failures; promote to `skills/systematic-debugging/`; update manifest, README, and behavior coverage.
- **Interfaces/data:** model-invoked; maintains an evidence log of observation, hypothesis, discriminating experiment, result, and next decision. It invokes verification behavior after the regression fix but does not own release readiness.
- **Test seam and RED condition:** manifest row fails before promotion. Manual scenario begins with a failing command and must prevent a fix proposal until reproduction or a documented alternative evidence gate exists; three failed hypotheses must trigger architecture reassessment rather than a fourth speculative patch.
- **Implementation outline:** wrap the mature `obra/superpowers@systematic-debugging` sequence; adapt tool names, Pi execution, `uv`, temporary instrumentation, and TDD regression-test handoff. Reuse terminal-operations evidence rules without absorbing commit/push behavior.
- **Verification:** Skill contract and behavior tests; walkthroughs for deterministic bug, intermittent bug, multi-component boundary, and failure that cannot be safely reproduced.
- **Blocked by:** slices 1 and 2.
- **Risks:** becoming a verbose debugging textbook. Keep the hypothesis loop in `SKILL.md`; disclose specialized tracing techniques.

### 4. Add the durable `spec` workflow

- **Delivers:** an explicit specification artifact that feeds `plan`, `tdd`, security policy, and final verification.
- **Changes:** create `processing/skills/spec/SKILL.md` with acceptance-quality and example references; promote to `skills/spec/`; update manifest, README, and behavior coverage; retire superseded intent/capability drafts only after a requirement coverage matrix proves equivalence.
- **Interfaces/data:** user-invoked; writes `docs/specs/YYYY-MM-DD-<slug>.md` without overwriting. Required sections: goal, scope, actors, invariants, observable acceptance criteria, failure/boundary behavior, non-goals, assumptions, and blocking decisions.
- **Test seam and RED condition:** manifest row fails before promotion. A sample ambiguous feature must not produce a final artifact until architecture/safety-changing decisions are resolved; a clear small change must produce a compact artifact without forced enterprise sections.
- **Implementation outline:** combine risk-scaled depth and acceptance criteria from `intent-driven-development`, constraint/invariant framing from `product-capability`, and minimal questioning. Keep product diagnosis and grilling separate rather than embedding them.
- **Verification:** Skill contract and behavior tests; artifact walkthroughs for compact, standard, and consequential-risk scenarios; confirm a downstream `plan` can consume the artifact without inventing requirements.
- **Blocked by:** slice 1. Parallelizable with slices 2–3 after the contract gate.
- **Risks:** name collision with ecosystem Skills and overlap with planning. Keep `spec` about desired behavior; prohibit file/symbol implementation maps.

### 5. Promote an evidence-gated `security-review`

- **Delivers:** high-confidence security findings tied to a changed trust boundary, attacker control, exploit path, and concrete impact.
- **Changes:** rewrite `processing/skills/security-review/` into a concise `SKILL.md` with disclosed trust-boundary, web, data, and supply-chain references; promote to `skills/security-review/`; update manifest, README, and behavior coverage.
- **Interfaces/data:** model-invoked for authentication, authorization, sensitive data, public endpoints, uploads, secrets, payments, unsafe execution, or dependency trust changes. Findings use severity plus evidence strength and suppress unproven checklist matches.
- **Test seam and RED condition:** manifest row fails before promotion. Scenario fixtures must retain a traced authorization bypass and injection path while rejecting framework-protected input, internal prevalidated input, and generic “missing security control” claims without an attacker path.
- **Implementation outline:** replace TypeScript/Next/Supabase/Solana cookbook material with threat-model workflow; preserve useful categories as disclosed search directions; adopt code-review's finding gate; require current official documentation for version-sensitive framework claims.
- **Verification:** Skill contract and behavior tests; positive and false-positive scenario matrix; validate that reported secrets are redacted.
- **Blocked by:** slices 1 and 4 for intended policy evidence. It may be drafted in parallel but cannot complete policy-sensitive scenarios before `spec`.
- **Risks:** duplication with `code-review`. Keep code-review broad; invoke this Skill only for deep trust-boundary analysis.

### 6. Promote `codebase-onboarding`

- **Delivers:** an evidence-cited repository map for an unfamiliar codebase, with unknowns and confidence separated from facts.
- **Changes:** rewrite `processing/skills/codebase-onboarding/` with references for architecture mapping and optional artifact templates; promote to `skills/codebase-onboarding/`; update manifest, README, and behavior coverage.
- **Interfaces/data:** user-invoked; defaults to analysis and a concise `docs/onboarding.md` artifact. Updating `AGENTS.md` requires explicit user scope because it changes governing instructions.
- **Test seam and RED condition:** manifest row fails before promotion. A fixture repository with two entry points must produce both paths and mark an intentionally opaque external boundary as unknown; it must not infer package-manager commands absent repository evidence.
- **Implementation outline:** retain reconnaissance, architecture map, and convention discovery; remove npm/Next assumptions; add fact/evidence/implication records and completion criteria; separate analysis from instruction-file mutation.
- **Verification:** Skill contract and behavior tests; fixture walkthrough; verify every named path exists and every unknown remains labeled.
- **Blocked by:** slice 1. Parallelizable with slices 2–5.
- **Risks:** overlap with plan exploration. Onboarding creates a reusable repository map; planning remains change-specific.

### 7. Add `resilience`

- **Delivers:** design and review gates for deadlines, cancellation, retries, idempotency, partial failure, backpressure, and recovery.
- **Changes:** create `processing/skills/resilience/SKILL.md` with references for synchronous boundaries, messaging, and recovery verification; promote to `skills/resilience/`; update manifest, README, and behavior coverage; retire `processing/skills/error-handling/` after coverage mapping.
- **Interfaces/data:** model-invoked for remote calls, asynchronous processing, shared resource limits, retries, and partial failure. Outputs explicit failure classes, ownership, retry budget, idempotency key/operation, recovery path, and proving test.
- **Test seam and RED condition:** manifest row fails before promotion. Scenario matrix must reject retrying non-idempotent unknown-outcome writes without protection, detect retry amplification, and require cancellation/timeout propagation at a remote boundary.
- **Implementation outline:** use `skills/backend-patterns/references/messaging-and-resilience.md` as the concise baseline; extract only valid typed failure-contract material from `error-handling`; correct `fetch` and HTTP status assumptions; add telemetry and recovery evidence.
- **Verification:** Skill contract and behavior tests; scenarios for synchronous timeout, queue redelivery, duplicate command, downstream outage, and fallback correctness.
- **Blocked by:** slices 2 and 5 for verification and diagnostic-data safety. Uses the promoted TDD seam.
- **Risks:** overlap with backend-patterns. Keep backend-patterns as architecture reference; resilience owns execution/review discipline.

### 8. Add the migration execution discipline

- **Delivers:** preflight, rollout, reconciliation, stop, rollback, and cleanup gates for data, API/protocol, dependency, and runtime migrations.
- **Changes:** create `processing/skills/migration/SKILL.md` with data/API/dependency references; promote to `skills/migration/`; update manifest, README, and behavior coverage. Keep `skills/plan/references/migrations-and-rollout.md` as planning guidance.
- **Interfaces/data:** model-invoked when executing or reviewing a migration. Requires migration identity, source/target states, compatibility window, batch/canary progression, resumability, reconciliation, rollback boundary, and cleanup owner.
- **Test seam and RED condition:** manifest row fails before promotion. A destructive migration scenario must stop without backup/recovery evidence; a resumable batch scenario must prove repeated execution is safe and reconciliation catches divergence.
- **Implementation outline:** convert plan concepts into execution gates; separate reversible rollback from forward recovery; require explicit point-of-no-return and stop conditions; keep vendor-specific commands out of the core.
- **Verification:** Skill contract and behavior tests; scenario matrix for data backfill, API version transition, dependency/runtime upgrade, and irreversible contract step.
- **Blocked by:** slices 2, 4, and 7.
- **Risks:** duplication with plan. Maintain the boundary: plan selects transition states; migration governs executing and validating them.

### 9. Add `testing-adapters`

- **Delivers:** stack-specific test seams and runner behavior for Python and React without duplicating the promoted TDD workflow.
- **Changes:** create `processing/skills/testing-adapters/SKILL.md` with `references/python.md` and `references/react.md`; promote to `skills/testing-adapters/`; update manifest, README, and behavior coverage; retire `python-testing`, `react-testing`, and legacy `tdd-workflow` after traceability review.
- **Interfaces/data:** model-invoked only after stack detection. The core routes to one relevant reference and returns the smallest authoritative command, stable public seam, isolation controls, and framework-specific fixture guidance.
- **Test seam and RED condition:** manifest row fails before promotion. Python fixture must select configured `uv run pytest`; React fixture must select repository scripts and accessible queries. Repositories without matching evidence must return “no adapter” instead of inventing dependencies.
- **Implementation outline:** reuse `skills/tdd/references/runner-detection.md`; prune generic pytest/RTL tutorials, fixed coverage thresholds, bare commands, and duplicated RED/GREEN steps; require Context7 before version-sensitive API guidance.
- **Verification:** Skill contract and behavior tests; Python, React, mixed-stack, and unsupported-stack routing scenarios.
- **Blocked by:** slice 1 and the already promoted `tdd`. It can run in parallel with slices 2–8.
- **Risks:** a router that loads every reference. Keep stack branches explicit and load exactly one adapter unless the change spans stacks.

### 10. Promote consolidated `frontend-patterns`

- **Delivers:** framework-neutral frontend boundaries with disclosed React-specific composition, state, accessibility, performance, and client/server guidance.
- **Changes:** rewrite `processing/skills/frontend-patterns/` with concise core and references such as `react.md`, `accessibility.md`, and `performance.md`; incorporate only validated material from `react-patterns`; promote to `skills/frontend-patterns/`; update manifest, README, and behavior coverage; retire the superseded React pattern draft.
- **Interfaces/data:** model-invoked for frontend implementation or review. Requires explicit UI behavior, state ownership, accessibility outcome, data/privacy boundary, and test seam before recommending a pattern.
- **Test seam and RED condition:** manifest row fails before promotion. Scenarios must choose local state over global state for a local interaction, reject unconditional memoization, preserve accessible semantics, and avoid exposing server-only data in a client boundary.
- **Implementation outline:** remove hand-rolled stale data-fetching examples and framework conflation; use decision tables and invariants; place current React/Next APIs behind references verified with Context7 at implementation time.
- **Verification:** Skill contract and behavior tests; scenario matrix for state placement, forms, asynchronous UI, accessibility, rendering performance, and server/client privacy.
- **Blocked by:** slices 4, 7, and 9.
- **Risks:** fast-moving framework APIs. Keep the core stable and document the version/date of every external API source used in references.

### 11. Add `release-readiness`

- **Delivers:** an evidence-based readiness verdict without performing push, release, deployment, or other externally consequential actions.
- **Changes:** create `processing/skills/release-readiness/SKILL.md` with references for rollout/rollback evidence and readiness reporting; promote to `skills/release-readiness/`; update manifest, README, and behavior coverage.
- **Interfaces/data:** user-invoked. Consumes verification status, migration state, security findings, artifact identity, rollback trigger, observability plan, and unresolved risk. Returns `READY`, `READY WITH ACCEPTED RISKS`, `NOT READY`, or `BLOCKED`.
- **Test seam and RED condition:** manifest row fails before promotion. Scenario matrix must block on a failed required gate, an incomplete irreversible migration, or absent rollback ownership; it must not block a docs-only release on irrelevant deployment checks.
- **Implementation outline:** compose evidence rather than restating verification, security, migration, Git, or hosting mechanics; require explicit authorization before any external mutation and leave execution to separate tools/Skills.
- **Verification:** Skill contract and behavior tests; readiness scenarios for ordinary code change, migration, security-sensitive release, docs-only change, and unavailable CI evidence.
- **Blocked by:** slices 2, 5, and 8.
- **Risks:** becoming another deployment checklist. Every readiness requirement must trace to the current change's risk or repository policy.

## Migration and Rollback

This roadmap migrates documentation/workflow assets, not production data.

For each replacement:

1. create and validate the new draft under `processing/skills/<target>/`;
2. add the manifest row to observe RED while the Skill is not yet promoted;
3. promote the validated directory to `skills/<target>/`;
4. run Skill contract and behavior tests;
5. update README and rerun the applicable gates;
6. only then remove the superseded processing candidate.

Rollback for any slice:

- remove the new manifest row and README entry;
- move the promoted directory back to `processing/skills/` or restore the superseded source from version control;
- rerun `./tests/skills_test.sh` and the applicable behavior tests;
- do not roll back unrelated promoted Skills.

No slice changes the schema of existing promoted Skills. Invocation-name collisions are handled by removing or renaming the superseded processing candidate before final promotion.

## Final Verification

Run after every slice:

```bash
bash -n tests/skills_test.sh tests/skill_handoffs_test.sh
./tests/skills_test.sh
./tests/skill_handoffs_test.sh
# Run the promoted Skill's behavior test when present.
git diff --check
git status --short
```

Distribution, installation, upgrade, rollback, and global-state tests are deferred until all target Skills are complete and the repository designs a dedicated delivery phase.

Manual completion matrix:

- one positive trigger and one non-trigger for every model-invoked Skill;
- one compact and one consequential scenario for every user-invoked Skill;
- one expected failure that proves each behavioral gate can go RED;
- one clean outcome that proves the Skill can legitimately return no finding/no blocker;
- one review confirming every referenced path exists and every source URL was actually consulted.

Roadmap completion gate:

```text
10/10 target Skills promoted
0 superseded duplicate candidates remaining for migrated responsibilities
Skill contract PASS
Skill handoff PASS
All per-Skill behavior tests PASS
README inventory complete
All required scenario gates recorded
```

## Assumptions and Open Questions

- Assumption: the ten-item roadmap refers to the previously ranked Skill-only list; Commands remain out of scope.
- Assumption: English remains the implementation language for new Skill bodies and references; `README.md` keeps its current Chinese catalog style.
- Assumption: `spec` is intentionally user-invoked despite possible ecosystem name collisions.
- Assumption: `migration` is a top-level model-invoked execution discipline, while planning guidance remains in `plan`.
- Assumption: the initial `testing-adapters` scope is Python and React; additional stacks require observed repository demand.
- Assumption: `release-readiness` reports readiness and performs no external mutation.
- Decision: `spec` supersedes the intent and capability-contract responsibilities after coverage review; `product-lens` and `grilling` retain distinct responsibilities.
- Open question, non-blocking: decide during `codebase-onboarding` whether its default artifact is one stable `docs/onboarding.md` file or dated history; follow any repository-local convention first.

## Non-Goals

- No changes to `processing/commands/`.
- No implementation of the ten Skills in this planning task.
- No installation or distribution mechanism before the complete Skill portfolio passes integration review.
- No automatic Git commit, push, PR, release, or deployment behavior.
- No new language adapters beyond Python and React in the initial roadmap.
- No rewrite of the promoted `backend-patterns`, `plan`, `tdd`, or `code-review` Skills except narrow cross-reference updates required by a completed slice.
- No retention of duplicated cookbook guidance solely for backward compatibility; superseded processing candidates are not promoted interfaces.

## Reference Sources

Sources already consulted while shaping this roadmap:

- https://github.com/mattpocock/skills
- https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md
- https://github.com/affaan-m/everything-claude-code
- https://skills.sh/affaan-m/ecc/verification-loop
- https://skills.sh/obra/superpowers/systematic-debugging
- https://skills.sh/github/awesome-copilot/create-specification
- https://skills.sh/getsentry/skills/security-review

Before implementing each slice, rerun `npx skills find <focused query>` and crawl the selected first-party README and exact `SKILL.md`. Record install count, repository reputation/stars, security-audit status, borrowed patterns, and local adaptations. Treat conflicting install counts or failed audits as explicit evidence favoring a wrapper/rewrite over direct installation.
