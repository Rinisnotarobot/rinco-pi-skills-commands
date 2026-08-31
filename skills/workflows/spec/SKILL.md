---
name: spec
description: Turn an explored product or engineering change into a durable, implementation-neutral specification with traceable requirements and acceptance evidence.
disable-model-invocation: true
---

# Specification

Convert settled intent into a durable contract for planning and delivery. Define what must be true without pre-implementing how the repository will change. The final specification artifact is the only expected repository mutation.

## Workflow

### 1. Fix the source and purpose

Identify the change being specified, its intended audience, and the authoritative inputs: current conversation, user decisions, issue, PRD, policy, contract, or existing specification. Read applicable repository instructions and only the code, schemas, interfaces, and documentation needed to establish current behavior and vocabulary.

Separate:

- desired product or policy truth supplied by the user or an authoritative artifact;
- current technical facts supported by repository evidence;
- proposals and assumptions that are not yet approved.

Repository behavior does not define desired business policy. Never infer target users, pricing, retention, compliance obligations, contractual service levels, or priority from code or naming.

Completion criterion: every input is named and every material statement has an authority class: supplied requirement, repository fact, approved decision, or assumption.

### 2. Choose proportionate depth

Use the smallest specification that preserves every consequential decision:

- **Compact:** one actor or system path, bounded behavior, no persistent-data or public-contract transition, and low operational risk.
- **Standard:** multiple behaviors or boundaries, meaningful failure cases, or coordination across components.
- **Consequential:** security/privacy, persistent data, migration, public compatibility, compliance, irreversible effects, significant cost, or operational rollout.

Depth changes the number of applicable details, not the observability standard. Omit irrelevant sections rather than filling them with boilerplate.

Completion criterion: the selected depth names the risk or complexity that justifies it.

### 3. Establish outcome and boundaries

State:

- the actor or system and the observable outcome;
- the problem or unmet capability;
- in-scope behavior;
- explicit non-goals;
- definitions needed to interpret requirements consistently;
- dependencies, constraints, and assumptions.

Keep implementation choices out unless an authoritative source already fixes them as constraints. File paths, symbols, package choices, task slices, and repository commands belong to `plan`, not the specification.

Completion criterion: two readers can agree on what success includes and what adjacent work remains excluded.

### 4. Resolve blocking decisions

Build a decision list from contradictions, missing product truth, safety choices, compatibility policy, irreversible transitions, and materially different user-visible outcomes. Discover technical facts from the repository; ask the user only for decisions that cannot be discovered.

Group independent blockers into one question round. Give a recommendation and consequence for each option. Do not persist a final artifact while a decision can materially change required behavior, security/privacy, data survival, compatibility, cost, or acceptance evidence. Non-blocking assumptions remain explicit and receive an owner or validation method.

Completion criterion: every blocker is answered, delegated to an authoritative owner, or reported as preventing finalization.

### 5. Write requirements and invariants

Assign stable IDs:

- `REQ-NNN` for required capabilities or constraints;
- `INV-NNN` for conditions that must remain true across transitions;
- `AC-NNN` for observable acceptance criteria.

Each requirement states one outcome or constraint, its authority, priority, and applicable actor or boundary. Each invariant names the states or operations across which it holds. Use requirement language that can be contradicted by evidence; replace vague terms such as “secure,” “fast,” “intuitive,” or “robust” with an observable threshold, explicit review judgment, or unresolved decision.

Read [Acceptance Quality](references/acceptance-quality.md) before writing acceptance criteria. For consequential changes, read [Risk and Transition Coverage](references/risk-and-transition-coverage.md).

Completion criterion: every required behavior and material risk is represented by an identifiable requirement or invariant without embedding an implementation plan.

### 6. Define acceptance and evidence intent

Map every retained `REQ` and `INV` to one or more `AC` entries. Each criterion identifies:

- starting condition and actor;
- trigger or event;
- observable result;
- prohibited side effect when material;
- requirement-level proving method: automated behavior, contract, manual UX/accessibility, security review, migration/reconciliation, operational signal, compatibility evidence, or stakeholder acceptance;
- safe environment or authorized owner when evidence has external effects.

Do not invent repository commands, frameworks, coverage thresholds, or test levels. `plan` turns evidence intent into the executable verification contract; TDD chooses the stable seam and witnesses RED/GREEN; `verification` decides whether final evidence is current and complete.

Completion criterion: every retained `REQ` and `INV` has acceptance evidence, and no `AC` exists without a requirement or invariant it proves.

### 7. Review traceability and persist

Read [Artifact and Handoff](references/artifact-and-handoff.md). Review the complete specification for authority, contradiction, scope, observability, risk coverage, and bidirectional traceability. Repair every gap before writing.

Choose the artifact path in this order:

1. an exact path supplied by the user;
2. an authoritative specification directory defined by the repository;
3. `docs/specs/YYYY-MM-DD-<slug>.md`.

Build `<slug>` from the title as lowercase ASCII kebab-case; use `specification` when no safe slug remains. Use the current local date. Preserve existing artifacts: append `-2`, `-3`, and so on before `.md` instead of overwriting.

Write the final specification as one Markdown file, read it back, and confirm no requirement, acceptance criterion, blocker, or traceability row was truncated. Return the path, depth, requirement counts, and readiness state without duplicating the full artifact in conversation.

Completion criterion: the reported artifact exists, satisfies the referenced `READY FOR PLAN` gate, contains no unresolved material product or policy decision or assumption, and every retained requirement and invariant is traceable to acceptance evidence.

## Boundaries

- `product-lens` owns whether and why to build; `spec` owns the approved behavior contract.
- `grilling` owns exhaustive decision-tree stress testing; `spec` asks only finalization blockers.
- `plan` owns repository implementation strategy and executable sequencing.
- `systematic-debugging` owns unknown causes of observed failures, not desired behavior.
- `security-review` owns exploit-path analysis; the specification owns required trust and privacy outcomes.
- A specification is neither implementation approval nor release authorization.
