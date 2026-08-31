# Review Lenses

Examine the behavior and boundaries touched by the change. The items below are search directions, not finding templates. Only concrete failures that pass the evidence gate belong in Findings.

## Correctness

- Map the implementation to each requirement, contract, and invariant. Look for omissions, divergence, and unrequested behavior.
- Trace success, expected failure, null, boundary, duplicate, out-of-order, and partial-completion paths.
- Check that errors propagate, transform, or roll back at the correct layer, and that cleanup runs on failure and cancellation.
- Examine concurrency, transactions, retries, idempotency, ordering, cache consistency, and state transitions.
- Check backward compatibility across APIs, events, data formats, configuration, migrations, and persisted state.
- Verify that tests exercise new behavior branches and would fail with the defect present. Check whether snapshots or mocks hide the real contract.

Do not report “missing tests” by itself. Name the specific risk path that lacks coverage and explain why existing tests cannot detect it.

## Security

Identify trust boundaries, attacker-controlled inputs, sensitive assets, and authorization subjects before tracing data flow:

- After authentication, verify object-, tenant-, and operation-level authorization.
- Check constraints before input reaches SQL, shells, templates, HTML, URLs, file paths, deserializers, or logs.
- Trace injection, XSS, SSRF, path traversal, open redirect, CSRF, prototype pollution, and unsafe deserialization paths.
- Check whether secrets, tokens, personal data, or internal errors enter source, logs, responses, caches, fixtures, or telemetry.
- Inspect uploads, downloads, archives, and file permissions for type, size, destination-path, and symlink controls.
- Validate cryptography, randomness, signatures, sessions, cookies, CORS, and security headers against the actual threat model.
- Examine dependency, lockfile, build-script, and CI changes for expanded supply-chain or execution privileges.

Prove framework protections against the active version, configuration, and call pattern. When reporting a secret, provide only its location and redacted characteristics—never its value.

## Performance

Establish call frequency, input scale, and resource limits before judging impact:

- Check whether algorithmic complexity degrades at realistic scale or loops repeat scans, sorts, or allocations.
- Find N+1 database or network calls, serial waterfalls, missing batching, pagination, indexes, or timeouts.
- Identify unbounded queries, queues, caches, or memory structures that can leak, backlog, or create high cardinality.
- Check whether synchronous I/O, locks, shared state, or excessive concurrency blocks a critical path or creates contention.
- Verify cache keys, invalidation, TTLs, and consistency so the optimization cannot return stale or incorrect results.
- For frontend changes, inspect critical-bundle growth, repeated rendering, layout thrashing, main-thread work, and large resource transfer.

Report a performance defect only when the scale and execution path are concrete. Put optimization ideas without measurement evidence under Open questions.

## Maintainability

- Check repository conventions for naming, module boundaries, error models, type strategy, and testing.
- Verify that public interfaces are minimal and express domain intent without forcing callers to understand internal data or timing.
- Look for duplication, shotgun changes, circular dependencies, hidden global state, and cross-layer coupling introduced by the diff.
- Check whether types, validation, and comments express real invariants rather than merely suppressing tools or restating code.
- Inspect diagnosability: errors should be locatable, and logs and metrics should carry enough context without leaking data.
- Keep configuration, migrations, deployment, rollback, and documentation synchronized with contract changes.
- Check that tests are deterministic, isolated, and behavior-focused through a public seam rather than coupled to implementation details.

Exclude stylistic preference, aesthetic refactoring, and technologies the repository has not adopted from Findings. Prefer the smallest change that restores an invariant or removes an observed risk.
