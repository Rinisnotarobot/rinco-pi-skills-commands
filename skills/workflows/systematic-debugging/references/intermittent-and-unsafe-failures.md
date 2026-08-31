# Intermittent and Unsafe Failures

Build evidence without turning nondeterminism or production risk into permission to guess.

## Intermittent failures

Record every attempt; a later pass does not erase a failure. Capture:

- command or trigger and attempt count;
- pass/fail sequence and exact failure signatures;
- seed, timing, concurrency, load, order, and environment;
- shared state and resource lifecycle;
- timeout, retry, cancellation, and scheduler behavior.

Change one dimension at a time. Use repeated runs to compare a stated hypothesis, not to fish for a pass. When repository policy defines a flake threshold or retry rule, apply it exactly; otherwise fail-then-pass remains unresolved evidence.

Prefer waiting for an observable condition over sleeping for a guessed duration. Keep a bounded timeout with a diagnostic error. A real timing requirement such as debounce or lease expiry may use elapsed time when the duration itself is the behavior under test.

## Unsafe reproduction

Do not reproduce directly when doing so could mutate production data, expose secrets, send external messages, trigger billing, violate policy, or create an unrecoverable state.

Use the strongest safe substitute available:

1. immutable production logs, traces, metrics, or audit events;
2. a sanitized captured input in an isolated environment;
3. a read-only query or dry-run/check mode;
4. a shadow, canary, sandbox, or disposable fixture approved for the experiment;
5. additional observability for the next natural occurrence.

Document the gap between the substitute and the real environment. When operator-only evidence is required to distinguish causes, keep the diagnosis blocked and request it from the authorized operator. Hand operator evidence to verification only when it is a post-fix gate rather than a prerequisite for proving the cause.

## Performance regressions

Pin workload, warmup, sample count, environment, and measurement method. Compare distributions or robust summaries rather than one timing. Separate CPU, I/O, allocation, lock contention, network, and downstream latency hypotheses. A performance fix requires a reproducible benchmark or operational signal that goes red on the regression and improves for the predicted reason.

## Exit conditions

The investigation can proceed to TDD when evidence identifies a stable behavior seam and causal mechanism. It is blocked when the safe evidence gate cannot distinguish plausible causes; report the missing access, event, fixture, or operator action instead of selecting a favorite explanation.
