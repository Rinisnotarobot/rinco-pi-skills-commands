# Repository Guidance

## Session continuity

When `docs/handoffs/current.md` exists, read it at session start as navigation for in-flight work. Treat its claims as state-bound context: verify branch, HEAD, worktree state, commands, and referenced artifacts against the repository before acting.

## Backend design philosophy

For the full method, read `skills/patterns/backend-patterns/SKILL.md` and only the references selected by its problem branch.

- Start from repository evidence and operational constraints, then state the problem and the observable invariant before naming a pattern.
- Keep the current design among the candidates. Choose the least complex option that satisfies the invariant; patterns are contextual tools, not maturity levels.
- Define boundaries by owned policy, capability, or invariant—not by directories, classes, interfaces, or deployment units. Point dependencies toward stable policy and isolate volatility only where it is real.
- Distinguish local atomicity from cross-system consistency. Remote effects require durable intent plus duplicate-safe handling, compensation, reconciliation, or another explicit recovery mechanism.
- Treat asynchronous delivery as failure-prone and normally duplicate-capable. Broker labels do not establish exactly-once business effects.
- Treat caches and read models as replicated views. Name their authority, freshness bound, invalidation or update policy, failure behavior, and capacity controls.
- Separate authentication from authorization; enforce deny-by-default policy at every authoritative entry path and preserve audit evidence without leaking sensitive data.
- Design performance from measured workload, latency percentiles, saturation, and capacity targets. Optimize the constrained resource and verify degradation as well as the happy path.
- Route deadlines, retries, cancellation, overload, backpressure, partial failure, idempotency policy, and recovery budgets to the `resilience` skill; keep one owner for failure policy.
- Map the selected pattern to the project's existing language, framework, storage, messaging, telemetry, and test conventions. Prove risky behavior with constraints, concurrency tests, failure scenarios, metrics, or traces, and report remaining assumptions explicitly.
