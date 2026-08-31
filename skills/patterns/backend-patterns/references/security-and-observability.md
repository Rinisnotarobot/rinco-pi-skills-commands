# Security and Observability Patterns

Use this reference for identity, policy enforcement, secrets, auditability, telemetry, health, and incident diagnosis.

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
