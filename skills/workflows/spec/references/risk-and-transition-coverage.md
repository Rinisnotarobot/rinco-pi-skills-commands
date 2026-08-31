# Risk and Transition Coverage

Apply only the branches the change can actually reach. For each applicable branch, define the required outcome, invariant, failure behavior, and evidence intent.

| Branch | Questions the specification must settle |
|---|---|
| Authorization and tenancy | Who may act or observe? What remains hidden on denial? Which tenant or ownership boundary must hold? |
| Privacy and sensitive data | Which data classes are collected, exposed, retained, deleted, or audited? Which policy or owner supplies the rule? |
| Persistent data | What states and transitions are valid? What survives partial failure? What is the source of truth? |
| Migration and compatibility | Which old/new versions coexist? What is backward/forward behavior? Where is the point of no return? |
| External effects and cost | Which action sends, charges, provisions, or mutates another system? What requires authorization, idempotency, or a sandbox? |
| Failure and recovery | What does the actor observe on timeout, rejection, partial success, retry, cancellation, or dependency outage? |
| Concurrency and ordering | Which operations may overlap or repeat? Which final states are valid? What ordering assumptions are contractual? |
| Performance and capacity | Under what workload and environment does a threshold apply? Is it a requirement, budget, or human judgment? |
| Accessibility and UX | Which keyboard, assistive-technology, feedback, recovery, or comprehension outcomes are required? |
| Operations and rollout | Which signals show healthy behavior? Who owns stop, rollback, reconciliation, and post-deploy acceptance? |

## Transition contract

For stateful or staged changes, record:

```text
Current supported state
Target supported state
Allowed intermediate states
Entry and exit conditions
Compatibility window
Failure/partial-completion behavior
Recovery or rollback boundary
Reconciliation outcome
Cleanup condition and owner
```

The specification defines required outcomes and ownership. `plan` later selects repository artifacts, ordering, commands, and rollout mechanics.

## Authority gate

Security, compliance, retention, billing, contractual availability, and destructive-transition rules need an authoritative source. Use one of:

- explicit user or stakeholder decision;
- product, policy, legal, or contract artifact;
- applicable repository instruction that governs engineering behavior;
- named assumption with an owner and blocker status.

Existing code can show current behavior and risk, but cannot silently authorize desired policy.
