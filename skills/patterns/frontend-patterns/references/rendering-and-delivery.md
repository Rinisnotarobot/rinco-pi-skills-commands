# Rendering and Delivery

Use this reference when selecting where and when UI is rendered, loaded, hydrated, navigated, cached, or upgraded. Choose from user journeys, data authority, platform capability, latency, privacy, and operational constraints—not framework fashion.

## Establish the rendering boundary

Record:

- which content is public, personalized, authenticated, time-sensitive, or user-specific;
- where required data and authorization decisions are available;
- first-view, interaction, indexing, sharing, and offline requirements;
- browser capability and no-script or degraded-mode policy;
- cacheability, geographic latency, compute cost, and deployment model;
- server/client serialization and hydration constraints.

## Candidate rendering patterns

### Client rendering

**Context:** the interface is highly interactive, indexing and first response HTML are secondary, and required data is safely available through client APIs.

**Costs:** more shipped code, delayed useful content, client resource pressure, loading-state complexity, and dependence on script execution. A loading shell is not evidence of acceptable first-view behavior.

### Request rendering

**Context:** content is personalized or request-dependent and meaningful HTML must arrive before client execution.

**Invariant:** authorization and private data remain request-scoped; shared caches cannot mix users or tenants.

**Costs:** server latency and capacity on the critical path, hydration work, and server/browser determinism requirements.

### Prerendering

**Context:** output changes less often than it is read and can be generated without per-request private context.

Define rebuild or revalidation triggers, maximum staleness, invalidation ownership, fallback behavior, and what happens when generation fails.

### Streaming and progressive reveal

**Context:** independent regions have materially different readiness times and early content is useful without later regions.

Place boundaries around coherent user tasks. Preserve layout stability, focus order, announcements, error ownership, and meaningful fallback content.

**Failure mode:** many tiny boundaries create visual churn, duplicate requests, and inaccessible announcements without improving task completion.

### Islands or selective hydration

**Context:** mostly static content contains a small number of interactive regions.

**Shape:** ship client runtime only for those regions and keep cross-island state or events explicit.

**Costs:** serialization boundaries, duplicated dependencies, interaction startup delay, and coordination complexity.

### Client-only boundary

Use for capabilities that fundamentally require browser state or APIs. Provide stable server output and avoid suppressing hydration disagreement as a substitute for deterministic rendering.

## Hydration invariant

The server output and first browser render must agree on semantic structure, identity, and initial state. Treat time, randomness, locale, viewport, browser storage, and environment-dependent values as explicit inputs or defer them until after hydration without replacing meaningful content unnecessarily.

Serialization is a trust and compatibility boundary. Pass only required data, preserve type and identity semantics, and avoid embedding secrets or private records into markup or navigation payloads.

## Route and navigation architecture

Routes own navigable state, data boundaries, authorization transitions, document metadata, focus/announcement behavior, and refresh/deep-link semantics. A client transition and a full document load must preserve the same accepted outcome unless the difference is explicit.

Use nested rendering and loading boundaries when parent content remains valid across child navigation. Avoid a global route loader that blocks unrelated stable content.

## Delivery and evolution

Code splitting, asset hashing, preload, prefetch, and caching form a delivery policy. Define entry points, dependency duplication, cache lifetime, invalidation, failed-chunk recovery, and behavior on constrained networks.

Deployments can leave active sessions with old documents, new APIs, old service workers, and mixed-version chunks. Keep required combinations compatible, make stale-asset recovery user-safe, and give temporary shims or flags an owner and removal condition. Hand deployment order, observation windows, rollout, rollback, and roll-forward steps to `plan`.

Progressive enhancement starts from a semantic, server-accepted path where the requirement calls for it, then adds client acceleration without changing correctness. Do not claim support for no-script operation unless it is required and verified.

## Verification

- Exercise first load, client navigation, refresh, deep link, back/forward, and interrupted navigation.
- Compare server output with the first browser render under locale, time, storage, and capability variations.
- Test loading, empty, partial, error, stale, unauthorized, and recovery boundaries independently.
- Measure useful content and interaction on representative devices and networks, including cold caches.
- Test old/new document, asset, API, and service-worker combinations required by the delivery policy.
- Verify personalized data cannot enter public or cross-user caches and serialized payloads contain only intended data.
