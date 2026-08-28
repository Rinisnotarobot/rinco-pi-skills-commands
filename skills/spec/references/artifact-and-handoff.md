# Artifact and Handoff

Use one durable artifact as the source of desired behavior.

## Output contract

```markdown
# Specification: <change>

- Status: READY FOR PLAN
- Depth: Compact | Standard | Consequential
- Date: YYYY-MM-DD
- Sources: <user decision, issue, PRD, policy, repository evidence>

## Outcome
## Actors and Definitions
## Scope
### In Scope
### Non-Goals
## Authority and Context
### Supplied Product/Policy Requirements
### Repository Facts
### Assumptions
## Requirements
### REQ-001: <outcome or constraint>
- Authority:
- Priority: required | important | optional
- Applies to:
## Invariants
### INV-001: <condition that must remain true>
- Applies across:
## Failure and Boundary Behavior
## Dependencies and Constraints
## Acceptance Criteria
### AC-001: <observable outcome>
- Proves: REQ-001, INV-001
- Given:
- When:
- Then:
- Must not:
- Evidence intent:
- Environment/owner:
- Priority: required | important | optional
## Traceability
| Requirement / invariant | Acceptance criteria | Evidence intent |
|---|---|---|
| REQ-001 | AC-001 | automated behavior |
## Non-Blocking Assumptions
## Decisions and Rationale
## Handoff
### Planning inputs
### Security/privacy inputs
### Operational or migration inputs
```

Omit empty optional sections in Compact depth. Preserve authority, scope, requirements, acceptance criteria, traceability, assumptions, decisions, and handoff in every depth.

## Readiness gate

Use `READY FOR PLAN` only when:

- no unresolved decision can materially change behavior, safety, data survival, compatibility, cost, or acceptance evidence;
- each retained `REQ` and `INV` maps to at least one `AC`;
- each retained `AC` names evidence intent and any authorized owner;
- product/policy truth that can materially change behavior, safety, data survival, compatibility, cost, or acceptance meaning is resolved by an authoritative source;
- remaining assumptions are explicitly classified as non-blocking with an owner or validation method, never inferred from code;
- implementation details are absent unless fixed by an authoritative constraint.

When the gate fails, report `BLOCKED` in conversation with the exact decisions and owners. Do not persist a final artifact that looks ready.

## Plan handoff

Pass the exact artifact path. Planning must:

1. preserve `REQ`, `INV`, and `AC` identifiers;
2. map every required identifier to implementation slices and the executable verification contract;
3. distinguish repository discoveries from changes to desired behavior;
4. return to specification revision when implementation constraints would alter scope, safety, compatibility, or acceptance meaning.

A plan may refine methods and commands but must not silently reinterpret the contract.

## Revision

When a later discovery changes desired behavior, create a new non-overwriting specification artifact with:

```text
Revision: <number>
Supersedes: <prior artifact path>
Changed IDs: <old → new mapping>
Retired IDs: <IDs that no longer apply>
Invalidated downstream artifacts: <plans, evidence, or reviews to regenerate>
Reason and authority: <decision source>
```

Read the full `Supersedes` lineage before assigning identifiers. Preserve an identifier only when its meaning is unchanged. For each prefix, allocate changed or new semantics above the highest identifier used anywhere in that lineage. Retired identifiers remain permanently reserved. Editorial clarifications that do not change meaning may retain IDs and must be recorded as such.

## Other consumers

- TDD uses mapped `AC` entries and independently sourced expected outcomes after planning selects seams.
- Systematic debugging uses the expected behavior and invariants when an observed failure has an unknown cause.
- Verification consumes the plan-enriched evidence contract and reports current gate state.
- Security review consumes trust, privacy, and prohibited-outcome requirements while independently proving exploit paths.
- Code review compares the diff against the originating identifiers and reports a separate review verdict.
- Release readiness consumes both verification state and review verdict; the specification does not authorize release.
