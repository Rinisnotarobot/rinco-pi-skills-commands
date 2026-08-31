# Coverage and Verification

Use TDD-owned evidence to prove the requested behavior and affected regressions at proportionate scope. Passing the new test alone is necessary but not sufficient; broad repository readiness remains owned by `verification`.

## TDD evidence ladder

Run only the checks assigned to TDD by the plan or needed to establish affected behavior:

1. the new or changed test;
2. tests for the affected module/package;
3. relevant integration, contract, component, or end-to-end tests when the behavior cannot be established more narrowly.

Discover configured lint, formatting, type, build, coverage, and full-suite gates, but hand them to `verification` unless the plan explicitly assigns one to the TDD stage. Record exact commands and exit results for checks run. Distinguish tests not run from tests that passed.

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
Repository gates: handed to verification, or command/result when explicitly TDD-owned
Coverage: handed to verification, configured result when explicitly TDD-owned, or risk-based assessment
Integrity review: skips/retries/snapshots/exclusions changed or unchanged
Not run: checks and reason
Remaining risks: assumptions and follow-up
```

Completion requires honest evidence, not a claim that “all tests pass” when only a subset ran.
