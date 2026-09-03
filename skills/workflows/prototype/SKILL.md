---
name: prototype
description: Build a throwaway prototype that answers one named design question, then return an evidence handoff - the answer, the artifact location, observed results, and limitations - without touching production behavior. Use when a design question cannot be settled by discussion and the user asks to prototype, sanity-check a state model or logic, or explore UI variants.---

# Prototype

A prototype is **throwaway code that answers one question**. The question decides the shape. Prototype evidence ends a discussion; it never starts production work — behavior changes reach the repository only through `spec`, `plan`, `tdd`, and `verification`.

## Workflow

### 1. Name the question and the stopping condition

Before any code, write down:

- **The question**: one named design question ("does this state machine handle X-then-Y?", "which of these layouts fits the data?"). One question per prototype — a prototype answering two questions answers neither well.
- **The stopping condition**: what observation ends the prototype ("the walkthrough shows partial cancellation is unreachable", "the user picks a variant or rejects all three").

If the user cannot name a question, help them name it — but do not start coding on a vague impulse to "try something". If the question is actually a requirements question (what should the system do, not how should a mechanism feel), route to `grilling` or `spec` instead and stop.

Completion criterion: question and stopping condition are stated, singular, and recorded where the prototype will live.

### 2. Pick the branch

- **"Does this logic / state model feel right?"** → [Logic Prototype](references/logic.md): a single shareable HTML file that pushes the state machine through cases that are hard to reason about on paper.
- **"What should this look like?"** → [UI Prototype](references/ui.md): several structurally different UI variations on a single route, switchable via a URL search param.

The two branches produce very different artifacts. If the question is genuinely ambiguous and the user is unreachable, default to the branch that better matches the surrounding code (a backend module → logic; a page or component → UI) and state the assumption at the top of the prototype.

Completion criterion: the branch is chosen and matches the named question.

### 3. Build throwaway code

Apply the rules from the branch reference. The invariants, whichever branch:

1. **Throwaway from day one, clearly marked.** Locate the prototype near the module or page it prototypes for, named so a casual reader sees it is not production.
2. **Trivial to run.** One command, or one double-click for an HTML file.
3. **No persistence by default.** State lives in memory; a scratch DB or "wipe me" file only when the question is about persistence itself.
4. **Skip the polish.** No tests, no error handling beyond runnable, no abstractions.
5. **Surface the state.** Print or render the full relevant state after every action, so the observation is visible.

The prototype lives outside the production merge path, from day one: all prototype work — including a sub-shape A variant switch mounted on an existing page's copy — happens on a throwaway branch, never on the working branch that production builds from. The working branch keeps its current rendering untouched.

Completion criterion: the prototype runs by one command, answers the named question, and the working branch has no prototype edits to clean up.

### 4. Observe and answer

Run the stopping condition. Record what was actually observed — the walkthrough transcript, the state the machine reached, the variant the user picked or rejected — not just the conclusion.

Completion criterion: the question has an observed answer, or the prototype explicitly failed to answer it (also a result: record why).

### 5. Return the evidence handoff and stop

Return once:

```text
Producer: prototype (one-question evidence)
Question: <the named design question>
Answer: <what was observed and decided, or explicitly unresolved>
Artifact: <where the throwaway code lives and how to run it>
Observed result: <the transcript-level evidence behind the answer>
Limitations: <what this prototype cannot prove - throwaway code, no tests, unrepresentative data>
Next: <the owner of the follow-up: grilling/spec for requirement decisions, plan for production implementation>
```

Return the handoff and stop. Do not fold the validated decision into production code: the answer is evidence for `grilling`, `spec`, or `plan` to consume; production behavior is implemented later through `tdd` with its own RED, and gated by `verification`. The prototype code stays on its throwaway branch unless a later Rinco plan deliberately reimplements the validated behavior; retiring the prototype is deleting or archiving that branch, which never leaves residue on the working branch.

Completion criterion: the handoff carries every field, and the working branch is unchanged.

## Guardrails

- Never answer two questions with one prototype.
- Never edit production behavior to build or run a prototype.
- Never present the prototype as production-ready, tested, or deployable.
- Never let prototype code reach the production merge path without a later plan.
- Never skip recording the limitations — a prototype without limits stated is being oversold.
