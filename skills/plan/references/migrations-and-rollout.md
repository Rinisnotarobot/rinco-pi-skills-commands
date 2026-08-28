# Migrations and Rollout

Use this reference when old and new forms must coexist, persistent state changes, external consumers cannot update atomically, or deployment order affects correctness.

## Define transition states

Describe:

1. current state;
2. compatibility state where old and new coexist;
3. target state;
4. cleanup condition.

For each state, identify readers, writers, contracts, data authority, observability, and what happens on rollback.

## Expand, migrate, contract

### Expand

Introduce the new schema, API, field, event, configuration, or implementation alongside the old form. Keep existing consumers working. Add observability before traffic or data depends on the new path.

### Migrate

Move writers, readers, callers, or stored data in bounded steps. Define ordering, idempotency, retry/resume behavior, progress measurement, and compatibility during mixed versions.

### Contract

Remove the old form only after evidence shows no supported producer, consumer, or stored record depends on it. Delete compatibility code, flags, temporary metrics, and obsolete documentation together.

Each phase is a separate plan slice unless the repository is proven to deploy atomically with no external or persistent compatibility surface.

## Data migration questions

- Is the migration forward-only or reversible?
- Can it run online, or does it require a maintenance window?
- How are concurrent writes handled during backfill?
- What is the batch size, checkpoint, retry, and rate limit?
- How is correctness reconciled after migration?
- Which schema/version is authoritative during coexistence?
- What backup or restore evidence exists?
- How are partially migrated records detected?

Never claim rollback means reversing a destructive data transformation unless that reversal is proven. Sometimes rollback means stopping new writes, restoring from backup, or rolling forward with a repair.

## Public API and protocol changes

Prefer additive changes, explicit versioning, tolerant readers, and staged consumer migration. Record:

- supported old/new combinations;
- deployment order;
- deprecation and removal conditions;
- generated-client or schema-registry updates;
- unknown or third-party consumer risk.

For events, distinguish event identity and semantics from serialized schema compatibility.

## Dependency and runtime upgrades

Identify behavior, configuration, lockfile, generated output, build, deployment, and platform changes. Read current release/migration documentation when version-specific behavior matters. Plan one compatibility boundary rather than mixing unrelated application refactors into the upgrade.

## Feature rollout

A feature flag needs ownership, default, targeting, expiry, fallback, and removal. Define whether disabled means old behavior, no behavior, or a safe degraded path. Tests must cover transition-critical states, not every arbitrary flag combination.

## Operational evidence

Name the signals used to proceed or stop:

- error and rejection rates;
- latency and saturation;
- old/new path usage;
- migration progress and reconciliation differences;
- queue/backlog age;
- authorization or data-integrity violations.

Include alert ownership and an observation window when rollout safety depends on production behavior.

## Rollback record

```text
Trigger: observable condition that stops rollout
Action: exact state/config/deployment transition
Data effect: what happens to writes already performed
Compatibility: which versions remain interoperable
Verification: evidence that rollback restored a safe state
Point of no return: irreversible step, if any
```
