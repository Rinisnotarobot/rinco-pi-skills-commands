# Rendering and Server Boundaries

Use this reference when the work involves the server/client split in React: a boundary to draw, a client bundle that grew, a Suspense or error boundary to place, a route-level loading state, or a hydration warning. It owns the React and framework form of a rendering decision. The decision itself — request rendering, prerendering, streaming, islands, or a client-only shell — belongs to `frontend-patterns` in its `rendering-and-delivery.md`. Secrets, tokens, and trust crossings that the boundary exposes belong to `security-review`; this file only keeps them from leaking into a bundle.

## Drawing the Server/Client Boundary

### The server is the default

A server component resolves async data and authorization itself, never ships JavaScript for its own render, and cannot hold state or event handlers. Reach for a client component when the capability genuinely needs browser state or an API.

```tsx
// Server component: default, async, no client bundle.
export default async function ProductPage({ params }: { params: { id: string } }) {
  const product = await db.product.findUnique({ where: { id: params.id } });
  if (!product) notFound();
  return <ProductView product={product} />;
}

// Client component: opt in, and everything it imports comes along.
"use client";
export function AddToCartButton({ productId }: { productId: string }) {
```

### `"use client"` marks a boundary, and it is contagious

The directive is inherited by the module's imports, so one client leaf placed high in the tree drags its whole subtree into the bundle. Push the directive down to the smallest interactive leaf. A page that only needs one toggle should not become a client page. Verify the consequence by inspecting the emitted bundle, not by reading the directive.

### A client component cannot import a server component

Importing a server component from a client file silently turns it into a client component. Pass the server-rendered subtree as `children` or as a prop instead, so the client component renders a slot it never had to resolve.

```tsx
// Server side composes; the client wrapper only places the slot.
<ClientTabs>
  <ServerRenderedPanel id={id} />
</ClientTabs>
```

### Props crossing the boundary must be serializable

Functions, class instances, and DOM nodes cannot cross. Passing a callback from a server component to a client component is a build-time error, not a runtime fallback. Convert to a server action reference or move the handler into the client component.

### Server-only dependencies and secrets never enter the client graph

A database client, an admin SDK, a private API key, or a server-only package imported anywhere under a client boundary is shipped or bundled for the browser. Keep the import in server modules only, and mark packages that must never be bundled accordingly. Anything that reaches the browser is public: hidden UI and client-side checks never enforce authorization. Route the trust-boundary review to `security-review`.

## Suspense Boundaries

### Place boundaries where content becomes useful independently

A boundary belongs next to the data that fills it, so a fast region can commit while a slow sibling streams in. One boundary at the route root turns every partial response into a blank page; many tiny boundaries around trivial fragments cause visual churn without improving the task.

### The fallback must occupy the final layout

A fallback that changes size when replaced causes layout shift and moves content under a user's pointer or focus. Shape the fallback as the real region would be — same dimensions, same structure — and keep headings and stable chrome outside the boundary where they do not depend on the pending data.

### Suspense handles pending, not failure

A thrown fetch or render error is not caught by `Suspense`. Pair each boundary with an error boundary, and give the error region its own message and recovery path rather than leaving the fallback spinning forever.

```tsx
<ErrorBoundary fallback={<ErrorView />}>
  <Suspense fallback={<UserSkeleton />}>
    <UserDetail id={id} />
  </Suspense>
</ErrorBoundary>
```

### Nested boundaries are independent

A boundary only catches around its own subtree, so an error inside a nested boundary does not unmount the parent's already-rendered content. Place them around coherent user tasks, and avoid a boundary whose failure discards content the user could still use.

## Error Boundaries

### What a boundary catches

A boundary catches errors thrown during render, in lifecycle methods, and in constructors of its descendants. It does not catch errors in event handlers, in asynchronous code, or in the boundary itself. Handle a failed event handler where the action is initiated, and route remote failure policy — deadlines, retries, cancellation, unknown outcomes — to `resilience`.

### Recovery is a declared state, not a refresh

Returning a retry affordance means the boundary can re-render the subtree with fresh state; without that, the fallback is a dead end. Use the provided reset function for the local retry, or change the boundary's `key` to force a fresh subtree when identity changed.

```tsx
"use client";
export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div role="alert">
      <p>Something went wrong.</p>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

### Keep the boundary, its fallback, and its recovery consistent

Say which subtree failed, what the user can still do, and whether the underlying condition is retryable. A retry that repeats a deterministic failure is a false affordance; a fallback with no recovery is an outage even when the rest of the page rendered.

## Streaming and Hydration

### The hydration invariant

The server output and the first browser render must agree on structure, identity, and initial state. Treat time, randomness, locale, viewport, browser storage, and capability checks as explicit inputs or defer their effect until after hydration — without replacing meaningful server-rendered content.

```tsx
// Stable on the server and first client render; filled in after mount.
const [mounted, setMounted] = useState(false);
useEffect(() => setMounted(true), []);
return <time>{mounted ? formatLocal(iso) : iso}</time>;
```

### The four real causes of a mismatch

Time and locale formatting; `Math.random()`, generated ids, and keys derived from them; browser branches such as `typeof window`, `localStorage`, or user agent; and invalid nesting that the browser repairs differently from React — a `div` inside `p`, a nested `a`, or a table row outside its table. Name the cause before changing the code.

### Suppressing the warning is not a fix

The mismatch boundary is treated as an error in development for a reason: an unreconciled tree loses event handlers and state, and can flash the wrong content. Fix the input, or move the environment-dependent value behind a stable placeholder. Never quiet the warning globally to make the console readable.

## Verification

- Assert the boundary: a bundle or module-graph observation showing the server-only dependency and its transitive imports never reached a client entry.
- Assert serializable crossings at build time; a callback prop from server to client must fail rather than pass unnoticed in review.
- Render each boundary independently and assert the fallback is replaced by the final layout without measurable layout shift.
- Assert both reachable outcomes: the pending fallback appears, and the same region reaches its error state with a working reset.
- Drive hydration with locale, time, storage, and capability variation and assert no mismatch warning and no lost event handlers on first interaction.
- Confirm streaming preserves focus and announcements across boundary commits.
- Check the rest of the page still renders when one boundary fails, and that a retry after a persistent failure is reported as retryable rather than offered as a fix.
