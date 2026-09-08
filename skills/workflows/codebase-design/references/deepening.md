# Deepening

How to assess deepening a cluster of shallow modules, given its dependencies. This is evaluation guidance for the design conversation and for a plan — it never licenses an in-session refactor: merging modules, deleting tests, and rewriting code belong to a plan's slices and are implemented through `tdd`.

Uses the vocabulary in [SKILL.md](../SKILL.md): **module**, **interface**, **seam**, **adapter**.

## Dependency categories

When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested across its seam.

### 1. In-process

Pure computation, in-memory state, no I/O. Always deepenable: the modules merge, and the deepened module is tested through the new interface directly. No adapter needed.

### 2. Local-substitutable

Dependencies that have local test stand-ins (an in-memory filesystem, an embedded database). Deepenable if the stand-in exists. The deepened module is tested with the stand-in running in the test suite. The seam is internal; no port at the module's external interface.

### 3. Remote but owned (ports & adapters)

Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter; production uses an HTTP/gRPC/queue adapter.

### 4. True external (mock)

Third-party services you do not control (payment processors, messaging providers). The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

## Seam discipline

- **One adapter means a hypothetical seam; two adapters means a real one.** Do not introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection.
- **Internal seams vs external seams.** A deep module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface. Do not expose internal seams through the interface just because tests use them.

## Testing strategy: replace, don't layer

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist; deleting them is part of the implementing slice, not this skill.
- New tests are written at the deepened module's interface. The **interface is the test surface**.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors, since they describe behavior, not implementation. If a test has to change when the implementation changes, it is testing past the interface.
