---
name: codebase-design
description: Reference vocabulary for designing deep modules - module, interface, depth, seam, adapter, leverage, locality. Use when designing or improving a module's interface, finding deepening opportunities, deciding where a seam goes, making code more testable, or when another skill needs the deep-module vocabulary.
---

# Codebase Design

Design **deep modules**: a lot of behavior behind a small interface, placed at a clean seam, testable through that interface. The aim is leverage for callers, locality for maintainers, and testability for everyone.

This is a reference layer: it names and evaluates designs. It never starts a refactor on its own — restructuring is owned by a plan and implemented through `tdd`.

Use these terms exactly; do not substitute "component," "service," "API," or "boundary." Consistent language is the whole point.

## Glossary

**Module**: anything with an interface and an implementation. Deliberately scale-agnostic: a function, class, package, or tier-spanning slice. _Avoid_: unit, component, service.

**Interface**: everything a caller must know to use the module correctly: the type signature, but also invariants, ordering constraints, error modes, required configuration, and performance characteristics. _Avoid_: API, signature (too narrow — they refer only to the type-level surface).

**Implementation**: what is inside a module, its body of code. Distinct from **adapter**: a thing can be a small adapter with a large implementation (a Postgres repository) or a large adapter with a small implementation (an in-memory fake). Reach for "adapter" when the seam is the topic; "implementation" otherwise.

**Depth**: leverage at the interface. The amount of behavior a caller (or test) can exercise per unit of interface they have to learn. A module is **deep** when a large amount of behavior sits behind a small interface, **shallow** when the interface is nearly as complex as the implementation.

**Seam** _(Michael Feathers)_: a place where behavior can be altered without editing in that place; the *location* at which a module's interface lives. Where to put the seam is its own design decision, distinct from what goes behind it. _Avoid_: boundary (overloaded with DDD's bounded context).

**Adapter**: a concrete thing that satisfies an interface at a seam. Describes *role* (what slot it fills), not substance (what is inside).

**Leverage**: what callers get from depth. More capability per unit of interface they learn. One implementation pays back across N call sites and M tests.

**Locality**: what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place rather than spreading across callers. Fix once, fixed everywhere.

## Deep vs shallow

**Deep module** = small interface + lots of implementation:

```text
┌─────────────────────┐
│   Small Interface   │  ← few methods, simple params
├─────────────────────┤
│                     │
│  Deep Implementation│  ← complex logic hidden
│                     │
└─────────────────────┘
```

**Shallow module** = large interface + little implementation (avoid):

```text
┌─────────────────────────────────┐
│        Large Interface          │  ← many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← just passes through
└─────────────────────────────────┘
```

When designing an interface, ask:

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?

## Principles

- **Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small, mockable, swappable parts; they just are not part of the interface. A module can have **internal seams** (private to its implementation, used by its own tests) as well as the **external seam** at its interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam. If a test has to reach *past* the interface, the module is probably the wrong shape.
- **One adapter means a hypothetical seam; two adapters means a real one.** Do not introduce a seam unless something actually varies across it.

## Designing for testability

Good interfaces make testing natural:

1. **Accept dependencies, don't create them.**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Return results, don't produce side effects.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Small surface area.** Fewer methods = fewer tests needed; fewer params = simpler test setup.

## Relationships

- A **module** has exactly one **interface** (the surface it presents to callers and tests).
- **Depth** is a property of a **module**, measured against its **interface**.
- A **seam** is where a **module**'s **interface** lives.
- An **adapter** sits at a **seam** and satisfies the **interface**.
- **Depth** produces **leverage** for callers and **locality** for maintainers.

## Rejected framings

- **Depth as a ratio of implementation-lines to interface-lines** (Ousterhout): rewards padding the implementation. Depth is used here as leverage at the interface instead.
- **"Interface" as a type-level keyword or a class's public methods**: too narrow; interface here includes every fact a caller must know.
- **"Boundary"**: overloaded with DDD's bounded context. Say **seam** or **interface**.

## Going deeper

- Deepening a cluster given its dependencies — dependency categories, seam discipline, replace-don't-layer testing: [Deepening](references/deepening.md).
- Exploring alternative interfaces for a chosen candidate — a parallel-design comparison pattern: [Design It Twice](references/design-it-twice.md).
