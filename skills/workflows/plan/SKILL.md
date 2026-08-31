---
name: plan
description: Evidence-based implementation planning that writes a final Markdown artifact to disk. Use when the user asks for an implementation plan, a multi-file feature needs sequencing before coding, a migration or compatibility change needs rollout steps, or another engineer or agent needs a codebase-grounded handoff.
---

# Implementation Planning

Turn a sufficiently clear coding goal into an executable, verifiable change plan. Inspect the repository before naming changes. Planning produces decisions and ordered work; the final plan artifact is its only expected repository change.

## Workflow

### 1. Establish the implementation contract

Extract:

- source specification path and status when one exists;
- intended observable outcome;
- in-scope and out-of-scope behavior;
- originating `REQ`, `INV`, and `AC` identifiers;
- acceptance evidence;
- technical and business constraints supplied by authoritative sources;
- assumptions and unresolved decisions.

Validate a supplied specification before planning: it must be ready, internally traceable, and authoritative for desired behavior. Preserve its identifiers and meaning. Repository code is evidence of current behavior, not proof of desired product policy.

Ask only about decisions that cannot be discovered and would materially change behavior, safety, compatibility, persistent data, cost, or public interfaces. When unresolved product or policy truth affects any of those outcomes or acceptance meaning, confirm that `spec` is available, then stop and ask the user to invoke `/skill:spec`; `spec` is user-invoked and planning must not synthesize it silently. When it is unavailable, return `BLOCKED` with a relaunch command that adds it. Only technical assumptions that do not alter desired behavior or safety may remain open in a persisted plan.

Completion criterion: the goal is testable, scope is bounded, every material product decision is resolved in the source specification or authoritative input, and remaining technical assumptions are explicit.

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

### 6. Define the verification contract

Derive completion evidence from the requirement, repository policy, selected design, and affected risks. For every evidence item record:

- claim and affected scope;
- `required` or `optional` status;
- owner and earliest stage when the evidence is due: debugging, TDD, verification, review, release, or operator;
- proving method: command, manual observation, operational signal, migration/reconciliation record, security review, or compatibility evidence;
- authority: requirement, repository instruction, CI job, configuration, or explicit risk decision;
- exact command or observable result, including prerequisites.

Separate focused RED/GREEN evidence, affected package checks, repository-required gates, and evidence automation cannot prove. Do not invent a coverage threshold or require every test level. Match the contract to the risk and existing project policy.

Planning defines this contract but does not execute it. TDD supplies behavior-cycle evidence; the `verification` skill accepts or rejects reusable evidence, runs missing gates, and owns the final gate state.

Completion criterion: every acceptance condition and material risk maps to a required or optional proving method without assigning the same gate to multiple executors.

### 7. Self-review and persist the plan

Read [references/plan-quality.md](references/plan-quality.md) and repair gaps before writing. Confirm requirement coverage, path/symbol existence, interface consistency, dependency ordering, migration safety, and verification traceability.

Choose the artifact path in this order:

1. an exact path supplied by the user;
2. an authoritative plan directory defined by the repository;
3. `docs/plans/YYYY-MM-DD-<slug>.md`.

Build `<slug>` from the plan title as lowercase ASCII kebab-case; use `implementation-plan` when no safe slug remains. Use the current local date. Preserve existing artifacts: if the path exists, append `-2`, `-3`, and so on before `.md` rather than overwriting it.

After the plan passes self-review, create the parent directory, write the complete Output Contract as one Markdown file, read it back, and confirm that no section was truncated. Return the artifact path and a concise summary in the conversation instead of duplicating the full plan.

Stop for a reply only when an open question is blocking or the user explicitly requested a review gate.

Completion criterion: the final, self-reviewed plan exists at the reported path and its contents match the plan summary.

## Choose the Depth

- **Compact:** one or two local files, established pattern, no persistent-data or public-contract change. Return current path, ordered changes, tests, and verification.
- **Standard:** several modules or a new behavior crossing boundaries. Use the full output contract.
- **Migration:** persistent data, public API/protocol, dependency replacement, multi-stage rollout, or compatibility window. Include transition states, rollback, observability, and cleanup.

Use the smallest depth that leaves no implementation decision hidden.

## Output Contract

```markdown
# Implementation Plan: <change>

## Goal and Scope
## Source Specification
## Requirement Traceability
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

The `Requirement Traceability` section maps every originating `REQ`, `INV`, and `AC` identifier to implementation slices and final evidence. The `Final Verification` section is the durable verification contract. Preserve each item's claim, scope, requirement level, owner/stage, method, authority, and expected evidence so downstream Skills do not have to rediscover or reinterpret it.

[references/example-plan.md](references/example-plan.md) shows a worked Compact-depth plan end to end.

A plan is complete when another engineer or agent can execute it without rediscovering the code path or inventing requirements, while retaining freedom over implementation details not decided by the task. Executing the slices follows the `tdd` skill's red–green cycle at each named seam.
