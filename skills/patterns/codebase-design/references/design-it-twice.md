# Design It Twice

A pattern for exploring alternative interfaces for a chosen deepening candidate, based on "Design It Twice" (Ousterhout): your first idea is unlikely to be the best. Produces a comparison and a recommendation — never an autonomous refactor; implementation stays downstream of a plan and `tdd`.

Uses the vocabulary in [SKILL.md](../SKILL.md): **module**, **interface**, **seam**, **adapter**, **leverage**.
## Process

### 1. Frame the problem space

Before designing alternatives, write a user-facing explanation of the problem space for the chosen candidate:

- the constraints any new interface would need to satisfy;
- the dependencies it would rely on, and their categories (see [Deepening](deepening.md));
- a rough illustrative code sketch that makes the constraints concrete — not a proposal, just a way to ground them.

Show this to the user, then proceed to step 2 immediately; the user reads and thinks while the alternatives are designed.

### 2. Design the alternatives

If the session can dispatch parallel subagents, spawn 3+ with one technical brief each (file paths, coupling details, dependency category, what sits behind the seam). Give each a different design constraint:

- Agent 1: "Minimize the interface: 1–3 entry points at most. Maximize leverage per entry point."
- Agent 2: "Maximize flexibility: support many use cases and extension."
- Agent 3: "Optimize for the most common caller: make the default case trivial."
- Agent 4 (when applicable): "Design around ports & adapters for cross-seam dependencies."

If the session cannot dispatch subagents, design the alternatives yourself sequentially, one constraint per pass, keeping the passes independent.

Parallel designers are read-only: they produce designs, not changes. Include the SKILL.md vocabulary and the project's CONTEXT.md vocabulary in each brief so every alternative names things consistently with the architecture language and the domain language.

Each alternative records:

1. the interface (types, methods, params, plus invariants, ordering, error modes);
2. a usage example showing how callers use it;
3. what the implementation hides behind the seam;
4. the dependency strategy and adapters (see [Deepening](deepening.md));
5. the trade-offs: where leverage is high, where it is thin.

### 3. Present and compare

Present the alternatives sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu. A recommendation is not a decision: the user chooses, and a plan or ADR records what was chosen.
