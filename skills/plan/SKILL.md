---
name: plan
description: Evidence-based implementation planning for code changes. Use when the user asks for an implementation plan, a multi-file feature needs sequencing before coding, a migration or compatibility change needs rollout steps, or another engineer or agent needs a codebase-grounded handoff.
---

# Implementation Planning

Turn a sufficiently clear coding goal into an executable, verifiable change plan. Inspect the repository before naming changes. Planning produces decisions and ordered work; it does not modify production code.

## Workflow

### 1. Establish the implementation contract

Extract:

- intended observable outcome;
- in-scope and out-of-scope behavior;
- acceptance evidence;
- technical and business constraints supplied by authoritative sources;
- assumptions and unresolved decisions.

Repository code is evidence of current behavior, not proof of desired product policy. Ask only about decisions that cannot be discovered and would materially change behavior, safety, compatibility, persistent data, cost, or public interfaces. Approval is not the default gate: record unresolved decisions as open questions and proceed unless one of them blocks the plan.

Completion criterion: the goal is testable, scope is bounded, and every implementation-blocking decision is resolved or explicitly listed.

### 2. Trace the current code path

Read [references/codebase-evidence.md](references/codebase-evidence.md). Locate the relevant entry point, call/data flow, state ownership, external boundaries, similar implementation, tests, configuration, and authoritative verification commands.

Use exact paths and symbols only after verifying that they exist. Distinguish confirmed facts from proposals.

Completion criterion: the plan can explain where the behavior enters, where it is decided, where state or effects occur, and where it is currently tested.

### 3. Choose the change strategy

Start with the smallest strategy consistent with the repository's existing architecture. Compare alternatives only when a real decision exists. For each viable option state:

- what boundary or invariant it changes;
- compatibility and operational consequences;
- why it is selected or rejected.

Avoid architecture changes whose benefit is unrelated to the requested behavior. If preparatory refactoring is necessary, identify the concrete obstruction it removes.

Completion criterion: one strategy is selected from explicit constraints rather than preference.

### 4. Build the change map

List each verified integration point:

```text
<path> :: <symbol or section>
Current responsibility:
Planned responsibility:
Interface/data impact:
```

Include created, modified, moved, and deleted artifacts; tests; schemas/migrations; configuration; documentation; generated artifacts; and public contracts only where applicable.

Use signatures, schemas, state transitions, or short pseudocode only when they encode a decision that prose cannot preserve precisely. Do not write the implementation inside the plan.

Completion criterion: every planned artifact has a reason to change and every affected boundary has an owner.

### 5. Slice and order the work

Read [references/slicing-and-dependencies.md](references/slicing-and-dependencies.md). Prefer vertical slices that deliver one observable behavior through the required layers and remain buildable after each slice. Give each slice:

- behavior delivered;
- files and symbols changed;
- interface or data decisions;
- test seam and RED condition (predicted failing test or characterization — asserted by the plan, written by the executor);
- implementation outline;
- focused and broader verification;
- dependencies and risks.

Use horizontal steps only when the work is inherently cross-cutting or cannot remain compatible as a vertical slice. For schema, API, protocol, or broad migrations, read [references/migrations-and-rollout.md](references/migrations-and-rollout.md).

Completion criterion: dependency order is explicit, no slice relies on hidden work, and each slice ends in an independently verifiable repository state.

### 6. Define verification and completion

Derive exact commands from repository evidence. Separate:

1. focused RED/GREEN command;
2. affected package/module checks;
3. repository-required test, type, lint, build, and coverage gates;
4. manual, operational, migration, security, or compatibility evidence that automation cannot prove.

Do not invent a coverage threshold or require every test level. Match verification to the risk and existing project policy.

### 7. Self-review the plan

Read [references/plan-quality.md](references/plan-quality.md) and repair gaps before returning. Confirm requirement coverage, path/symbol existence, interface consistency, dependency ordering, migration safety, and verification traceability.

Return the plan in the conversation unless the user requested a file or the repository defines an authoritative plan location. Stop for a reply only when an open question is blocking or the user explicitly requested a review gate.

## Choose the Depth

- **Compact:** one or two local files, established pattern, no persistent-data or public-contract change. Return current path, ordered changes, tests, and verification.
- **Standard:** several modules or a new behavior crossing boundaries. Use the full output contract.
- **Migration:** persistent data, public API/protocol, dependency replacement, multi-stage rollout, or compatibility window. Include transition states, rollback, observability, and cleanup.

Use the smallest depth that leaves no implementation decision hidden.

## Output Contract

```markdown
# Implementation Plan: <change>

## Goal and Scope
## Repository Evidence
## Selected Strategy
## Change Map
## Implementation Slices
### 1. <observable deliverable>
- Changes
- Interfaces/data
- Test seam and RED condition
- Implementation outline
- Verification
- Blocked by
- Risks
## Migration and Rollback

Include this section only when the change involves persistent data, a public contract, or multi-stage rollout.
## Final Verification
## Assumptions and Open Questions
## Non-Goals
```

[references/example-plan.md](references/example-plan.md) shows a worked Compact-depth plan end to end.

A plan is complete when another engineer or agent can execute it without rediscovering the code path or inventing requirements, while retaining freedom over implementation details not decided by the task. Executing the slices follows the `tdd` skill's red–green cycle at each named seam.
