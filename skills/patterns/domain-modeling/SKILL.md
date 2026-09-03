---
name: domain-modeling
description: Build and sharpen a project's domain vocabulary and durable decisions - challenge terms, resolve them into a CONTEXT.md glossary, and record ADRs only for decisions that are hard to reverse, surprising without context, and the result of a real trade-off. Use when the user wants to model domain language - defining, unifying, or recording domain terms - when writing or editing a CONTEXT.md, or when recording or editing an ADR.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design: challenge terms, invent edge-case scenarios, and write the glossary and decisions down the moment they crystallize. Reading `CONTEXT.md` for vocabulary is not this skill — that is a one-line habit any skill can do. This skill is for changing the model, not consuming it.

Domain modeling owns domain language only. It never writes specs, implementation plans, or code: the behavior contract belongs to `spec`, repository strategy to `plan`, implementation to `tdd`.

## File targets and allowed mutations

Single-context repo (the default):

```text
/
├── CONTEXT.md              ← the glossary
└── docs/adr/               ← durable decisions
```

Multiple contexts: if a `CONTEXT-MAP.md` exists at the root, it points to where each context's glossary and ADRs live. Infer which context the current topic belongs to; ask when unclear.

Create files lazily — only when there is something to write.

The allowed worktree mutations, and no others:

- create or edit the applicable `CONTEXT.md`;
- create or edit the applicable `CONTEXT-MAP.md`, but only to add, rename, or relocate a context — and only after the user approves that structural change;
- create or edit files under the applicable `docs/adr/`;
- reverse your own edits to these paths when a decision changes mid-session.

Any other change — source code, specs, plans, tests, configuration, or other people's content inside these files — is out of scope. When the discussion surfaces such work, name it for its owning stage and stop.

## Workflow

### 1. Challenge the language

- When the user uses a term that conflicts with the glossary, call it out immediately: "Your glossary defines this as X, but you seem to mean Y. Which is it?"
- When a term is vague or overloaded, propose a precise canonical term rather than accepting the fuzz.
- When domain relationships are discussed, stress-test them with concrete edge-case scenarios that force the boundaries between concepts to be stated.
- When the user states how something works, check whether the code agrees; surface the contradiction instead of recording it as truth.

Completion criterion: every term in play is either already canonical, sharpened to a single meaning, or explicitly unresolved.

### 2. Record vocabulary the moment it resolves

Update the applicable `CONTEXT.md` inline when a term is resolved — do not batch glossary updates. Use [Context Format](references/context-format.md).

Keep `CONTEXT.md` a glossary and nothing else: no implementation details, no task status, no specifications, no plans, no session notes. Include only terms specific to this project's domain; general programming concepts do not belong.

Completion criterion: each resolved term has a glossary entry with a tight definition and its avoided synonyms.

### 3. Offer ADRs sparingly

Offer to create an ADR only when all three are true:

1. **Hard to reverse** — the cost of changing course later is meaningful;
2. **Surprising without context** — a future reader will wonder why it was done this way;
3. **The result of a real trade-off** — genuine alternatives existed and one was picked for specific reasons.

If any of the three is missing, skip the ADR. Use [ADR Format](references/adr-format.md) and sequential numbering under the applicable `docs/adr/`. A decision the user has not confirmed is not a decision: put it to them and wait.

Completion criterion: every recorded ADR passes the three-part gate, and ADR candidates that fail it are simply dropped.

### 4. Report the mutations in a handoff

When the conversation ends or hands off, report:

```text
Producer: domain-modeling (domain language)
Glossary mutations: <files created or edited, terms added or sharpened>
ADR mutations: <files created or edited, decisions recorded, numbering used>
Unresolved terms: <terms still in conflict or fuzzy, with the open question>
Out of scope: <spec, plan, or code work the discussion surfaced, named for its owning stage>
```

Return the handoff and stop. Later domain changes invalidate affected entries and ADRs: supersede an ADR explicitly (status or successor link), never silently.

Completion criterion: the handoff lists every file this skill touched, and nothing it did not.

## Guardrails

- Never write implementation details, task status, or specifications into `CONTEXT.md`.
- Never create an ADR that fails any part of the three-part gate, or that the user has not confirmed.
- Never touch paths outside the declared glossary, map, and ADR targets.
- When an existing `CONTEXT.md` contains non-glossary content, do not delete it on your own initiative — flag it and ask.
- Never resolve a domain conflict by redefining the term inside a spec or plan — resolve it here first, then let the owning stage consume the canonical term.
