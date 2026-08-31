# Gate Discovery

Discover gates from the repository rather than from a preferred toolchain.

## Authority order

Inspect evidence in this order:

1. applicable `AGENTS.md`, contribution guides, and explicit user scope;
2. CI and required-check configuration;
3. task runners, workspace configuration, and package scripts;
4. manifests, lockfiles, and tool configuration;
5. nearby tests, generated-file headers, and established commands;
6. tool `--help` output when repository evidence identifies the tool but not the safe invocation.

When sources conflict, prefer the narrower applicable instruction. Ask when conflicting sources have equal authority and the choice changes the verdict.

## Build the gate matrix

For every affected surface, decide whether these gate classes apply:

| Gate class | Evidence that makes it applicable | Typical reason for `N/A` |
|---|---|---|
| Acceptance evidence | plan/spec criterion or explicit user acceptance | no acceptance condition beyond the applicable executable gates |
| Focused behavior | changed behavior or reproduced defect | documentation-only change with no executable claim |
| Tests | owning package tests, CI job, or behavioral risk | repository has no tests for a non-executable asset |
| Types | configured type checker or typed compiler phase | affected language has no configured type gate |
| Lint/format | configured check-mode command or required CI job | no configured static-style gate |
| Build/package | deployable, compiled, bundled, or packaged output | repository produces no build artifact |
| Coverage | configured threshold or required coverage job | no configured coverage policy or meaningful measurement |
| Generated artifacts | generated files, schema snapshots, lockfiles, code generation | change cannot affect generated state |
| Security scanner | configured scanner, dependency change, or required security job | no configured scanner and no scanner-specific policy |
| Review/approval evidence | required code, security, accessibility, compliance, or human review | no policy or risk decision requires that review |
| Operational/migration evidence | rollout check, metric, reconciliation, compatibility observation, or recovery exercise | change has no operational or transition claim |

Repository policy, the plan's verification contract, and required CI checks are required gates. For unclassified gates, use change impact: make a gate required when its absence could invalidate the claim; otherwise mark it optional and state why.

Assign every gate an owner and earliest due stage. A required review, release, or operator gate that belongs after the current stage remains `PENDING`; it is carried forward rather than converted to `N/A` or treated as a current blocker. Verification records external review or operational evidence but does not grant the approval itself.

## Select commands

Choose the highest-authority repository wrapper that preserves required environment, flags, services, and workspace scope. Separate:

- environment or package manager;
- underlying tool;
- repository command that invokes it;
- focused, affected, and repository-wide scopes.

Prefer one-shot, non-interactive, check-mode commands. Avoid watch mode, format/write mode, snapshot update mode, generated-file rewrite mode, and package executors that can download tools.

For Python, use project-configured `uv run` commands. When `uv` is unavailable, report an environment blocker and follow the repository's documented fallback; do not bootstrap it during verification. Do not install, remove, upgrade, or auto-fix dependencies for any stack.

Identify required databases, brokers, browsers, containers, credentials, fixtures, and network access before execution. A missing prerequisite is `BLOCKED`, not a reason to replace an integration gate with a weaker unit command.

## Expand proportionately

Use this order unless repository policy requires a stronger gate immediately:

1. the command that directly proves the claim;
2. affected module or package checks;
3. affected integration or contract checks;
4. repository-required type, lint, build, coverage, generation, and scanner gates;
5. full workspace or end-to-end suites when policy or blast radius requires them.

Expand for shared APIs, persistence or schema changes, concurrency, authentication or tenancy, dependency resolution, build configuration, platform behavior, and escaped-defect paths. State why a broad expensive gate is required; do not run arbitrary categories to appear thorough.

## Discovery record

Record before execution:

```text
Claim: <observable statement>
Scope: <base/target or worktree comparison>
Affected surfaces: <packages, services, contracts, generated state>
Gate: <class and scope>
Requirement: required | optional
Owner: systematic-debugging | tdd | verification | review | release | operator
Due stage: implementation | pre-review | pre-release | post-deploy | other
Method: <command, observation, review, operational record, or reconciliation>
Expected evidence: <exact command/result or observable record>
Authority: <requirement, instruction, CI job, script, config, or impact reason>
Prerequisites: <services, credentials, fixtures, reviewers, or none>
```
