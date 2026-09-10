---
name: backend-patterns
description: Language- and framework-neutral backend architecture patterns. Use when designing or reviewing service boundaries, data consistency, contract evolution, distributed workflows, messaging, caching, regional topology, authorization, or observability; choose patterns from explicit constraints and trade-offs, route domain, failure, security, and rollout work to their owners, then map decisions to the project's existing stack.
---

# Backend Patterns

Choose backend patterns from the problem's forces and invariants. Preserve the project's language, framework, and established architecture unless the evidence justifies a change.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- execution model: request/response, event-driven, scheduled, streaming, actor, or mixed;
- deployment shape: process, serverless function, container, edge, or worker;
- canonical domain terms, capability and data ownership, transaction boundaries, and external systems;
- consumers, compatibility surfaces, data lifecycle, and deployment coexistence constraints;
- required consistency, latency, throughput, availability, recovery objectives, and regional or regulatory constraints;
- existing conventions and operational capabilities.

Consume `CONTEXT.md` or `CONTEXT-MAP.md` when present. Invoke `domain-modeling` when vocabulary or context ownership must be resolved rather than guessed. Backend pattern comparison remains here; route a selected decision to `domain-modeling` only when the user wants a qualifying ADR recorded.

Completion criterion: every relevant constraint is supported by repository evidence or explicitly marked as an assumption.

### 2. Define the problem and invariant

Describe the recurring failure or design pressure without naming a solution. Then state the invariant that any acceptable solution must preserve.

Examples:

- Duplicate delivery may repeat a charge. Invariant: one idempotency key produces at most one charge.
- A remote dependency stalls requests. Invariant: dependency time is bounded by the caller's deadline.
- A read path overloads the primary store. Invariant: freshness may lag by at most five minutes.

Completion criterion: the problem, affected boundary, and observable correctness condition are explicit.

### 3. Select the relevant pattern family

Read only the references needed for the active branch:

| Problem branch | Reference |
|---|---|
| Module boundaries, layering, dependency direction | [references/boundaries.md](references/boundaries.md) |
| Unresolved domain vocabulary or context ownership; recording a confirmed qualifying ADR | Invoke `domain-modeling`; consume its canonical terms or ADR while keeping backend pattern selection here |
| Transactions, concurrency, distributed consistency, data access and lifecycle | [references/consistency-and-data.md](references/consistency-and-data.md) |
| API, event, schema, or consumer compatibility and evolution | [references/contracts-and-evolution.md](references/contracts-and-evolution.md) |
| Remote, asynchronous, partial-failure, or capacity policy | Invoke the `resilience` skill — in this repository at `skills/workflows/resilience/`, in an installed flat scope as a sibling `resilience/` folder — and consume its policy and evidence requirements |
| Queues, delivery semantics, publish/subscribe | [references/messaging.md](references/messaging.md) |
| Caching, batching, pagination, throughput and cost modeling | [references/caching-and-performance.md](references/caching-and-performance.md) |
| Regional topology, replication placement, failover, restore | [references/topology-and-continuity.md](references/topology-and-continuity.md) |
| Authentication, authorization, auditability, telemetry | [references/security-and-observability.md](references/security-and-observability.md); invoke `security-review` for a deep review of changed trust boundaries |
| Node.js/TypeScript implementation choices | [references/node-typescript.md](references/node-typescript.md) |

Completion criterion: candidate patterns come from the problem branch rather than from habit.

### 4. Compare the smallest viable options

For each candidate, record:

1. **Context** — conditions in which it applies.
2. **Forces** — competing goals such as consistency versus availability.
3. **Solution shape** — components and their relationships, without framework syntax.
4. **Invariant** — what must remain true.
5. **Consequences** — complexity, latency, storage, and operational cost.
6. **Failure modes** — how the pattern is commonly misapplied.
7. **Verification** — tests, metrics, traces, constraints, or failure injection that prove it works.

Include the simplest option, including keeping the current design. Prefer the least complex option that satisfies the invariant.

### 5. Map the pattern to the codebase

Use the project's native primitives and terminology. Keep conceptual boundaries distinct from file-count or class-count: a boundary can be a function, module, process, database constraint, policy, or protocol.

Document where the invariant is enforced. If enforcement spans systems, identify the gap and the recovery mechanism.

Completion criterion: the proposal names concrete integration points without pretending the example implementation is the pattern.

### 6. Verify the behavior

Match verification to the risk:

- concurrency properties: race tests plus database constraints;
- delivery semantics: duplicate, delayed, reordered, and poison messages;
- resilience: consume the focused failure scenarios and observable requirements from `resilience`; do not derive a second failure policy;
- consistency: concurrency and storage-invariant tests plus the partial-failure and recovery requirements consumed from `resilience`;
- contracts and migrations: supported-version matrices, mixed-version tests, backfill reconciliation, and explicit contract-removal evidence;
- topology and continuity: restore tests, failover/failback exercises, replication-lag bounds, and RPO/RTO evidence;
- security: deny-by-default authorization tests and audit evidence; route changed trust boundaries to `security-review`;
- performance: representative load, latency percentiles, saturation signals, workload skew, and unit-cost evidence.

Report what was proved, what remains assumed, and the operational signals needed after deployment.

## Pattern Selection Rules

- Treat transaction script, service layer, vertical slice, ports and adapters, and event-driven designs as alternatives shaped by context—not maturity levels.
- Add a repository boundary when it protects domain code from meaningful persistence complexity or supports multiple callers/adapters. Direct data access is valid for a simple local operation.
- Route deadlines, retries, retry or replay safety, overload, and operation-level partial-failure recovery policy to `resilience`; this Skill maps that policy, while topology and continuity own regional authority, restore, failover, and failback architecture.
- A cache is a replicated view with a freshness policy. Define invalidation, ownership, fallback behavior, and stampede control before adding it.
- At-least-once delivery requires duplicate-safe consumers. Ordering is scoped to the guarantees of the chosen broker and partition key.
- Cross-service consistency requires explicit compensation, reconciliation, or durable state transfer; local database transactions do not cross remote calls.
- Authentication establishes identity. Authorization evaluates whether that identity may perform this action on this resource in this context.
- In-process state is process-local. Do not use it to claim distributed rate limits, durable work, global locks, or cross-instance coordination.
- Compatibility is a time-bounded invariant across deployed versions, consumers, and stored data. Versioning alone does not prove coexistence or safe removal.
- Prefer one authoritative write owner. A multi-writer or active-active topology is incomplete until conflict semantics, failover, failback, and reconciliation are explicit.
- Separate architecture selection from delivery sequencing. Hand migration and rollout steps to `plan`; do not hide irreversible data transitions behind a generic rollback claim.
- Use canonical domain terms and context ownership from `domain-modeling`; do not redefine them inside an implementation recommendation. Backend pattern comparison and selection remain this Skill's responsibility.

## Output Contract

Scale depth to scope: combine headings for a small local decision; use the full structure for cross-system, irreversible, security-sensitive, or continuity-critical work. Mark a section not applicable rather than manufacturing concerns.

When proposing or reviewing a backend pattern, return:

```text
Context and constraints
Problem and invariant
Current design
Candidate options and trade-offs
Selected pattern and why
Rejected alternatives and why
Implementation and evolution mapping
Operational ownership and continuity
Failure modes
Verification plan
Assumptions and open risks
```

The pattern is not complete until its applicability boundary, cost, and verification method are stated.
