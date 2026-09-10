# Composition and Interfaces

Use this reference when the problem is component responsibility, feature organization, design-system reuse, third-party isolation, or change locality. Consume `codebase-design` for the canonical module, interface, seam, depth, leverage, and locality vocabulary rather than redefining it here. Route and navigation architecture lives in [Rendering and Delivery](rendering-and-delivery.md).

## Start with ownership

A useful frontend module owns a coherent user capability or policy, with an interface that has:

- explicit inputs, outputs, events, and user-visible failure behavior;
- one authoritative owner for its mutable state;
- a semantic interface that hides framework and vendor details where they are genuinely volatile;
- accessibility behavior, responsive constraints, and performance characteristics included in its interface;
- changes that remain local when the owned capability evolves.

A file, component, hook, context, package, or route is not automatically a module or seam. Reserve boundary for actual trust, serialization, server/client, process, or deployment crossings.

## Candidate patterns

### Direct local composition

**Context:** one route or component owns a small behavior with no repeated policy or volatile integration.

**Shape:** keep markup, state, and events together at the narrowest useful owner.

**Choose when:** separation would only create pass-through props, wrappers, or files.

**Cost/failure mode:** duplication becomes harmful only when behavior or policy actually repeats. Do not extract presentation fragments solely to reduce line count.

### Feature slice

**Context:** a user capability changes across view, state, validation, and data access while horizontal folders scatter every change.

**Shape:** group capability-specific UI, state, data mapping, and tests; share only stable platform and design-system primitives.

**Invariant:** a feature change remains local without forking cross-application policy.

**Cost/failure mode:** isolated slices duplicate authentication, accessibility, analytics, or data semantics; premature shared abstractions recreate horizontal coupling.

### Headless behavior and view

**Context:** one interaction policy needs materially different visual presentations or platform adapters.

**Shape:** a behavior module owns state transitions and semantic events; views provide rendering through a narrow interface.

**Cost/failure mode:** splitting every component into “container” and “presentational” halves creates shallow indirection. Separate only when behavior is independently reusable or testable.

### Design-system primitive

**Context:** semantics, interaction, accessibility, tokens, and variants must remain consistent across independent features.

**Shape:** one governed primitive hides difficult platform behavior behind a small supported interface.

**Invariant:** consumers cannot bypass required semantics or accessibility through ordinary configuration.

**Cost/failure mode:** too many variants turn the primitive into a second styling language; too little escape capacity causes consumers to fork it. Version and deprecate the public surface deliberately.

### Controlled or owner-managed interface

A controlled interface lets a caller own value and transitions; an owner-managed interface keeps them local and reports meaningful events. Support both only when each has a real use case and their precedence is unambiguous. Avoid two simultaneous authorities.

### Platform or vendor adapter

**Context:** browser APIs, native shells, analytics, editors, maps, payment widgets, or other third-party surfaces have volatile lifecycle and error semantics.

**Shape:** isolate setup, cleanup, events, data conversion, consent, and failure behavior at one seam.

**Cost/failure mode:** a transparent wrapper that leaks vendor objects offers no isolation. An adapter that hides required capabilities forces escape hatches everywhere.

### Micro-frontend boundary

**Context:** independent teams require separate delivery and ownership, and the operational cost is justified.

**Invariant:** routing, identity, design tokens, dependencies, telemetry, accessibility, and cross-slice communication remain compatible during independent deployment.

**Costs:** duplicated runtime, version skew, navigation seams, inconsistent UX, larger failure surface, and difficult end-to-end testing. Prefer one deployable frontend unless organizational independence is an evidenced constraint.

## Selection prompts

- What user capability or invariant does the module own?
- Which mutable state has exactly one authority?
- What knowledge must callers learn beyond the type signature?
- Which changes become local, and which coordination is introduced?
- Is reuse proven by behavior and policy, or only visual similarity?
- Can native semantics or an existing design-system primitive satisfy the need?
- Can old and new consumers coexist while the interface evolves?

## Verification

- Test through the supported interface rather than component internals.
- Exercise every supported controlled/owner-managed mode and reject ambiguous mixed ownership.
- Verify semantic output, events, focus, cleanup, and error behavior across adapters.
- Check representative feature changes for locality rather than counting files or components.
- For independently deployed boundaries, test version skew, routing, identity, shared dependencies, and failure isolation.
