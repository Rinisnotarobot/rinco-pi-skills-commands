# Plan Quality Review

Review the complete plan against its source requirement and repository evidence. Repair defects before presenting it.

## Traceability

Every required behavior or acceptance criterion maps to:

- one or more implementation slices;
- a changed boundary or artifact;
- verification evidence.

Every slice maps back to an in-scope requirement, migration necessity, or explicitly justified preparation. Remove orphan work and expose uncovered requirements.

A compact matrix is useful for complex plans:

```text
Requirement → Slice(s) → Test/evidence → Completion gate
```

## Repository grounding

Confirm:

- every existing path and symbol was inspected;
- proposed paths follow repository placement and naming conventions;
- call sites and consumers of changed interfaces were considered;
- commands come from scripts, CI, configuration, or repository instructions;
- required services, fixtures, generation, and environment are stated;
- current facts, assumptions, and proposals are not conflated.

A line number may supplement a symbol but should not be its only identity because lines drift.

## Interface consistency

Compare producers and consumers across slices:

- names, parameter and return shapes;
- nullability and absence semantics;
- errors and status/outcome mapping;
- schema/event/config versions;
- transaction and retry ownership;
- authorization and data ownership;
- defaults and backward compatibility.

If a later slice uses an interface not produced by an earlier slice or current code, repair the dependency or define the interface.

## Ordering and repository state

After each slice, the repository should have a coherent state. Check that:

- tests can be written and run at the planned point;
- consumers do not precede producers unless compatibility permits it;
- migrations are deployed before dependent code;
- cleanup follows all migration evidence;
- independent work is not unnecessarily serialized;
- no circular blocker exists.

## Specificity balance

A plan needs enough detail to avoid rediscovery, not enough code to pre-implement the change.

Revise vague instructions such as:

- “add validation”;
- “handle errors”;
- “update relevant tests”;
- “modify the service”;
- “ensure compatibility.”

Replace them with behavior, boundary, files/symbols, and evidence. Conversely, remove complete function bodies and incidental implementation choices unless they encode an approved interface, schema, state machine, algorithm, or compatibility decision.

## Risk coverage

Consider only applicable risks, but do not silently omit:

- security, privacy, authorization, and tenancy;
- persistent data, transaction, concurrency, and idempotency;
- external effects, retries, and partial failure;
- API/protocol/configuration compatibility;
- rollout, rollback, and operational ownership;
- performance and capacity claims;
- accessibility or manual UX evidence.

Each material risk needs a handling step, verification method, or explicit accepted assumption.

## Plan failure conditions

The plan is not ready when:

- an unresolved decision changes the architecture or safety of multiple slices;
- paths or symbols are guessed;
- a requirement has no implementation or evidence;
- a task depends on hidden setup;
- tests are deferred into a final horizontal phase without justification;
- verification commands are generic placeholders;
- rollback assumes impossible reversal;
- broad cleanup is mixed into the feature without an obstruction;
- the plan requires the executor to rediscover the active code path.

## Final rubric

A plan passes only when every answer is yes:

- Is the observable goal and non-goal boundary clear?
- Is the current path supported by evidence?
- Is the selected strategy justified against real alternatives?
- Does every slice deliver or enable a coherent verified state?
- Are dependencies and interfaces consistent?
- Can the executor find every integration point named?
- Does verification prove behavior at proportionate scope?
- Are material transition and failure states handled?
- Are assumptions and blockers explicit?
