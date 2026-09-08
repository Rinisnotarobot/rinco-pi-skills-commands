# ADR Format

ADRs live under the applicable `docs/adr/` directory and use sequential numbering: `0001-slug.md`, `0002-slug.md`, and so on. Create the directory lazily — only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what is the context, what was decided, and why.}
```

An ADR can be a single paragraph. The value is in recording *that* a decision was made and *why*, not in filling out sections.

## Optional sections

Include these only when they add genuine value; most ADRs will not need them.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`): useful when decisions are revisited.
- **Considered options**: only when the rejected alternatives are worth remembering.
- **Consequences**: only when non-obvious downstream effects need to be called out.

## Numbering

Scan the applicable `docs/adr/` for the highest existing number and increment by one.

## What qualifies

These are decision shapes that often pass the gate. Each candidate still has to pass all three criteria individually — matching a shape is not a shortcut around the check:

- **Architectural shape** — "the write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts** — "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in** — database, message bus, auth provider, deployment target; not every library, only the ones that would take a quarter to swap out.
- **Boundary and scope decisions** — "Customer data is owned by the Customer context; others reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path** — "manual SQL instead of an ORM because X." These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code** — "we can't use AWS because of compliance requirements." Record the constraint as the decision; alternatives and trade-offs still have to be real to pass the gate.
- **Rejected alternatives when the rejection is non-obvious** — if REST was picked over GraphQL for subtle reasons, record it, or GraphQL will be proposed again in six months.

If a decision is easy to reverse, you will just reverse it. If it is not surprising, nobody will wonder why. If there was no real alternative, there is nothing to record beyond "we did the obvious thing."
