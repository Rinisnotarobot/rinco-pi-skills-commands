---
name: session-handoff
description: Explicit-only session compaction: serialize the current session into a handoff document a fresh session can continue from, written into the repository's wired handoff location, in the session-continuation format owned by living-docs-governance. Invoke when you want to hand off, compact, or package the session for continuation; not for phase-to-phase handoffs inside a lane.
disable-model-invocation: true
compatibility: Requires the living-docs-governance session-continuation format to be readable at one of the resolved locations below (it need not be pre-loaded).
---

# Session Handoff

Serialize the current session's state into a handoff document a fresh session can continue from. This skill is a thin serializer: the format, the field list, and the navigate-don't-duplicate rule are owned by `living-docs-governance` — this skill never restates, extends, or overrides them.

Explicit-only: serialize only when the user asks; never produce one speculatively at a session boundary.

## Workflow

### 1. Read the format from its owner

Resolve `living-docs-governance` from its location in the current session's discovered Skills. If it is reference-only and not discovered, look relative to the directory containing this `SKILL.md`: `../living-docs-governance/SKILL.md` — this repo's layout and flat installations both keep the two skills as siblings under one family folder, so the same relative path resolves either way. Use an existing file whose frontmatter names `living-docs-governance`; stop on conflicting copies rather than choosing silently. Never resolve these paths against the user's working directory or assume the source checkout is installed.

Read only its "Session continuation handoff" section as format content, not an instruction to start documentation governance. Serialize exactly the fields defined there. If the file or section is missing, report `BLOCKED` with the attempted paths and what would make the format readable. Never reconstruct the format from memory.

Completion criterion: the field list being filled is the one currently in that file, not a remembered or invented one.

### 2. Gather evidence, not fields

For each field the owner's format names, gather from these sources:

- **Repository state** — branch, HEAD, and worktree status from `git` commands, never from conversation claims.
- **Artifacts this session produced or consumed** — specs, plans, tickets, reviews, verification reports; each referenced by path and the revision it was established against. Artifacts inherited from prior sessions count when this session consumed them.
- **Session facts** — the current owner and phase, open blockers and unresolved decisions verbatim, conclusions the session superseded, and the next explicit invocation.
- **The next session's startup** — normal `pi` startup in the target project unless the user states an exception. Note any skill or tool the next phase needs and record it as `unresolved` when its availability cannot be verified. The continuation depends on artifact paths, revisions, evidence freshness, and the next invocation — not on remembered startup flags.

If the user passed an argument describing the next session's focus, use it to sharpen the next-invocation and startup entries; do not drop other fields.

Fill rules, in order of honesty: a value evidenced in the sources above; `none` when the field's honest value is an absence (no blocker, nothing superseded); `unresolved` when evidence is missing; `no repository` for the repository fields outside a git repository. Never guess and never leave a field blank.

Completion criterion: every field of the owner's format has one of these four fill values.

### 3. Write the live handoff into the repository

Write to the project's wired handoff location - the path the repo convention or `living-docs-governance` points to, default `docs/handoffs/current.md` (create `docs/handoffs/` when the repository has no docs convention). Prefer a tracked file so a fresh session or clone can find it; if a different live-handoff path is already wired, follow that existing convention instead of creating a competing one. The file is a live slot: overwrite the previous handoff, never accumulate dated copies.

The document contains navigation, not content: artifact references are path plus revision; never copy an artifact's body into the handoff. Redact secrets, tokens, and personally identifying information before writing.

Completion criterion: the file exists at the wired path inside the repository and every referenced path exists on disk at write time.

### 4. Report and stop

Report to the user: the handoff file's path, the target project directory, normal `pi` startup (or an explicit user-requested exception), the next invocation, and any `unresolved` fields with what evidence would resolve them. Point out the startup signpost that should let a fresh session find the file by itself (ask `living-docs-governance` to wire it into the harness when it is not yet wired); do not assume the next session inherits this conversation. Then stop. Starting the next session's work, fixing the unresolved fields, or touching anything but the handoff file is downstream - not this skill's.

## Guardrails

- Never restate the handoff format - the field list lives only in `living-docs-governance`.
- Write only the live handoff at the wired repo path - never to `/tmp`, never a second copy, never a dated pile. The slot is superseded when the next session consumes the work or completes it.
- Never fill a field by inference - `none`, `unresolved`, and `no repository` are valid, honest values.
- Never copy artifact content - path and revision only.
- Never include secrets or personally identifying information.
- Never spawn or chain the next session - the user starts a fresh session in the project, where the wired startup signpost points it at the handoff file.
