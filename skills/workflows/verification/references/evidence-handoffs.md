# Evidence Handoffs

Consume upstream evidence without trusting stale claims or rerunning valid work.

## Ownership

| Producer | Evidence it owns | Evidence it does not own |
|---|---|---|
| `spec` | desired behavior, authority, `REQ`/`INV`/`AC` identifiers, invariants, and evidence intent | repository implementation strategy or execution results |
| `plan` | acceptance claims, source-ID mapping, required/optional methods, authority, scope, and prerequisites | execution results |
| `backend-patterns` | invariant, failure modes, and risk-specific proving methods | repository gate verdict |
| `systematic-debugging` | symptom, reproduction, causal chain, violated invariant, experiments, and diagnosis blockers | regression fix or readiness verdict |
| `tdd` | witnessed RED/GREEN cycle and affected tests after the final mutation | broad final gate selection or readiness verdict |
| `code-review` | diff findings and review verdict | verification gate verdict |
| `verification` | evidence freshness, missing-gate execution, attribution, and `READY`/`NOT READY`/`BLOCKED` | review, merge, or release approval |

## Acceptance test for upstream evidence

Reuse a result only when every answer is yes:

1. **Claim:** does the result prove the current gate's exact claim?
2. **Scope:** does it cover the pinned comparison point, package, configuration, and required environment?
3. **Sequence:** was it produced after the final relevant code, test, configuration, schema, or generated-artifact mutation?
4. **State:** is the relevant diff and `git status --short` unchanged since execution?
5. **Authority:** did it use the repository-authoritative command or proving method?
6. **Completeness:** are the exact command or observation, exit/result, key output, and prerequisites available?
7. **Integrity:** did the proving method leave the intended worktree and dependency state unchanged?

A failed answer makes the result stale, partial, or unverifiable. Rerun command-backed gates when safe. Mark required non-command evidence `BLOCKED` when it cannot be refreshed by the current actor.

Evidence from another session or agent is a lead, not proof, unless an authoritative immutable record identifies the exact revision, environment, command, and result. CI for the exact commit is reusable; an uncited statement that CI passed is not.

## Handoff record

```text
Producer: spec | plan | backend-patterns | systematic-debugging | tdd | code-review | CI | user
Source IDs: <REQ/INV/AC identifiers or none>
Claim: <observable statement>
Scope: <comparison point, package/service, configuration>
Requirement: required | optional
Owner: systematic-debugging | tdd | verification | review | release | operator
Due stage: implementation | pre-review | pre-release | post-deploy | other
Method: <exact command, observation, review, or operational record>
Result: PENDING | PASS | FAIL | BLOCKED | N/A
Sequence: <after final relevant mutation>
Worktree before/after: <status evidence>
Authority: <requirement, instruction, CI job, configuration, or risk decision>
Prerequisites: <services, credentials, fixtures, reviewers, or none>
Freshness decision: reuse | rerun | blocked — <reason>
```

## Downstream interpretation

Keep gate and review states separate:

- `Verification State` answers whether the pinned verification contract has sufficient current evidence.
- `Review Verdict` answers whether the diff has evidence-backed findings.
- A proven baseline failure may yield `Verification State: NOT READY` and `Review Verdict: APPROVE`; report both and do not present the change as release-ready.
- A change-introduced or unknown required failure yields `NOT READY` and prevents review approval.
- Missing required evidence due in the current stage yields `BLOCKED`; when that evidence could change review safety, the review verdict is `INCONCLUSIVE`.
- Required evidence owned by a later stage remains `PENDING` and does not block entry into the current stage.

Future release readiness must consume both states and any required approval or operational evidence rather than treating either state as release authorization.
