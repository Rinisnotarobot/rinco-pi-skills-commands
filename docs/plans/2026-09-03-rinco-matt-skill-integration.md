# Implementation Plan: Integrate Matt's discovery layer into the Rinco evidence kernel

## Goal and Scope

Implement [ADR 0001](../adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md) without replacing the proven Rinco delivery chain. Add only the Matt-derived capabilities that improve decision quality, domain language, module design, task scheduling, and context recovery.

The target is a set of task-specific lanes rather than one mandatory ceremony:

```text
Small, clear behavior:
  authoritative request → tdd → verification → optional risk-based code-review

Ambiguous change:
  shape(grilling + domain-modeling, with prototype/research branches)
    → spec → plan → optional publish-tickets
    → tdd → verification → code-review

Unknown defect:
  fix → systematic-debugging → tdd or approved direct repair
    → verification → optional risk-based code-review

Large, foggy effort:
  optional wayfinder → spec → plan → publish-tickets
    → per-ticket tdd evidence → final verification → code-review
```

Every arrow denotes artifact or evidence handoff. It does not promise that Pi can discover a missing Skill during the current session.

## Source Decision

- Architecture decision: [`docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md`](../adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md)
- Current Rinco workflow authority: repository `README.md` and promoted `skills/`
- Upstream design source: <https://github.com/mattpocock/skills>
- Pi runtime source: <https://github.com/badlogic/pi-mono>

## Current State

Already promoted and retained as authoritative:

- `skills/workflows/spec/`
- `skills/workflows/plan/`
- `skills/workflows/systematic-debugging/`
- `skills/workflows/tdd/`
- `skills/workflows/verification/`
- `skills/workflows/code-review/`
- `skills/workflows/fix/`
- supporting patterns and tools under `skills/patterns/` and `skills/tools/`

Useful processing candidates:

- `processing/skills/grilling/`
- `processing/skills/living-docs-governance/`

The former `docs/plans/2026-08-28-skill-roadmap.md` has been superseded and removed. Its surviving targets (`security-review`, `resilience`, `frontend-patterns`) moved to `docs/plans/2026-09-03-skill-portfolio-focus.md`; the remaining targets (`codebase-onboarding`, `migration`, `release-readiness`) were dropped.

Current exact name collisions with the Matt repository are `tdd`, `code-review`, and `writing-for-agents`; including Rinco processing also adds `grilling`. Pi warns on duplicate names and keeps the first discovered Skill, so production profiles must not discover both copies.

## Non-Negotiable Invariants

1. One responsibility has one authoritative owner.
2. Only `verification` produces the current implementation gate state `READY`, `NOT READY`, or `BLOCKED`.
3. `code-review` produces a separate review verdict and consumes, rather than duplicates, verification evidence.
4. `spec` owns desired behavior; `plan` owns repository implementation strategy and decomposition.
5. `systematic-debugging` stops after proving cause and preparing a downstream handoff.
6. Later relevant mutations invalidate state-bound evidence.
7. User-invoked stages hand off and stop before another user-invoked stage.
8. Missing startup dependencies are never treated as dynamically loadable.
9. `CONTEXT.md` remains a glossary, not a specification, plan, status page, or session transcript.
10. Every adapted upstream Skill enters through `processing/skills/` and passes composition validation before promotion.

Reference and primitive Skills may own vocabulary or execution discipline without producing a verdict. Orchestrators own routing state only.

## Responsibility Map

| Responsibility | Authoritative owner | Matt capability used | Integration rule |
|---|---|---|---|
| Decision-tree stress testing | new/adapted `grilling` | `grilling` | Return shared-understanding handoff; do not implement |
| Domain language and durable decisions | new/adapted `domain-modeling` | `domain-modeling` | Mutate only approved glossary/ADR paths and report worktree state |
| Behavior contract | Rinco `spec` | selected grilling inputs | Preserve `REQ`, `INV`, `AC`, authority and traceability |
| Module design vocabulary | new/adapted `codebase-design` | `codebase-design` | Reference layer only; no autonomous redesign workflow |
| Technical plan and slicing | Rinco `plan` | tracer bullets, blocking edges, prefactoring | Plan remains the only decomposition authority |
| Tracker publication | future `publish-tickets` | `to-tickets` | Serialize approved plan slices without replanning |
| Design-question evidence | future `prototype` | `prototype` | Answer one named question; production code remains downstream |
| Root-cause proof | Rinco `systematic-debugging` | tight red-capable loop | No production behavior edits before handoff |
| Behavior implementation | Rinco `tdd` | stable seams and vertical slices | Keep Rinco RED, GREEN, REFACTOR and evidence handoff |
| Gate state | Rinco `verification` | none required | Single current gate table and verdict owner |
| Review | Rinco `code-review` | optional Standards/Spec separation | Preserve Rinco finding gate and separate Verification State |
| Repair orchestration | Rinco `fix` | none required | Route existing owners; document any direct non-behavioral repair exception |
| Context recovery | adapted living-docs and handoff rules | context pointers, phase boundaries | Read pointers to canonical artifacts; do not duplicate their contents |

## Artifact Lifetimes

| Class | Typical artifacts | Authority and invalidation |
|---|---|---|
| Durable | `AGENTS.md` pointers, `CONTEXT.md`, ADRs | Reviewed project truth; update only through their owning discipline |
| Delivery | specs, plans, tickets | Authoritative for one effort; revise explicitly and preserve supersession links |
| State-bound evidence | verification and review reports | Reusable only for matching claim, scope, sequence, worktree and prerequisites |
| Exploration | research notes and prototype branches | Evidence for one question; retain a pointer and limits, not a generalized conclusion |
| Session continuation | compact handoff | Navigation to primary artifacts plus current owner, state and next invocation |

A continuation handoff should contain:

```text
Current owner and phase
Pinned branch, HEAD and worktree state
Source artifact paths and revisions
Completed evidence and its freshness scope
Open blocker or unresolved decision
Next explicit invocation
Required Pi startup profile
Evidence invalidated by later changes
```

## Pi Startup Profiles

Prompt templates may select work but cannot add undiscovered Skills. Implement profiles as shell launchers, package filters, or documented `pi --no-skills --skill ...` commands.

### Shape

```text
grilling
domain-modeling
codebase-design
spec
plan
terminal-ops
context7-docs
```

### Build

```text
plan
tdd
systematic-debugging
verification
code-review
coding-standards
terminal-ops
```

### Fix

```text
fix
systematic-debugging
tdd
verification
code-review
coding-standards
terminal-ops
```

### Review

```text
code-review
verification
coding-standards
terminal-ops
```

Keep prompt templates thin: state the requested artifact or next explicit Skill, then rely on the preloaded owner. A profile/router reports a relaunch command when the current session lacks a dependency; it never claims that expanding a prompt loaded the dependency.

## Implementation Slices

### 1. Stabilize governance references

**Delivers:** one current architecture decision and a non-conflicting roadmap baseline.

**Changes:**

- link ADR 0001 and this plan from `README.md`;
- add a trigger-specific pointer in `AGENTS.md` for workflow ownership, external Skill adoption, and Pi profile changes;
- synchronize `docs/plans/2026-08-28-skill-roadmap.md` with promoted `fix`, or mark it as a historical snapshot without rewriting its original plan. (Resolved: roadmap superseded and removed; surviving targets tracked in `docs/plans/2026-09-03-skill-portfolio-focus.md`.)

**Verification:** every pointer resolves; no decision text is duplicated; `git diff --check` passes.

**Blocked by:** none.

### 2. Promote a Pi-compatible grilling primitive

**Delivers:** decision-tree stress testing before specification without creating a parallel behavior contract.

**Changes:**

- review `processing/skills/grilling/` against current Matt `grilling`;
- preserve rounds, frontier, recommendations, fact-versus-decision ownership, and final shared-understanding confirmation;
- make subagent use conditional on available Pi tooling rather than mandatory;
- define a compact decision handoff containing approved decisions, rejected options, unresolved blockers, source authority and artifact pointers;
- promote only after positive, non-trigger, BLOCKED and premature-implementation scenarios pass.

**Verification:** grilling stops before spec or implementation; user decisions are not self-answered; unavailable facts become explicit prerequisites.

**Blocked by:** slice 1.

### 3. Add domain and module vocabulary layers

**Delivers:** file-backed domain memory and shared module-design language without changing Rinco ownership.

**Changes:**

- adapt `domain-modeling` into `processing/skills/`;
- keep `CONTEXT.md` glossary-only and gate ADR creation on reversibility, surprise and real trade-off;
- declare the exact allowed worktree mutations and include them in the handoff;
- adapt `codebase-design` as a reference Skill for module, interface, depth, seam, adapter, leverage and locality;
- point `spec`, `plan`, `tdd` and `code-review` at these references only on relevant branches.

**Verification:** domain modeling cannot write specs or implementation plans; codebase-design invocation alone does not start an autonomous refactor; every local reference resolves.

**Blocked by:** slice 2.

### 4. Promote typed context governance

**Delivers:** deterministic context recovery without a monolithic memory store.

**Changes:**

- revise `processing/skills/living-docs-governance/` around Constitution, Map, Status and History roles;
- make existing repository documents canonical before creating new files;
- define artifact lifetime and freshness rules from this plan;
- define a thin project entry prompt that reads the map, current status and only task-relevant history;
- never claim automatic reading unless `AGENTS.md`, package configuration or a real lifecycle hook provides it.

**Verification:** one canonical owner exists per fact; stale status is detectable; project entry does not load the full documentation tree.

**Blocked by:** slices 1 and 3.

### 5. Add one-question prototype evidence

**Delivers:** a bounded exit from unproductive discussion.

**Changes:**

- adapt Matt `prototype` under `processing/skills/`;
- require one explicit design question and a stopping condition;
- separate the decision answer from the throwaway implementation;
- return an evidence handoff with artifact location, observed result and limitations;
- keep prototype code outside the production merge path unless a later Rinco plan deliberately reimplements the validated behavior.

**Verification:** the prototype answers one named question, contains no production-readiness claim, and cannot bypass `spec`, `plan`, `tdd` or `verification` when production behavior changes.

**Blocked by:** slice 2.

### 6. Add a plan-to-ticket publication adapter

**Delivers:** tracker-native scheduling without a second planning owner.

**Changes:**

- create `processing/skills/publish-tickets/` as user-invoked;
- accept only an approved Rinco plan artifact and its slice identifiers;
- publish one ticket per approved slice unless the plan itself is revised;
- include delivered behavior, source `REQ`/`INV`/`AC`, source plan and slice, blocking edges, base revision and acceptance pointer;
- keep exact paths, symbols and commands in the plan rather than duplicating them into tickets;
- preserve expand, migrate, contract ordering for wide refactors.

**Verification:** every ticket traces to exactly one approved slice; the dependency graph is acyclic; the publisher cannot silently merge, split or reinterpret slices.

**Blocked by:** slice 1.

### 7. Add deterministic launch profiles

**Delivers:** reproducible Pi sessions with required dependencies and no discovery-order ambiguity.

**Changes:**

- implement shape, build, fix and review launchers;
- use `--no-skills` during development and list every required `--skill` path;
- keep slash prompt templates as thin user interfaces over already discovered Skills;
- include exact relaunch commands in `BLOCKED` and `PENDING` reports;
- add a duplicate-name check for selected profile paths.

**Verification:** each profile exposes the intended commands, keeps core dependencies visible, and rejects a missing or duplicate owner before work begins.

**Blocked by:** slices 2, 3 and 6 for the complete profile set; fix/review profiles may ship earlier.

### 8. Pilot before adding wayfinder

**Delivers:** evidence that the hybrid reduces rework without weakening gates.

Exercise at least:

1. one small, already-clear behavior;
2. one ambiguous multi-module feature;
3. one unknown-cause defect;
4. one multi-session change requiring ticket handoff.

Record:

- turns and elapsed time to the first useful RED;
- unnecessary questions and artifacts;
- rejected or stale handoffs;
- duplicate conclusions or gate tables;
- context usage at phase boundaries;
- verification failures and defects found after a readiness claim;
- manual corrections needed to keep owners separate.

Only evaluate `wayfinder`, architecture surveying or a general research workflow after these pilots expose a real unresolved need.

**Verification:** every run has one behavior contract when needed, one plan when needed, one final verification state per unchanged target state, and no Matt workflow duplicate in its profile.

**Blocked by:** slices 2 through 7 as applicable.

## Composition Validation Matrix

Before promotion, verify these scenarios:

1. An ambiguous request enters grilling and cannot reach a ready spec until user-owned decisions are resolved.
2. An ungrillable question produces prototype evidence and returns to the original decision owner.
3. A clear one-session task skips unnecessary artifacts while still reaching fresh verification.
4. An unknown defect reaches a proven-cause handoff before production behavior changes.
5. A ticket publisher maps approved slices without creating a second decomposition.
6. Missing startup dependencies produce executable `BLOCKED` or `PENDING` recovery instructions.
7. A changed worktree invalidates old verification and review evidence.
8. `CONTEXT.md` contains only domain vocabulary.
9. A model-invoked reference cannot issue a competing verdict.
10. No profile contains duplicate authoritative owners or duplicate Skill names.

## Rollback

Each Matt-derived capability remains optional until promotion. Roll back a slice by removing it from the relevant startup profile and moving its directory back to `processing/skills/`. Keep the Rinco `spec`, `plan`, `systematic-debugging`, `tdd`, `verification`, `code-review` and `fix` artifacts unchanged.

Do not remove an upstream-derived Skill until its unique artifact or pointer has been mapped to a retained owner. Preserve source attribution and local adaptation notes.

## Non-Goals

- Replacing the Rinco delivery kernel with Matt's full workflow.
- Loading both repositories wholesale in one Pi session.
- Building an opaque general-purpose memory database.
- Making every task pass through every planning artifact.
- Letting ticket publication redefine the implementation plan.
- Adding wayfinder, release automation or broad architecture scanning before representative pilots justify them.
- Automatically committing, pushing, opening a PR, releasing or deploying.

## Completion Evidence

This integration is complete when:

- ADR 0001 remains the canonical decision;
- ownership and invocation modes agree across Skills, profiles and README;
- all promoted adaptations have source attribution and validated local references;
- all profile commands start with the intended dependency set and no duplicate names;
- the composition matrix has recorded evidence;
- representative tasks preserve the single-owner and fresh-evidence invariants;
- `git diff --check` and repository link checks pass;
- unrelated pre-existing worktree changes remain untouched.
