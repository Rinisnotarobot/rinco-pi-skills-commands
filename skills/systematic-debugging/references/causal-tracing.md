# Causal Tracing

Trace backward until the first incorrect state or violated assumption is explained.

## Build the chain

For each step record:

```text
Observed symptom
Immediate failing operation
Inputs and state at that operation
Caller or producer of each incorrect input
Boundary that admitted or transformed it
Earliest incorrect value, transition, or assumption
Trigger that makes the path reachable
Violated invariant
```

Ask at every layer:

1. What exact value or state is wrong here?
2. Where was it produced?
3. Was it already wrong on entry, or transformed incorrectly inside?
4. What should have rejected or normalized it?
5. Which evidence shows this is the earliest supported cause rather than another symptom?

Stop only when moving one layer earlier reaches valid state plus a specific transition that creates the invalid state.

## Multi-component boundaries

For paths such as client → API → service → queue → worker → database, record at every boundary:

- correlation identity and timestamp;
- sanitized input and output shape;
- relevant configuration identity, not secret values;
- state transition or persistence result;
- retry, timeout, cancellation, and error mapping;
- the component that first diverges from the invariant.

Instrument both sides of a boundary when either side could be responsible. One-sided logs prove only what that side observed.

## State pollution

When a failure depends on test order or prior activity:

1. prove that isolated and grouped runs differ;
2. bisect the preceding tests, requests, jobs, or state mutations;
3. capture state before and after the suspected polluter;
4. identify the missing reset, leaked singleton, shared resource, or ordering assumption;
5. reproduce with the smallest polluter → victim sequence.

## Cause taxonomy

Keep these distinct:

- **Trigger:** input or event that enters the failing path.
- **Root cause:** earliest faulty transition or invalid assumption that must change.
- **Contributing condition:** increases likelihood or impact but is insufficient alone.
- **Detection gap:** allowed the defect to escape or delayed diagnosis.
- **Symptom:** observable consequence.

A useful fix targets the root cause. Tests may also cover the trigger; observability may address the detection gap.
