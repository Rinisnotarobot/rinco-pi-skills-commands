# Pilot 1 — Reject an unclosed Skill frontmatter block

Lifetime: **state-bound evidence**, governed by [PROTOCOL.md](PROTOCOL.md). Reuse only when claim, scope, sequence, source revision, worktree, and prerequisites still match. Retain superseded observations. Initial intake disposition was **not an accepted Pilot or an implementation verdict**. See [S2 close](#s2-close--e011e013) for the resumed attempt's current disposition; the prerequisite pause below remains historical evidence.

## Task and eligibility

- Request authority: the user confirmed the proposed Pilot 1 defect with `确认`, session entry `36f87212`, at `2026-09-07T07:14:03.714Z`. The confirmed proposal is entry `7b376224` in session S1 below.
- Expected observable outcome: `scripts/validate.sh` rejects a Skill whose opening frontmatter block has no standalone closing delimiter; well-formed Skills remain accepted. Repair the existing malformed delimiter in `skills/workflows/prototype/SKILL.md` and preserve the regression at the validator's CLI seam.
- Target repository: `/home/LiYu/code/rinco-pi/rinco-pi-skills-commands` (self-hosted; also the Rinco source checkout).
- Lane and fit: **Pilot 1**, `tdd → verification`. One bounded, known-cause validation defect; no unresolved product, public-interface, persistent-data, or external-service decision. A focused Bash regression can exercise the existing executable without installing a framework.
- Rejected routes: Pilot 3 does not fit because the cause was established during candidate screening. No feature spec, implementation plan, glossary, prototype, or tickets are needed for this fix. The campaign plan is not a new behavior specification.
- Scope: `scripts/validate.sh`, the delimiter repair in `skills/workflows/prototype/SKILL.md`, and a minimal Bash regression test. `scripts/test-validate.sh` is the proposed test entry, not an existing or executed test. Campaign status/observation writes are separate recordkeeping.
- Initial permissions (E001; later project-install approval is E006): no global or project Skill installation changes, new dependencies, fixed launchers, ADR changes, broad Skill rewrites, commits, or pushes were authorized by the initial confirmation. Preserve unrelated work if it appears.
- Operator / campaign reviewer: foreground agent in S1; same-actor record inspection is disclosed. Final campaign acceptance is not reached.
- Canonical artifacts: [campaign plan slice 2](../plans/2026-09-07-composition-pilot-validation.md#2-validate-the-small-clear-behavior-lane), this task record, and the original request. No task spec/plan or source REQ/INV/AC IDs exist.
- Previous/replacement task record: none.

## Attempt 1 — prerequisite pause

### Baseline and prerequisites

- Rinco source repository and commit: `/home/LiYu/code/rinco-pi/rinco-pi-skills-commands` at `82a107c0830c02d89766d91d39d70e5b6d388866`.
- Source state at intake: branch `main`; clean worktree, no staged or unstaged diff. This commit contains the protocol/template used here. C001 and C002 observed the same clean state.
- Protocol/template revision: `docs/pilots/PROTOCOL.md` and `docs/pilots/RECORD-TEMPLATE.md` at that commit. The subsequent protocol edit updates campaign status only, not the execution method.
- Target comparison and start state: identical checkout, branch, HEAD, and clean state. Dirty/untracked inputs at intake: none.
- Relevant content identities (`git hash-object`): `scripts/validate.sh` = `72efc0721d99516670ecf535cf5628fc4f501252`; `skills/workflows/prototype/SKILL.md` = `ab7fac864969797182b5890eb79d49fe2bba5db3`.
- Environment: Bash `5.2.37(1)-release`; installed Pi `0.85.1`; provider/model from the shell-tool environment: `openai-codex` / `gpt-6-astra`. No services or external tracker are needed.
- Focused RED/GREEN command: **not reached: TDD is unavailable in S1**. Proposed entry is `bash scripts/test-validate.sh` from the target root. The TDD owner must establish the minimal harness and pin the actual command before first execution; no test file has been written and no TDD RED is claimed.
- Required target gates: repository `scripts/validate.sh`, `git diff --check`, the focused regression, and applicable Bash syntax checks. `verification` discovers the final affected gates and owns the implementation outcome.
- Intake prerequisites: `tdd` is absent from the actual session-visible Skills; `verification` is present. Some global Skills used during preflight differ from this source. E006 later installs the missing project copies; actual new-session inventory and parity still require rechecking before implementation.
- Reserved evidence-only path: `docs/pilots/1-frontmatter-closing-delimiter.md`. No review artifact is reserved; review is currently not requested. Do not exclude `PROTOCOL.md`, the regression test, the target Skill, or other files from final implementation/document verification.
- Measurement origin: user confirmation `36f87212` at `2026-09-07T07:14:03.714Z`; first foreground assistant entry `5c9ddee0` at `2026-09-07T07:14:39.213Z`.

### Sessions and installed Skills

#### S1 — intake session, implementation not started

- Session: `01a07984-db95-7422-967f-f2ffaa030f05`; session file `/home/LiYu/.pi/agent/sessions/--home-LiYu-code-rinco-pi-rinco-pi-skills-commands--/2026-09-07T01-39-05-237Z_01a07984-db95-7422-967f-f2ffaa030f05.jsonl`.
- Session start: the filename identifies `2026-09-07T01:39:05.237Z`; this Pilot's invocation is later and uses the measurement origin above. Pi/model values are the observations above, not a reconstructed startup configuration.
- Available-Skills evidence: the agent's active session inventory exposes the 13 names below; it does **not** expose `tdd`. Reading the repository's `tdd/SKILL.md` for its dependency contract did not make it discovered.
- Discovery locations: project `.pi/skills/` and global `~/.pi/agent/skills/` are represented in that inventory. `~/.agents/skills/` also exists; its discovery contribution, settings/package sources, and original CLI flags were not fully resolved. This is an explicit incomplete prerequisite check, not evidence of a duplicate-free session.
- Path notation: `R` = the absolute target repository above; `G` = `/home/LiYu/.pi/agent/skills`. Project entries are symlinks resolving to the canonical directories named below. Global directories have no independently recorded installation commit; C002 compares them with the pinned source, allowing declared provenance differences.

| Frontmatter name | Active installed path | Canonical source at the pinned commit | Directory parity evidence |
|---|---|---|---|
| codebase-design | `R/.pi/skills/codebase-design` | `skills/patterns/codebase-design` | C002 project mirror check: matches |
| coding-standards | `R/.pi/skills/coding-standards` | `skills/patterns/coding-standards` | C002: matches |
| domain-modeling | `R/.pi/skills/domain-modeling` | `skills/patterns/domain-modeling` | C002: matches |
| plan | `R/.pi/skills/plan` | `skills/workflows/plan` | C002: matches; not invoked for this task |
| systematic-debugging | `R/.pi/skills/systematic-debugging` | `skills/workflows/systematic-debugging` | C002: matches |
| verification | `R/.pi/skills/verification` | `skills/workflows/verification` | C002: matches; implementation verification not reached |
| context7-docs | `G/context7-docs` | `skills/tools/context7-docs` | C002: content drift |
| find-skills | `G/find-skills` | `skills/tools/find-skills` | C002: content drift; not invoked |
| gh | `G/gh` | `skills/tools/gh` | C002 normalized global mirror check: matches; not invoked |
| living-docs-governance | `G/living-docs-governance` | `skills/patterns/living-docs-governance` | C002 normalized global mirror check: matches |
| readme | `G/readme` | `skills/workflows/readme` | C002: content drift; not invoked |
| terminal-ops | `G/terminal-ops` | `skills/tools/terminal-ops` | C002: content drift |
| writing-for-agents | `G/writing-for-agents` | `skills/meta/writing-for-agents` | C002: content drift; not invoked in intake |

- Disk-only observation: `.pi/skills/code-review` exists but is not in the model-visible list; it is not a requested stage. `tdd` is absent from both `.pi/skills/` and `G/tdd`. Do not infer runtime availability solely from these filesystem observations.
- Duplicate names / competing owners: **UNPROVEN** across all enabled discovery sources. No implementation is allowed until the new session resolves this prerequisite.
- Dependency recovery at E004: not reached; no installation or configuration had changed. The E005 one-session command was only a proposal. E006 subsequently installs project copies with user approval; runtime recovery is still unobserved.
- Session handoff/recovery: not reached; no fresh session has started. No separate `session-handoff` Skill or temporary continuation file was requested. This canonical task record is the recovery pointer.

### Chronological events

| Event ID | Timestamp / foreground turn | Session / producer / phase | Input and source state | Output/evidence pointer | Next owner / stop point |
|---|---|---|---|---|---|
| E001 | `2026-09-07T07:14:03.714Z` / origin | S1 / user / admission | Proposal `7b376224` | Confirmation `36f87212`: `确认` | Admit this task to Pilot 1 only |
| E002 | `2026-09-07T07:16:18Z` / count recoverable from S1 | S1 / operator / preflight | Clean source/target at pinned HEAD | C001; actual inventory lacks `tdd` | Pause before TDD; do not edit implementation |
| E003 | Between E002 and E004; exact tool timestamps in S1 | S1 / operator / dependency recovery preparation | Installed Pi documentation and Context7 `/earendil-works/pi` | CLI recovery semantics confirmed; no Pi process launched | Prepare explicit canonical loading, not an installer |
| E004 | `2026-09-07T07:24:16Z` / checkpoint through `35b822c0` | S1 / operator / source and parity observation | Same clean source/target | C002; 15 foreground assistant entries through this checkpoint | Keep the dependency pause; this is not first RED |
| E005 | Subsequent record-writing tool timestamps in S1 | S1 / operator / recordkeeping | C002 unchanged implementation | Create this record and update only protocol status/navigation | User starts a new session; new operator rechecks prerequisites |
| E006 | Approval `2026-09-07T08:26:03.638Z`; installation `2026-09-07T08:29:44Z` | S1 / user and operator / dependency installation | User entry `04952957`: `我觉得可以直接安装到项目里` | Three project symlinks installed; see the project-installation update below | Restart/recheck remains required; no TDD phase started |

These events append intake observations, not fabricated executions. Continue the event IDs on recovery; preserve this pause and the original measurement origin.

### Command and observation evidence

#### C001 — baseline and actual dependency availability

- Owner: operator records prerequisites; no implementation readiness verdict is issued.
- Claim/scope/source IDs: establish source/target identity and identify missing session dependency; no task REQ/INV/AC IDs.
- Method from the repository root: `git branch --show-current`, `git rev-parse HEAD`, `git status --short`, `git diff --stat`, `git diff --cached --stat`; inspect project Skill symlinks and relevant global directories; compare the active available-Skills list. Observe `pi --version` and whitelisted shell session metadata separately.
- Before/after: HEAD pinned above; status and both diffs empty. No command-created repository artifacts. CLI documentation research and session-counter scratch files stayed outside the repository.
- Result: commands completed with exit 0; branch `main`, clean state, and no active `tdd`. Filesystem presence is not the availability test.
- Full evidence: S1 tool results between E001 and E004. Timestamped source/content/measurement checkpoint is assistant entry `00477d93` and its following tool result.
- Freshness: intake evidence only. The next session must recheck state, skill identity, enabled sources, and parity.

#### C002 — fresh source/mirror observation, not task success

- Owner: operator records repository output; `verification` has not assessed the implementation.
- Method: `scripts/validate.sh` from the repository root, at `2026-09-07T07:24:16Z`, with `git status --short` immediately before and after.
- Prerequisites/state: same clean HEAD as C001. This is before E005 documentation writes.
- Exit/output: **0**; `RESULT: 0 failure(s), 5 warning(s)`. Project mirrors match; global mirrors report `8 mirrored, 5 drifted`. Drift names: writing-for-agents, context7-docs, find-skills, terminal-ops, readme.
- After: still clean; no repository mutation. Full output is the tool result following S1 entry `35b822c0`.
- Freshness/limit: valid for that source/mirror observation. The validator's known delimiter detection gap still exists; its success does **not** prove this task fixed. Rerun structural checks after E005 document writes stop; the resulting session report is separate from implementation readiness.

#### Upstream diagnosis — pre-invocation screening, not TDD RED

The same session's tool output before proposal `7b376224` records the actual malformed `prototype/SKILL.md`, validator exit 0, and `frontmatter_block` consuming `# Prototype` as frontmatter. The well-formed `tdd/SKILL.md` control stops before its Markdown body. The localized cause is an EOF path that never requires a closing delimiter; name/description checks can therefore pass despite that boundary defect. No source changes or instrumentation remained after screening.

Reuse that cause only after matching the pinned inputs. Its diagnosis failure is not this Pilot's first TDD RED. The next owner must write and run a regression through the validator CLI, observe the intended failure, and only then change behavior.

### Seven metrics

- First useful RED: **not reached: missing active `tdd`**. Origin and first foreground entry are fixed above. No RED timestamp, elapsed-to-RED value, or final turn count exists yet. The 15-entry E004 snapshot is not a final count.
- Unnecessary questions/artifacts: none observed through E004. No task shaping/spec/plan/tickets were produced. This record, protocol status write, CLI documentation lookup, and session-counter scratch script are disclosed as preparation/recordkeeping overhead, not lane-created implementation artifacts.
- Rejected/stale handoffs: no downstream implementation handoff occurred. Dependency admission was stopped before TDD; installed-file presence was not treated as active capability.
- Duplicate conclusions/gate tables: none observed through E004. No TDD, implementation verification, or review conclusion has been produced.
- Boundary context usage: unavailable: the intake did not expose a reliable per-boundary context percentage. Recovery cost is not yet observable; the next session must read this record and recheck prerequisites.
- Post-readiness defects: not reached: no implementation readiness claim exists. The original defect is known before the Pilot, not a post-readiness discovery.
- Manual owner corrections: none observed through E004. The user's confirmation is authorization, not an owner correction.
- Timing limitations: count each foreground `role=assistant` entry on the active session branch from the confirmation, including assistant entries containing tool calls, excluding tool-result messages and subagents. S1 had 15 through entry `35b822c0`; intake documentation continues after that checkpoint. Recover the final S1 count from its retained transcript before summing S2. No subagents were launched for this intake. Disclose the subsequent restart/human wait; do not silently subtract it or restart the clock.

### Owner artifacts and recovery

- Verification: not reached: no implementation or TDD evidence exists. `verification` remains the sole final implementation owner.
- Review: not requested for this bounded local validator repair; reassess only if the eventual diff raises the risk.
- Pilot-specific evidence: real request, known-cause CLI behavior, and the dependency stop above. No fresh-session success has been observed.
- Correction/rerun ledger: none. Append a new attempt for a relevant operating Skill/protocol-method change; do not erase S1's pause. `prototype` is the target of the repair, not a Skill loaded to operate this lane.
- Stale/superseded evidence: pre-commit preparation checks do not establish this task's implementation result. C002 predates E005 document writes and is not their final structural gate.

### Invariants and disposition

| Protocol invariant | PASS / FAIL / UNPROVEN | Observation and evidence pointer |
|---|---|---|
| 1 — one behavior contract when needed | PASS at intake | E001 is a clear bounded request; no unnecessary spec was created |
| 2 — one plan when needed | PASS at intake | No task decomposition is needed; campaign plan remains a campaign artifact |
| 3 — one final verification state per unchanged target state | UNPROVEN | Implementation and final verification are not reached |
| 4 — no Matt workflow duplicate in installed Skills | UNPROVEN | All enabled-source/duplicate checks and recovery inventory are not yet complete |

- Started: `2026-09-07T07:14:03.714Z`; TDD paused on missing dependency at E002. Documentation preparation continues during that pause; actual human wait starts after the session's final response.
- State history: eligible at E001; prerequisite inspection only; recorded after E002. **No transition to running implementation is claimed.**
- Current disposition: **recorded**, dependency recovery required. Not accepted and not invalidated merely because the dependency is missing.
- Lane verdict: **not reached: TDD and final verification have not run**.
- Reviewer: same S1 operator records the prerequisite pause using C001/C002; no independent acceptance is implied.
- Unresolved blockers / next actor: project installation is complete at E006; the user restarts Pi and the next operator proves actual availability, directory parity, and lack of competing owners before invoking TDD. Use the current project-installation recovery note below.
- Residual limits: no behavior change, behavioral regression, first RED, GREEN, final implementation gate, or restart recovery has been observed. Initial active global-copy drift is retained as an observation, not hidden by the project installation.

### Superseded proposal — one-session dependency recovery

The E005 proposal below was not executed. The user chose project-local installation at E006 instead; retain the proposal as history, not the current next action.

The installed Pi `0.85.1` README and `docs/skills.md`, cross-checked with [upstream Skills documentation](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md), support explicit repeatable `--skill` paths with `--no-skills`. This is the temporary trial allowed by [ADR 0002](../adr/0002-self-install-skills-with-recommended-bundles.md), not a repository launcher, installation mechanism, or permanent profile.

Exit the current Pi process and run this once from a shell. Do not run a second writing session concurrently in the same checkout:

```bash
cd /home/LiYu/code/rinco-pi/rinco-pi-skills-commands
pi --no-skills \
  --skill skills/workflows/tdd \
  --skill skills/workflows/verification \
  --skill skills/workflows/systematic-debugging \
  --skill skills/patterns/codebase-design \
  --skill skills/patterns/coding-standards \
  --skill skills/tools/terminal-ops \
  --skill skills/meta/writing-for-agents \
  '继续已确认的 Pilot 1：先读 docs/pilots/1-frontmatter-closing-delimiter.md，核对实际可用 Skills、源版本、工作区与同名冲突，追加恢复事件；满足前提后按 tdd → verification 修复校验器。保留原计时起点，不把旧诊断算作 TDD RED；不提交、不推送。'
```

The intended source directory tree IDs at the pinned commit are: tdd `ccbf421d81c56034017e9cc5cf86d42df3af312c`; verification `bf8e0cece5102b9b30ae896e5c7911fbf5d01583`; systematic-debugging `66f5517ff84d54d8a1e1ec8c2b6a750cf379a2ca`; codebase-design `a1d951366bbcaa1fc744015b1387aabbccc1efd4`; coding-standards `89e1d2195ac08188a1fa43c58be1f64624423e2e`; terminal-ops `edf993226497c60a64cc7832c818c2d5376815ff`; writing-for-agents `317f2b300709ff6483cdb9ba397b5ea903880012`.

At E005, the proposed recovery check allowed only the record and protocol status edits. It was not executed. E006 extends the known target changes to include the three project symlinks below; the operating Skill contents and protocol method remain pinned.

### Project-local installation update — E006

- Authorization: user entry `04952957` at `2026-09-07T08:26:03.638Z` explicitly prefers installation into this project. This extends E001's permissions for project-local Skill installation only; no global install, configuration, implementation, commit, or push action was performed.
- Installation observed at `2026-09-07T16:29:44+08:00`, from the target repository root, with three guarded `ln -s` operations:
  - `.pi/skills/tdd` → `../../skills/workflows/tdd`;
  - `.pi/skills/terminal-ops` → `../../skills/tools/terminal-ops`;
  - `.pi/skills/writing-for-agents` → `../../skills/meta/writing-for-agents`.
- Existing `verification`, `systematic-debugging`, `codebase-design`, and `coding-standards` project links already point at their canonical directories and were left untouched. Symlinks include the reference files without copying or forking the source.
- Before: the record was untracked and `PROTOCOL.md` had its status edit. After: those same paths plus the three untracked symlinks. `scripts/validate.sh` and the target `prototype/SKILL.md` retain the content identities recorded at intake. No unrelated work was removed.
- Read-only discovery evidence: the installed Pi `0.85.1` `loadSkills` function was called with `cwd` equal to this repository, `skillPaths: [".pi/skills"]`, and `includeDefaults: false`. It returned 10 project Skills and zero diagnostics; all seven intended partners are present and model-invoked. This only checks filesystem discovery; it neither starts a new Pi/model session nor changes S1's active inventory.
- Same-session evidence: the guarded installation command/output and the following authorization/loader inspection remain in S1 after entry `04952957`. Each command exited 0. No separate dependency installer or launcher file was created.
- Measurement continuity: retain the original E001 origin. The installation preference is not an owner-boundary correction, a fresh Pilot invocation, a TDD RED, or successful runtime recovery. S1 now contains additional foreground entries beyond the earlier 15-entry snapshot.

For the formal Pilot, start with only the project installation so unchanged global same-name copies cannot compete. Exit the current Pi process first, then run from this repository:

```bash
pi --no-skills --skill .pi/skills \
  '继续 Pilot 1：读取 docs/pilots/1-frontmatter-closing-delimiter.md，完成新会话依赖与工作区检查后按 tdd → verification 执行；保留原计时起点，不提交、不推送。'
```

This is a one-session discovery choice over the installed project directory, not a permanent profile or configuration change. On recovery, preserve both documentation edits and all three installation links, compare actual loaded directories/references to the pinned source, inspect for any additional mutations or collisions, and append the observed session/recovery event. Do not mark the attempt accepted from installation or the offline loader check alone.

### S2 recovery — E007 (Attempt 1 resumes)

- Session: `01a07b04-973e-7537-ab17-2df529428c8c`, transcript `/home/LiYu/.pi/agent/sessions/--home-LiYu-code-rinco-pi-rinco-pi-skills-commands--/2026-09-07T08-38-13-566Z_01a07b04-973e-7537-ab17-2df529428c8c.jsonl`. User requests continuation of this record; original E001 clock remains in force.
- Recovery observations at `2026-09-07T08:41:34Z`–`08:42:59Z`: same source/target root, branch `main`, HEAD `82a107c0830c02d89766d91d39d70e5b6d388866`. Target fingerprints still match intake. Status contains only `M docs/pilots/PROTOCOL.md` and the four expected untracked paths (this record and the three E006 symlinks). Staged diff empty. Protocol diff changes status only; no execution-method change. `git diff --exit-code HEAD -- skills` exits 0; no untracked canonical Skill files. Resume the original attempt, not a new source revision.
- Actual session inventory: nine model-visible names, all at `R/.pi/skills/<name>`: codebase-design, coding-standards, domain-modeling, plan, systematic-debugging, tdd, terminal-ops, verification, writing-for-agents. Each symlink resolves to its canonical directory in the S1 table or E005 source list. All seven operating directory tree IDs, including references, match the pinned commit. Domain-modeling tree: `bdf813850e1759d9fe5dfbaed34b691e9836fd41`; plan tree: `3775af25be7aac202d7362d4ae2a741c6ddd9b4b`.
- Active discovery authority: the user confirms `pi --no-skills --skill .pi/skills` in the S2 structured-question response. This confirmation was necessary because process argv exposes only `pi`; it is not independent CLI-flag instrumentation. Global and `.agents` disk candidates exist but are excluded by that invocation. No duplicate active names or competing Matt workflow owners. Disk-only project code-review remains outside the model-visible inventory and is not invoked.
- Pi `0.85.1`; environment reports `openai-codex` / `gpt-6-astra`. No dependency, installation, configuration, or operating-Skill edits in S2. Canonical pointer recovery succeeded; context percentage unavailable because no boundary telemetry is exposed.
- TDD accepts the known-cause handoff: target byte identities match, and source inspection confirms `frontmatter_block` reaches EOF without requiring a close. Old diagnosis/C002 is not RED or final verification.
- Focused command pinned **before first use**: `bash scripts/test-validate.sh`, from `R`. The minimal new Bash harness will copy the real CLI into a temporary Git repository with one valid Skill and README inventory, prove the control exits 0, then require an unclosed block to exit 1 with a closing-delimiter diagnostic. Temporary HOME isolates informational global mirrors; cleanup removes only the harness-owned temporary directory. No dependencies or commits.
- Independent oracle: E001's confirmed behavior requires a standalone closing delimiter; `description: ...---` is not one. Public seam: executable CLI, not sourced/private awk functions. Broader gates handed to verification: `scripts/validate.sh`, `bash -n scripts/validate.sh scripts/test-validate.sh`, `git diff --check`, and final change-integrity inspection. No build/type/coverage system or nearby tests found; `scripts/validate.sh` is the sole existing script.
- Transition: prerequisite pause → running TDD. Next owner: TDD, then verification. Record exclusion remains only this file; protocol status and all implementation/test/install paths stay in scope.

### TDD observations — E008–E010

- **E008 / C003, first useful RED:** `2026-09-07T08:46:49Z`; `bash scripts/test-validate.sh` exits **1**. Valid control passes. Unclosed fixture incorrectly exits **0**, with `RESULT: 0 failure(s), 0 warning(s)`; test reports `expected exit 1 and diagnostic "skills/tools/example/SKILL.md: frontmatter missing closing delimiter"; got exit 0`. This is the expected behavioral failure, not setup or syntax failure. S2 tool-result entry `92e241cb` at `08:46:49.094Z` retains full output.
- RED before/after: identical status to E007 plus untracked `scripts/test-validate.sh`; production hashes remain `72efc0721d99516670ecf535cf5628fc4f501252` and `ab7fac864969797182b5890eb79d49fe2bba5db3`. Test hash `217bc9b6224a00baba4076b1c1f2bbcbcaab6ab7`. No command-created worktree mutation.
- **E009 / C004, GREEN:** after RED, add a `closed` flag and EOF exit status to `frontmatter_block`; gate promoted frontmatter before reading fields. Repair only the newline before the prototype closing delimiter. At `2026-09-07T08:47:16Z`, the **same command** exits **0**, both original tests pass. Production hashes: validator `6993515eb1254e2097252d5a5390140533edaf85`; prototype `cc7277cbca44d269a43244f04a9f5e52963fb333`. Test hash unchanged from RED. No local refactor needed; no assertions weakened.
- **E010 / C005, final affected tests:** add characterization for plain EOF without any close, and existing acceptance of a closing line with trailing whitespace at EOF without a final newline. No further production edit. At `2026-09-07T08:47:43Z`, `bash scripts/test-validate.sh` exits **0**, four `PASS` lines. Final test hash `7b7de944fda975b735245223642385a58e71df1d`; production hashes unchanged from C004. These extra cases are post-GREEN boundary checks, not additional claimed RED cycles.
- C004/C005 before and immediately after: `M docs/pilots/PROTOCOL.md`, `M scripts/validate.sh`, `M skills/workflows/prototype/SKILL.md`; untracked E006 links, this record, and `scripts/test-validate.sh`. Hashes unchanged around each command. No fixture residue; no snapshots, skips, retries, dependencies, or coverage exclusions.
- **TDD handoff:** source IDs none; originating behavior is E001. CLI seam proves valid acceptance, malformed rejection, and boundary compatibility. Reuse C005 only for the unchanged implementation/test state. Broader gates not yet run; next owner is verification. No resilience, migration, generated output, build, type, or configured coverage/scanner surface is affected. Code review remains not requested; narrow local parser guard and mechanical delimiter repair do not add a new risk requiring a separate review stage.
- **Recordkeeping after TDD:** protocol status updated to reference actual recovery/RED/GREEN rather than the superseded restart pause; this record appended. Both changes are disclosed; only this record is excluded from implementation evidence. No operating-Skill method changed, so Attempt 1 continues.

### S2 close — E011–E013

#### Owner evidence and state binding

- **E011 / C006, verification:** required gates ran at `2026-09-07T08:49:49Z`–`08:49:50Z`. The sole owner report is S2 assistant entry `7df69966` at `08:50:51.037Z`, titled `Verification Report`; full gate output is S2 tool-result `332b4291`. Consult that report for the gate table and implementation **READY** result; this record does not issue another verification verdict.
- Verification reused C005 for the unchanged CLI/test claim. Missing gates `bash -n scripts/validate.sh scripts/test-validate.sh`, `scripts/validate.sh`, and `git diff --check` each exited **0**. Structural summary: `RESULT: 0 failure(s), 5 warning(s)`; same five global-mirror warnings as C002, `8 mirrored, 5 drifted`. They are informational and excluded from S2 discovery, not hidden prerequisites.
- Before and immediately after **each** gate: the eight-path state listed at C005; no gate-created artifacts. Whole tracked implementation patch fingerprint is `46897da9e770cdc545c1d16d1ccf5f2d954fbf33`, calculated with `git diff --binary HEAD -- . ':(exclude)docs/pilots/1-frontmatter-closing-delimiter.md' | git hash-object --stdin`. Untracked test hash remains `7b7de944fda975b735245223642385a58e71df1d`; all three untracked symlink targets remain exactly E006. Prototype/validator identities remain C004. Rechecked at `08:50:51Z` before record closure.
- Direct change-integrity inspection confirms the local validator guard, mechanical delimiter newline, final regression file, and status-only protocol edit; no operating-owner or invocation change. Both modified pilot documents' relative link paths resolve (read-only Node check at `08:50:17Z`). An auxiliary `git diff --no-index --check /dev/null scripts/test-validate.sh` returned **1**, with no output: the no-index comparison identifies a newly added file; no whitespace diagnostic was emitted. This auxiliary comparison is not substituted for the required passing `git diff --check` gate.
- Scope: all changes relative to pinned HEAD, including protocol status, test, prototype repair, and E006 install links; exclude only this reserved record. No review artifact. No dependency/configuration/lockfile mutations, commits, pushes, or global installs. A structural gate is not a claim that this script fully validates YAML; existing parsing and opening-line policy remain unchanged.

#### Seven metrics at close

1. **First useful RED:** origin `2026-09-07T07:14:03.714Z`; observed result `2026-09-07T08:46:49.094Z` (UTC). Elapsed **5,565.380 seconds = 1h 32m 45.380s**. **67 foreground assistant entries** through RED: S1 **45** from confirmation `36f87212` through final entry `0f8ff90b`; S2 **22** through C003. Computed by reading retained JSONL, following `parentId` from the current branch leaf, and counting `message.role === assistant`; exclude tool results and subagents. S1's earlier 15-entry checkpoint is superseded only as a count. No subagents used. Includes dependency pause, documentation/installation work, all intervening human wait, and restart; nothing subtracted. The visible final-S1-response to S2-user-request gap is `08:37:45.379Z` → `08:40:39.528Z` (2m 54.149s), not a measurement of every earlier human pause.
2. **Unnecessary questions/artifacts:** no unnecessary shaping/spec/plan/tickets or lane artifacts observed. S2 asked one prerequisite question because process argv could not prove isolated discovery; the user's confirmation resolved it. Recordkeeping overhead includes repeated source/Skill reads, inventory/fingerprint checks, transcript counting, protocol status edits, this record, and one no-op record edit that made no change. These are disclosed rather than counted as implementation output. The sole new implementation artifact is the focused Bash regression.
3. **Rejected/stale handoffs:** S1's missing TDD correctly stopped admission. C002 was not reused as fix evidence; pre-invocation diagnosis was not counted as RED. C004 was superseded by C005 after boundary-test additions; verification reused C005 for its exact unchanged behavioral scope and ran missing broad gates. No incorrectly accepted stale handoff observed.
4. **Duplicate conclusions/gate tables:** none observed. The single S2 verification report owns final implementation readiness. TDD owns RED/GREEN only; this record points to the report. A final record-only structural recheck is required by protocol, not a second implementation owner.
5. **Boundary context usage:** unavailable: no reliable context-share telemetry at recovery or the TDD → verification boundary. Qualitative recovery cost: read canonical task/protocol and owner references, recheck worktree/parity/discovery, ask one launch-mode confirmation. Canonical handoff recovered without creating a parallel continuation document.
6. **Post-readiness defects:** none observed through `2026-09-07T08:50:51Z` inspection cutoff. The original unclosed block predates readiness. No future defect-free guarantee is made; final record-only gate output follows this write in S2.
7. **Manual owner corrections:** none observed through that cutoff. E006's installation preference is authorization; S2's launch answer is prerequisite confirmation, neither a correction of phase ownership. No repeated correction or safety-critical ownership violation was observed.

#### Campaign acceptance observation — E012

Reviewer/operator: the same foreground S2 agent that executed the lane; no independent human or code-review acceptance is implied. At the `2026-09-07T08:50:51Z` state checkpoint, the resumed task has actual CLI RED/GREEN, current owner verification, complete metrics, and the following invariant evidence:

| Protocol invariant | Result | Evidence |
|---|---|---|
| 1 — one behavior contract when needed | PASS | E001 remains the only task behavior authority; settled bounded request needed no spec |
| 2 — one plan when needed | PASS | No task plan/decomposition created; the campaign plan is not a task plan |
| 3 — one final verification state per unchanged target state | PASS | S2 owner report `7df69966`; same-state C005 reuse and C006 broad gates |
| 4 — no Matt workflow duplicate in installed Skills | PASS | E007 actual nine-name project inventory, pinned directory parity, user-confirmed project-only discovery; global candidates disabled |

- Current disposition: **accepted — Pilot 1, Attempt 1**, resuming rather than erasing the S1 prerequisite pause. State history: eligible → prerequisite pause/recorded → running TDD → recorded execution → accepted.
- Lane verdict: **lane kept as designed**. The dependency gate stopped S1 honestly; fresh-session recovery admitted TDD only after confirmation; verification alone issued final readiness. No claim of measured improvement over another workflow or baseline.
- Remaining campaign work: Pilots 2–4 need real tasks. No aggregate `RESULTS.md`, portfolio completion, release readiness, or general composition-validation claim. No user action to commit/push is implied.
- Residual limits: local Bash/Git CLI coverage only; no independent code review, full YAML parser audit, cross-platform matrix, or numerical coverage threshold. Global mirror warnings remain unchanged and inactive. Source operating Skills/protocol method remain at the pinned commit; the repaired prototype is target content, not an operating Skill for this attempt.

#### Final record-only write — E013

This close section and the top disposition pointer are the only post-owner-report mutations. Preserve all earlier observations. Recheck the implementation patch fingerprint, untracked test hash, and E006 link targets against C006, then run `scripts/validate.sh` and `git diff --check` after this write with status before and immediately after each command. Also inspect this untracked record's whitespace and local link paths. The ensuing S2 tool output and final response own that final-document check result; no unexecuted result is claimed in this paragraph. If it fails or exposes another mutation, append a correction and reopen the affected disposition rather than leaving this acceptance unqualified.
