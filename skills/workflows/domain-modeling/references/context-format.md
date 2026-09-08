# Context Format

The structure of a `CONTEXT.md` glossary file.

## Template

```md
# {Context Name}

{One or two sentences: what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence definition of the term.}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences. Define what the term *is*, not what it *does*.
- **Only include terms specific to this project's domain.** General programming concepts (timeouts, error types, utility patterns) do not belong, even when the project uses them heavily. Before adding a term, ask: is this a concept unique to this context, or a general programming concept?
- **Group terms under subheadings** when natural clusters emerge. A flat list is fine for a single cohesive area.

## Single vs multi-context repos

**Single context (most repos):** one `CONTEXT.md` at the repo root.

**Multiple contexts:** a `CONTEXT-MAP.md` at the repo root lists the contexts, where they live, and which vocabulary they share:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md): receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md): generates invoices and processes payments

## Shared vocabulary

- **Ordering ↔ Billing**: share the terms `CustomerId` and `Money`
```

The map records where contexts and their shared terms live — not how contexts integrate. Integration mechanisms (events, synchronous calls, queues) are decisions, not vocabulary: they belong in ADRs.

Which structure applies:

- `CONTEXT-MAP.md` exists → read it to find the contexts;
- only a root `CONTEXT.md` exists → single context;
- neither exists → create a root `CONTEXT.md` lazily when the first term resolves.
