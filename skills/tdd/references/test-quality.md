# Test Quality

Use this reference to choose what to test, where to observe it, and whether a test can detect meaningful regressions.

## Behavior and seam

A **behavior** is an outcome visible to a caller, user, peer system, or operator. A **seam** is the stable boundary through which the behavior is exercised and observed.

Good seams include:

- a public function or module API;
- an HTTP/RPC endpoint;
- a command or event handler;
- a rendered component's accessible interface;
- a durable message or persisted state when that output is the contract.

The narrowest seam is not always the smallest function. Choose the least expensive stable boundary that proves the risk. Testing a private helper often duplicates implementation structure; testing every case end-to-end often makes feedback slow and diagnosis vague.

## Independent oracle

A test needs an expected result independent of the implementation. Sources include:

- an acceptance criterion or protocol specification;
- a worked example calculated separately;
- a known fixture or historical regression case;
- an invariant or property;
- a trusted reference implementation when explicitly justified.

A tautological test computes its expected value using the same algorithm or constant as production and therefore cannot disagree with it.

## Assertions

One test should describe one logical behavior. It may need several physical assertions to establish that outcome—for example status, body, and emitted effect. Split a test when failures would represent independent behaviors or require unrelated setup.

Assert semantically meaningful outputs. Avoid assertions on private fields, incidental call order, generated formatting, or broad snapshots unless those details are part of the contract.

## Test level selection

| Level | Choose when | Main risk |
|---|---|---|
| Pure/unit | rules can be exercised without infrastructure | coupling to internal decomposition |
| Component/module | several real collaborators form one stable capability | test setup may imitate production wiring poorly |
| Integration | database, filesystem, broker, framework, or serialization behavior matters | slower setup and environmental flakiness |
| Contract | independently deployed parties must agree on protocol | provider and consumer assumptions can drift |
| End-to-end | only the deployed path proves a critical journey | slow, expensive, and hard to diagnose |

Use the fewest levels needed to cover distinct risks. Do not repeat the same assertion at every level without a reason.

## Vertical slicing

A vertical slice adds one observable behavior through the minimum real path needed to learn from it:

```text
choose behavior → write one failing test → implement → refactor → choose next behavior
```

Avoid writing a full suite against an imagined interface before any implementation feedback. An upfront acceptance example is valid when it defines the target, but use small cycles to reach it.

## Properties of durable tests

- **Sensitive:** fails when the protected behavior breaks.
- **Specific:** failure identifies the broken behavior.
- **Stable:** survives internal refactoring and irrelevant output changes.
- **Deterministic:** same controlled inputs and state produce the same result.
- **Isolated:** order and parallel execution do not change the outcome.
- **Readable:** setup, action, and expected outcome reveal intent.
- **Economical:** confidence gained justifies runtime and maintenance cost.

## Common failure modes

### Implementation-coupled

The test mocks internal collaborators, calls private methods, or verifies incidental interactions. Move observation to a stable public seam.

### Tautological

The expected value mirrors the production calculation. Replace it with a literal example, property, or independent oracle.

### Vacuous

The test executes code but makes no meaningful assertion, accepts any non-error result, or uses a snapshot nobody reviews. State the behavior it can falsify.

### Over-broad

One failure can come from many unrelated systems. Move most cases to a narrower seam and retain only critical deployed-path coverage.

### False isolation

A mock reproduces the same wrong assumption as the caller. Add a contract or integration test against the real boundary.

### Flaky timing

Fixed sleeps and uncontrolled scheduling make outcomes probabilistic. Observe a condition with a deadline, inject time, or expose deterministic synchronization.

## Review questions

- What production defect would make this test fail?
- Could a harmless refactor make it fail?
- Is the expected value independent?
- Is this the cheapest stable seam that proves the behavior?
- Does setup conceal the condition being tested?
- Can tests run alone, reordered, and concurrently where supported?
