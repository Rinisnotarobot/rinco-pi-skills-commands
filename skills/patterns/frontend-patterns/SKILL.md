---
name: frontend-patterns
description: Language- and framework-neutral frontend architecture patterns. Use when designing or reviewing component interfaces, route boundaries, UI state ownership, server-data synchronization, rendering strategy, interaction and accessibility, browser performance, or client privacy and observability; choose patterns from explicit user, platform, and operational constraints, route specialized work to its owner, then map decisions to the project's existing stack.
---

# Frontend Patterns

Choose frontend patterns from user-visible invariants and platform constraints. Preserve the project's framework, design system, browser policy, and established architecture unless evidence justifies a change.

## Workflow

### 1. Establish the context

Inspect the repository and state:

- target journeys, interaction model, content hierarchy, and accepted behavior from a spec or other authoritative source;
- runtime and rendering model: browser-only, request-rendered, prerendered, streamed, hybrid, embedded, or native shell;
- component interfaces and seams; route, deployment, trust, and server/client boundaries; state and data ownership;
- data authority, mutation paths, cache ownership, network conditions, and offline expectations;
- supported browsers, devices, input modalities, locales, assistive technologies, and progressive-enhancement requirements;
- measured performance, bundle and asset constraints, privacy obligations, telemetry, and operational capabilities;
- existing framework, router, design-system, styling, testing, and delivery conventions.

Read canonical project vocabulary and accepted UX requirements when present. If desired behavior is unresolved, route it to `spec`; if one visual or state-model question needs throwaway evidence, invoke `prototype` rather than designing production architecture around a guess.

Completion criterion: every relevant constraint is supported by repository or authoritative product evidence, or explicitly marked as an assumption.

### 2. Define the problem and invariant

Describe the recurring pressure without naming a solution. State the user-visible or system invariant any acceptable design must preserve.

Examples:

- A slower search response can replace a newer result. Invariant: only the latest accepted query may update the visible result.
- A filter must survive reload and sharing. Invariant: the URL reconstructs the same navigable state.
- A dialog works with a pointer but loses keyboard focus. Invariant: every supported input modality can complete the action and focus returns predictably.
- Optimistic state diverges after rejection. Invariant: confirmed server state eventually becomes authoritative without duplicating the effect.
- Server and browser renders disagree. Invariant: the first client render preserves the server-rendered semantics and identity.

Completion criterion: the affected user journey, ownership seam, and observable correctness condition are explicit.

### 3. Select the relevant pattern family

Read only the references needed for the active branch:

| Problem branch | Reference or owner |
|---|---|
| Component, feature, design-system, or adapter interfaces and seams | [references/composition-and-interfaces.md](references/composition-and-interfaces.md); consume `codebase-design` vocabulary for module depth and seams |
| Local, shared, URL, workflow, form, server, optimistic, or synchronized state | [references/state-data-and-effects.md](references/state-data-and-effects.md) |
| Route and navigation architecture, client/request rendering, prerendering, streaming, hydration, assets, or browser delivery | [references/rendering-and-delivery.md](references/rendering-and-delivery.md) |
| Forms, keyboard, focus, announcements, motion, responsive interaction, or localization | [references/interaction-and-accessibility.md](references/interaction-and-accessibility.md) |
| Rendering, loading, responsiveness, memory, bundle, or asset performance | [references/performance.md](references/performance.md) |
| Client trust, sensitive data, third parties, analytics, or diagnostic signals | [references/security-privacy-and-observability.md](references/security-privacy-and-observability.md); invoke `security-review` for a deep review of changed trust boundaries |
| Remote-dependency or durable-work deadlines, cancellation, retries, overload, unknown mutation outcomes, or partial-failure recovery | Invoke `resilience`; browser-local effect cleanup and stale-result suppression remain in [state-data-and-effects.md](references/state-data-and-effects.md), while this Skill owns user-visible presentation |
| React-specific hooks, JSX, Suspense, RSC, or framework APIs | Invoke `ts-frontend`; it expresses the selected frontend architecture in React and TypeScript forms |

Completion criterion: candidates come from the problem branch rather than from framework habit or a preferred library.

### 4. Compare the smallest viable options

For each candidate, record:

1. **Context** — conditions in which it applies.
2. **Forces** — usability, correctness, accessibility, latency, complexity, privacy, and delivery trade-offs.
3. **Solution shape** — ownership and relationships without framework syntax.
4. **Invariant** — what users and systems can observe as true.
5. **Consequences** — shipped code, render work, coupling, state synchronization, and operating cost.
6. **Failure modes** — stale state, lost intent, hydration mismatch, inaccessible interaction, sensitive-data exposure, or degraded-network behavior.
7. **Verification** — behavior, accessibility, browser, performance, privacy, and failure evidence.

Include the current design and a direct local implementation. Prefer the least complex option that satisfies the invariant.

### 5. Map the pattern to the codebase

Use the project's native routes, modules, components, browser APIs, framework primitives, design tokens, data clients, telemetry, and test infrastructure. Name:

- the authoritative owner of each mutable state and server-derived value;
- the component, route, cache, URL, or server enforcement point for each invariant;
- pending, empty, stale, success, error, unauthorized, and recovery states that are actually reachable;
- serializable and trust-boundary crossings;
- compatibility and delivery effects for existing users, sessions, cached assets, and deployed versions.

Hand file-level sequencing, rollout, and executable gates to `plan`; production implementation belongs to `tdd`. Framework syntax is an implementation map, not the pattern itself.

Completion criterion: the proposal names concrete integration points and ownership without pretending a component type, hook, store, or library is the architecture.

### 6. Define verification evidence

Read the **Verification** section of every selected branch reference. For each invariant and reachable user-visible state, record the starting condition, action or event, expected observation, prohibited side effect where material, representative environment, and evidence method.

Pass these requirements to `plan` for an executable contract before implementation or to `verification` when reviewing an existing change. Route changed trust boundaries to `security-review` and remote or durable failure scenarios to `resilience`. This Skill may identify design gaps; it does not execute gates or issue the implementation's `READY`, `NOT READY`, or `BLOCKED` verdict.

## Pattern Selection Rules

- Treat components, hooks, stores, routes, and design systems as ownership mechanisms, not maturity levels.
- Keep state at the narrowest authoritative owner. Derive values instead of synchronizing duplicate state.
- Put navigable, shareable state in the URL when its representation and privacy permit it; keep ephemeral interaction state local.
- Treat server-state caches and offline replicas as replicated views with freshness, conflict, invalidation, and recovery policies.
- Make asynchronous states explicit. A spinner is not a policy for stale data, empty results, unknown mutation outcomes, or recovery.
- Use optimistic presentation only when operation identity, duplicate safety, reconciliation, rejection, and user correction are defined.
- Prefer native platform semantics and progressive enhancement before recreating controls or navigation in script.
- Treat the browser as an untrusted, interruptible, resource-constrained client. Client validation and hidden UI do not enforce authorization.
- Select rendering and performance controls from measured journeys and supported environments; memoization, virtualization, hydration, and code splitting are costs as well as tools.
- Keep remote failure policy singular: consume `resilience` budgets and classifications rather than inventing retries inside components or data hooks.

## Output Contract

Scale depth to scope: combine headings for a small local decision; use the full structure for cross-route, persistent-state, accessibility-critical, privacy-sensitive, or delivery-risk work. Mark a section not applicable rather than manufacturing concerns.

```text
Context and constraints
User journey, problem, and invariant
Current design and ownership
Candidate options and trade-offs
Selected pattern and why
Rejected alternatives and why
Codebase and framework mapping
User-visible states and degradation
Accessibility, privacy, and delivery impact
Failure modes
Evidence requirements
Assumptions and open risks
```

The pattern is not complete until ownership, applicability boundary, user-visible failure behavior, cost, and verification method are stated.
