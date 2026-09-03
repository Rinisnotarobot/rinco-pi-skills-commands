# Pilot Protocol — Hybrid Rinco Lanes Validation

Status: **protocol ready; pilots pending real tasks.** This document defines what must be exercised and recorded before the hybrid lanes are considered validated (integration plan slice 8). No pilot below may be claimed complete without its record row filled with real evidence.

## Purpose

Prove that the hybrid (Rinco kernel + Matt-derived discovery layer) reduces rework without weakening gates, before any evaluation of `wayfinder`, architecture surveying, or a general research workflow.

## Required pilots

| # | Task shape | Lane | Skills exercised (via profile) |
|---|---|---|---|
| 1 | One small, already-clear behavior | `tdd → verification` (+ optional risk-based `code-review`) | build |
| 2 | One ambiguous multi-module feature | `shape (grilling + domain-modeling [+ prototype]) → spec → plan → tdd → verification → code-review` | shape, then build |
| 3 | One unknown-cause defect | `fix → systematic-debugging → tdd → verification (+ optional code-review)` | fix |
| 4 | One multi-session change requiring ticket handoff | `spec → plan → publish-tickets → per-ticket tdd → final verification → code-review` | shape/build + publish-tickets |

Each pilot runs in a real repository against a real requested change, launched with the matching profile launcher. Pilots on this repository itself (self-hosting) are valid when the task is real work, not staged demonstrations.

## Metrics to record per pilot

- turns and elapsed time to the first useful RED (tdd's first failing test that fails for the right reason);
- unnecessary questions asked and unnecessary artifacts produced (any grilling round, spec, plan, or ticket a clear task did not need);
- rejected or stale handoffs (handoffs a downstream refused for scope/sequence/worktree mismatch);
- duplicate conclusions or gate tables (more than one verdict for the same unchanged target state);
- context usage at phase boundaries (approximate context share consumed at each handoff);
- verification failures and defects found after any readiness claim;
- manual corrections needed to keep owners separate (any point where a skill overstepped and a human pulled it back).

## Per-pilot record

```text
Pilot: <n> — <task one-liner>
Repository and profile: <repo, launcher command>
Started / ended: <dates>
Metrics:
  first useful RED: <turns, elapsed>
  unnecessary questions/artifacts: <list or none>
  rejected/stale handoffs: <list or none>
  duplicate conclusions/gate tables: <list or none>
  boundary context usage: <observations>
  post-readiness defects: <list or none>
  manual owner corrections: <list or none>
Verdict: lane kept as designed | lane adjusted (how) | lane failed (why)
```

## Completion invariants (checked per pilot)

1. one behavior contract when needed (no second spec source);
2. one plan when needed (no second decomposition);
3. one final verification state per unchanged target state;
4. no Matt workflow duplicate in the session's profile.

A pilot that requires manual correction is still valid evidence — record the correction; two corrections of the same kind mean the skill text needs revision before the lane is trusted.

## Where records live

One file per pilot under `docs/pilots/`: `docs/pilots/<n>-<slug>.md`, using the record template above.
