# State, Data, and Effects

Use this reference when deciding where state lives, how server data reaches the UI, how mutations reconcile, or how effects follow user intent. Start with authority and lifetime rather than choosing a store or hook.

## Classify each value

| Kind | Default owner | Key question |
|---|---|---|
| Derived value | Render or pure selector | Can it be computed from authoritative inputs? |
| Ephemeral interaction | Narrowest component or behavior module | Does it matter after navigation or remount? |
| Form draft | Form owner | Who owns validation, submission, and unsaved recovery? |
| Navigable state | URL/router | Must reload, history, back/forward, or sharing reproduce it? |
| Server state | Server authority plus a client replicated view | What is the freshness and invalidation policy? |
| Cross-feature client state | Smallest shared owner or external store | Is sharing real, and what update frequency fans out? |
| Durable workflow state | Server or durable local store by explicit requirement | How are partial progress, versioning, and recovery handled? |

State duplicated across categories needs an explicit synchronization invariant or one copy should be derived.

## Candidate patterns

### Derive instead of synchronize

Compute filtered lists, totals, flags, validation summaries, and presentation models from authoritative inputs during render or in a pure selector.

**Invariant:** one source determines the value.

**Failure mode:** copying a prop, query result, or URL value into local state creates drift and effect loops. Cache a derivation only after measurement shows its cost matters.

### Local ownership and lifting

Keep state local while one behavior owns it. Lift to the nearest real common owner when coordinated descendants need the same transition policy.

**Cost/failure mode:** lifting too far creates render fan-out and broad interfaces; keeping coordinated copies local creates conflicting authorities.

### URL-owned state

Use the URL for shareable filters, tabs, search, sorting, pagination, and selected resources when exposure is safe.

Define canonical serialization, defaults, invalid values, history replacement versus push, and server/browser parsing agreement. Never place secrets or sensitive personal data in URLs.

### Reducer or state machine

Use an explicit transition model when several events, guarded transitions, cancellation, or impossible combinations make independent booleans ambiguous.

**Invariant:** every reachable state and event has declared behavior.

**Cost/failure mode:** ceremony exceeds value for a simple toggle; an incomplete machine merely hides unmodeled states. Use `prototype` if one difficult transition question needs throwaway evidence before production design.

### Shared external store

Use when independently located consumers require coordinated, frequent client-owned updates or when a framework-external source already exists.

Define subscription granularity, snapshot consistency, lifecycle, persistence, versioning, and reset behavior. Do not move server data or all local state into a global store merely to avoid passing values.

### Server-state replicated view

A query cache owns a replicated view, not the business authority. Define key identity, freshness, invalidation, refetch triggers, retention, authorization changes, and behavior when cached and remote states disagree.

Avoid hand-built effect-plus-fetch caches when the project already has a server-state primitive that enforces these policies.

### Pessimistic or optimistic mutation

Pessimistic presentation waits for authoritative confirmation. Optimistic presentation applies a provisional transition before confirmation.

Use optimistic presentation only when it has:

- a stable operation and entity identity;
- duplicate-safe server behavior or status reconciliation;
- defined concurrent-edit and ordering semantics;
- provisional UI that users can distinguish where material;
- rejection, rollback or correction, and retry behavior;
- accessibility announcements for pending and final outcomes.

For remote dependencies, durable work, multi-step effects, or shared capacity, `resilience` owns deadlines, retries, propagated cancellation, unknown-outcome, and partial-failure recovery policy. This reference retains browser-local effect cleanup, request supersession, stale-result suppression, and the mapping of consumed policy into user-visible state.

## Effect ownership

An effect synchronizes with something outside the current render: network, subscription, timer, storage, browser API, or imperative widget. Put it at the seam that owns that external lifecycle.

Define setup, cleanup, dependency identity, cancellation, stale-result protection, remount behavior, and development/runtime replay behavior. User actions belong in event transitions when no external synchronization is required.

## Forms and validation

Separate:

- browser constraints and accessible affordances;
- client feedback for speed and usability;
- authoritative server validation and authorization;
- submission identity and duplicate handling;
- field, form, and global errors;
- unsaved, pending, accepted, rejected, and unknown outcomes.

Client validation improves interaction but never establishes server trust.

## Offline and synchronization

Add durable client writes only when offline mutation is an explicit requirement. Define local identity, ordering, conflict policy, schema version, storage limits, encryption constraints, sync trigger, duplicate safety, user-visible status, and abandonment or repair. “Works offline” is incomplete without conflict and recovery semantics.

## Verification

- Enumerate reachable states and transitions, including empty, stale, unauthorized, rejected, cancelled, and unknown outcomes.
- Prove stale responses and remounted effects cannot overwrite newer intent.
- Test duplicate actions, concurrent mutations, invalidation, optimistic rejection, and authoritative reconciliation.
- Verify URL round-trip, refresh, deep link, history, invalid input, and privacy behavior.
- Exercise subscription cleanup, reconnect, offline persistence, schema upgrade, conflict, and storage failure where applicable.
