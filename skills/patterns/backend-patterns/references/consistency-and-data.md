# Consistency and Data Patterns

Use this reference for atomicity, concurrent updates, duplicate effects, cross-system workflows, query shape, and read/write model decisions.

## Local consistency

### Database Transaction

**Context:** several operations against one transactional resource must commit or fail together.

**Invariant:** observers never see a committed partial state.

Keep remote network calls outside a long-lived database transaction where possible. If a remote side effect participates, use durable intent plus recovery rather than assuming rollback crosses systems.

### Optimistic Concurrency Control

**Context:** conflicts are uncommon and blocking would be expensive.

**Shape:** update only when a version, timestamp, or compared value still matches.

**Invariant:** a stale writer cannot silently overwrite a newer value.

Handle conflicts explicitly: reject, retry from fresh state, or merge according to domain rules.

### Pessimistic Locking

**Context:** conflicts are frequent or the protected transition is too expensive to repeat.

**Shape:** acquire a scoped lock before reading/changing protected state.

**Costs:** contention, deadlocks, reduced throughput, and failure recovery. Define lock ordering, timeout, and scope.

### Unique Constraint

Use a storage-enforced uniqueness constraint for invariants such as one reservation per seat or one result per idempotency key. An application-level check followed by insert has a race window.

## Duplicate-safe effects

### Idempotency Key

**Context:** requests, webhooks, or messages can be delivered more than once.

**Shape:** bind a stable operation key to its state/result and reject or replay duplicates.

**Invariant:** the same key and semantic request produce one business effect.

Define:

- key scope and owner;
- behavior when the same key carries different input;
- concurrent first attempts;
- retention period;
- whether failures are replayable.

Use an atomic database constraint or equivalent coordination primitive. A check-then-write sequence alone is insufficient.

## Cross-system consistency

### Transactional Outbox

**Context:** a local state change must eventually produce a message or integration event.

**Shape:** write domain state and an outbox record in one local transaction; a relay publishes the outbox record and marks progress.

**Invariant:** committed state has durable publication intent.

Publication is normally at least once, so consumers still need deduplication. Monitor backlog age and relay failures.

### Inbox

**Context:** an at-least-once consumer must protect a local side effect from duplicates.

**Shape:** record message identity and the local change atomically.

**Invariant:** one message identity produces at most one committed local effect.

### Saga

**Context:** a workflow spans independently transactional services and cannot use one atomic transaction.

**Shape:** each step commits locally; failures trigger explicit compensating or forward-recovery actions. Coordination may be orchestrated or event-driven.

**Costs/failure modes:** temporary inconsistency, compensation failure, semantic undo that differs from rollback, and difficult observability. Persist workflow state and make every step repeatable.

### Reconciliation

Use periodic comparison and repair when perfect synchronous coordination is too expensive or impossible. Define the authority, detection delay, repair policy, and audit trail.

## Read and query patterns

### Explicit Projection

Fetch the fields and rows required by the use case. This controls transfer, authorization exposure, mapping cost, and index opportunities.

### Batch Loading

Collect related keys and fetch them in bounded batches rather than issuing one request per parent. Preserve missing-key semantics and cap batch size.

### Cursor Pagination

Use a stable, unique ordering key when datasets change during traversal or deep offset scans are expensive. The cursor must encode the complete ordering tuple; define forward/backward behavior and snapshot expectations.

### CQRS / Read Model

**Context:** write invariants and read shapes have materially different models or scaling needs.

**Shape:** separate command handling from one or more purpose-built read models.

**Costs:** synchronization lag, additional storage, replay/backfill, and operational complexity. A separate class for reads and writes is not by itself CQRS.

## Verification

- Exercise concurrent writers rather than only sequential unit tests.
- Back invariants with storage constraints where available.
- Inject failure between each durable step.
- Test duplicate, delayed, and reordered delivery.
- Measure reconciliation lag and outbox/inbox growth.
