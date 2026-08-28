# Caching and Performance Patterns

Use this reference after identifying a measured bottleneck or an explicit capacity target. Preserve correctness first; optimize the constrained resource rather than adding generic machinery.

## Establish the performance model

Record:

- workload shape and representative data volume;
- latency percentiles, throughput, and error budget;
- saturated resource: CPU, memory, connection pool, storage, network, lock, or dependency;
- acceptable freshness and degradation behavior;
- expected read/write ratio and key distribution.

An average latency without load and percentile context is not a sufficient baseline.

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

## Load control

- Bound concurrency at each scarce dependency.
- Bound queues by count, bytes, and/or age.
- Apply backpressure or admission control before saturation.
- Reserve capacity for health, recovery, or high-priority work when needed.
- Prefer graceful degradation with explicit semantics over silent partial correctness.

## Verification

Compare the same representative workload before and after. Measure percentiles, throughput, resource saturation, cache hit ratio, load amplification, freshness age, eviction, and failure behavior. A faster happy path that worsens overload recovery is not a complete improvement.
