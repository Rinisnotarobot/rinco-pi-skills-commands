---
name: grilling
description: Stress-test a plan, design, decision, or idea with rounds of exhaustive questions until shared understanding, then return a decision handoff. Use when the user wants to stress-test their thinking before a spec or plan, or says grill / grill me / 拷问 / 盘问.
---

# Grilling

Interview the user relentlessly until you reach a shared understanding, then stop with a decision handoff. Grilling owns decision-tree stress testing only: the behavior contract belongs to `spec`, and grilling never writes specs, plans, or implementation code.

## Workflow

### 1. Map the design tree

Restate the subject of the interview and map it as a **design tree**: every decision branches into the decisions that hang off it. Mark which decisions depend on which, so no question is asked before its prerequisites are settled.

Completion criterion: the root decision is stated, and every listed decision has its dependency edges identified.

### 2. Ask the frontier in rounds

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask now without guessing at answers you have not heard yet. Ask the whole frontier in one round: number each question and give your recommended answer, then wait for the user's answers before the next round. A question whose answer depends on another question still open in this round belongs to a later round, not this one.

Format a round like so:

```text
❓ Q1 - <question title>: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ Q2 - <question title>: <question body>

➡️ <your recommended answer>
```

After each round of answers, recompute the frontier: settled decisions push the frontier outward and unblock the questions that depended on them. Ask the next round.

Completion criterion: every round asked only frontier questions, and no dependency edge was skipped or silently assumed.

### 3. Split facts from decisions

Finding **facts** is your job, never the user's. When a frontier question needs a fact from the environment — filesystem, tool output, dependency versions, repository state — look it up yourself. If the current session can dispatch subagents, dispatch parallel lookups; if it cannot, explore in the main agent. Either way, do not block the round: a running lookup is an unsettled prerequisite, so only the questions downstream of it wait; ask the rest of the frontier now.

The **decisions** are the user's. Put each to them and wait. A recommendation is not an approval: an unanswered question stays open, and no answer may be supplied on the user's behalf. When the user decides, record the chosen option and the options they rejected, with the reason given.

When a lookup fails or a fact is unavailable (missing tool, missing permission, unreachable upstream), record it as an unresolved prerequisite instead of guessing. If the fact stays unavailable, the questions downstream of it cannot be settled now: propose ending the interview and carrying them as blockers in the handoff.

Completion criterion: every **decision** in the tree is either user-answered or explicitly unresolved with its unblocking condition named; every **fact** a decision depends on is either agent-verified with a recorded source or carries the same unresolved marker.

### 4. Confirm shared understanding

The interview is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Recite the approved decisions and the unresolved items back to the user and ask them to confirm the shared understanding.

If the user ends the interview before the frontier is empty, treat every open decision as unresolved and continue to the handoff with its blockers.

Completion criterion: the user explicitly confirms the decision set, or the interview is explicitly ended with every open decision recorded as unresolved.

### 5. Return the decision handoff and stop

Once the user confirms, return the handoff once:

```text
Producer: grilling (decision-tree stress test)
Approved decisions: <each decision with the option chosen>
Rejected options: <the options turned down, with the reason given>
Unresolved blockers: <decisions the user could not answer or facts that were unavailable, each with the condition that would unblock it>
Source authority: <paths, versions, or links that supported the verified facts>
Artifact pointers: <entry points the next stage should read: draft notes, related ADRs, CONTEXT.md, upstream issues>
Next: <the next owner, normally spec, and the explicit invocation to ask the user for>
```

Return the handoff and stop. Do not start writing the spec, plan, or implementation; requirements, invariants, and acceptance criteria belong to `spec`. A later decision change invalidates this handoff: re-grill, or let `spec` record an explicit revision.

Completion criterion: the handoff carries every field plus the next owner, and no contract, plan, or code artifact was produced.

## Guardrails

- One question set per round; never ask a downstream question before its prerequisite is answered.
- Never present a recommended answer as decided, and never answer for the user.
- Never block a round on an unfinished fact lookup.
- If the whole tree resolves in one round, re-examine each top-level decision for unvisited downstream consequences — failure, rollout, migration, cost, security — before declaring the frontier empty.
- Never turn the handoff into a specification: no requirements, invariants, acceptance criteria, or implementation steps.
