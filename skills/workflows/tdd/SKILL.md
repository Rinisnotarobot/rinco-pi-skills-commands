---
name: tdd
description: Behavior-first test-driven development with vertical red-green-refactor slices. Use when implementing a feature, implementing a bug fix after its cause is known, choosing an observable test seam, or reviewing whether tests specify behavior rather than implementation; use systematic-debugging first when an observed failure has an unproven cause.
compatibility: Requires verification unless an upstream orchestrator owns the final verdict; also requires systematic-debugging when a defect's cause is unproven.
---

# Test-Driven Development

Drive one observable behavior at a time through a verified **red → green → refactor** cycle. Let repository evidence define the test runner, conventions, and required gates.

Before editing, confirm that `verification` is available unless an upstream orchestrator explicitly owns the final verdict. Stop with `BLOCKED` and name the missing Skill when neither route can consume the final evidence handoff.

## Workflow

### 1. Establish the behavior and context

Inspect the requirement, affected code, nearby tests, test configuration, and relevant architecture decisions. State:

- originating `REQ`, `INV`, and `AC` identifiers when a specification or plan supplies them;
- the behavior a caller or user should observe;
- the public seam through which it can be exercised;
- the independent source of truth for the expected result;
- the smallest relevant test command.

For a defect with an unproven cause, confirm that `systematic-debugging` is available, then invoke it with `tdd` named as the downstream implementation owner and retain any upstream final verification owner unchanged. Stop with `BLOCKED` and provide a relaunch command when the diagnosis dependency is missing. Resume TDD only after validating and reusing the minimal reproduction, causal chain, violated invariant, expected RED signature, and cleanup state instead of rediscovering them. When debugging returns a blocker, return it to the caller without production edits. For behavior-preserving refactoring, establish a green baseline and identify any behavior that needs characterization.

Ask the user about the seam only when repository evidence cannot resolve a consequential choice, such as changing a public interface or adding an expensive system test.

Completion criterion: the next behavior, observation seam, and expected outcome are explicit.

### 2. Detect the project test workflow

Read [references/runner-detection.md](references/runner-detection.md) when the authoritative commands are not already known. Distinguish the package manager, test runner, and repository scripts. Use the project's installed tooling; do not substitute a preferred framework or install dependencies without approval.

Completion criterion: the narrow RED/GREEN command and broader verification commands come from project evidence.

### 3. Choose the next vertical slice

Order behaviors by learning value and dependency:

1. simplest representative success;
2. important boundary or business rule;
3. expected failure;
4. regression and interaction cases justified by risk.

Select only the next behavior. Do not pre-write the whole imagined test suite. Read [references/test-quality.md](references/test-quality.md) when choosing the seam, oracle, assertions, or test level; the `codebase-design` seam vocabulary applies here — tests cross the module's interface (the external seam), because the interface is the test surface.

Completion criterion: one slice can move from RED to GREEN without requiring unrelated behavior.

### 4. RED — prove the test can fail

Write one focused test that exercises the chosen seam and observes public behavior. Multiple assertions are valid when they jointly describe one outcome.

Run the narrow command and confirm:

- the test fails;
- it fails for the expected behavioral reason;
- the failure is not caused by syntax, configuration, missing dependencies, stale fixtures, or an unrelated defect.

A test that passes immediately has not demonstrated its ability to detect the missing behavior. Correct the test or establish why the behavior already exists before proceeding.

Completion criterion: the expected failure is observed and recorded.

### 5. GREEN — implement the smallest complete behavior

Change production code only after RED is established. Implement enough to satisfy the behavior while respecting existing design and correctness constraints. “Minimal” means no speculative capability; it does not mean hard-coding the example or bypassing real invariants.

Run the same narrow command until the new test and relevant nearby tests pass.

Completion criterion: the selected behavior is GREEN without weakening the test.

### 6. REFACTOR — improve while staying green

Remove duplication, improve names, deepen interfaces, or simplify structure exposed by the completed slice. Keep refactoring local to evidence from the current cycles; defer broad redesign to an explicit task.

Run the narrow tests after each meaningful refactor step. If they fail, restore GREEN before continuing.

Completion criterion: behavior is unchanged, tests remain green, and the slice is maintainable enough for the next cycle.

### 7. Repeat and hand off verification evidence

Repeat RED → GREEN → REFACTOR for the next behavior. When the requested capability is complete, read [references/coverage-and-verification.md](references/coverage-and-verification.md). Run the affected tests needed to establish the completed behavior, then prepare a verification evidence handoff instead of independently rerunning every broad repository gate.

Record evidence produced after the final relevant code or test mutation:

- every source `REQ`, `INV`, and `AC` identifier assigned to the TDD stage, mapped to RED/GREEN evidence, `N/A`, or another named owner;
- behavior, seam, and acceptance claim;
- exact RED and GREEN commands, exit results, and key output;
- affected tests run after the final mutation;
- relevant `git status --short` before and after those commands;
- broader gates not run, required prerequisites, and residual risks.

When an upstream orchestrator explicitly names itself as the final verification owner, return this complete evidence handoff and stop before invoking `verification`. The orchestrator must pass that ownership instruction when invoking TDD; do not infer it from surrounding context.

Otherwise, let the model-invoked `verification` skill decide whether this same-state evidence is reusable and run every missing required gate. A stale, partial, differently scoped, or unverifiable result must be rerun; a reusable result must not be rerun merely to duplicate ownership.

Report:

```text
Source ID → RED/GREEN evidence | N/A | other owner
Behaviors added or reproduced
Seams exercised
RED evidence
GREEN evidence
Refactoring performed
Affected verification commands and results
Final worktree state
Unrun broader gates
Uncovered risks or assumptions
```

## Rules

- Test behavior through the narrowest stable public seam that can prove it.
- Prefer real domain code; replace dependencies at volatile system boundaries. Read [references/mocking.md](references/mocking.md) before introducing mocks, spies, or fakes.
- Derive expected values independently from requirements, examples, standards, or known fixtures—not by reimplementing the production algorithm in the test.
- Keep each test isolated and deterministic. Control time, randomness, identity, external state, and concurrency where they affect the result.
- Match test level to risk. A unit, integration, contract, component, or end-to-end test is a choice, not a mandatory checklist.
- Preserve project-configured coverage thresholds. Where none exist, use uncovered risk to choose tests rather than inventing a percentage.
- Treat skipped tests, retries, snapshots, and broad mocks as evidence requiring review, not automatic failures or automatic acceptance.
- Keep production and test changes traceable to the behavior currently under development.

## Exceptions

If a runnable RED test cannot be created because the repository lacks a harness, the environment is unavailable, or the failure is non-deterministic, stop and present the smallest enabling step or alternative evidence. Do not claim TDD when RED was not observed.

For generated code, declarative configuration, documentation-only changes, or mechanical migrations, use the repository's appropriate verification workflow rather than forcing a behavioral unit test.
