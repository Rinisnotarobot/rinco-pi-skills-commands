# Frontend Performance

Use this reference after identifying a measured user-journey problem or an explicit resource budget. Optimize the constrained browser, network, server, or third-party resource while preserving correctness and accessibility.

## Establish the performance model

Record:

- representative journeys, routes, data volume, content, and interaction sequences;
- target and measured distributions for loading, responsiveness, and visual stability;
- device CPU, memory, display, network latency/bandwidth, cache, and power conditions;
- shipped JavaScript, CSS, fonts, media, requests, hydration, and third-party work;
- main-thread long tasks, render and layout work, memory growth, and server or edge latency;
- warm versus cold navigation, authenticated versus public state, and field versus lab evidence.

An isolated microbenchmark, development build, desktop-only trace, or average without distribution context is not a baseline.

## Performance budgets

Allocate budgets to user-visible milestones and constrained resources: document response, critical assets, useful content, interaction readiness, response to input, layout stability, route transitions, memory, and data usage. Assign ownership per route or feature so shared dependencies do not consume the budget invisibly.

Use field telemetry for experienced distributions and controlled lab traces for diagnosis. Neither substitutes for the other.

## Candidate patterns

### Ship less work

Remove unused functionality and dependencies before scheduling them differently. Prefer platform capabilities, server-produced content, smaller representations, and feature-scoped entry points where they preserve the invariant.

**Failure mode:** bundling reports show smaller bytes while parse, evaluation, hydration, duplicate dependencies, or runtime work remains the bottleneck.

### Render containment

Keep frequently changing state near its consumers, subscribe to narrow snapshots, preserve stable identities where meaningful, and isolate expensive subtrees.

Memoization adds comparison, memory, and invalidation complexity. Use it only when traces show avoidable repeated work and its inputs have stable semantics.

### Defer or split work

Delay non-critical code, data, media, or third parties until intent or idle capacity when the task allows it. Split on coherent route or feature boundaries and provide useful, stable fallback content.

**Failure modes:** request waterfalls, layout shift, interaction-time downloads, failed dynamic chunks, duplicate dependencies, and prefetch that competes with critical work.

### Virtualization or incremental rendering

Use when DOM, layout, memory, or render work grows beyond the viewport's useful content.

Preserve keyboard navigation, focus, search, selection, measurement, announcements, print/export requirements, and stable identity. Pagination or incremental disclosure may be simpler when users do not need one continuous surface.

### Media and font policy

Choose dimensions, formats, quality, responsive sources, loading priority, decoding, and caching from visual need and network cost. Reserve layout space. Limit font variants and define acceptable fallback metrics and behavior.

### Data and request shaping

Fetch the fields and ranges needed for the current task, batch compatible work, avoid serial waterfalls, and coordinate duplicate requests. A client cache remains a replicated view governed by `state-data-and-effects.md`.

### Third-party containment

Budget scripts, frames, tags, and widgets separately. Load them only with required consent and capability, isolate failure, and measure their CPU, network, privacy, and interaction cost on real journeys.

## Selection rules

- Fix the largest evidenced constraint first.
- Prefer deletion and simpler rendering before memoization or scheduling machinery.
- Evaluate loading and interaction together; improving one metric by delaying required work into the first interaction is not a complete improvement.
- Treat accessibility, correctness, freshness, and privacy regressions as failed optimizations.
- Do not use arbitrary list lengths, bundle sizes, or timing thresholds without a project or product authority.

## Verification

- Compare the same production-mode journey, data distribution, device, network, cache, and account state before and after.
- Record traces or profiles that attribute improvement to the selected mechanism.
- Measure distributions and outliers, not only one successful run.
- Exercise cold and warm loads, navigation, interaction bursts, long sessions, failures, and constrained conditions.
- Check semantic structure, focus, announcements, reduced motion, and content completeness after optimization.
- Observe field results and regressions after delivery; laboratory success alone does not prove user impact.
