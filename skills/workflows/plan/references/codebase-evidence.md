# Codebase Evidence for Planning

Inspect only enough of the repository to ground the plan, but follow the relevant path end to end. A directory listing alone is not architectural evidence.

## Evidence map

### Entry and ownership

Identify:

- user, API, CLI, event, job, or library entry point;
- symbol that currently owns the behavior or nearest related behavior;
- module/service that owns affected state and invariants;
- public contracts and downstream consumers.

### Flow

Trace:

```text
input/event → validation → decision/policy → state/effect → observable output
```

Record error, retry, authorization, transaction, and asynchronous boundaries that influence the change. Follow actual calls and data structures rather than inferring from filenames.

### Prior art

Find the closest implemented behavior and state exactly what is reusable:

- directory/module placement;
- interface shape;
- validation and error semantics;
- persistence/query conventions;
- test seam, fixtures, and setup;
- configuration and telemetry conventions.

Prior art is evidence, not a command to copy a bad pattern. Note relevant differences.

### Verification infrastructure

Identify commands from repository instructions, scripts, CI, manifests, and test configuration. Separate package/environment manager from runner. Record required services, fixtures, generated files, or credentials.

### Change impact

Search call sites and consumers of any interface proposed for change. Include serialization formats, schemas, migrations, events, public types, configuration keys, generated clients, and documentation when they are part of the contract.

## Evidence record

Use concise entries:

```text
Fact: <verified current behavior>
Evidence: <path>::<symbol/section>
Plan implication: <why this fact changes the plan>
```

For commands:

```text
Command: <exact command>
Source: <script/config/instruction path>
Scope: focused | affected | repository gate
Requirements: <services/fixtures/environment>
```

## Assumptions versus facts

- **Fact:** directly observed in authoritative repository or supplied specification.
- **Assumption:** plausible but not yet verified.
- **Proposal:** behavior or structure the plan intends to introduce.
- **Business constraint:** supplied by the user or authoritative product artifact; never reconstructed from implementation code.

Do not phrase assumptions or proposals as current-state facts.

## Exploration stop condition

Stop when all are true:

- the active call/data path is understood;
- affected invariants and boundaries are identified;
- every named path and symbol is verified;
- comparable tests and canonical commands are known;
- no unexplored caller can materially change compatibility or scope.

Do not inventory unrelated subsystems to make the plan appear comprehensive.
