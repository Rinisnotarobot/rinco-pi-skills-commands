# Composition Pilot Record Template

Lifetime: **delivery template** owned by [PROTOCOL.md](PROTOCOL.md). Consult the protocol for eligibility, metric definitions, evidence freshness, attempt transitions, and acceptance. Revise this template with that contract; it is not an executed pilot.

Copy the Markdown block below only after a real task is admitted. Name the file `docs/pilots/<n>-<task-slug>.md`. Replace every placeholder with observed evidence, `none`, `unavailable: <reason>`, or `not reached: <blocker>` as appropriate; missing proof never becomes a pass. Append another numbered attempt when a source revision or lane adjustment requires a rerun. Link a replacement task's record rather than overwriting this task's history.

```markdown
# Pilot <n> — <real task title>

Lifetime: state-bound evidence. Reuse only when claim, scope, sequence, source revision, worktree, and prerequisites still match; retain superseded attempts as observations, not current proof.

## Task and eligibility

- Request authority: <user request/issue/approved artifact identifier and accessible pointer>
- Expected observable outcome: <one task statement, not a duplicate specification>
- Target repository: <path or accessible repository identifier>
- Lane and fit: <pilot number; evidence for its task-shape criteria>
- Rejected candidate/route reasons: <what did not fit and why, or none>
- Scope and exclusions: <authorized paths/effects; unrelated work to preserve>
- Operator / campaign reviewer: <named actors or agent/session identifiers; disclose same-actor review>
- Canonical artifact pointers: <spec/plan/source IDs when needed, or none with reason>
- Previous/replacement task record: <pointer and reason, or none>

## Attempt 1

### Baseline and prerequisites

- Rinco source repository and commit: <full immutable commit containing the Skills and protocol used>
- Source state: <branch, status, staged/unstaged diff summary; clean at attempt start>
- Protocol/template revision: <repository paths at that commit>
- Target comparison and start state: <branch, full HEAD, status, staged/unstaged diff summary>
- Dirty/untracked input identity: <reproducible patch or content fingerprints and accessible evidence; none when clean>
- Relevant environment/configuration/dependency state: <versions and evidence, no secrets>
- Focused RED/GREEN command and authority: <exact command, cwd, repository source; not reached with the stage that will discover it if shaping is still in progress>
- Required target gates: <authoritative repository/plan pointer; verification retains gate ownership>
- Prerequisites and permissions: <tools/services/fixtures/authorized external actions, or blocker and next actor>
- Reserved evidence-only paths: <pilot record path; code-review's reserved artifact when applicable>
- Start time / measurement origin: <timestamp with timezone, first foreground assistant turn ID>

### Sessions and installed Skills

Repeat this block for each actual session start:

- Session identifier, start time, Pi/model details: <observed values or unavailable with reason>
- Enabled discovery/configuration sources: <project/global roots and every other enabled source>
- Available Skills evidence: <session-visible inventory pointer>

| Frontmatter name | Resolved installed path | Canonical source/revision | Directory parity evidence / declared provenance difference |
|---|---|---|---|
| <actual Skill> | <absolute path> | <source path and commit> | <comparison result, not assumption from path presence> |

- Duplicate names/competing owners: <enumerated candidates and resolution, or none with evidence>
- Dependency availability/recovery: <original blocker, missing names/locations, approval, restart, and recheck; or none>
- Session handoff/recovery: <temporary path at write time, source artifact path+revision pointers, next invocation, actual next-session lookup result; or none>

### Chronological events

| Event ID | Timestamp / foreground turn | Session / producer / phase | Input and source state | Output/evidence pointer | Next owner, user invocation/approval, stop point, or freshness decision |
|---|---|---|---|---|---|
| E001 | <time/turn> | <actual producer> | <artifact or request; revision> | <observation pointer> | <observed action; not inferred approval> |

Include handoff rejection/reuse, record-only writes, pauses, resume events, and all relevant mutations. Link the command observations below instead of duplicating their output here.

### Command and observation evidence

Repeat for each evidence-producing command or manual observation. This is an execution log, not a second verification gate table.

- Evidence ID / event / timestamp: <C001 / E001 / time>
- Producer and evidence owner: <actual actor and owning Skill>
- Claim / scope / source IDs: <what this proves, comparison point, applicable REQ/INV/AC or none>
- Exact method: <cwd and exact command, or manual procedure and authorized observer>
- Authority and prerequisites: <repository instruction/CI/config/plan source; services/fixtures/permissions>
- Before state: <HEAD, git status --short, relevant diff/content identity, dependency/config state>
- Exit status / result: <actual exit code or observation, including failures>
- Key output / accessible full evidence: <behavioral signature and sanitized log pointer>
- After state: <same fields; account for command-created artifacts>
- Freshness decision: <owner's reuse/rerun/blocked decision and reason; or not yet assessed>

### Seven metrics

- First useful RED: <TDD event, command, expected failure, start/RED timestamps, turns, elapsed wall time; distinguish earlier debugging RED>
- Unnecessary questions/artifacts: <event list and reason, or none; separate protocol recording overhead>
- Rejected/stale handoffs: <events, producers/consumers, reason, resolution, or none>
- Duplicate conclusions/gate tables: <events and scope/state match, or none>
- Boundary context usage: <per-handoff observations or unavailable with reason; qualitative recovery cost>
- Post-readiness defects: <claim/state, discovery event, attribution, observation cutoff; or none observed through timestamp>
- Manual owner corrections: <event, intervention, affected owner, category, causal defect, or none>
- Timing limitations: <human waits, pauses, missing counters; subagent counts separately if available>

### Owner artifacts and recovery

- Verification: <report/transcript identifier, pinned claim/scope/stage/state, quoted owner outcome; no recalculated gate table>
- Review: <separate report pointer and quoted verdict; or not requested/not reached with reason>
- Pilot-specific evidence: <P2 decision/domain/spec/plan traceability; P3 cause/cleanup-before-production-edit evidence; P4 approved plan/base revision, ticket-to-slice/source-ID DAG, per-ticket evidence and fresh-session recovery; omit irrelevant branches>
- Correction and rerun ledger: <event/category/causal defect/owning Skill/change evidence/affected rerun; or none>
- Stale or superseded evidence: <identifiers, invalidating events, replacement pointers, or none>

### Invariants and disposition

| Protocol invariant | PASS / FAIL / UNPROVEN | Observation and evidence pointer |
|---|---|---|
| 1 — one behavior contract when needed | <result> | <pointer; justified omission for a clear task> |
| 2 — one plan when needed | <result> | <pointer; justified omission when unnecessary> |
| 3 — one final verification state per unchanged target state | <result> | <owner/state pointer> |
| 4 — no Matt workflow duplicate in installed Skills | <result> | <session inventory/parity evidence> |

- Started / ended or paused: <timestamps with timezone>
- State history: <eligible → running → recorded, with event/timestamp for each observed transition>
- Current disposition: <recorded | accepted | adjustment-required | invalid, applying protocol conditions>
- Lane verdict: <lane kept as designed | lane adjusted (how) | lane failed (why) | not reached: blocker>
- Reviewer / decision time / evidence: <who checked the protocol and which observations support the disposition>
- Unresolved blockers and next actor: <required evidence or permission still missing, or none>
- Residual limitations and observation cutoff: <what was not exercised/measured; no blanket effectiveness claim>
- Next action / rerun or replacement pointer: <resume, owner correction, next real task, or accepted result awaiting campaign close>
```
