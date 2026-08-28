# Coverage and Verification

Use verification to prove the requested behavior and detect regressions at proportionate scope. Passing the new test alone is necessary but not sufficient.

## Verification ladder

Run the narrowest useful checks first and expand after they pass:

1. the new or changed test;
2. tests for the affected module/package;
3. relevant integration, contract, component, or end-to-end tests;
4. configured lint, formatting, type, build, and coverage gates;
5. the full repository suite when required or when change impact is broad.

Record exact commands and exit results. Distinguish tests not run from tests that passed.

## Coverage

Repository-configured thresholds are authoritative. Do not lower, bypass, or rewrite them to make a change pass.

When no threshold exists, coverage is diagnostic evidence:

- inspect uncovered branches in changed behavior;
- prioritize business rules, error handling, boundary conditions, and recovery paths;
- avoid tests whose only purpose is executing lines without meaningful assertions;
- explain intentionally untested behavior and its risk.

A high percentage does not prove assertion quality, realistic integration, concurrency safety, or absence of important missing cases.

## Regression scope

Expand verification when the change affects:

- a shared public API or widely used module;
- serialization, schema, migration, or persistence behavior;
- concurrency, transactions, retries, or asynchronous delivery;
- authentication, authorization, tenancy, or secrets;
- build configuration or dependency resolution;
- platform-specific behavior;
- a previous source of escaped defects.

Use dependency and call-site evidence to select affected tests rather than running arbitrary categories.

## Test integrity

Review changes for:

- weakened or deleted assertions;
- new skips, only/focus markers, retries, or enlarged timeouts;
- regenerated snapshots with unexplained behavior changes;
- broad fixtures or mocks that cannot represent production;
- tests that pass before the production change;
- order dependence, leaked state, and uncontrolled time;
- changed coverage exclusions.

Any intentional change to these mechanisms should be explained in the completion report.

## Flaky failures

Do not repeatedly rerun until green and report only the success. Capture the failure, determine whether it is related, and report reruns. Fix deterministic causes such as shared state, fixed sleeps, resource leaks, and uncontrolled scheduling. Quarantine is a project policy decision, not an automatic remedy.

## Stronger techniques

Use when justified by risk and existing tooling:

- property-based tests for broad input invariants;
- mutation testing to assess assertion sensitivity;
- contract tests for independently deployed boundaries;
- concurrency/race tooling for shared state;
- failure injection for retries and recovery;
- performance tests for latency or capacity claims.

These supplement rather than replace a clear behavior example and a witnessed RED state.

## Completion report

```text
Focused RED: command, expected failure
Focused GREEN: command, pass result
Affected tests: command, result
Repository gates: command, result
Coverage: configured result or risk-based assessment
Integrity review: skips/retries/snapshots/exclusions changed or unchanged
Not run: checks and reason
Remaining risks: assumptions and follow-up
```

Completion requires honest evidence, not a claim that “all tests pass” when only a subset ran.
