# Components and Hooks

Use this reference while editing React code: a hook called in the wrong place, an effect that fights its own inputs, a prop mirrored into state, a component whose reuse is markup rather than logic, or JSX accessibility wiring. It owns the React form only. Who owns a value and where it is lifted belongs to `frontend-patterns`, which decides it in its `state-data-and-effects.md`; accessibility requirements — what must be named, focusable, announced, or keyboard-complete — are also owned by `frontend-patterns`, in its `interaction-and-accessibility.md`. This file only says how settled decisions appear in JSX.

## Hook Rules

### Call hooks unconditionally at top level

A hook inside `if`, `&&`, `try`, a loop, or after an early return changes the call order between renders. Hooks are matched by position, so the next render reads the wrong slot: state silently belongs to another hook, or the render throws for a mismatched count. Move the condition inside the hook, or split the component so each branch has its own hook sequence.

### Effects synchronize with something outside React

An effect starts and stops an external owner: network, subscription, timer, storage, browser API, imperative widget. User actions belong in event handlers and values belong in render. Reaching for `useEffect` to react to a prop or to compute a value means the logic belongs in render or in the handler that already knows the change happened.

### Derive during render, never mirror into state

A prop, query result, or URL value copied into state creates a second authority that drifts and needs an effect to catch up.

```tsx
// Derived at render time: one authority.
const visible = items.filter((i) => i.title.includes(query));

// Mirrored into state: drift plus an extra render cycle.
const [total, setTotal] = useState(0);
useEffect(() => setTotal(sum(items)), [items]);
```

### Use a functional update when new state depends on old

`setCount(count + 1)` reads a value captured by the render; if the update is queued or replayed, that stale read loses writes. `setCount((prev) => prev + 1)` composes with anything already queued.

### Every effect reverses itself, every subscription has a stable key

The cleanup must undo exactly what setup did, and the dependency array must carry the identity of the subscribed thing. A listener without cleanup, a timer without clear, or a fetch without abort keeps running against a remounted tree.

```tsx
useEffect(() => {
  const controller = new AbortController();
  const id = setInterval(poll, 5000);
  return () => { controller.abort(); clearInterval(id); };
}, [roomId]);
```

### The dependency array describes identity, not intent

Elements are compared per element with `Object.is`, not by deep equality. A selector, options object, or inline array is a new identity every render, so the effect re-runs forever. Depend on primitives and stable references instead of silencing the warning with an empty array — a missing dependency is a stale read, not a lint nit.

### Default position: do not memoize

Add `useMemo` or `useCallback` only when a measurement or a specific dependency chain shows it matters. A memo whose inputs change on most renders pays the comparison and buys nothing.

## Choosing the React Primitive

The table maps a settled ownership decision to its React form. Ownership itself is not decided here.

| Shape of the value | React form | Do not use it for |
|---|---|---|
| Rendered output, filtered list, total | compute during render | caching work nothing measured |
| One component's interaction state | `useState` | derived values, mutually exclusive flags |
| Events with guarded transitions | `useReducer` | a single toggle |
| Value for imperative work, not output | `useRef` | anything that must re-render |
| Rarely changing value read far away | `context` | interaction-frequency updates |
| Frequent updates from outside React | `useSyncExternalStore` | one component's local state |

Context is a transport, not a store: split one context per concern, so a change in one does not re-render consumers of the other. Refs hold values that must survive renders without causing one — DOM handles, timer ids, imperative widgets — and assigning one during render is a bug. Reach for an external store only when many independently located consumers need the same frequently updated client-owned value; consume it through `useSyncExternalStore` so the snapshot stays tear-free, and keep subscription granularity narrow.

## Custom Hooks

### Extract for reused logic, not reused markup

A custom hook owns a behavior with its own state, effects, and cleanup. A hook that only returns a boolean flag, or a component that only re-wraps markup, adds a layer without removing knowledge.

```tsx
function useDebounced<T>(value: T, delay = 300): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const id = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(id);
  }, [value, delay]);
  return debounced;
}
```

### Name it for the capability it owns

`useDebounced`, `useOnlineStatus`, and `useDraftAutosave` describe behavior; `useUserState` describes a variable. A caller should predict from the name and returned shape what the hook subscribes to and when it cleans up.

### Keep the returned interface stable

Return the value, pending flag, error, and transition function the caller must act on, and hide intermediate state that leaks the implementation. An unstable returned identity forces callers to re-subscribe.

## Composition Recipes

Prefer the cheapest recipe that satisfies the need: a wrapper whose content the parent cannot inspect is cheaper than an interface the parent must keep widening.

| Recipe | Use when | Cost |
|---|---|---|
| `children` slot | the parent owns layout only | none beyond the wrapper |
| Named slots | regions sit at fixed parent positions | every region widens the parent interface |
| Compound parts | several parts share one implicit state | coupling the type system cannot express |
| Render props | the parent must pass parameters to caller-supplied rendering | nested render functions and reader indirection |

For compound components — tabs, accordion, menu, field — document the required nesting and cover violations in tests, because the shared state lives outside the type signature. A hook returning the same values as a render prop is usually clearer and composes with the rest of the component's logic; prefer it unless parameterized rendering is the point.

## Accessibility Mechanics in JSX

### Semantic element before ARIA

Render `button`, `a`, `input`, `label`, `nav`, `main`, and headings before reaching for a `role`. A native element already supplies name, role, value, focusability, and keyboard behavior; recreating them with ARIA means reimplementing all of it.

### Labels and accessible names

Every control needs a programmatic name. Use `<label htmlFor>` when a visible label exists, wrap the input for compound controls, and use `aria-label` only when no visible name is available.

```tsx
<label htmlFor="email">Email</label>
<input id="email" name="email" type="email" autoComplete="email" />

<button aria-label="Close panel" onClick={onClose}><XIcon /></button>
```

### Focus with refs, and return it

Route changes, dialog open, and content removal move focus. Read the node through a ref and move focus after the change commits; store the previously focused element and restore it on close, so keyboard users are not dropped at the document start.

### Keyboard handling on non-interactive elements

An element with `onClick` but no semantics is invisible to assistive technology and unreachable by keyboard. Prefer a real button. When a composite widget truly needs a custom container, wire the expected keys — Enter, Space, Escape, arrows — and expose `aria-expanded` or `aria-selected` so the container is reached only through its interactive children.

### Announce asynchronous results

When a result appears without moving focus, keep a polite live region in the DOM and update its text instead of remounting it. Reserve `role="alert"` for urgent error-class updates, and never re-announce the same message on every render.

## Verification

- Render each conditional branch and fail on hook-order warnings, not only on the happy path.
- Mount, unmount, and remount with a subscription or timer spy active; assert cleanup ran once with the same key, and that no stale response can write after unmount.
- Change inputs and assert the derived output changed in one pass, with no commit showing the stale value.
- Count renders around a memoization claim instead of asserting the memo exists.
- Exercise composition through its public interface: invalid compound nesting is rejected and controlled usage keeps one authority.
- Assert accessibility mechanically in component tests: each control resolves an accessible name, focus lands where expected after open and after close, and non-interactive click handlers are absent. Requirement-level accessibility evidence belongs to `frontend-patterns`.
- Assert announcements: the live region updates text and is not remounted on status change.
