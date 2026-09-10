# Contracts and Evolution

Use this reference when independently changing producers, consumers, deployed versions, persistent schemas, or serialized data must coexist. It defines compatibility architecture; hand executable sequencing and rollout gates to `plan`.

## Establish the compatibility boundary

Inventory every supported producer, consumer, stored representation, generated client, and administrative tool. Record who owns each, whether it can upgrade atomically, and how long old and new forms must coexist.

A contract includes semantics, validation, authorization, error behavior, ordering, idempotency, defaults, and performance expectations—not only a URL or schema. State the invariant that mixed versions preserve.

## Select the interaction shape

- **Resource-oriented request/response:** choose when clients manipulate stable resources with standard cache, conditional, and status semantics.
- **Operation or RPC contract:** choose when the capability is a command, calculation, or workflow whose domain meaning is clearer than artificial CRUD.
- **Client-shaped query contract:** choose when trusted clients need flexible composition over a governed data graph; bound query cost, authorization, and schema evolution explicitly.
- **Asynchronous command or event:** choose when acceptance is distinct from completion, work must survive the caller, or independent consumers react to a completed fact. Consume delivery semantics from [Messaging Patterns](messaging.md).

Transport style does not decide ownership or consistency. Avoid exposing internal storage shape as the public contract merely because it is easy to serialize.

## Candidate evolution patterns

### Additive evolution

Add optional fields, operations, or event variants while preserving existing meaning. Define default behavior when a field is absent and how old readers handle unknown values.

**Choose when:** the old meaning remains valid and consumers can migrate gradually.

**Failure mode:** a syntactically optional field is semantically required, or an existing field changes meaning without changing shape.

### Explicit versioning

Create a new contract version when incompatible semantics must coexist. Name the versioned unit: endpoint, media type, message type, schema, or capability—not an arbitrary whole service by default.

**Cost:** parallel support, routing, documentation, tests, and a removal process. Versioning labels incompatibility; it does not make migration safe by itself.

### Compatibility adapter

Translate old and new forms at one owned boundary when consumers cannot migrate together. Preserve error and idempotency semantics, expose adapter usage, and give it a removal condition.

**Failure mode:** bidirectional translation loses information and silently makes the older form authoritative again.

### Consumer-driven contract

Capture the supported assumptions of independently owned consumers and verify providers against them. Use it to detect breaking changes, not to let consumers dictate provider internals or preserve accidental behavior forever.

### Expand, migrate, contract

Expand storage or protocol shape so old and new forms coexist; migrate readers, writers, and data in bounded steps; contract only after evidence shows the old form is unused. During coexistence, declare the authoritative representation and how divergent dual writes are detected and repaired.

`plan` owns the deployment order, checkpoints, observation windows, feature flags, rollback or roll-forward actions, and point of no return.

## Event evolution

Separate envelope compatibility from business semantics. Preserve stable event identity for deduplication, define ordering scope, and version completed facts without retroactively changing their meaning. A tolerant parser cannot repair a consumer whose business assumption is no longer true.

For replay, state which handler and schema versions process historical events, how non-deterministic dependencies are controlled, and how backfill effects avoid duplication.

## Data migration architecture

Define:

- old, compatibility, and target states;
- authoritative readers and writers in each state;
- online versus maintenance-window constraints;
- handling of concurrent writes during backfill;
- reconciliation and cleanup conditions;
- retention or deletion effects on derived and restored data.

Do not describe destructive migration rollback as reversing data unless that reversal is proven. Record whether safety requires stopping writes, restoring a verified backup, or rolling forward with repair as a planning constraint; `plan` owns the exact sequence and commands.

## Selection rules

- Prefer additive change when semantics permit it.
- Support only explicit producer/consumer combinations; “backward compatible” without a matrix is incomplete.
- Keep one authority during coexistence. If dual writes are unavoidable, define divergence detection and repair before rollout.
- Give every compatibility shim, legacy field, and feature flag an owner and removal condition.
- Treat unknown external consumers as a constraint requiring telemetry, communication, or a longer support window—not as evidence that removal is safe.

## Verification

- Run old/new producer-consumer combinations from the declared compatibility matrix.
- Verify absent, unknown, reordered, duplicated, and malformed fields or events.
- Reconcile backfilled data and concurrent writes against the declared authority.
- Observe old/new path usage and prove supported consumers have migrated before contraction.
- Hand each transition state, compatibility invariant, and removal condition to `plan` for executable stop, rollback, roll-forward, and observation gates.
