---
name: backend-patterns
description: Language- and framework-neutral backend architecture patterns. Use when designing or reviewing service boundaries, data consistency, distributed workflows, messaging, caching, resilience, authorization, or observability; choose patterns from explicit constraints and trade-offs, then map them to the project's existing stack.
---

# Backend Patterns

Choose backend patterns from the problem's forces and invariants. Preserve the project's language, framework, and established architecture unless the evidence justifies a change.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- execution model: request/response, event-driven, scheduled, streaming, actor, or mixed;
- deployment shape: process, serverless function, container, edge, or worker;
- data ownership, transaction boundaries, and external systems;
- required consistency, latency, throughput, availability, and recovery behavior;
- existing conventions and operational capabilities.

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
| Transactions, concurrency, distributed consistency, data access | [references/consistency-and-data.md](references/consistency-and-data.md) |
| Timeouts, retries, isolation, queues, delivery semantics | [references/messaging-and-resilience.md](references/messaging-and-resilience.md) |
| Caching, batching, pagination, load control | [references/caching-and-performance.md](references/caching-and-performance.md) |
| Authentication, authorization, auditability, telemetry | [references/security-and-observability.md](references/security-and-observability.md) |
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
- resilience: timeout and dependency-failure tests;
- consistency: partial-failure and recovery tests;
- security: deny-by-default authorization tests and audit evidence;
- performance: representative load, latency percentiles, and saturation signals.

Report what was proved, what remains assumed, and the operational signals needed after deployment.

## Pattern Selection Rules

- Treat transaction script, service layer, vertical slice, ports and adapters, and event-driven designs as alternatives shaped by context—not maturity levels.
- Add a repository boundary when it protects domain code from meaningful persistence complexity or supports multiple callers/adapters. Direct data access is valid for a simple local operation.
- Retry only transient failures when the operation is idempotent or protected by an idempotency mechanism. Bound retries by the caller's deadline and a retry budget.
- A cache is a replicated view with a freshness policy. Define invalidation, ownership, fallback behavior, and stampede control before adding it.
- At-least-once delivery requires duplicate-safe consumers. Ordering is scoped to the guarantees of the chosen broker and partition key.
- Cross-service consistency requires explicit compensation, reconciliation, or durable state transfer; local database transactions do not cross remote calls.
- Authentication establishes identity. Authorization evaluates whether that identity may perform this action on this resource in this context.
- In-process state is process-local. Do not use it to claim distributed rate limits, durable work, global locks, or cross-instance coordination.

## Output Contract

When proposing or reviewing a backend pattern, return:

```text
Context and constraints
Problem and invariant
Current design
Candidate options and trade-offs
Selected pattern and why
Rejected alternatives and why
Implementation mapping
Failure modes
Verification plan
Assumptions and open risks
```

The pattern is not complete until its applicability boundary, cost, and verification method are stated.
