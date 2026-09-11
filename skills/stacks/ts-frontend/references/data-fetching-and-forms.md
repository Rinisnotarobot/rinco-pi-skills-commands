# Data Fetching and Forms

Use this reference when the work is expressed in React data mechanics: where an await lives, a waterfall that serializes requests, a Suspense boundary waiting on a promise, an action with pending and optimistic state, or a form whose submit can be triggered twice. It owns React form only. The freshness and invalidation policy for server state — key identity, staleness, refetch triggers, conflict with cached values — belongs to `frontend-patterns` in its `state-data-and-effects.md`. Deadlines, retries, cancellation, and unknown mutation outcomes belong to `resilience`. This file maps those settled policies into fetch, action, and form shapes.

## Where the Fetch Lives

### Fetch where the data is rendered, in the server when possible

A server component awaits the data it needs, so the first response already contains the content and no client cache or loading state is required. Reach for a client-side fetch when the data arrives or changes after interaction, is scoped to a browser capability, or the project already fetches that resource in the client.

```tsx
// Server: both await before anything renders; no client cache involved.
const [product, reviews] = await Promise.all([
  getProduct(id),
  getReviews(id),
]);
return <ProductView product={product} reviews={reviews} />;
```

### Fetch in a component through the project's query primitive

When the value must live in the client, use the query or cache primitive the project already has rather than a hand-built effect. That primitive supplies key identity, deduplication, retry, and invalidation; a bespoke effect reimplements all four, usually incompletely.

### Never fetch application data in an effect

An effect-based fetch races the next render, has no cache, no deduplication, no cancellation, and no Suspense integration. When the requirement is genuinely "run this after render and update local state" — a browser API read, a measurement — the effect is correct; when it is "load this resource", it is the wrong tool.

### Collapse waterfalls by hoisting and parallelizing

A waterfall forms when each await depends on the previous fetch's result. Independent requests must start together, and a child's data requirement should be hoisted into the parent's parallel fetch when the parent is already awaiting.

```tsx
// Waterfall: the second request waits for the first.
const product = await getProduct(id);
const reviews = await getReviews(product.id);

// Parallel: both start on the same tick.
const product = await getProduct(id);
const reviews = await getReviews(id);
const [a, b] = await Promise.all([getProduct(id), getReviews(id)]);
```

### State the boundary of each request

Say whether a request is per-navigation, per-interaction, or per-session, and whether its result is cacheable across users. Personalized or authorized data must not enter a shared cache; that boundary is a trust decision, so route it to `security-review` when it crosses.

## Cache and Invalidation in React Form

### The server fetch form

Server-side caching is expressed by the framework's fetch or route configuration: the revalidation window, tags, and the call site that invalidates. The policy — how stale the value may be and who invalidates it — comes from `frontend-patterns`; this file only records where that setting is written.

### The query form

For a client query cache, the key is the identity of the request and the invalidation call is the mutation's completion, not a timer. Keep the key derivable from the same inputs the request used, and invalidate the narrowest key that covers the change rather than clearing the cache after every write.

### Do not hand-roll a cache while a primitive exists

An effect that stores results in `useState` keyed by an ad hoc string duplicates the cache without invariance, eviction, or invalidation. If the project's primitive cannot express the requirement, that is a decision for `frontend-patterns`, not a reason for a second caching mechanism.

## `use` and Suspense

`use` reads a promise or context inside render and suspends the component until it settles. It requires a supported promise identity — a promise created once and passed down, or the framework's cache — and a `Suspense` boundary above it.

```tsx
function Reviews({ reviewsPromise }: { reviewsPromise: Promise<Review[]> }) {
  const reviews = use(reviewsPromise);
  return <ReviewList reviews={reviews} />;
}
```

- Creating the promise inline in render and consuming it with `use` re-suspends on every render; create it in the parent, in a cache, or in the server component that passes it down.
- Suspense handles only the pending state. Rejections and errors still need an error boundary.
- A component that suspends must not also own interactive state that would be discarded on retry; keep the boundary around the smallest subtree that can be re-rendered.

## Actions and Pending State

### A form action is a function, not a handler call

`<form action={fn}>` receives a `FormData` and participates in the framework's pending lifecycle. It also keeps the form usable before hydration and after a client-side handler would have failed to attach, which is why it is preferred over `onSubmit` for submissions with server effects.

### `useActionState` owns the action's result and pending flag

```tsx
const [state, formAction, pending] = useActionState(updateUser, initial);
return (
  <form action={formAction}>
    <input name="name" required />
    <button type="submit" disabled={pending}>Save</button>
    {state.error && <p role="alert">{state.error}</p>}
  </form>
);
```

The reducer receives the previous state and the submitted `FormData`, so validation errors and success values travel back to the same component without a separate state store.

### Optimistic state must be reachable and recoverable

`useOptimistic` shows a provisional value while the action is in flight and discards it when the action settles or the component re-renders. It is only safe when operation identity, duplicate safety, reconciliation, and user correction are defined; a provisional row the user cannot distinguish, or one that reappears after rejection, is worse than a pending state.

```tsx
const [optimistic, addOptimistic] = useOptimistic(
  messages,
  (state, draft: Message) => [...state, draft],
);

async function send(formData: FormData) {
  addOptimistic({ id: "pending", text: String(formData.get("text")) });
  await saveMessage(formData);
}
```

### Pending and error states must both be reachable

A pending flag that never disables the control allows a second submit; an error the user cannot see leaves the form looking successful. Render pending on the control that was used, keep the entered values in place on failure, and connect the error to a visible, announced element.

## Forms

### Controlled versus uncontrolled

Use uncontrolled inputs with `action` when the browser owns the value and only the final submission matters: fewer renders, less code, and progressive enhancement come free. Use controlled inputs when the value drives other UI, formats as it is typed, or feeds a validation that must run on every keystroke. Both at once — a `defaultValue` input that a state also writes — creates two authorities and loses keystrokes.

### Submission identity and duplicate safety

Client-side deduplication — disabling the button while pending — improves the experience but cannot prevent a retried connection, a double tap before the flag commits, or a replayed request. Duplicate safety needs a stable operation identity the server can reject or replay, decided with `resilience`; the React side supplies the identity per submission and does not invent retry behavior.

### Put validation in the layer that can enforce it

Browser constraints and affordances first, client feedback for speed second, and authoritative validation where the data is trusted. Client validation never establishes server trust, and hidden UI never enforces authorization. Distinguish validation, authorization, conflict, network, and unknown outcomes rather than collapsing all failures into one message.

### Keep the draft when a submission fails

Recoverable failure must not clear the form. Preserve the user's input, state what failed, and offer a retry for retryable conditions only — a deterministic validation failure should point at the field, not at a retry button.

## Verification

- Count requests and their start times on a mocked network boundary; assert independent requests start on the same tick and no request depends on a render-time fetch.
- Assert the server/client split of each request: a personalized response never enters a shared cache, and no fetch runs in an effect where the primitive is available.
- Exercise the pending state and assert the submit control is disabled and exactly one request is issued for a rapid double submit.
- Exercise optimistic presentation end to end: the provisional value appears, reconciles to the authoritative value, and its failure path removes or corrects it.
- Assert both outcomes are reachable: the pending state renders, and the error state renders with the user's input preserved.
- Drive the form with and without client script, and assert the same accepted outcome for the same input.
- Assert validation layering by submitting values that pass the client checks and confirming the server rejects them without exposing server detail.
