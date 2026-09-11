# Performance and Bundling

Use this reference when a render or payload cost has been measured, or when a change proposes memoization, virtualization, code splitting, or a new client dependency. The performance model, targets, budgets, and device and network tiers belong to `frontend-patterns`; read its performance reference before treating any cost described here as a goal. This reference owns only the React mechanism and what that mechanism costs.

## Name the measurement before changing the render

| Symptom | Measurement | What it distinguishes |
|---|---|---|
| A subtree re-renders after one keystroke | render count per component, with the props that changed | a stale closure or an unstable identity handed down, versus genuinely changing input |
| Typing feels laggy | commit duration in a production build | slow render work versus slow effects, layout, or paint |
| First interaction is slow | transferred and parsed JavaScript for the route | payload size versus parse and evaluate cost |
| A route loads code it never runs | which chunks load, on which interaction | eager imports pulled in by a shared barrel file |

Measure a production build on the project's constrained device tier. Development-mode render counts, one average with no distribution, and isolated microbenchmarks are not evidence.

Derive before caching. A value computable during render needs no cache, memo, or effect; memoizing a derivation whose inputs change on every render buys comparison cost and nothing else.

## What each memoization tool solves

| Tool | What it prevents | What it costs |
|---|---|---|
| `React.memo` | re-rendering a child whose props are equal under the comparison used | a comparison on every parent render, retained previous props, and staleness when the comparison is wrong |
| `useMemo` | recomputing a value on every render | a dependency comparison, retained memory, and a cache that must stay correct |
| `useCallback` | a new function identity each render | the same comparison and retention, useful only where identity is itself observed |

`useCallback` earns its cost when the function is a dependency of another effect or memo, or when it is passed to a memoized child. Passing a wrapper that nothing observes is overhead with a misleading name.

## When memoization is the burden

- Props differ on most renders: the comparison runs and the render happens anyway.
- The compared subtree is cheap: the check costs more than the work it skips.
- A custom comparison ignores values the child actually reads, so stale output ships.
- `memo` is added to silence a re-render instead of locating the unstable prop that causes it.
- Memoization compensates for a state placement problem that moving state down would remove outright.

```tsx
// The comparison is real work; the row is a plain text node.
const Row = React.memo(({ label }: { label: string }) => <li>{label}</li>);

// Cheaper: no comparison, no retained props.
function Row({ label }: { label: string }) {
  return <li>{label}</li>;
}
```

## Why `memo` does not take effect

| Cause | Shape to look for |
|---|---|
| Fresh object, array, or function literal each render | `style={{...}}`, `items={[...]}`, `onSelect={() => ...}` |
| `children` built inline by the parent | `<Panel><Toolbar /></Panel>` creates a new element every render |
| Context value not memoized | `value={{ user, dispatch }}` re-renders every consumer |
| Identity from an unstable source | a hook returning a new object per call, or a selector that maps without caching |
| Two copies of a dependency | duplicate package versions defeat `memo` comparisons on objects from the other copy |

Fix the identity at the call site, or stop memoizing. A `memo` whose props never compare equal is measurement noise that hides the real problem.

## List virtualization

Virtualize when DOM node count, layout work, or memory grows past what the viewport needs, and when users genuinely need one continuous scrolling surface. Pagination, incremental disclosure, or server-side windowing may be cheaper and simpler when they do not.

Costs to budget for: the virtualizer owns scroll position and measurement; keyboard traversal must still reach every row; focus must survive recycling; selection, copy, search-in-page, find-on-page, print, and export change behavior; row keys must be stable identities, not indices; variable row heights make measurement a first-class concern.

```tsx
const rowVirtualizer = useVirtualizer({
  count: rows.length,
  getScrollElement: () => parentRef.current,
  estimateSize: () => 44,
  getItemKey: (index) => rows[index].id,
});
```

Do not introduce a virtualizer for a list that only looks long on the largest screen. Confirm the count and row cost against the project's own data.

## Where the split boundary goes

Split on coherent route or feature boundaries, not per component. A chunk that loads on interaction must be prefetched on intent where the interaction is predictable, and its fallback must be stable enough not to shift layout.

```tsx
const HeavyReport = lazy(() => import("./HeavyReport"));

<ErrorBoundary fallback={<ReportUnavailable />}>
  <Suspense fallback={<ReportSkeleton />}>
    <HeavyReport id={id} />
  </Suspense>
</ErrorBoundary>
```

Boundary rules: a failed chunk request needs recovery, so pair lazy boundaries with an error boundary; splitting inside a render path that the first paint already needs delays the first paint; deep barrel files reintroduce eager imports and defeat the split; a chunk that arrives after the interaction it was meant to serve has moved the cost, not removed it.

## Keep server-side dependencies out of the client bundle

The `"use client"` boundary is where bundle cost and secrets cross. Everything the client component imports, and everything those imports pull in transitively, ships to the browser.

- Place `"use client"` at the leaves that need interactivity, not at a layout or page that then wraps the whole tree.
- Never import a database client, filesystem module, secret-bearing config, or server-only utility from a client module, directly or through a helper that does.
- Prefer passing serialized props or `children` across the boundary over re-importing server logic on the client.
- Guard the boundary so a mistake fails the build or a test rather than reaching users.

```tsx
// server-only module: fails loudly instead of leaking into the client graph
import "server-only";
export async function getOrders() { /* db access */ }
```

## Verification

- Show a render count for the component and its children, before and after, for the same interaction and the same data volume.
- Attribute improvement to the chosen mechanism with a production-mode trace or profile that covers commit duration, not only render counts.
- Show the module in the bundle or chunk report, and show that a deferred chunk actually loads at the intended moment rather than merely moving bytes between bundles.
- For virtualization: keyboard traversal reaches every row, focus survives scrolling and recycling, and selection, search-in-page, and print or export behave as declared.
- For lazy boundaries: the fallback renders, a failed chunk reaches the error path, and nothing critical to first paint waits on the split.
- For the client boundary: build or bundle inspection shows the server-only dependency absent from the client graph, and a check fails if it is reintroduced.
- No improvement is claimed without a comparison on the same journey, build mode, data volume, and device tier.
