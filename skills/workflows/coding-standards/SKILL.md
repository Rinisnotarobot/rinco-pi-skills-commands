---
name: coding-standards
description: Model-invoked, language-neutral maintainability baseline. Use when a scoped implementation, refactor, or review needs repository-specific rules for naming, readability, control flow, duplication, mutation, errors, comments, or code structure; defer framework architecture, security, resilience, and test workflow decisions to narrower Skills.
---

# Coding Standards

Apply the repository's standards to the code in scope. Treat this Skill as a model-invoked maintainability baseline, not a framework playbook or a license for unrelated cleanup.

## Invocation and Routing

Activate this Skill after the task has a concrete code scope. When the primary decision concerns framework architecture, backend boundaries, security, resilience, or test strategy, route that decision to the narrower Skill or current official documentation first; resume this baseline only to assess how the decided behavior is expressed in code.

When `code-review` is active, supply only maintainability rules and observations to that workflow. Let `code-review` exclusively own the formal review scope, candidate disproval, severity, verdict, and all review reporting.

## Workflow

### 1. Pin the scope and standards

Identify the requested behavior, changed files or target module, and applicable instruction scope. Inspect, in order:

1. accepted specifications and explicit user constraints;
2. scoped `AGENTS.md`, `CONTRIBUTING.md`, coding guides, and ADRs;
3. formatter, linter, compiler, and type-check configuration;
4. representative adjacent code and tests;
5. the baseline in this Skill.

Record each applicable rule as **documented**, **tool-enforced**, **established**, or **baseline**. Infer an established convention only from repeated, relevant examples; label mixed evidence as unresolved instead of choosing a favorite style.

Completion criterion: every rule used to change or judge code has a source and applies to the pinned scope.

### 2. Preserve the contract

State the observable behavior, public interfaces, compatibility constraints, and important performance or resource properties that must remain unchanged. Trace callers before changing names, signatures, control flow, ownership, or error behavior.

For a maintainability assessment, inspect without editing. For implementation or refactoring, keep the change inside the requested behavior and pinned files unless a traced dependency requires a wider edit.

Completion criterion: the preserved contract is explicit, and any unknown that makes a refactor unsafe is reported before modification.

### 3. Apply the maintainability baseline

Examine every touched unit through these lenses:

- **Names:** use the repository's domain language; make purpose and units visible; keep short names to tiny conventional scopes.
- **Flow:** keep the common path direct; make state transitions and side effects visible; extract a unit when it has a distinct responsibility, invariant, or test seam—not to satisfy a line-count rule.
- **Abstraction:** prefer the simplest design that meets current requirements. Remove speculative hooks and pass-through layers. Deduplicate knowledge that must change together; preserve coincidental repetition when sharing would couple unrelated concepts.
- **Data and mutation:** make ownership clear and keep mutation local and observable. Use immutable values where they clarify transitions; use controlled mutation where the language, local design, or measured cost supports it.
- **Failures and resources:** handle failures at the boundary that can add context, recover, translate, or clean up. Preserve causes, release owned resources, and avoid catch-and-rethrow layers that add no information.
- **Async and concurrency:** preserve required ordering; parallelize only independent work; account for cancellation, partial failure, and shared-state safety.
- **Types and interfaces:** represent meaningful constraints with the project's native type system without adding wrappers that obscure simple values. Keep interfaces no larger than their consumers require.
- **Comments and documentation:** explain intent, invariants, units, workarounds, and externally visible contracts. Let clear code express mechanics, and update comments when the behavior changes.
- **Tests:** name observable behavior and keep fixtures readable. Route test-first sequencing and suite design to `tdd`; route final gate discovery and readiness to `verification`.

Completion criterion: every touched unit has been assessed through each relevant lens; actionable issues have the smallest justified correction, while mixed or insufficient evidence is recorded as no actionable rule.

### 4. Make the smallest standards change

In implementation mode, correct only evidence-backed issues needed for the requested work. Preserve local formatting, avoid repository-wide rewrites, and require explicit approval before adding dependencies, changing public APIs, or expanding the task into architecture migration.

In maintainability-assessment mode, surface an observation only when it includes the rule source, code location, concrete maintainability impact, and smallest viable correction. Mark baseline heuristics and established conventions as judgment calls; reserve hard-violation language for documented or tool-enforced rules. Pass observations to `code-review` when that workflow owns the review.

Completion criterion: every edit or finding is traceable to one applicable rule, and preference-only changes are absent.

### 5. Hand off verification

Inspect the final diff for accidental formatting churn, generated-file edits, stale comments, and scope expansion. Give the affected scope, standards sources, and expected formatter, lint, type, and behavior checks to `verification` when it is available. Consume its current evidence instead of rediscovering gates, rerunning reusable checks, or assigning a second readiness state.

When `verification` is unavailable, report the standards assessment as `UNVERIFIED` and name the missing evidence. A narrow manual inspection supports only the scoped maintainability observations, not repository readiness.

Completion criterion: the final diff has been inspected, and the single verification state is either consumed from `verification` or explicitly unavailable.

## Output Contract

Use this standalone contract only when `code-review` does not own the task. Otherwise return the rules and observations requested by `code-review` without a separate report.

Report:

```text
Scope
Standards sources and precedence
Contract preserved
Applied changes or maintainability observations
Exceptions and judgment calls
Verification handoff and evidence
Unverified claims and residual risks
```

A clean result is valid. Do not manufacture findings when the scoped code follows its applicable standards.
