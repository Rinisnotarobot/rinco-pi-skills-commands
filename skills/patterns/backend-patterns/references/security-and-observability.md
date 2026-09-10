# Security and Observability Patterns

Use this reference for identity, policy enforcement, secrets, auditability, telemetry, health, and incident diagnosis.

## Threat and abuse model

Before selecting controls, identify protected assets, actors, trust boundaries, data classifications, privileged operations, and realistic abuse cases. For each case, name the authoritative enforcement point and the evidence that a bypass is denied. Do not turn a generic threat checklist into findings.

When reviewing a change that crosses a trust boundary, invoke `security-review` for its source-to-sink evidence method and verdict. This reference retains architecture selection—identity propagation, policy placement, tenant isolation, audit, and telemetry—without issuing exploit findings.

## Security boundaries

### Authentication at the Boundary

Verify credentials at a trusted ingress and propagate a constrained identity context. Validate signature/issuer, audience, expiry, algorithm, and required claims according to the credential type. Parse claims as untrusted input rather than relying on type assertions.

Authentication establishes who or what is acting; it does not grant access by itself.

### Policy-Based Authorization

**Context:** permission depends on action, resource, ownership, tenant, state, or environment—not only a global role.

**Shape:** evaluate an explicit policy from authenticated subject, action, resource, and context.

**Invariant:** access is denied unless an applicable policy grants it.

Enforce policy at every authoritative entry path. Centralize policy meaning while keeping resource loading and decision evidence explicit.

### Tenant Isolation

Carry tenant identity through authorization and storage access. Enforce isolation as close to the data as practical using scoped queries, keys, schemas, databases, or row-level policy. Test cross-tenant identifiers and confused-deputy paths.

### Least Privilege

Give each process, job, and integration only the capabilities it needs. Separate runtime, migration, administrative, and read-only credentials where the platform permits.

### Secret Reference

Store secret values in an appropriate secret system and pass references/configuration through deployment. Define rotation, revocation, access auditing, and failure behavior. Avoid logging credential material or placing it in durable job payloads.

### Audit Log

Record security- and business-significant actions with actor, action, target, decision, timestamp, and correlation context. Protect integrity and access. An audit event represents evidence, not ordinary debug logging.

## Observability patterns

### Correlation Context

Propagate request, trace, workflow, and message identifiers across boundaries. Generate identity at the first trusted boundary and preserve causality through asynchronous work.

Do not use high-cardinality user-controlled values as unrestricted metric labels.

### Structured Events

Emit machine-readable events with stable names and fields. Include outcome, duration, dependency, retry/attempt, and correlation context where relevant. Redact sensitive fields at the source.

### Metrics at the Boundary

Measure rate, errors, and duration for requests and dependencies; saturation for constrained resources; queue age for asynchronous work; and freshness/reconciliation lag for eventually consistent views.

Prefer service-level indicators tied to user-visible behavior over counts without interpretation.

### Distributed Tracing

Trace causal work across process boundaries and annotate spans with operation and outcome, not secret payloads. Sampling policy must preserve enough errors and slow paths for diagnosis.

### Service objectives and alerting

Define SLIs from user-visible correctness, availability, latency, durability, and freshness. Set an SLO and observation window where the service has an operational commitment; use error-budget consumption to govern risk rather than treating every threshold breach equally.

An alert must identify an owner and an actionable response. Prefer sustained or burn-rate signals over single-point noise, and connect alerts to a runbook or explicit first diagnostic step. Dashboard visibility without ownership is not an operating control.

### Telemetry budget

Bound event volume, metric cardinality, trace sampling, retention, and payload size. Preserve errors, slow paths, security decisions, and recovery transitions within that budget. Measure telemetry loss or throttling explicitly instead of silently dropping the evidence needed during an incident.

### Health and Readiness

- **Liveness:** the process can continue or should be restarted.
- **Readiness:** the instance can safely receive its intended work.
- **Dependency status:** observable separately; avoid making every optional dependency a restart trigger.

A deep health check that creates load or shares the failing path can amplify incidents.

## Failure and privacy rules

- Return stable public error semantics while retaining internal diagnostic context.
- Bound and classify logs; an outage should not cause logging to exhaust the service.
- Define retention and access for logs, traces, audit events, and payload captures.
- Record authorization denials without exposing sensitive policy or resource data.
- Prefer explicit degraded-state signals to silently dropping telemetry.

## Verification

- Test unauthenticated, unauthorized, wrong-tenant, expired, replayed, and malformed credentials.
- Verify every entry path reaches the authoritative policy decision.
- Confirm sensitive values are absent from logs, traces, metrics, and queue payloads.
- Trace one workflow across synchronous and asynchronous boundaries.
- Exercise readiness, telemetry backpressure, rotation, and audit retrieval during failure.
- Prove each SLI from emitted signals, test alert routing and runbook entry conditions, and verify cardinality and sampling remain bounded under abuse or outage load.
