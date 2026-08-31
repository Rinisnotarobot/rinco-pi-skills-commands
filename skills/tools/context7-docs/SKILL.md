---
name: context7-docs
description: Fetch current, version-aware documentation and examples with the ctx7 CLI. Use when a library/framework/SDK/CLI API, configuration, migration, or library-specific behavior may depend on current official docs; skip for general programming and repository-local logic.
license: MIT
compatibility: Requires the ctx7 CLI and network access.
---

# Context7 CLI documentation lookup

Use Context7 only when current external-library documentation would materially improve the answer.

## Workflow

1. If the user supplied a Context7 ID (`/org/project` or `/org/project/version`), skip resolution. Otherwise resolve it:

   ```bash
   ctx7 library "<official library name>" "<specific topic>"
   ```

2. Select the strongest match using name, relevance, source reputation, snippet coverage, and benchmark score.
3. Fetch documentation for one focused concept:

   ```bash
   ctx7 docs "<library-id>" "<specific question>"
   ```

4. Base library-specific claims and examples on the returned documentation. Mention the selected library ID or source links when useful.

## Guardrails

- Prefer precise, task-oriented queries; separate unrelated concepts.
- Resolve again only when results are clearly mismatched. Keep total Context7 commands to at most 3 per user question.
- Never place secrets, credentials, personal data, or proprietary source in a query.
- On quota/auth errors, report the issue and suggest `ctx7 login` or `CONTEXT7_API_KEY`; do not present stale memory as freshly verified docs.
- Do not invoke Context7 merely because a library is mentioned. Skip it for refactors, business logic, code review, repository-local behavior, and stable language concepts unless current external docs are actually needed.
