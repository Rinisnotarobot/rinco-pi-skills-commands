# Pilot Protocol — Hybrid Rinco Lanes Validation

Lifetime: **delivery protocol** for the [composition validation plan](../plans/2026-09-07-composition-pilot-validation.md). Revise the method explicitly; a relevant protocol or Skill change requires reassessing affected evidence.

Status: **Pilot 1 runtime recovery and RED/GREEN observed; consult its record for verification and acceptance disposition. Pilots 2–4 pending real tasks; campaign incomplete.** Established on 2026-09-07 against `82a107c0830c02d89766d91d39d70e5b6d388866`; see [Pilot 1 — frontmatter closing delimiter](1-frontmatter-closing-delimiter.md) for request authority, source state, session recovery, and execution evidence. This supersedes the no-record, missing-installation, and restart-pending statuses; it changes campaign status, not the execution method. Recheck on admission, recovery, or attempt close. Protocol preparation and installation alone are not completed pilots.

[Required pilots](#required-pilots) · [Execution](#execution) · [Metrics](#metrics-to-record-per-pilot) · [Acceptance](#completion-invariants-and-acceptance) · [Record template](RECORD-TEMPLATE.md)

## Purpose and ownership

Exercise the Rinco kernel plus Matt-derived discovery layer on real tasks before evaluating `wayfinder`, architecture surveying, or a general research workflow. Collect rework and gate-quality observations; without a comparable baseline, describe observations rather than claiming a measured improvement.

- This protocol owns the method and campaign status. The [validation plan](../plans/2026-09-07-composition-pilot-validation.md) owns sequencing and the final verification contract.
- The [record template](RECORD-TEMPLATE.md) owns the record fields. Each `docs/pilots/<n>-<task-slug>.md` owns that task's observations, including failed and rerun attempts.
- Phase artifacts retain their existing owners under [ADR 0001](../adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md). A record links to owner evidence; it does not publish a second specification, plan, verification gate table, or review verdict.
- The operator records events; the campaign reviewer checks this protocol's acceptance conditions. Those are recording roles, not new Skills or stage owners. State who filled each role; independent human acceptance is not implied.

## Required pilots

| # | Task shape | Lane | Recommended bundle |
|---|---|---|---|
| 1 | One small, already-clear behavior | `tdd → verification` (+ optional risk-based `code-review`) | build |
| 2 | One ambiguous multi-module feature | `shape (grilling + domain-modeling [+ prototype]) → spec → plan → tdd → verification → code-review` | shape, then build |
| 3 | One unknown-cause defect | `fix → systematic-debugging → tdd → verification (+ optional code-review)` | fix |
| 4 | One multi-session change requiring ticket handoff | `spec → plan → publish-tickets → per-ticket tdd → final verification → code-review` | shape/build + publish-tickets |

Use the [README bundle membership](../../README.md#推荐套装) and each owner's current dependency contract, including conditional partners. Follow [ADR 0002](../adr/0002-self-install-skills-with-recommended-bundles.md): self-install the required Skills and restart; record missing dependencies as honest `BLOCKED` recovery, not silently skipped work. Do not restore fixed launcher profiles.

Each pilot requires a real repository and a real requested change. Self-hosting is valid when the task naturally matches its lane. Documentation-only protocol preparation, invented defects, staged demonstrations, and retrospective reconstruction do not count.

## Execution

### 1. Admit a task

Record the original request or issue, its authority, the expected observable outcome, the target repository, and why it fits one row above. Apply the [plan's per-pilot eligibility rules](../plans/2026-09-07-composition-pilot-validation.md#implementation-slices):

- **Pilot 1:** select bounded behavior with settled intent and a runnable behavioral test; skip needless grilling, spec, plan, and tickets.
- **Pilot 2:** select a genuine multi-module feature with a user-owned decision and a domain-language question. Use a prototype only when one design question needs observation.
- **Pilot 3:** start with an observable symptom whose complete cause is still unknown. Select a task capable of exercising the diagnosis-to-TDD handoff; a known-cause fix does not cover this lane.
- **Pilot 4:** use at least two approved plan slices, ticket mapping, and at least two session starts with one actual fresh-session handoff. Extra session boundaries are optional. Preserve the plan's real dependency edges; do not manufacture a dependency for demonstration.

Inspect the target repository to discover prerequisites and repository-authoritative test/gate commands. Record the exact focused RED/GREEN command before its first use; for Pilot 2, let shaping and planning determine the seam instead of pre-implementing the feature at intake. Record task rejection reasons without fabricating a RED.

**Exit:** a real task, matching lane, scope, authority, and prerequisite disposition are recorded. Without a task, leave the pilot pending and create no empty pilot or results file.

### 2. Pin source, target, and session state

Run in both the Rinco source checkout and the target repository, recording which is which:

```bash
git branch --show-current
git rev-parse HEAD
git status --short
git diff --stat
git diff --cached --stat
```

Record a clean, committed Rinco Skill/protocol source before the attempt begins. A prior commit plus later uncommitted protocol edits is not the new protocol baseline. Do not commit, reset, or stash on behalf of the operator; ask for the source disposition when necessary. Record and preserve any unrelated target-repository work rather than demanding its removal.

For every session, inventory the actual available Skills: frontmatter name, resolved directory, source revision, and active discovery/configuration path. Include project/global locations and any other enabled sources; compare same-name candidates and the available-Skills list. A directory existing on disk is not proof that it is available in this session. Reject duplicate names or competing authoritative owners. Compare the installed directories, including their references, with the pinned Rinco source; only declared provenance metadata differences are expected. Resolve content drift in Skills used by the pilot before resuming; unrelated global mirror warnings remain informational.

Missing dependencies leave an honest blocker: retain the original output, name the missing Skills and installation locations, and record the restart and rechecked inventory. Installation of new dependencies or use of a real tracker requires the appropriate user authorization. Record the Pi/model version if observable, otherwise `unavailable: <reason>`; this protocol adds no runtime launcher or automatic installer.

**Exit:** source revision, target baseline and dirty content, active Skill inventory, duplicate/parity checks, and every required prerequisite are fixed. A missing prerequisite permits a blocked observation, not a successful execution claim.

### 3. Execute owners and capture events

Copy [RECORD-TEMPLATE.md](RECORD-TEMPLATE.md) into `docs/pilots/<n>-<task-slug>.md` only for the admitted task. Record each input, output pointer, next owner, approval/stop point, and command as it occurs. Give events stable IDs; append corrections to the original observations rather than overwriting them.

Use each Skill's stopping contract. The operator explicitly invokes user-owned stages such as `spec`, `publish-tickets`, and `code-review`; a model-invoked stage returning to its caller does not require a fresh session. Use `session-handoff` only on explicit request, following its [temporary-file contract](../../skills/workflows/session-handoff/SKILL.md). Observe recovery before the temporary file expires; retain the recovery facts and canonical artifact identifiers in the pilot record, not a second continuation document.

For each evidence-producing command or observation:

1. Record the claim, scope, producer/owner, source IDs if supplied, method/command, prerequisites, and timestamp.
2. Retain the exact exit status or observation result and enough key output to distinguish the expected failure from setup failures. Link larger logs from an accessible durable evidence location; redact secrets and sensitive payloads.
3. Capture `git status --short` before and immediately after the gate. Bind it to the relevant diff and dependency/configuration state as well as HEAD. A status listing alone cannot detect a second edit to an already-modified file; retain a reproducible patch or content fingerprint, including relevant untracked inputs.
4. Record whether downstream evidence was reused, rejected, rerun, or blocked and why. Refer to the [verification freshness contract](../../skills/workflows/verification/references/evidence-handoffs.md); only `verification` decides reusable gate evidence and final readiness.

A gate that unexpectedly mutates the target stops dependent checks. Preserve the change, report the blocker, and ask for cleanup or approval rather than restoring it automatically. Relevant later edits invalidate the affected verification/review evidence; retain the older result as historical evidence and rerun through its owner.

**Exit:** every completed handoff and gate has a chronological, state-bound observation; unrun work is explicit, not implied by an empty field.

### 4. Keep record writes outside implementation evidence

Reserve the pilot record path before target verification. If the pilot self-hosts here, explicitly exclude only that path and the review artifact path reserved by `code-review` from the pinned implementation scope. Log their updates; do not expand the exclusion to all docs, tests, configuration, Skills, or unrelated files. Recheck the actual diff to prove that an excluded record write was the only post-verification change.

For external target repositories, this repository's pilot record does not mutate the target. In both cases, run this repository's structural gate after record/document edits stop. Updating an observation file is not permission to alter phase evidence or hide target mutations.

**Exit:** implementation scope, excluded artifact paths, and every post-verification mutation are accounted for without creating a circular verification claim.

### 5. Close or resume the attempt

Fill all seven metrics and the invariant table, then apply the disposition rules below. Preserve a `BLOCKED`/failed workflow outcome and its next action even when the lane handled it correctly; it is not a completed end-to-end pilot.

Resume the same task under the same source after rechecking scope, sequence, worktree, and prerequisites; append a resumption event and refresh stale evidence. A relevant Skill/protocol change or an adjustment requiring a rerun starts a new numbered attempt. A replacement real task gets its own slug and links to the previous record. Keep invalid and failed attempts visible.

**Exit:** the attempt is either accepted with evidence or recorded with an explicit blocker, adjustment, or rejection and next actor.

## Metrics to record per pilot

Retain these seven metrics; the template contains their fields:

- **First useful RED:** TDD's first failing test that fails for the intended behavioral reason. Count foreground assistant turns starting at the task invocation through that observation, across sessions; exclude tool messages and separately label any subagent count. Record start/RED timestamps, timezone, and elapsed wall time. Disclose pauses and human wait time instead of subtracting them silently. A debugging red loop is separately identified, not relabeled as TDD RED.
- **Unnecessary questions/artifacts:** list each question or artifact with its event and why the task did not need it; separate protocol recordkeeping from lane-created work.
- **Rejected/stale handoffs:** identify producer, consumer, reason, and resolution. Distinguish correct rejection from an incorrectly accepted stale handoff.
- **Duplicate conclusions/gate tables:** identify a competing owner or repeated final verdict for the same claim, stage, scope, and unchanged state. A pointer quoting the owner's result is not a second verdict; a later-state rerun is not a duplicate.
- **Boundary context usage:** record the observed approximate context share at each handoff. If unavailable, state why and record any qualitative recovery cost without inventing a percentage.
- **Post-readiness defects:** record failures and defects discovered after a readiness claim, with the claim's state, discovery event, attribution, and observation cutoff. `none observed through <timestamp>` is not a future no-defect guarantee.
- **Manual owner corrections:** retain the event, operator intervention, affected owner, causal explanation, and correction category.

Use `none` only for an observed absence. Use `unavailable: <reason>` for missing measurement and `not reached: <blocker>` for an unfinished phase. Neither supplies missing required proof. Approximate context observations may remain unavailable as disclosed limitations; unavailable required behavioral or invariant evidence prevents acceptance.

## Completion invariants and acceptance

Check the original four invariants per attempt:

1. one behavior contract when needed (no second spec source);
2. one plan when needed (no second decomposition);
3. one final verification state per unchanged target state;
4. no Matt workflow duplicate among the session's installed skills.

Record `PASS`, `FAIL`, or `UNPROVEN` and evidence for each. For invariants 1–2, skipping an unnecessary artifact can be `PASS` with the task-shape reason; missing a required artifact is not N/A. These are observations, not a competing implementation gate table.

Use `eligible → running → recorded`, then choose one disposition:

| Disposition | Condition | Next action |
|---|---|---|
| `accepted` | Real task fits its lane; required phases finish; all four invariants pass; required metrics/evidence are present and current; no unresolved required failure or blocker | Record reviewer, timestamp, and evidence pointers |
| `recorded` | The attempt is interrupted or required evidence is unavailable | Retain blocker and next actor; resume with fresh state checks |
| `adjustment-required` | A lane/owner defect requires a contract change, a repeated correction, or a critical invariant repair | Route to the owning Skill, verify the scoped change, and append an affected rerun |
| `invalid` | Task does not fit, authority is missing, or evidence was fabricated/unreconstructable | Preserve why; select another real task without backfilling observations |

Keep the lane verdict separate: `lane kept as designed`, `lane adjusted (how)`, or `lane failed (why)`. For an unfinished run, write `not reached: <blocker>` rather than inventing a verdict. An adjusted verdict does not imply acceptance until the affected rerun is accepted. `verification` alone issues `READY`/`NOT READY`/`BLOCKED` for implementation; review remains separate and is required for Pilots 2 and 4 and risk-based otherwise.

A manual correction is valid evidence. Group corrections as task-shape mismatch, missing/duplicate Skill, owner crossing, stale evidence reuse, duplicate verdict, unnecessary artifact/question, handoff recovery failure, or other. Retain the causal detail: two corrections of the same kind require an owning-Skill revision before trust; a single safety-critical owner violation, stale readiness claim, or production edit before cause proof also requires adjustment. Restore a violated invariant before accepting a run. Keep failed attempts and append the revision plus affected rerun; do not wait for all four pilots to fix a proven blocker.

## Campaign close

After all four pilots have accepted records, create `docs/pilots/RESULTS.md` under [plan slice 6](../plans/2026-09-07-composition-pilot-validation.md#6-synthesize-results-repair-proven-composition-defects-and-close-the-campaign). It owns the cross-pilot matrix, recurring-correction ledger, source revisions, rerun links, observation limits, and campaign conclusion. Until it exists, no results link or completed status should imply otherwise.

Run `scripts/validate.sh` and `git diff --check` from this repository after the final relevant document/Skill mutation, recording before/after worktree state. These commands establish structure and hygiene, not successful pilot behavior. Have `verification` consume the final evidence contract. Update this status, integration-plan slice 8, and README pointers only with the accepted result; retain the recorded date and revision.

Pilot acceptance does not mean the entire Skill portfolio or release work is complete. `frontend-patterns` and the remaining [portfolio work](../plans/2026-09-03-skill-portfolio-focus.md) are independent of these four lane observations.
