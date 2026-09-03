---
name: publish-tickets
description: Serialize an approved implementation plan's slices into tracker tickets - one ticket per approved slice, with blocking edges, requirement traceability, and a base revision - without re-slicing, merging, or reinterpreting the plan. Use when the user asks to publish, create, or file tickets from an approved plan.
disable-model-invocation: true
compatibility: Requires a plan artifact produced by the plan skill. Ticket owners (tdd, verification, code-review) run in later sessions; when reporting the first ticket, name the exact pi relaunch command that loads them.
---

# Publish Tickets

Serialize an approved plan's slices into tickets. The plan is the only decomposition authority: this skill publishes what the plan already decided — one ticket per approved slice — and never slices, merges, or reinterprets on its own. Ticket publication is scheduling, not re-planning.

## Workflow

### 1. Verify the plan artifact

Accept only an approved `plan` artifact: a persisted implementation plan with an explicit slice list, each slice carrying its behavior, files, test seam, and dependencies. Anything else — a conversation, a spec, an issue, a bare feature request — is the wrong input. Report:

```text
BLOCKED: publish-tickets accepts only an approved plan artifact.
Found: <what was actually supplied>.
Run plan first, then re-invoke: pi --no-skills --skill skills/workflows/plan
```

Verify, from the artifact itself:

- the plan states its source specification and requirement IDs;
- the slice list is explicit and each slice has an identifier;
- the dependency edges between slices are stated;
- the plan records a base revision (the commit it was planned against) in its Repository Evidence.

For the base revision: if the plan records one, use it and check it — when the current worktree has changes on paths the plan's change map names, relative to that revision, the plan is stale. If the plan records none, stamp the current HEAD as the base revision at publish time and flag in the report that the plan pre-dates revision stamping. Either way the ticket carries a real, recorded revision; never fabricate one silently.

Any other missing piece is a plan defect. Report `BLOCKED` with the named gap and the exact `plan` relaunch command — do not repair the plan here.

Completion criterion: the plan artifact is present, approved, internally complete, and not stale against its recorded revision, or the session is explicitly blocked with the gap named.

### 2. Map slices to tickets one-to-one

Map exactly one ticket per plan slice. Do not merge similar slices, split large ones, or reorder work: if the granularity seems wrong, that is a plan defect — report it and stop, do not fix it here.

Each ticket carries, from the plan:

- **Delivers**: the slice's behavior statement, copied verbatim from the plan;
- **Requirements**: the source `REQ`/`INV`/`AC` identifiers the slice implements — IDs and pointers only, never the requirement text;
- **Source**: the plan artifact path and the slice identifier;
- **Blocked by**: the slice identifiers of the gating slices, or "none";
- **Base revision**: the commit recorded in step 1, so a stale ticket is detectable;
- **Acceptance pointer**: the plan's per-slice verification contract, referenced by location, never restated.

Keep exact file paths, symbols, and commands in the plan. A ticket references them by slice, never copies them — copied paths go stale and fork the plan's authority. Do not inline snippets from any non-plan source.

Wide refactors stay in the plan's expand–migrate–contract order: one ticket per plan slice — when the plan expresses the migration as batches, each batch is already a slice, gated by the expand slice and gating the contract slice. If the plan sequenced them differently, follow the plan and note the deviation in the report.

Completion criterion: every ticket traces to exactly one slice identifier, and every slice has exactly one ticket.

### 3. Check the dependency graph

Build the graph from the plan's stated edges. Verify it is acyclic and that every blocking edge references a slice that has a ticket. A cycle or dangling edge is a plan defect: report it and stop — the fix belongs to `plan`.

Completion criterion: the ticket graph is acyclic, complete, and identical to the plan's slice graph.

### 4. Publish in dependency order

Publish tickets blockers-first, so each ticket's blocking edges can reference tickets that already exist. Where they land:

- **Local files** — one file per ticket under `.tickets/<plan-slug>/`, named `NN-<slice-slug>.md`, numbered from `01` in dependency order; the ticket body carries the slice identifier. Never one combined file.
- **A real tracker** (GitHub, Linear, ...) — one issue per ticket. Use the platform's native blocking relationship where it has one; where it does not, write the gating tickets' identifiers into the ticket's Blocked-by field. Apply the repository's agent-ready label convention if one is configured.

Do not assign or reassign implementation owners beyond what the plan names — the tracker is a schedule, not a re-assignment of `tdd`, `verification`, or `code-review` ownership.

Completion criterion: every ticket exists at its target with its blocking edges resolved to identifiers of tickets that exist, and nothing else on the tracker was touched.

### 5. Report and stop

Return:

```text
Producer: publish-tickets (plan serialization)
Plan source: <artifact path, base revision, approval state>
Tickets published: <count, target, per-ticket identifier and slice>
Graph: <acyclic confirmation, frontier (tickets with no open blockers)>
Traceability: <every ticket -> slice -> requirement IDs>
Deviations: <plan defects found, unstamped base revision, or none>
Next: <the frontier ticket to start with, and the exact pi relaunch command that loads tdd, verification, and code-review for its owner>
```

Return the report and stop. Implementation, verification, and review belong to their owning skills, invoked per ticket. A later plan revision supersedes the published set: unpublish or supersede the affected tickets explicitly, never silently.

Completion criterion: the report accounts for every published ticket, names the executable next step, and no implementation work has started.

## Guardrails

- Never slice, merge, split, or reorder without a plan revision.
- Never copy file paths, symbols, commands, or requirement text into tickets — reference the plan's slice.
- Never publish from an unapproved, incomplete, or stale-mismatched plan; never fabricate a base revision.
- Never let a ticket claim production readiness or its own verification verdict.
- Never touch unrelated tracker state.
