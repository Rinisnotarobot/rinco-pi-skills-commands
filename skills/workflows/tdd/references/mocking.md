# Test Doubles and Mocking

Use a test double to control a dependency or observe a protocol that cannot be exercised reliably and economically with the real implementation at the chosen test level.

## Vocabulary

- **Stub:** returns controlled responses.
- **Fake:** working, simplified implementation such as an in-memory store.
- **Spy:** records calls for later observation.
- **Mock:** verifies expected interactions.

Use the least behavior-rich double that satisfies the test.

## Boundary rule

Prefer real code inside the capability under test. Introduce doubles at volatile system boundaries such as:

- third-party services;
- network peers;
- clocks, randomness, and identity generation;
- expensive or unavailable infrastructure;
- failure conditions that the real dependency cannot safely reproduce.

A database is not automatically mocked. Use a real test database when SQL, constraints, transactions, mapping, or concurrency are part of the behavior. Use a fake only when the storage contract is simple and separately verified.

## Interaction tests

Assert interactions only when the interaction itself is the contract, such as:

- publishing one durable command;
- passing an idempotency key;
- committing before acknowledging;
- not calling a payment provider after authorization fails.

Call counts and ordering are brittle when they merely describe the current implementation. Prefer asserting the resulting observable state or response.

## Design testable boundaries

Inject narrow capability-shaped dependencies rather than a generic transport:

```text
ChargePayment(order, key) -> receipt
SendReceipt(customer, receipt) -> outcome
Clock.now() -> instant
```

This keeps setup declarative and prevents test logic from branching on URLs, SQL strings, or unrelated methods.

Do not create an interface solely because mocking syntax demands one. A function, object, protocol, trait, or framework-provided test adapter can represent the boundary according to project conventions.

## Contract protection

A double can drift from reality. Protect important boundaries with at least one of:

- provider/consumer contract tests;
- schema validation against captured representative fixtures;
- integration tests with a local or sandbox dependency;
- generated clients from an authoritative contract;
- periodic compatibility tests.

Fixtures should state their source and intentionally omit secrets and personal data.

## Failure simulation

Model outcomes the production boundary can actually produce:

- timeout or cancellation;
- transient and permanent failures;
- partial response or malformed payload;
- duplicate or reordered delivery;
- rate limit and retry guidance;
- success with delayed side effects.

Avoid a universal “throw error” mock that erases the distinctions production logic must handle.

## Warning signs

Review the design when:

- one test configures many internal mocks;
- mocks return mocks through long call chains;
- harmless refactoring breaks most tests;
- the test reimplements dependency behavior;
- the double accepts states the real system rejects;
- production code exposes internals only for tests;
- mock reset/order rules dominate the test.

Often the remedy is a deeper public seam, a narrower boundary, or a focused integration test.
