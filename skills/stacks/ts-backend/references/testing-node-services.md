# Testing Node Services

Use this reference for the Node.js and TypeScript mechanics of a test strategy that has already been decided.

## Ownership

Test-first slices, test seam choice, coverage policy, and what a passing suite is allowed to conclude are **decided** by `tdd`; gate execution and the final verdict belong to `verification`. This reference owns only the mechanics: how an application instance is built for a test, how a request or a job is exercised, and which failures this level of test can and cannot detect.

**These tests prove the service's behavior, not the deployment's.** A suite passing against an in-process application says nothing about the module system, the configuration, or the container ([project-and-runtime-setup.md](project-and-runtime-setup.md)).

## Choose the level

| Level | What it exercises | What it substitutes |
|---|---|---|
| Application | One operation's logic and its ports | Persistence, network, clock |
| Persistence | The real client against the real schema | Nothing inside the boundary |
| Transport | Request in, response out, through validation and error mapping | External services, sometimes the database |
| Worker | Job in, side effect out, through acknowledgement | The broker, sometimes the database |
| End-to-end | The deployed system | Nothing |

Match the level to the invariant being protected. A transport test is the only level that can prove a status mapping or an authorization check; an application test is the cheapest level that can prove a business rule.

## Build the application, do not start it

### Compose a fresh instance per test

The production entry point starts listeners, opens pools, and reads the process environment; reusing it in tests couples the suite to deployment configuration and to process-global state. Expose a composition function that accepts its dependencies and use it from both the entry point and the tests.

- Give each test its own instance and close it afterwards, so a leaked handle or a shared container cannot make one test's result depend on another's.
- Substitute at the boundary the code actually resolves: the injected client, the provider token, or the port. A test that patches a module's exports is testing the patch.
- Keep fake clock, identifier generator, and randomness injectable. A test that depends on wall-clock time or a real generated identifier is a test that fails intermittently for reasons unrelated to the change.

## Transport-level tests

- Exercise the application through its real request path — the framework's injection helper against the composed instance, or a real HTTP client against an ephemeral port — so parsing, validation, guards, pipes, and error mapping all run.
- Assert on the observable contract: status, declared body fields, and headers that clients depend on. Asserting on the internal call sequence makes the test break on refactors that change nothing observable.
- Keep one test per classified failure, since the mapping is what this level exists to prove ([validation-errors-and-identity.md](validation-errors-and-identity.md)).
- Cover the unauthorized and forbidden paths explicitly; they are the paths most likely to be missing rather than wrong.

## Database and container fixtures

- Use the project's existing mechanism: a container per suite, a transaction rolled back per test, or a schema reset. Whichever it is, confirm isolation holds when tests run in parallel.
- Seed the minimum data the assertion needs, and assert on the result of the operation rather than on the fixture.
- A test that passes only in a particular order is an isolation failure; treat it as the defect, not as flakiness to retry.

## External services

- Substitute at the client boundary — the injected HTTP client, the broker producer, or the SDK instance — rather than at the framework level.
- Where the project uses recorded interactions, keep the recordings reviewable and tied to a contract; a recording that no longer matches the real service is a false pass.
- Never let a test call a real third-party service in the default path. If a test needs the real service, it belongs to a separate, explicitly invoked suite.

## Asynchronous pitfalls

- Await every promise the assertion depends on. A missing `await` in a test produces a passing test that asserted nothing.
- Do not use fake timers over real I/O unless the project's helper supports it; the combination produces hangs rather than failures.
- Register the unhandled-rejection and uncaught-exception paths so a test that triggers one fails instead of being attributed to a later test.
- Close clients, servers, and containers in teardown; an open handle is why a suite passes and the runner does not exit.

## Worker and queue tests

- Drive the handler with the same shape the broker delivers, including the metadata the handler reads, and assert on the acknowledgement decision — not just on the returned value.
- Test the failure paths that decide durability: a handler that throws, a process that exits mid-handler, and a duplicate delivery ([persistence-transactions-and-jobs.md](persistence-transactions-and-jobs.md)).
- Assert the ordering claim only to the extent the broker guarantees it; a suite that assumes global ordering proves something the production broker does not offer.

## What this level cannot prove

- That the built artifact starts, or that the module system and aliases resolve at runtime.
- That the deployed configuration is valid.
- That the database schema in production matches the tested schema.
- That delivery semantics hold under real broker behavior, contention, or failover.
- That the response contains no field outside the declared shape, unless the assertion checks for it explicitly.

State which of these remain unproven rather than implying a passing suite covers them.

## Verification

- Run the suite twice in a row and in a randomized order; confirm identical results.
- Confirm the runner exits without an open handle warning.
- Confirm each failure classification has at least one transport-level test.
- Confirm an unauthorized request is denied by test, and that removing the check makes a test fail.
- Confirm a test that mutates data leaves no residue that a later test observes.
- Confirm no test in the default suite reaches a real external service.
- Confirm the suite still passes with the fake clock and injected identifiers in place, and fails when the invariant is broken.
