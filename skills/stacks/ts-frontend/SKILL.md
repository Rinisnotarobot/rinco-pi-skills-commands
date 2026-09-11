---
name: ts-frontend
description: React and TypeScript frontend conventions - hooks discipline, component composition, server/client component boundaries, Suspense and error boundaries, data fetching and form actions, memoization and bundling, and component testing with React Testing Library. Use when working in a React or TypeScript frontend: writing or reviewing components, hooks, pages, or TSX, wiring data fetching or forms, tuning render cost, configuring tsconfig or module resolution, or when a React change must reconcile with the project's selected frontend architecture. 中文触发：React、前端组件、hooks、TSX、组件测试
---

# TS Frontend

Express frontend architecture decisions in React and TypeScript forms on top of `frontend-patterns`, and adopt whatever this repository already does. This skill owns the framework binding: hooks, JSX, server/client boundaries, React APIs, and component tests. It does not own state ownership, rendering strategy, or accessibility decisions.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- React version and whether the project uses the App Router, Pages Router, a Vite SPA, or another shell; whether Server Components are in play;
- TypeScript posture: `strict`, `noUncheckedIndexedAccess`, path aliases, `moduleResolution`, and whether generated route or schema types exist;
- package manager and lockfile, bundler, and the declared scripts — as declared, not as commonly used;
- state and data stack already in use: local state, context, external store, TanStack Query, SWR, form library, validation library;
- styling and design system, and whether components come from a shared package;
- test stack: runner, `jsdom` or browser mode, React Testing Library, MSW, axe, and any existing render helpers or provider wrappers in `conftest`-equivalent setup files;
- the existing component conventions: file naming, colocation, barrel exports, prop naming, and how loading and error states are rendered today.

Completion criterion: every claim about "how this project does it" cites a file; anything unverified is marked as an assumption.

### 2. Define the problem and the invariant

Describe the pressure without naming a library: a value recomputed on every keystroke, a stale response overwriting a newer one, a component losing keyboard focus after an update, a client component pulling a server-only dependency into the bundle, a form that double-submits. State the invariant in user-visible or system terms — what must remain true after the change.

Completion criterion: the affected journey, ownership seam, and observable correctness condition are explicit.

### 3. Select the branch

Read only the references the active branch needs:

| Problem branch | Reference or owner |
|---|---|
| Hook rules, custom hook shape, dependency arrays, effects and cleanup, composition patterns, memo discipline | [references/components-and-hooks.md](references/components-and-hooks.md) |
| Server/client component split, Suspense, error boundaries, streaming, hydration correctness, route-level loading | [references/rendering-and-server-boundaries.md](references/rendering-and-server-boundaries.md) |
| Fetching and caching decisions expressed in React, request waterfalls, React 19 actions, optimistic and pending states, controlled forms | [references/data-fetching-and-forms.md](references/data-fetching-and-forms.md) |
| Render cost, memoization, list virtualization, code splitting, bundle and asset budget | [references/performance-and-bundling.md](references/performance-and-bundling.md) |
| Component, hook, and page tests: queries, user interaction, network mocking, provider setup, accessibility assertions, the boundary with end-to-end runs | [references/testing-react-components.md](references/testing-react-components.md) |
| State ownership, server-state freshness, rendering strategy, component interfaces, accessibility requirements, browser performance targets, client privacy | Invoke `frontend-patterns` and read only the references its problem branch selects; this skill supplies the React form of that decision |
| Module depth, seams, interface leverage | Consume `codebase-design` vocabulary |
| Remote-dependency or durable-work deadlines, cancellation, retries, unknown mutation outcomes, partial-failure recovery | Invoke `resilience`; browser-local effect cleanup and stale-result suppression stay in [references/components-and-hooks.md](references/components-and-hooks.md) |
| Test-first slices, test seam choice, coverage policy, mocking scope | Invoke `tdd`; this skill owns only React and TypeScript test mechanics |
| Gate execution, fresh evidence, `READY`/`NOT READY`/`BLOCKED` | Invoke `verification`; do not restate gate commands as policy |
| Trust boundary: new endpoint, auth flow, input surface, secret or token handling, third-party script | Invoke `security-review` |
| Naming, readability, duplication, control flow, comments | Invoke `coding-standards` |

Completion criterion: the branch is chosen from the problem, not from a preferred library or a remembered blog post.

### 4. Adapt to this repository

Prefer the pattern already present: search for an existing component, hook, or fetch of the same shape and follow it. Match the project's state library, styling approach, error and loading UI, prop conventions, and test setup. Introducing a second way to fetch, cache, or hold form state is a regression even when the new way is better in isolation.

Completion criterion: the change is indistinguishable in style from its neighbours, and no second convention for fetching, caching, or errors was introduced.

### 5. Version-sensitive APIs: repository evidence only

React 18, React 19, the App Router, and the surrounding libraries differ in ways that are not remembered reliably.

- Read the pinned versions from `package.json` and the lockfile before depending on version-specific behavior; a hook that exists in one major does not exist in the other.
- Search the repository for an existing call site and copy its shape.
- When the exact signature, default, or server/client constraint decides correctness, mark it unverified and confirm against the installed version rather than writing from recall.
- External documentation lookup is intentionally out of scope here; when it is enabled, this section points at the global `context7-docs` skill.

Completion criterion: no version-dependent claim in the change rests on memory alone.

### 6. Define verification evidence

Name the check for each invariant: the component or hook test that would fail, the accessibility assertion, the measured render or bundle observation, or the request-level assertion on a mocked network boundary. Hand sequencing to `plan` and gate execution to `verification`. This skill identifies design gaps; it does not issue `READY`, `NOT READY`, or `BLOCKED`.

## Component Rules

- Follow the rules of hooks exactly: no conditional hooks, no hooks in loops, and effects only for synchronizing with something outside React.
- Derive values during render instead of mirroring them into state; a copied prop in state is a bug with a delay.
- Give every effect a cleanup that reverses it, and every subscription a stable key.
- Keep components focused: extract a custom hook for reused logic, not for reused markup alone.
- Lift state only to the narrowest common owner; put navigable state in the URL when its representation permits it.
- Treat server components as the default and client components as an explicit, justified boundary — the boundary is where bundle cost and secrets cross.
- Render every reachable state: pending, empty, stale, error, unauthorized, and recovery. A spinner is not a policy.
- Use optimistic presentation only when operation identity, duplicate safety, reconciliation, and user correction are defined.
- Verify claims about render cost with a measurement; memoization, virtualization, and code splitting are costs as well as tools.
- Consume `frontend-patterns` and `resilience` decisions rather than inventing retries, freshness rules, or accessibility requirements inside components.

## Output Contract

Scale depth to scope: a local component change needs the invariant, the React form, and its check. Use the full structure for server/client boundary, data or cache, form, accessibility-critical, or performance work.

```text
Detected stack and evidence
Problem and invariant
Component, hook, and boundary shape
Data, cache, and form ownership
Reachable states and failure behavior
Performance and accessibility impact
Verification evidence
Unverified API assumptions and open risks
```

The change is not complete until the invariant, the server/client boundary, the reachable states, the accessibility path, and the check are stated.
