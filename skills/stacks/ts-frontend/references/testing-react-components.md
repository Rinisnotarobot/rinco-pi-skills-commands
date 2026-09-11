# Testing React Components

Use this reference when writing, fixing, or reviewing tests for React components, hooks, or pages. Test flow, test seam selection, coverage policy, and mock scope belong to `tdd`; gate execution and the final verdict belong to `verification`; accessibility requirements belong to `frontend-patterns`. This reference owns only the React and TypeScript mechanics: queries, user interaction, network mocking, provider setup, and the boundary with end-to-end runs.

## Detect the project's test setup

Read the repository before writing the first test. Adopt what exists; introducing a second render path or a second mocking style is a regression even when the new one is cleaner in isolation.

Inspect, in this order:

1. The runner and its pinned version, and the declared test scripts as declared, not as commonly used.
2. Whether tests run in `jsdom` or in a real browser mode, and which configuration decides that.
3. The Testing Library version and whether it is React Testing Library, a wrapper package, or a framework-specific helper.
4. Whether MSW is installed, where its handlers live, and whether unhandled requests already fail.
5. Existing render helpers, setup files, provider wrappers, and their exports.
6. The existing query and assertion style: role-based names, label text, testing-library matchers in use, custom matchers registered.

Completion criterion: every claim about "how this project tests" cites a file, and the new test imports the project's helper rather than building its own wrapper. Anything unverified is marked as an assumption.

## Query in the order users perceive

| Tier | Queries | Use for |
|---|---|---|
| Accessible to everyone | `getByRole`, `getByLabelText`, `getByPlaceholderText`, `getByText`, `getByDisplayValue` | default for every interactive element and visible text |
| Semantic, narrower | `getByAltText`, `getByTitle` | images and elements whose accessible name is genuinely the only handle |
| Escape hatch | `getByTestId` | no accessible name exists yet; treat it as a finding to fix, not a habit |

```tsx
screen.getByRole("button", { name: /save/i }); // preferred
screen.getByLabelText("Email");                // inputs
screen.getByTestId("save-btn");                // last resort
```

Pick the variant by intent: `getBy*` for required presence, `queryBy*` to assert absence, `findBy*` for elements that appear after asynchronous work. A test that queries by role breaks when the accessible name changes for users too, which is the failure you want.

## Await the right thing

```tsx
expect(await screen.findByText("Loaded")).toBeInTheDocument();
await waitFor(() => expect(onSave).toHaveBeenCalled());
await waitForElementToBeRemoved(() => screen.queryByText("Loading"));
```

- `findBy*` for an element that appears after asynchronous work; `waitFor` for an observable side effect rather than a rendered node; `waitForElementToBeRemoved` for disappearance.
- Assert absence with `queryBy*`; a failed `getBy*` throws and reports a presence assertion as its cause.
- Never sleep on a timer or assert after a fixed delay. A fixed delay is a race that passes on the author's machine.
- `await` every `userEvent` call, and call `userEvent.setup()` once per test. `userEvent` reproduces a browser interaction sequence; `fireEvent` dispatches one synthetic event and should not be the default.
- Do not wrap calls in `act` manually where the Testing Library helper already awaits them; an `act` warning signals a real update-ordering bug, not noise to silence.

## Mock at the network boundary

MSW intercepts at the network layer, so the component, its hooks, and its fetch library run the same code as in production. Prefer it over module-level mocks of the data layer.

```ts
export const handlers = [
  http.get("/api/users/:id", ({ params }) =>
    HttpResponse.json({ id: params.id, name: "Alice" })),
];

export const server = setupServer(...handlers);
beforeAll(() => server.listen({ onUnhandledRequest: "error" }));
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

- Set unhandled requests to fail. A silently unmocked request turns a real integration gap into a passing test.
- Override per test with `server.use(...)` and let the reset between tests restore the shared handlers.
- Handlers describe the shape the real endpoint returns; fixtures state their source and omit secrets and personal data.
- Model the failure outcomes the boundary can produce — status, timeout, malformed body, duplicate — rather than one universal error.
- Which boundary to replace and when a real dependency is required is a mock-scope decision owned by `tdd`; this section covers only the HTTP mechanics in a component test.

## Wrap providers once

Ship one render helper, re-exported alongside the Testing Library so test files have a single import.

```tsx
export function renderWithProviders(ui: ReactElement, options?: RenderOptions) {
  const queryClient = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={queryClient}>
      <MemoryRouter>{ui}</MemoryRouter>
    </QueryClientProvider>,
    options,
  );
}
export * from "@testing-library/react";
```

- The wrapper must mirror the providers the component has in production; a missing provider produces a test that proves nothing about the real tree.
- Create per-test state such as a cache or store client inside the helper, and disable retries so a failing path fails at the first attempt.
- Extend the existing helper when a new provider appears; do not add a second helper or inline the providers in one test file.

## Test hooks through their public API

```tsx
const { result, rerender } = renderHook(() => useUser("1"), { wrapper });
await waitFor(() => expect(result.current.isSuccess).toBe(true));
rerender();
expect(result.current.data).toEqual({ id: "1", name: "Alice" });
```

- Pass a `wrapper` when the hook consumes context, and build any cache or store client outside the wrapper closure so it survives re-renders instead of resetting per render.
- Wrap state-changing calls in `act`.
- Assert the values and transitions the hook's caller depends on, not internal call order or which other hooks it used.
- When the hook's only observable behavior is rendered output, test the component instead.

## Assert accessibility with axe

```tsx
const { container } = renderWithProviders(<UserCard user={user} />);
expect(await axe(container)).toHaveNoViolations();
```

`axe` catches missing labels, invalid ARIA, missing alternative text, and heading-order violations in the rendered tree. It cannot judge real color contrast, actual layout, or focus order, because the test environment has no layout engine; keyboard and focus behavior is verified by driving the component with `userEvent`, and the remaining checks belong in a real browser or a manual pass. Which accessibility requirements must hold — and the accessibility reference that states them — is owned by `frontend-patterns`.

## Do not snapshot rendered output

A DOM snapshot of a component breaks on every styling change, gets approved without reading, and asserts structure users never perceive. Use snapshots only where the value is data, such as a pure serialization or formatting function with a stable string result, or generated configuration output. For visual regression, use screenshot comparison in a real browser through `playwright` or `cypress`, or a dedicated visual service — not a serialized DOM string.

## Know when to leave the component test

| Case | Level |
|---|---|
| A hook, a presentational component, form logic | React Testing Library |
| Behavior needing real layout, real CSS, browser APIs absent from the test environment, native scrolling, or drag and drop | component test in a real browser |
| A flow crossing several pages, with real navigation and real network | end-to-end run under `playwright` or `cypress`, driven by the repository's declared commands (see `verification`) |

Choose one lane per concern. Running both a component-test runner and browser-level component tests over the same component without a stated reason duplicates maintenance and doubles the places a refactor must be repeated.

## Anti-patterns

- `container.querySelector(...)` or direct DOM traversal instead of an accessible query.
- Asserting render counts or hook call order: implementation detail, and it fails on correct refactors.
- Mocking `react` or framework hooks; refactor the component instead.
- Mocking child components by default, which discards the integration the test was meant to cover.
- Ignoring `act` warnings, which usually indicate an update after unmount or an unwrapped async transition.
- Shared mutable state between test files or tests, which makes results depend on execution order.
- A test that still passes when its assertion is deleted, which proves the assertion was not load-bearing.
- Keeping a snapshot or broad mock that was regenerated without an explained behavior change.

## Verification

- Witness the test failing before the change and passing after it; a test never observed red is not evidence.
- Confirm the query would fail if the accessible name or label changed, which proves the assertion is anchored to what users perceive.
- Confirm an unmocked network request fails the test, and that a per-test override restores the shared handler afterwards.
- Confirm the test renders through the same provider set as production, and cite the helper and the file that supplies it.
- Confirm `axe` reports zero violations for the rendered tree, plus a keyboard-driven check for the focus behavior `axe` cannot see.
- Confirm the test still passes when unrelated markup and internal structure change, and that test execution order does not affect the result.
- Confirm the level is deliberate: a component test for component behavior, a browser-level test where layout or browser APIs decide correctness, an end-to-end run for a cross-page flow.
- Report the exact commands run and their results as declared by the repository; gate execution and the final verdict belong to `verification`.
