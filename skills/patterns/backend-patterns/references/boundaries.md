# Boundaries and Dependency Direction

Use this reference when the problem is coupling, ownership, testability, change isolation, or coordination between modules and systems.

## Start with the boundary

A useful boundary has:

- one reason to change;
- explicit inputs, outputs, and failure semantics;
- ownership of an invariant or capability;
- dependencies pointing toward stable policy rather than volatile infrastructure.

A directory or class is not automatically a boundary. Separate deployment is not automatically a service boundary.

## Domain and capability ownership

Consume the project's canonical vocabulary before drawing boundaries. A useful service or module boundary normally owns a capability, its policy, and the data needed to enforce its invariants. If terms or context ownership are disputed, invoke `domain-modeling`; this reference maps an accepted model into architecture rather than inventing a second one.

Treat team ownership and deployment independence as forces, not proof of a boundary. Splitting one invariant across teams, stores, or synchronous services increases coordination and failure cost; require an explicit recovery mechanism when the split is unavoidable.

## Candidate patterns

### Consistency Boundary (Aggregate)

**Context:** several entities or state transitions participate in one synchronously enforced business invariant.

**Shape:** one authoritative boundary loads the required state, decides the transition, and commits it atomically where the storage model permits.

**Invariant:** no caller or adapter can commit a partial transition that violates the protected business rule.

**Cost/failure mode:** an oversized aggregate increases contention and load; splitting it across services turns a local invariant into a distributed workflow. Keep only immediately consistent rules inside and use explicit eventual workflows for the rest.

### Transaction Script

**Context:** a use case is short, local, and mostly coordinates validation plus persistence.

**Shape:** one operation implements the use case from input to outcome.

**Choose when:** business rules are simple and duplication is limited.

**Cost/failure mode:** scripts become tangled when rules and workflows are repeatedly copied. Do not split them preemptively merely to obtain layers.

### Service Layer

**Context:** several transports or entry points invoke the same application rules, or a use case coordinates multiple domain operations.

**Shape:** an application boundary exposes use cases and keeps transport concerns outside.

**Invariant:** HTTP, queue, CLI, and scheduler adapters cannot change business meaning.

**Cost/failure mode:** pass-through services add indirection without owning policy.

### Repository

**Context:** domain/application code would otherwise depend on complex persistence behavior, query construction, or several data sources.

**Shape:** a port exposes operations in domain terms; an adapter implements storage details.

**Invariant:** callers depend on the contract, including absence, conflict, and concurrency semantics—not on a specific client API.

**Cost/failure mode:** generic CRUD repositories hide useful database capabilities and leak query requirements through endless parameters.

### Vertical Slice

**Context:** features change independently and horizontal layers create cross-folder edits for every use case.

**Shape:** group transport, application behavior, validation, and data access around one capability while sharing only stable infrastructure.

**Cost/failure mode:** slices become isolated copies when shared policy is not recognized; premature shared abstractions recreate horizontal coupling.

### Ports and Adapters

**Context:** core policy must survive changes in transport, persistence, or third-party integration, or deterministic tests need substitutes at volatile boundaries.

**Shape:** policy owns ports; infrastructure implements adapters.

**Invariant:** dependency direction points from volatile mechanisms toward stable contracts owned by the policy side.

**Cost/failure mode:** an interface for every class produces ceremony. Create ports at actual volatility or ownership boundaries.

### Anti-Corruption Layer

**Context:** an external or legacy model conflicts with the local domain language.

**Shape:** a translator isolates foreign concepts, errors, and lifecycle rules from the local model.

**Cost/failure mode:** a transparent proxy passes the foreign model through and provides no protection.

## Selection prompts

- What invariant or capability does the proposed boundary own?
- Which changes should remain local after introducing it?
- Are multiple implementations real, likely, or merely imagined?
- Does the boundary preserve useful storage/framework capabilities?
- Can the behavior be tested without reproducing the implementation?
- Which team owns the policy, data, operation, and incident response at this boundary?
- Does a synchronous dependency reveal that one invariant was split across services?
- Can the contract evolve while old and new callers coexist?

Prefer the current structure when no meaningful change or policy boundary can be named.
