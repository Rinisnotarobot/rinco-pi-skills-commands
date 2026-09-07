# Implementation Plan: Validate the Hybrid Rinco Composition Pilots

Lifetime: **delivery plan**. Keep planning-time evidence as a snapshot; record execution changes explicitly and recheck affected evidence after source or protocol revisions.

> Execution update — 2026-09-07: the ADR 0002 transition and premature README claim were resolved in `a87b8d22b543110574f6af3435dd63e9f3fcceec`; execution began from that clean worktree. Slice 1 now prepares the [protocol](../pilots/PROTOCOL.md) and its disclosed [record template](../pilots/RECORD-TEMPLATE.md). Commit the revised protocol before counting an attempt against it; `a87b8d2` alone does not contain this new method. No real task or pilot result has been recorded. This update also clarifies Pilot 4 as at least two session starts and one actual handoff, matching the Final Verification contract rather than the original “two session boundaries” wording. Execution consistency checks also distinguish intake discovery from first-use command pinning and preserve the narrow evidence-artifact exclusions.

## Goal and Scope

Execute the four real-task pilots defined by [`docs/pilots/PROTOCOL.md`](../pilots/PROTOCOL.md), preserve reproducible evidence for every phase handoff, and decide whether each recommended Rinco lane can be trusted as designed.

This is a **standard-depth, multi-session validation campaign**. It validates composition rather than individual prose or frontmatter:

1. a small, already-clear behavior reaches TDD and verification without unnecessary shaping artifacts;
2. an ambiguous multi-module feature preserves decision, domain, specification, planning, implementation, verification, and review ownership;
3. an unknown-cause defect reaches a proven-cause handoff before production behavior changes;
4. a multi-session change preserves plan slices, ticket dependencies, context handoffs, and one final verification state.

Completion requires real requested work. A staged demo, invented defect, synthetic “happy path,” or retrospective reconstruction does not satisfy a pilot. A blocked or failed attempt remains useful evidence but does not complete its required pilot until the blocker is cleared or the adjusted lane is rerun.

## Source Specification

There is no separate product specification and no originating `REQ`/`INV`/`AC` set for this campaign. The authoritative validation contract is distributed across these accepted project artifacts:

- [`docs/pilots/PROTOCOL.md`](../pilots/PROTOCOL.md) — required task shapes, metrics, record format, and four completion invariants; current status is `protocol ready; pilots pending real tasks`.
- [`docs/plans/2026-09-03-rinco-matt-skill-integration.md`](2026-09-03-rinco-matt-skill-integration.md), slice 8 and Completion Evidence — representative lane coverage and integration completion conditions.
- [`docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md`](../adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md) — single-owner and evidence-kernel architecture.
- [`docs/adr/0002-self-install-skills-with-recommended-bundles.md`](../adr/0002-self-install-skills-with-recommended-bundles.md) — self-installation, recommended bundles, runtime dependency checks, and the prohibition on restoring fixed launcher profiles without new evidence.
- [`README.md`](../../README.md), “推荐套装” and “设计原则” — current shape/build/fix/review membership and public workflow description.
- The promoted workflow contracts under [`skills/workflows/`](../../skills/workflows/) — phase-specific inputs, outputs, stopping rules, and verdict ownership.

At planning time README called the bundles “经过组合验证,” while the protocol explicitly said the real-task pilots were pending. The public claim was corrected in `a87b8d2`. Keep the protocol and integration completion gate authoritative for validation status; after campaign acceptance, README may state the narrower fact that the four protocol lanes were validated against the recorded tasks.

When any other source conflict appears during execution, stop the campaign and resolve it before counting another pilot. Do not silently choose the more convenient rule.

## Requirement Traceability

The source documents do not assign requirement IDs. The table therefore cites stable source sections directly rather than inventing product identifiers.

| Source clause | Validation obligation | Slice(s) | Completion evidence |
|---|---|---:|---|
| Protocol / Required pilots #1 | Exercise one real, small, already-clear behavior through `tdd → verification` | 2 | Pilot 1 record with useful RED, same-state verification outcome, and no unnecessary spec/plan |
| Protocol / Required pilots #2 | Exercise one real, ambiguous multi-module feature through shape and build owners | 3 | Pilot 2 record plus decision, domain, spec, plan, TDD, verification, and review handoffs |
| Protocol / Required pilots #3 | Exercise one real unknown-cause defect through fix and diagnosis before implementation | 4 | Pilot 3 record with pre-edit symptom, proven-cause handoff, regression RED/GREEN, and final verification |
| Protocol / Required pilots #4 | Exercise one real multi-session change with one ticket per approved plan slice | 5 | Pilot 4 record, ticket graph, session handoffs, per-ticket evidence, final verification, and review |
| Protocol / Metrics | Record all seven required metric classes for every attempt | 1–6 | Every record has explicit values, including `none`, `unavailable` with reason, or measured evidence; no blank field |
| Protocol / Completion invariants 1–4 | Preserve one spec, one plan, one verification owner, and no duplicate Matt workflow | 2–6 | Per-pilot invariant table and cross-pilot results matrix |
| Integration plan / Slice 8 | Compare representative tasks before evaluating wayfinder or broad research | 2–6 | Four accepted pilots and an aggregate result; no wayfinder work in this campaign |
| ADR 0001 / Non-negotiable ownership | Prevent a stage from producing another stage’s artifact or verdict | 1–6 | Ordered event log identifies producer, artifact, next owner, and stop point |
| ADR 0002 / Decision | Use installed recommended bundles and honest `BLOCKED` restart instructions, not deleted profile launchers | 1–6 | Installed-skill inventory, duplicate-name check, and any dependency-recovery transcript |
| Verification workflow / Verdict gate | Let `verification` alone issue `READY`, `NOT READY`, or `BLOCKED` for the pinned state | 2–6 | One owner-attributed verification report per unchanged final state |
| Protocol / repeated correction rule | Revise a Skill before trust when the same owner correction occurs twice | 6 | Normalized correction ledger, follow-up change evidence, and affected rerun |

## Repository Evidence

**Planning base revision:** `50da0b2e09bc88bf8fd1bb1f9495c1aa9120f833` on branch `main`.

**Planning-time state:** `main` was four commits ahead of `origin/main`. Before this plan was written, the worktree already contained 25 changed paths for the ADR 0002 transition and related Skill updates. Those changes include deletion of `profiles/`, edits to `README.md`, `AGENTS.md`, the protocol and integration plan, and a new untracked ADR 0002. They are pre-existing work and must not be overwritten or mistaken for pilot evidence.

Verified facts at planning time (see the dated execution update for resolved items):

```text
Fact: The protocol exists, but there are no per-pilot records yet.
Evidence: docs/pilots/PROTOCOL.md and `find docs/pilots -maxdepth 1 -type f`.
Plan implication: all four pilots remain outstanding; no historical conversation may be backfilled as a completed run.

Fact: README currently describes the recommended bundles as already composition-validated.
Evidence: README.md, “推荐套装”; conflicting status in docs/pilots/PROTOCOL.md.
Plan implication: correct the public status before execution and restore a validated claim only with a results pointer after acceptance.

Fact: Fixed profile launchers are being removed and are superseded by self-installation plus recommended bundles.
Evidence: docs/adr/0002-self-install-skills-with-recommended-bundles.md; current README diff; deleted profiles/*.sh.
Plan implication: each pilot must record the actual discovered Skill set and restart behavior rather than citing a profile script.

Fact: `scripts/validate.sh` covers promoted-Skill structure, links, references, README inventory, invocation mode, repository mirrors, global mirror information, and `git diff --check`.
Evidence: scripts/validate.sh.
Plan implication: it is a repository structural gate, not proof that a composition pilot ran correctly.

Fact: The planning-time structural run completed with 0 failures and 5 informational global-mirror warnings.
Evidence: fresh `scripts/validate.sh` execution during planning.
Plan implication: global mirror drift must be disclosed and eliminated for any globally installed pilot bundle, but it is not currently a structural failure.

Fact: `tdd` owns RED/GREEN/REFACTOR evidence; `systematic-debugging` stops after cause proof; `verification` alone owns readiness; `code-review` consumes verification and persists a separate review verdict.
Evidence: skills/workflows/tdd/SKILL.md; systematic-debugging/SKILL.md; verification/SKILL.md; code-review/SKILL.md.
Plan implication: pilot records may quote or point to owner output, but must not calculate a second gate or review verdict.

Fact: `publish-tickets` requires an approved, revision-stamped plan and preserves a one-ticket-per-slice acyclic graph without re-planning.
Evidence: skills/workflows/publish-tickets/SKILL.md.
Plan implication: Pilot 4 must use a plan with at least two explicit slices and must reject stale, merged, split, reordered, cyclic, or dangling ticket mappings.
```

Authoritative repository commands:

| Command | Source | Scope | Requirements |
|---|---|---|---|
| `scripts/validate.sh` | `AGENTS.md`, `scripts/validate.sh` | promoted-Skill structural gate | Run from this repository; exit 0 required |
| `git diff --check` | project instructions and existing plans | changed-text hygiene | Run after the last campaign-document mutation |
| `git branch --show-current` | workflow contracts | evidence baseline | Run in each pilot target repository |
| `git rev-parse HEAD` | workflow contracts | evidence baseline/freshness | Run in each pilot target repository |
| `git status --short` | workflow contracts | worktree integrity | Capture before/after every evidence-producing gate |

At intake, discover the target repository's test infrastructure, command authorities, and prerequisites from its instructions, manifests, CI, and nearby tests. Record each exact focused RED/GREEN command before its first use and required gates before execution. Pilot 2 may enter shaping before its test seam and focused command are determined; record the due stage instead of inventing a command or blocking legitimate discovery. Missing infrastructure or authorization remains an explicit prerequisite blocker.

## Selected Strategy

Run a **gated campaign with one durable record per required pilot and one aggregate result**:

1. stabilize and version the Rinco source state used by every pilot;
2. strengthen the protocol record envelope without changing its four task shapes or metrics;
3. execute each pilot only when a naturally occurring task meets its eligibility gate;
4. preserve stage outputs in chronological order and bind every reusable result to branch, HEAD, worktree status, command, exit status, and prerequisites;
5. normalize cross-pilot corrections only after each attempt is recorded;
6. revise an owning Skill through a separate, evidenced change when necessary, then rerun affected evidence before trusting the lane;
7. publish one aggregate result and update project status only after all four pilots are accepted.

Alternatives rejected:

- **Scripted mock pilots:** fast, but cannot expose real ambiguity, context loss, user decisions, environment blockers, or repository-specific gate discovery.
- **One autonomous uninterrupted chain for all phases:** hides explicit user-invoked stage stops. Several phases may share a session with real handoffs and user invocations; only Pilot 4 requires a fresh-session transition.
- **Treating `scripts/validate.sh` as composition proof:** verifies files, not behavior, ownership, evidence freshness, or task-shape fit.
- **Restoring `profiles/*.sh` for convenience:** contradicts ADR 0002 and would test a superseded mechanism.
- **Running all four pilots only inside this Skill repository:** allowed only when four genuine matching tasks arise; forcing repository-maintenance work into behavioral TDD lanes would bias the result.

## Change Map

```text
docs/pilots/PROTOCOL.md :: status, execution prerequisites, per-pilot record, completion rules
Current responsibility: Defines task shapes, metrics, a compact record, and completion invariants.
Planned responsibility: Also define evidence freshness fields, task eligibility, attempt disposition, correction normalization, and aggregate-results linkage.
Interface/data impact: Additive Markdown contract; do not change the existing four task shapes or seven metrics.

docs/pilots/RECORD-TEMPLATE.md :: disclosed per-task record fields (new in slice 1)
Current responsibility: Previously the compact template lived inline in PROTOCOL.md.
Planned responsibility: Own the expanded fillable fields without burying execution rules inside a long template.
Interface/data impact: PROTOCOL.md links here; fields are extended, not copied into a second competing schema.

docs/pilots/1-<task-slug>.md :: Pilot 1 evidence record (proposed)
Current responsibility: Does not exist.
Planned responsibility: Canonical chronological record for the small-clear-behavior pilot and any rerun attempts.
Interface/data impact: Uses the protocol template; exact slug chosen from the real task.

docs/pilots/2-<task-slug>.md :: Pilot 2 evidence record (proposed)
Current responsibility: Does not exist.
Planned responsibility: Canonical record for ambiguous-feature shaping, implementation, verification, and review.
Interface/data impact: Includes authoritative artifact paths and source IDs produced by spec/plan.

docs/pilots/3-<task-slug>.md :: Pilot 3 evidence record (proposed)
Current responsibility: Does not exist.
Planned responsibility: Canonical record for unknown symptom, causal proof, correction, and verification.
Interface/data impact: Includes confirmed/refuted hypotheses and pre-edit worktree evidence.

docs/pilots/4-<task-slug>.md :: Pilot 4 evidence record (proposed)
Current responsibility: Does not exist.
Planned responsibility: Canonical record for plan-to-ticket fidelity and multi-session continuation.
Interface/data impact: Includes ticket-to-slice mapping, dependency graph, base revision, and session boundaries.

docs/pilots/RESULTS.md :: aggregate campaign result (proposed)
Current responsibility: Does not exist.
Planned responsibility: Own the cross-pilot matrix, recurring corrections, accepted adjustments, residual limitations, and final campaign conclusion.
Interface/data impact: Link to records and owner artifacts instead of duplicating their full contents.

docs/plans/2026-09-03-rinco-matt-skill-integration.md :: slice 8 / Completion Evidence
Current responsibility: States the integration completion gate.
Planned responsibility: On acceptance only, annotate slice 8 with the results path and source commit used by the campaign.
Interface/data impact: Status pointer only; retain historical plan text.

README.md :: 推荐套装 / 当前状态
Current responsibility: Publicly describes bundle membership, stable Skills, and remaining work; it currently overstates the pending pilots as already composition-validated.
Planned responsibility: Before execution, label the bundles as pending real-task validation; on acceptance, link the completed pilot result and state any remaining portfolio blocker.
Interface/data impact: Status/navigation only; do not copy the results matrix.

skills/<category>/<owner>/SKILL.md :: conditional follow-up only
Current responsibility: Owns the affected phase contract.
Planned responsibility: Change only when pilot evidence proves a repeated or safety-critical contract defect; use a separate scoped change and rerun affected pilots.
Interface/data impact: Unknown until a finding is proven; never edit several owners to mask an unclear handoff.
```

## Implementation Slices

### 1. Establish a reproducible campaign baseline

**Delivers:** A protocol and source baseline from which every pilot attempt can be reproduced and judged consistently.

**Changes:**

- **Resolved in `a87b8d2`:** the 25 pre-existing changes were committed and the execution worktree was clean. Preserve that historical baseline; pin a new clean source commit containing the revised protocol before the first pilot.
- Update `docs/pilots/PROTOCOL.md` without changing the four required lanes or metric meanings. Disclose the expanded fields in `docs/pilots/RECORD-TEMPLATE.md`; extend each record with:
  - task source and why it is real;
  - task-shape eligibility and rejection reasons;
  - target repository, branch, baseline HEAD, and initial status;
  - Rinco source commit, installation roots, installed Skill names, and duplicate-name result;
  - phase event log with producer, input, output/pointer, next owner, stop point, turns, elapsed time, and context observation;
  - exact RED/GREEN/gate commands, exit statuses, key signatures, prerequisites, and before/after worktree status;
  - invariant table, correction category, attempt disposition, and rerun linkage;
  - values of `none` or `unavailable: <reason>` instead of blank metric fields.
- Reserve each per-pilot record path before target verification. When a pilot self-hosts in this repository, exclude only that record path and the code-review artifact path explicitly reserved by `code-review` from the pinned implementation scope; record every update to those evidence artifacts. Run the final repository structural gate after the records stop changing.
- **Resolved in `a87b8d2`:** README no longer claims completed composition validation. Keep its current-state navigation pointed at the protocol and this plan, distinct from the independent portfolio work.
- Define attempt states: `eligible → running → recorded → accepted | adjustment-required | invalid`. A `BLOCKED` workflow outcome stays `recorded` but does not become an accepted required pilot until resumed successfully or replaced by another eligible real task.
- Record one immutable Rinco source commit for each attempt. If Skills change, start a new attempt section and record the new source commit; do not rewrite prior evidence.

**Interfaces/data:** `PROTOCOL.md` remains the method owner; per-pilot files remain the observation owners; `RESULTS.md` will own only cross-pilot synthesis.

**Test seam and RED condition:** This is documentation-only setup, so do not force a behavioral TDD test. The current protocol is observably incomplete for reproducibility because it does not require source commit, target HEAD/worktree, exact commands, duplicate-name evidence, or attempt disposition.

**Implementation outline:** Add the minimal fields above, inspect links and terminology against ADR 0002 and the workflow contracts, then pin a clean campaign source revision.

**Verification:**

```bash
scripts/validate.sh
git diff --check
git status --short
git rev-parse HEAD
```

Expected evidence: `scripts/validate.sh` exits 0; `git diff --check` is empty; the campaign source revision and intended worktree are explicit; profile launchers are not used as the pilot entry mechanism; README no longer claims that pending real-task pilots have already passed.

**Blocked by:** No remaining blocker to preparing the documentation. Pilot execution still requires a clean source commit containing the revised protocol; the prior 25-path blocker is resolved.

**Risks:** Accidentally treating uncommitted ADR 0002 text as a durable source; refreshing global mirrors without recording which source revision was installed; turning the protocol into a duplicate verification gate.

### 2. Validate the small, clear behavior lane

**Delivers:** Evidence that a well-scoped request can go directly through `tdd → verification` without unnecessary decision, specification, or planning artifacts.

**Changes:** Create `docs/pilots/1-<task-slug>.md` when an eligible real task arrives. Do not create a spec or plan merely to satisfy the campaign.

**Interfaces/data:**

- Input: an authoritative request with one bounded observable behavior and no unresolved product, safety, compatibility, persistent-data, cost, or public-interface decision.
- TDD output: one or more behavior slices with useful RED, GREEN, refactor, affected-test, source-state, and residual-risk evidence.
- Verification output: the only `READY`, `NOT READY`, or `BLOCKED` result for the unchanged final target state.

**Test seam and RED condition:** Before implementation, identify the target repository’s narrowest stable public seam and exact focused command. RED must fail for the requested missing behavior, not syntax, setup, missing dependencies, stale fixtures, or an unrelated defect. If the behavior already exists or no runnable/approved alternative evidence is possible, mark the candidate invalid rather than manufacturing RED.

**Implementation outline:**

1. Record the request, eligibility decision, target baseline, installed build Skills, and duplicate-name result.
2. Invoke TDD directly. Record whether any Skill attempts to force grilling, spec, or plan despite the request being complete.
3. Capture the first useful RED turn/time and complete each vertical RED → GREEN → REFACTOR slice.
4. Hand the same-state evidence to `verification`; run only missing required gates.
5. Use code review only when requested or justified by changed risk; record `not requested` otherwise.
6. Fill all protocol metrics and invariants before marking the attempt accepted.

**Verification:** Required evidence is the target repository’s focused RED/GREEN command, affected checks, required repository gates, exact exit statuses, and unchanged worktree around the final verification run. The record must show zero unnecessary shaping artifacts or explain and classify each one.

**Blocked by:** Slice 1 and the arrival of an eligible real task with authoritative target-repository commands.

**Risks:** Misclassifying an ambiguous request as clear; counting a setup failure as RED; allowing a copied verification result to become a second verdict.

### 3. Validate the ambiguous multi-module feature lane

**Delivers:** Evidence that shaping reduces ambiguity while preserving one owner for domain vocabulary, behavior, implementation strategy, readiness, and review.

**Changes:** Create `docs/pilots/2-<task-slug>.md` for a real feature that crosses at least two existing modules and contains at least one user-owned decision plus one domain-language question. A prototype remains optional and may be used only for one genuinely unresolved design question.

**Interfaces/data:**

```text
request
  → grilling decision handoff
  → domain-modeling glossary/ADR mutation handoff when applicable
  → one READY-FOR-PLAN spec with REQ/INV/AC IDs
  → one revision-stamped plan with vertical slices and verification contract
  → TDD evidence mapped to source IDs
  → one same-state verification verdict
  → one separate code-review report
```

The production worktree must not receive prototype code. Domain modeling may touch only its declared glossary/map/ADR paths. Grilling may not emit requirements; spec may not choose repository paths; plan may not implement; review may not recalculate readiness.

**Test seam and RED condition:** Each approved plan slice names a module interface as its test surface and predicts the missing observable behavior. TDD must witness each required RED before production behavior for that slice changes. The exact commands are discovered and recorded after the target task is selected.

**Implementation outline:**

1. Run grilling until the user confirms the decision set; preserve rejected options and unresolved blockers.
2. Resolve the selected domain vocabulary through `domain-modeling`; create an ADR only if its three-part gate passes.
3. Invoke explicit `spec`, persist one traceable contract, and stop if any material decision remains unresolved.
4. Invoke `plan`, pin its base revision, map every source ID to slices/evidence, and self-review it before implementation.
5. If a discussion cannot settle one mechanism or layout question, run `prototype` on a throwaway branch and feed only its observed answer and limitations back to the owning stage.
6. Execute slices via TDD, then run verification once for the final unchanged implementation state.
7. Invoke code review with the exact scope and reusable verification state; persist its separate verdict.
8. Record owner crossings, rejected/stale handoffs, context observations, and unnecessary artifacts.

**Verification:** The pilot record must prove one confirmed grilling handoff, at most one authoritative glossary entry/ADR per decision, exactly one final spec, exactly one plan, bidirectional source-ID traceability, useful RED/GREEN evidence, one verification owner, and one review verdict. A later mutation affecting the pinned implementation scope or its prerequisites makes the affected verification and review evidence stale and requires rerun. Apply only the record/review artifact exclusions reserved in slice 1 and [protocol step 4](../pilots/PROTOCOL.md#4-keep-record-writes-outside-implementation-evidence); inspect the actual diff to prove that an excluded artifact write was the only change. Run the final repository structural gate after all campaign-document edits stop.

**Blocked by:** Slice 1 and a qualifying real feature. Material unanswered product decisions block progression to spec/plan rather than becoming plan assumptions.

**Risks:** Selecting a task whose ambiguity is purely technical and therefore never exercises user decisions or domain language; using a prototype as production implementation; allowing stage transitions in one continuous response without the explicit owner handoff.

### 4. Validate the unknown-cause defect lane

**Delivers:** Evidence that `fix → systematic-debugging → tdd → verification` prevents speculative production edits and preserves one causal chain and one final gate.

**Changes:** Create `docs/pilots/3-<task-slug>.md` for a current, observable defect whose symptom is known but complete causal chain and violated invariant are not.

**Interfaces/data:**

- `fix` owns routing and the final repair report, not diagnosis or verification logic.
- `systematic-debugging` owns the red feedback loop, hypotheses, causal proof, diagnostic cleanup, and downstream handoff; it stops before production behavior changes.
- `tdd` owns the regression test and correction cycle after cause proof.
- `verification` owns final readiness for the exact repaired state.

**Test seam and RED condition:** First establish a symptom-level red loop that reproduces the reported failure. After cause proof, establish a stable public seam and regression RED with the expected signature. A changed signature is a newly pinned symptom, not automatic progress.

**Implementation outline:**

1. Record the original report, expected/actual result, environment, reproduction command, initial state, and prior attempts.
2. Invoke `fix`; confirm it routes the unknown cause to `systematic-debugging` before production edits.
3. Minimize the failure and test one falsifiable hypothesis at a time. Preserve confirmed and refuted evidence; after three failed well-formed hypotheses, exercise the reassessment rule rather than continuing to thrash.
4. Remove agent-owned diagnostics and produce the complete cause handoff.
5. Revalidate the handoff against current state, then execute the regression RED/GREEN through TDD.
6. Let `fix` delegate the final state to one verification run; classify any new failure before another edit.
7. Record whether review is optional, pending, or requested based on risk without creating a review verdict inside `fix`.

**Verification:** The record must show no production-behavior diff before the proven-cause handoff, a reproducible symptom or approved alternative gate, the causal chain and violated invariant, diagnostic cleanup state, regression RED/GREEN, final target-repository gates, and one owner-attributed verification result.

**Blocked by:** Slice 1 and a genuine unknown-cause defect. A known-cause repair is not eligible. Unsafe reproduction requires explicit approval or an alternative observation gate.

**Risks:** Retrospectively calling a known cause unknown; confusing symptom disappearance with causal proof; leaving diagnostic edits in the final worktree; counting a legitimately blocked diagnosis as a completed end-to-end pilot.

### 5. Validate the multi-session ticket-handoff lane

**Delivers:** Evidence that an approved plan survives ticket serialization across at least two session starts and one actual fresh-session handoff without re-slicing, stale authority, duplicate conclusions, or context reconstruction.

**Changes:** Create `docs/pilots/4-<task-slug>.md`. Publish one ticket per plan slice to the repository’s configured tracker or to `.tickets/<plan-slug>/` when no external tracker is authoritative. Use at least two approved plan slices; a one-slice task cannot validate ticket dependencies or multi-session continuation.

**Interfaces/data:**

```text
one spec
  → one approved plan at base revision R
  → one ticket per plan slice, blockers-first, identical DAG
  → explicit session handoff at each chosen boundary
  → per-ticket TDD evidence
  → one final verification for the integrated unchanged state
  → one code-review verdict consuming that verification state
```

Tickets carry IDs and pointers, not copied paths, commands, or requirement prose. Session handoffs navigate to canonical artifacts and never become another spec, plan, status page, or verification table.

**Test seam and RED condition:** Every implementation ticket reuses its plan slice’s declared module interface, expected RED, and focused command after confirming that the plan and ticket are not stale. At least one session transition must occur before implementation completes; prefer a fresh session per frontier ticket when the dependency graph permits it.

**Implementation outline:**

1. Select a real change whose approved plan needs at least two slices and more than one session.
2. Verify the source spec, plan approval, explicit slice IDs, base revision, change map, verification contract, and DAG.
3. Invoke `publish-tickets`; check one-to-one mapping, acyclicity, blocker existence, publication order, and no reworded decomposition.
4. At each planned session boundary, ask explicitly for `session-handoff`, write its temporary artifact outside the repository, and start the next session with the named owner available. Record only its path/revision pointer and whether every canonical artifact was found.
5. Execute frontier tickets without silently changing slice boundaries. Return a stale or defective plan to `plan`; do not repair it in a ticket.
6. Preserve per-ticket RED/GREEN and intermediate state evidence, but defer the integrated readiness verdict to one final verification run after all relevant mutations.
7. Run code review against the integrated scope and consume the final verification result.

**Verification:** The record must include a ticket-to-slice-to-source-ID matrix, an acyclic dependency graph, publication target, base revision, at least two session starts, handoff recovery outcomes, per-ticket evidence pointers, final worktree state, one final verification verdict, and one review verdict.

**Blocked by:** Slice 1; a real qualifying task; an approved plan; user authorization before creating external tracker issues. If external tracker access is unavailable, decide explicitly whether local `.tickets/` evidence is sufficient and record that limitation before publication.

**Risks:** Copying plan details into tickets and creating stale parallel authority; measuring an ordinary pause rather than a genuine fresh-session recovery; mutating external tracker state without approval; treating each ticket’s local GREEN as integrated readiness.

### 6. Synthesize results, repair proven composition defects, and close the campaign

**Delivers:** A durable campaign result that supports “validated,” “adjusted and revalidated,” or “not validated,” plus honest public project status.

**Changes:**

- Create `docs/pilots/RESULTS.md` with one row per required pilot and links to canonical records.
- Normalize corrections into these initial categories without erasing free-text evidence: task-shape mismatch, missing/duplicate Skill, owner crossing, stale evidence reuse, duplicate verdict, unnecessary artifact/question, handoff recovery failure, or other.
- When the same correction category with the same causal contract defect appears twice, update only the owning Skill through a separate scoped change, run repository structural validation, increment the Rinco source revision, and rerun every affected pilot attempt.
- Treat a single safety-critical owner violation, stale readiness claim, or production edit before cause proof as adjustment-required even if it occurs only once.
- Keep failed and superseded attempts in their original pilot record; append rerun sections instead of rewriting history.
- After all four are accepted, update `docs/pilots/PROTOCOL.md` status and record links, annotate integration-plan slice 8 with the source revision and `RESULTS.md`, and update README current status with a pointer rather than copied conclusions.

**Interfaces/data:** `RESULTS.md` owns comparative conclusions only. Workflow artifacts own phase facts; per-pilot records own observations; the integration plan and README own project completion/status pointers.

**Test seam and RED condition:** This is evidence synthesis, not production behavior. The “red” state is any missing record/metric, unresolved required blocker, failed invariant, unrerun adjustment, stale final evidence, duplicate owner, or unaccounted repeated correction.

**Implementation outline:** Compare records only after all fields are complete; challenge each acceptance with the protocol invariants; route proven defects to their single owner; rerun affected evidence; then publish the aggregate verdict and status links.

**Verification:** Run the Final Verification contract below against the final unchanged campaign-document and Skill state.

**Blocked by:** Slices 2–5 for aggregate close only. All four may run opportunistically and independently after slice 1; synthesis waits for all accepted records. Route proven blockers to their owner and rerun affected attempts as soon as they arise rather than waiting for the other pilots.

**Risks:** Averaging away a severe invariant violation; silently dropping failed attempts; changing several Skills before isolating the responsible interface; declaring success because four files exist rather than because their evidence is complete and fresh.

## Migration and Rollback

No persistent-data or public-contract migration is planned.

Campaign rollback is documentation-safe and append-oriented:

- Do not delete a failed pilot record; mark the attempt `invalid` or `adjustment-required`, explain why, and append the accepted rerun when available.
- If an aggregate conclusion is disproved, add a dated correction to `RESULTS.md` and revert README/integration status to pending; do not rewrite the original observations.
- If a pilot-driven Skill adjustment regresses another lane, revert only that owning Skill change, rerun `scripts/validate.sh`, and mark evidence produced from the reverted source revision stale.
- Roll back production changes in a target repository only through that repository’s approved plan and safety rules. The pilot campaign does not grant permission to reset worktrees, delete unrelated work, close external tickets, or reverse persistent effects.
- Do not recreate `profiles/` as a rollback. ADR 0002 may be reconsidered only with repeated real evidence matching its stated reevaluation condition.

## Final Verification

The `verification` Skill owns the final repository gate state after the last campaign-related mutation. Manual campaign acceptance remains a separate protocol judgment and must not issue another `READY` verdict.

| Claim and scope | Requirement | Owner / earliest due stage | Method | Authority | Expected evidence |
|---|---|---|---|---|---|
| Rinco source used by each attempt is identifiable and stable | required | pilot operator / intake | `git rev-parse HEAD`, `git status --short`, source install inventory | ADR 0002; workflow freshness rules | Commit and state in each attempt; later source changes start a rerun |
| Installed Skills have no duplicate names and required dependencies are available or honestly blocked | required | pilot operator / intake | Enumerate project/global discovery roots or explicit `--skill` arguments; retain `BLOCKED` transcript | Protocol invariant 4; ADR 0002 | Empty duplicate set; exact installed list; missing dependency recovery if exercised |
| All four tasks are real and match their required shapes | required | campaign reviewer / pilot acceptance | Inspect request authority and eligibility section | Protocol / Required pilots | Four accepted eligibility decisions with source pointers |
| Every required metric is populated for every attempt | required | pilot operator / record close | Inspect the seven protocol metric fields and event log | Protocol / Metrics | Measured value, `none`, or justified `unavailable`; no blanks |
| One behavior contract and one plan exist only when needed | required | campaign reviewer / pilot acceptance | Inspect chronological artifacts and owner event log | Protocol invariants 1–2; ADR 0001 | Pilot 1 has no unnecessary spec/plan; Pilots 2 and 4 have exactly one of each; Pilot 3 only reroutes if behavior authority is missing |
| Unknown defect is diagnosed before production behavior changes | required | systematic-debugging / diagnosis | Compare initial diff, experiment statuses, cause handoff, and first production edit | systematic-debugging and fix contracts | Proven causal chain and clean diagnostic handoff precede TDD edit |
| Ticket graph exactly preserves approved plan slices | required | publish-tickets / publication | Compare slice IDs, ticket IDs, blocking edges, base revision, and publication order | publish-tickets contract | One-to-one complete acyclic map with no re-slicing |
| At least two fresh sessions recover Pilot 4 from canonical pointers | required | session-handoff / continuation | Compare handoff fields, artifact existence, next-session startup, and recovery event | Protocol pilot 4; living-docs/session-handoff contracts | Two session starts with no duplicated canonical content or unresolved required pointer |
| Each unchanged final implementation state has one verification verdict | required | verification / implementation or pre-review | Owner-attributed gate report with commands, exits, before/after status, freshness | Protocol invariant 3; verification contract | One `READY`, `NOT READY`, or `BLOCKED` owner output; no competing gate table |
| Review remains separate and consumes verification | required for Pilots 2 and 4; risk-based otherwise | code-review / review | Persisted review report and verification-state reference | integration plan; code-review contract | Review verdict is separate; no duplicate readiness calculation |
| Repeated or critical corrections are resolved and rerun | required | owning Skill change, then campaign reviewer | Correction ledger, scoped diff, structural validation, affected rerun | Protocol repeated-correction rule | No unresolved repeated category or critical invariant violation |
| Final repository structural gates pass | required | verification / campaign close | `scripts/validate.sh`; `git diff --check`; `git status --short` before/after | `AGENTS.md`; `scripts/validate.sh` | Exit 0, empty diff-check output, no command-created mutation |
| Public status points to canonical results | required | campaign close | Inspect `PROTOCOL.md`, integration plan, README, and links | project documentation ownership | No copied/contradictory status; all pointers resolve |

Final campaign acceptance is allowed only when:

1. all four canonical records exist and every required attempt is `accepted`;
2. no required gate is failed, blocked, stale, duplicated, or silently marked N/A;
3. every repeated or critical correction has a scoped owner fix and accepted rerun;
4. `RESULTS.md` names the Rinco source revisions and limitations;
5. the final `verification` run reports the repository state from after the last relevant mutation;
6. README and the integration plan link to the result without claiming release or publication readiness.

## Assumptions and Open Questions

- **Open — real tasks and target repositories:** none of the four qualifying tasks has been selected. Select opportunistically from genuine requests; this blocks each execution slice, not this plan.
- **Open — Pilot 4 publication target:** choose the repository’s authoritative tracker when configured and authorized. Otherwise explicitly approve local `.tickets/<plan-slug>/` as the evidence surface and record the limitation.
- **Open — context measurement source:** the protocol permits approximate observations. Record the Pi-displayed context share at each boundary when available; otherwise use `unavailable: <reason>` and still record qualitative recovery cost. Do not fabricate precision.
- **Assumption — one model/version is not required across all pilots:** record Pi/model/session details when available so differences remain visible; do not attribute a lane effect to Skill text when model or repository differences are a plausible cause.
- **Assumption — target repository authority wins for commands:** use its package manager, scripts, CI, services, and safety constraints. Do not install dependencies or substitute preferred tools without approval.
- **Assumption — evidence artifact exclusion is narrow:** for a self-hosted pilot, reserve and exclude only the canonical pilot record and the review artifact explicitly reserved by `code-review`; all production, test, configuration, Skill, and other documentation changes remain in verification scope.
- **Resolved — previous source worktree:** the 25-path ADR 0002 transition was committed in `a87b8d2`; execution started clean. **Still required before a pilot:** commit the revised protocol/template and pin that clean source revision. On 2026-09-07 the user explicitly authorized committing the four preparation documents after their checks pass (without pushing) and requested candidate selection from this repository; no specific pilot task has yet been approved.

## Non-Goals

- Revalidating every promoted Skill in isolation.
- Producing statistically significant model benchmarks or comparing model vendors.
- Manufacturing tasks solely to make all four lanes pass.
- Restoring fixed startup profiles, building an installer, or publishing a package.
- Evaluating `wayfinder`, general research, or broad architecture-survey workflows before these pilots expose a real need.
- Treating TDD GREEN, verification `READY`, code-review approval, merge approval, release approval, and production acceptance as interchangeable conclusions.
- Automatically committing, pushing, opening external tickets, merging, releasing, deploying, or mutating production systems.
