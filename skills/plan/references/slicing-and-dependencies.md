# Slicing and Dependencies

A plan slice is the smallest coherent deliverable that can be implemented, verified, and reviewed without relying on hidden future work.

## Prefer vertical slices

A vertical slice follows one observable behavior through only the layers it needs:

```text
input/interface → policy → state/effect → observable result → test
```

Examples:

- one accepted input and its persisted result;
- one API operation through validation and authorization;
- one event type from publication to duplicate-safe consumption;
- one UI interaction through state and backend contract.

Do not create separate “all models,” “all services,” “all tests,” and “all documentation” phases when none produce a usable or verifiable state alone.

## Slice boundaries

Split when a reviewer could meaningfully accept one deliverable and reject another, or when a later behavior depends on an explicit interface produced earlier. Keep together:

- setup required only by the behavior;
- the production change and its proving test;
- configuration/documentation inseparable from safe use;
- generated output with its authoritative source change.

Do not size by arbitrary minutes, line counts, or one commit per step. A slice should fit a focused implementation context, but correctness and coherence define its boundary.

## Dependency graph

For every slice, state `Blocked by`. A dependency is valid only when the earlier slice produces an interface, state, decision, or compatible transition required by the later slice.

Check for:

- cycles caused by poor slicing;
- “setup” tickets with no independently useful owner;
- test infrastructure deferred until after behavior;
- cleanup scheduled before all consumers migrate;
- several slices silently modifying the same unstable interface.

Order blockers first. Independent slices may be marked parallelizable when they do not compete for the same interface or migration state.

## Prefactoring

Plan preparatory refactoring only when current structure concretely prevents a safe slice. State:

```text
Obstruction: <specific coupling or missing seam>
Preparatory change: <small behavior-preserving change>
Proof: <existing/characterization tests and verification>
Unblocks: <later slice>
```

Avoid opportunistic cleanup. If the requested behavior can land safely without restructuring, keep the current architecture.

## Test-driven slices

Each behavior slice names:

- the stable seam under test;
- the missing behavior that makes RED fail;
- the minimum path required to reach GREEN;
- nearby regression scope;
- broader completion gates.

The plan should specify behavior and observation, not fabricate full test code. Include exact fixtures, signatures, or examples only when they are requirements or interface decisions.

## Horizontal exceptions

Horizontal work is valid when vertical slices cannot maintain a compatible repository state, including:

- mechanical changes across a shared symbol;
- generated-code or formatting migrations;
- dependency/runtime upgrades with one compatibility boundary;
- repository-wide policy or build changes;
- the expand or contract phase of a compatibility migration.

Keep these steps mechanically narrow, state their blast radius, and verify the repository-wide invariant they preserve.

## Slice template

```markdown
### N. <observable deliverable>

**Delivers:** <behavior available after this slice>
**Changes:** <verified paths and symbols>
**Interfaces/data:** <new or changed contracts>
**Test seam:** <where behavior is exercised and observed>
**RED:** <expected failing behavior>
**Implementation outline:** <decisions and order, not full code>
**Verification:** <focused and affected commands/evidence>
**Blocked by:** <slice numbers or none>
**Risks:** <slice-specific failure or compatibility concern>
```
