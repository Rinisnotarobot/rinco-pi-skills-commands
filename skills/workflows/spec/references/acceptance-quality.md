# Acceptance Quality

Write criteria that independent readers can evaluate against the same evidence.

## Criterion shape

Use this structure when each field adds information:

```text
AC-001: <observable outcome>
Proves: REQ-001, INV-001
Given: <starting state and actor>
When: <single trigger or event>
Then: <observable result>
Must not: <prohibited side effect, when material>
Evidence intent: <method and expected observation>
Environment/owner: <safe context or authorized actor, when needed>
Priority: required | important | optional
```

Given/When/Then is a tool, not a mandatory style. A table or declarative statement is valid when it preserves condition, outcome, and evidence.

## Quality gates

A required criterion passes only when:

1. its result is observable through a public behavior, contract, state transition, artifact, or authorized human judgment;
2. the starting state and trigger exclude materially different interpretations;
3. expected and prohibited outcomes are specific enough to disagree with an implementation;
4. evidence intent is proportionate and does not prescribe a framework or repository command;
5. risky evidence names a safe environment or authorized owner;
6. it traces to at least one requirement or invariant.

## Failure patterns

Revise criteria that:

- say “works correctly,” “is secure,” “is performant,” or “is user-friendly” without a measurable observation or named human judgment;
- restate an implementation step instead of user/system behavior;
- combine unrelated behaviors that can pass or fail independently;
- prescribe every test level regardless of risk;
- use a test as the source of expected truth rather than a requirement, policy, standard, or approved example;
- require destructive, production, paid, or secret-bearing evidence without authorization;
- accept success while omitting a material forbidden side effect.

## Examples

Weak:

```text
AC-001: CSV export works correctly and securely.
```

Strong:

```text
AC-001: An authorized analyst exports only the currently filtered rows.
Proves: REQ-002, INV-001
Given: an authenticated analyst viewing records filtered to Region A
When: the analyst requests CSV export
Then: the downloaded CSV contains exactly the visible Region A records and approved columns
Must not: include hidden internal fields or records from another tenant
Evidence intent: automated behavior test plus a schema inspection using synthetic tenant data
Priority: required
```

The strong criterion identifies what can be observed and falsified while leaving seam and command selection to planning and TDD.

## Traceability check

Build both directions:

```text
REQ/INV → AC → evidence intent
AC → REQ/INV
```

A requirement without an `AC` is unproved. An `AC` without a requirement or invariant is orphan scope. Merge duplicates only when one observation genuinely proves the same contract.
