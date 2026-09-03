---
name: security-review
description: Deep review of changed trust boundaries that reports only evidence-backed exploit paths - attacker-controlled source, reachable sink, and the path between them. Use when a change crosses a trust boundary (new endpoint, auth flow, input surface, secret handling, dependency) and needs security analysis beyond general code review.
---

# Security Review

Review the trust boundaries a change crosses, and report only exploitable paths you can trace: attacker-controlled source, reachable sink, and the route between. This is the deep lens on top of `code-review`, not a general audit — broad structural and correctness review belongs to `code-review`.

A security-review verdict is its own report. It consumes verification state as evidence and never re-derives it.

## Workflow

### 1. Pin the changed trust boundaries

From the diff, identify where trust levels change: new endpoints or routes, authentication or authorization flows, input parsing, file uploads, secret or credential handling, inter-service calls, dependency or build changes, configuration exposure.

A change that touches no trust boundary is out of scope: say so and stop — do not pad the report with checklist findings.

Completion criterion: every trust boundary the diff crosses is named, or the review is explicitly out of scope.

### 2. Trace attacker control before flagging

For each boundary, trace the data flow: where does input originate, what validation or sanitization stands in the way, what framework protections apply, what configuration governs it. Read [Trust Boundary Analysis](references/trust-boundary.md) for the source-to-sink method.

Do not flag from pattern matching. A finding requires all three, evidenced in the code:

1. **Attacker-controlled source** — input a user or external system can influence; server-controlled configuration, constants, and authenticated-trusted paths do not qualify. One explicit exception: **direct disclosure** — a secret written into source, logs, or a client-visible response is a finding without a further attacker path, because the source and the sink are the same act;
2. **Reachable sink** — the dangerous operation the input actually reaches, not one it might reach if other code were different;
3. **The path** — the concrete route from source to sink, with the guards that fail to stop it.

Completion criterion: every candidate finding has a traced source, sink, and path, or is dropped.

### 3. Apply the confidence gate

| Level | Criteria | Action |
|---|---|---|
| **HIGH** | Vulnerable pattern + traced attacker control + reachable sink | Report with severity |
| **MEDIUM** | Vulnerable pattern, input source or reachability unverified | Note as "needs verification" with the exact question to answer |
| **LOW** | Theoretical, hardening, defense-in-depth | Do not report |

Reject without reporting (check [Web and Data guides](references/web.md) and [Data and Storage](references/data.md) for framework-protection specifics):

- framework-protected input (auto-escaped templates, ORM-parameterized queries);
- prevalidated internal input (already checked at a boundary this diff does not remove);
- server-controlled values (settings, environment, config files, constants);
- code paths where authentication is a working guard among others — note the auth requirement instead of a finding; but when the changed boundary is itself the authentication or authorization guard, a broken guard is the finding (an authorization bypass is a path through a failed guard, not an authenticated path to clear);
- missing-control claims with no attacker path ("no rate limiting", "no MFA", "weak crypto policy") — these are hardening, not exploit paths.

Completion criterion: every reported finding is HIGH with an attacker path; every MEDIUM note names its unverified question; nothing LOW appears.

### 4. Report with evidence

For each HIGH finding:

```text
Boundary: <the trust boundary crossed>
Source: <attacker-controlled input, file and line>
Sink: <dangerous operation, file and line>
Path: <guard-by-guard trace from source to sink>
Exploit: <the concrete action an attacker takes and the impact>
Severity: <critical | high | medium, from impact and reachability>
Fix direction: <the minimal boundary change, without redesigning the system>
```

End the report with the review verdict, kept separate from any verification state:

```text
Security review verdict: PASS | FINDINGS | UNRESOLVED | OUT OF SCOPE
Findings: <count by severity — HIGH-confidence findings only carry a severity>
Verification state consumed: <report path and freshness, or none>
Unverified questions: <MEDIUM notes, each with its exact question>
```

`UNRESOLVED` is the verdict whenever MEDIUM notes remain open — a report with open verification questions is not a PASS, and notes never escalate to findings without the missing evidence.

Return the report and stop. Fixing the findings is downstream work (`plan`, `tdd`); re-verifying is `verification`'s. Report to `docs/reviews/` alongside other review artifacts when the repository convention supports it.

Completion criterion: every finding is evidence-complete, and no fix has been started here.

## Guardrails

- Never report a finding without a traced attacker path.
- Never flag server-controlled values, framework-protected input, or authenticated paths as vulnerabilities.
- Never audit the whole codebase — only the changed boundaries.
- Never overwrite or duplicate the verification verdict; this review produces its own verdict only.
- Never include secrets, tokens, or sensitive payloads in the report — describe, redact, and reference.
