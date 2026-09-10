# Caching and Performance Patterns

Use this reference after identifying a measured bottleneck or an explicit capacity target. Preserve correctness first; optimize the constrained resource rather than adding generic machinery.

## Establish the performance model

Record:

- workload shape and representative data volume;
- latency percentiles, throughput, and error budget;
- saturated resource: CPU, memory, connection pool, storage, network, lock, or dependency;
- acceptable freshness and degradation behavior;
- expected read/write ratio, arrival rate, service time, concurrency, queueing, and key distribution;
- cost per request, job, tenant, or unit of useful work when cost is a design constraint.

An average latency without load and percentile context is not a sufficient baseline.

## Analytical tools

### Critical-path budget

Allocate the end-to-end latency objective across serial waits and account for fan-out tail amplification. A downstream P99 cannot consume the caller's entire P99 budget. `resilience` owns deadlines and attempt budgets; this reference uses them in the performance model.

### Queueing and concurrency

Use Little's Law, `concurrency = throughput × time-in-system`, as a consistency check on measured steady-state workloads. Treat rising queue time and utilization near saturation as warning signals: adding workers or connections helps only when the constrained downstream resource has capacity. Model burst size and workload skew rather than assuming uniform arrival.

### Hotspot analysis

Measure per-key, tenant, partition, shard, and endpoint distributions. An acceptable aggregate can conceal one overloaded partition or noisy tenant. Select partition keys and isolation boundaries from observed or bounded skew, and define a rebalancing path.

### Query and storage evidence

Use representative query plans, index selectivity, rows scanned versus returned, lock time, I/O, memory, and write amplification. An index accelerates some reads by consuming storage and write capacity; retain it only when measured workload justifies that cost.

## Caching patterns

A cache is a replicated view. Every cache requires an authority, key/version scheme, freshness policy, invalidation strategy, capacity policy, and behavior on cache failure.

### Cache-Aside

**Shape:** read cache; on miss read authority and populate cache. Writes update the authority and invalidate or version cached entries.

**Choose when:** reads dominate and bounded staleness is acceptable.

**Failure modes:** stale data, forgotten invalidation, stampedes, negative-result abuse, unbounded cardinality, and treating cache outage as authority outage.

### Read-Through / Write-Through

A cache abstraction loads misses or synchronously updates the authority. This centralizes behavior but adds the cache to the request's critical path and can conceal consistency semantics.

### Write-Behind

Acknowledge writes before the authority is updated. Use only when temporary loss/reordering is acceptable or a durable log protects pending writes. Define conflict and recovery behavior.

### Request Coalescing

Allow one in-flight load per key while concurrent callers await the same result. This limits miss amplification. Bound wait time and clean up failed in-flight entries.

### Stale-While-Revalidate

Serve a stale value within an explicit window while one actor refreshes it. Useful when availability and latency outweigh immediate freshness. Expose age where consumers need to reason about it.

### Negative Caching

Cache absence or failures only with short, explicit policies. Do not turn transient dependency failures into long-lived false absence.

## Data access and throughput

### Batching

Combine compatible operations to reduce round trips and fixed overhead. Bound batch size and waiting time; define partial-failure behavior.

### Connection Pooling

Reuse bounded connections. Pool size must reflect downstream capacity and total instance count. A larger pool can overload the database while hiding local queueing.

### Cursor Pagination

Prefer a stable cursor for large or changing datasets. Use a deterministic unique ordering tuple and indexes that support it.

### Materialized View

Precompute expensive read shapes when rebuild/update lag is acceptable. Define refresh trigger, staleness bound, backfill, and source-of-truth behavior.

### Compression

Trade CPU for network/storage reduction. Measure payload distribution and avoid compressing already-compressed or very small data.

## Capacity boundary

Use the performance model to identify the constrained resource and capacity target, then follow the resilience method for concurrency, bounded queueing, backpressure, admission, isolation, degradation, and recovery policy — the `resilience` skill, when loaded, is its full form. Consume that policy here only to map it into caching or data-access architecture.

## Verification

Compare the same representative workload and data distribution before and after. Measure percentiles, throughput, queue time, resource saturation, hotspot skew, rows scanned, cache hit ratio, load amplification, freshness age, eviction, and unit cost. State warm-up, cache state, concurrency, dataset size, and environmental differences so results are comparable. Consume overload and recovery evidence requirements from `resilience`; a faster happy path without that evidence is not a complete improvement.
