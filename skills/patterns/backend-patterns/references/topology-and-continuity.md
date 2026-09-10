# Topology and Continuity

Use this reference when architecture spans failure domains, regions, replicas, recovery sites, or data-residency boundaries. Prefer the simplest topology that meets measured latency, availability, RPO, RTO, and regulatory constraints.

## Establish authority and objectives

Record:

- authoritative write location for each invariant and dataset;
- clients, regions, latency targets, and residency restrictions;
- failure domains and correlated dependencies;
- recovery point objective (RPO) and recovery time objective (RTO);
- replication mode, lag bound, and behavior when connectivity is partitioned;
- failover and failback authority, including human or automated ownership.

Availability percentages alone do not select a topology. State which operations must continue, which may become read-only or stale, and which must stop to preserve correctness.

## Candidate topologies

### Single region with restore

Run one authoritative region and recover from verified backups or rebuilt infrastructure.

**Choose when:** its failure exposure satisfies the objectives and operational simplicity is valuable.

**Cost:** regional outages last until restore or redeployment completes. Prove restore time and recoverable data rather than assuming a backup meets RTO/RPO.

### Active-passive

Maintain a secondary environment or replica and promote it after a declared failure condition.

**Invariant:** at most one accepted write authority exists unless conflict handling says otherwise.

**Costs:** replication lag, standby drift, promotion orchestration, stale routing, and failback complexity. “Warm” and “hot” are incomplete without measured readiness and promotion time.

### Read-local, write-authoritative

Serve replicated reads near clients while routing invariant-changing writes to one authority.

**Choose when:** read latency matters and bounded staleness is acceptable.

**Failure modes:** read-your-writes violations, stale authorization or configuration, and lag hidden from callers. Define consistency tokens, authority reads, or user-visible freshness where required.

### Partitioned ownership

Assign each tenant, account, or key range one write region and route operations to that owner.

**Choose when:** ownership is stable enough to avoid multi-writer conflicts while distributing latency or capacity.

**Costs:** routing metadata, rebalancing, cross-partition workflows, and hotspot risk. Migration of ownership is a consistency workflow, not a routing-only change.

### Multi-writer

Accept writes for the same logical data in more than one failure domain only when merge or conflict semantics are part of the domain contract.

Define commutative operations, version vectors or ordering, conflict visibility, invariant enforcement, reconciliation, and irreconcilable cases. Last-write-wins is a business decision with data-loss semantics, not a neutral default.

## Continuity mechanisms

### Backup and restore

Define backup scope, frequency, retention, encryption, isolation from production credentials, integrity checks, and restore procedure. Include configuration, schemas, queues, object stores, and external dependencies needed to reconstruct service—not only the primary database.

### Failover and failback

Define detection, decision authority, fencing of the old writer, traffic and dependency changes, validation before acceptance, and communication. Failback must reconcile writes and restore a safe authority; switching DNS back is not recovery.

### Degraded modes

State which operations remain correct under stale reads, missing dependencies, or regional isolation. Consume deadlines, overload, and operation-level partial-failure recovery policy from `resilience`; this reference owns regional authority, restore, failover, and failback architecture and maps the consumed policy into that topology.

## Selection rules

- Start with one write authority and add topology only for evidenced objectives.
- Count shared identity, DNS, control plane, secrets, observability, and third-party services as correlated dependencies.
- Never claim zero data loss without synchronous durability across the stated failure boundary and evidence that it holds.
- Keep residency and encryption requirements attached to replicas, backups, logs, and failover paths.
- Hand deployment coexistence, traffic shifts, observation windows, and irreversible transitions to `plan`.

## Verification

- Restore representative data and dependent configuration into an isolated environment; measure achieved RPO and RTO.
- Exercise loss of a replica, zone, region, control plane, and network path within an explicitly authorized blast radius.
- Prove write fencing, routing convergence, lag visibility, read-your-writes behavior, and duplicate-safe recovery.
- Exercise failback and reconcile divergent or queued work before declaring recovery complete.
- Verify residency, access, encryption, and retention across replicas, backups, logs, and temporary recovery artifacts.
