---
name: session-handoff
description: Explicit-only session compaction - serialize the current session into a handoff document for a fresh session, in the session-continuation format owned by living-docs-governance. Use ONLY when the user explicitly asks to hand off, compact, or package the session for continuation (交接 / 打包会话 / 会话交接 / handoff / session handoff). Not for phase-to-phase handoffs inside a lane - those belong to each workflow skill's own output contract.
disable-model-invocation: true
compatibility: Requires readable living-docs-governance format content at its installed location (it need not be pre-loaded). Terminal evidence commands come from terminal-ops.
---

# Session Handoff

Serialize the current session's state into a handoff document a fresh session can continue from. This skill is a thin serializer: the format, the field list, and the navigate-don't-duplicate rule are owned by `living-docs-governance` — this skill never restates, extends, or overrides them.

Explicit-only: the user asks for the handoff; never produce one speculatively at a session boundary.

## Workflow

### 1. Read the format from its owner

Resolve `living-docs-governance` from its location in the current session's discovered Skills. If it is reference-only and not discovered, look relative to the directory containing this `SKILL.md`: `../living-docs-governance/SKILL.md` for flat installations, or `../../patterns/living-docs-governance/SKILL.md` for the source layout. Use an existing file whose frontmatter names `living-docs-governance`; stop on conflicting copies rather than choosing silently. Never resolve these paths against the user's working directory or assume the source checkout is installed.

Read only its "Session continuation handoff" section as format content, not an instruction to start documentation governance. Serialize exactly the fields defined there. If the file or section is missing, report `BLOCKED` with the attempted paths. Ask the user to copy or repair the named format owner in the installation, then give a restart command using the actual installation paths. Preserve `session-handoff`, the next phase's owner, and its required dependencies; label a missing destination as requiring installation before that command can work. Do not substitute a checkout-relative example or reconstruct the format from memory.

Completion criterion: the field list being filled is the one currently in that file, not a remembered or invented one.

### 2. Gather evidence, not fields

For each field the owner's format names, gather from these sources:

- **Repository state** — branch, HEAD, and worktree status from `git` commands, never from conversation claims.
- **Artifacts this session produced or consumed** — specs, plans, tickets, reviews, verification reports; each referenced by path and the revision it was established against. Artifacts inherited from prior sessions count when this session consumed them.
- **Session facts** — the current owner and phase, open blockers and unresolved decisions verbatim, conclusions the session superseded, and the next explicit invocation.
- **The next session's startup** — resolve the next phase's owner and required execution/reference dependencies to the installed paths. Preserve the current owner when its workflow must resume. Keep an isolated session isolated: supply `pi --no-skills --skill <verified-path> ...` covering that set, not bare `pi` or source-checkout paths. A verified installed parent directory is usable when all its Skills are intended. If discovery provenance is unknown, prefer this explicit command; if a dependency is missing, label the installation prerequisite rather than claiming the command is already sufficient. Normal discovery is an option only after confirming the intended paths, trust, and absence of conflicting sources.

If the user passed an argument describing the next session's focus, use it to sharpen the next-invocation and startup entries; do not drop other fields.

Fill rules, in order of honesty: a value evidenced in the sources above; `none` when the field's honest value is an absence (no blocker, nothing superseded); `unresolved` when evidence is missing; `no repository` for the repository fields outside a git repository. Never guess and never leave a field blank.

Completion criterion: every field of the owner's format has one of these four fill values.

### 3. Write the document outside the repository

Write to the OS temporary directory - `$TMPDIR` when set, otherwise `/tmp` - never inside the repository or its docs. Filename: `handoff-<repo-name>-<short-HEAD>-<date>.md` (omit the HEAD part when there is no repository).

The document contains navigation, not content: artifact references are path plus revision; never copy an artifact's body into the handoff. Redact secrets, tokens, and personally identifying information before writing.

Completion criterion: the file exists outside the repository tree and every referenced path exists on disk at write time.

### 4. Report and stop

Report to the user: the handoff file's absolute path, the exact restart command for the next session, and any `unresolved` fields with what evidence would resolve them. Then stop. Starting the next session's work, fixing the unresolved fields, or touching repository files is downstream - not this skill's.

## Guardrails

- Never restate the handoff format - the field list lives only in `living-docs-governance`.
- Never write into the repository; the handoff dies with the session it describes.
- Never fill a field by inference - `none`, `unresolved`, and `no repository` are valid, honest values.
- Never copy artifact content - path and revision only.
- Never include secrets or personally identifying information.
- Never spawn or chain the next session - the user starts it with the reported command.
