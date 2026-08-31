---
name: readme
description: Create, rewrite, audit, or update repository and GitHub profile README files. Use when a README must be grounded in the current project, when setup or usage documentation is stale, or when the repository landing page needs a clearer audience path.
metadata:
  version: 4.0.0
---

# README

Write the shortest README that lets its intended reader understand the project and reach a verified first success. Treat the repository as the source of truth; treat existing prose as a claim to verify.

## Workflow

### 1. Fix the scope

Determine:

- the requested operation: create, rewrite, update, or audit;
- the README path and whether it is a repository README or GitHub profile README;
- the primary audience and the action they should take next;
- the project archetype.

Read [`references/archetypes.md`](references/archetypes.md) when choosing an outline or handling a profile, internal, config, or curated repository. Ask the user only when the audience, scope, or desired outcome cannot be inferred from the repository or request.

**Gate:** state one primary audience, one desired next action, and one archetype before drafting.

### 2. Build an evidence ledger

Inspect the current README and the smallest set of authoritative project surfaces needed to support its claims:

- manifests, lockfiles, entry points, and package metadata;
- executable help, scripts, task runners, and CI configuration;
- examples, tests, screenshots, and deployed documentation;
- environment templates and configuration schemas;
- `LICENSE`, contribution guides, changelogs, and security or support policies.

Record each important README claim with its source and status: **verified**, **needs clarification**, or **omit**. Prefer current machine-readable configuration and successful command output over stale prose. Preserve useful existing content, links, and project voice.

**Gate:** every feature, prerequisite, command, compatibility statement, and status claim in the draft has repository evidence or explicit user confirmation.

### 3. Design the reader path

Lead with:

1. project name;
2. a direct statement of what it does and who it helps;
3. the shortest verified path to first success.

Add later sections only when they answer a real reader question. Link to canonical docs instead of duplicating their content. Keep architecture, API reference, operations, contribution policy, changelog, and license detail in their existing dedicated files when those files exist.

For profile READMEs or README-adjacent GitHub presentation such as About text and topics, read [`references/github-presentation.md`](references/github-presentation.md).

**Gate:** the outline puts the primary audience's first-success path before background and maintainer detail.

### 4. Draft from evidence

Use GitHub Flavored Markdown and the repository's established language and tone.

- Make headings descriptive and links explicit.
- Make setup commands copy-pasteable from a stated working directory.
- Explain placeholders, required credentials, and destructive effects before the command that uses them.
- Use examples that match real interfaces and current names.
- Add badges, screenshots, diagrams, tables, admonitions, and a table of contents only when they improve a reader decision.
- Give every meaningful image useful alt text.
- Mark unstable, experimental, generated, or platform-specific behavior precisely.

When evidence is missing, write a visible placeholder or ask for the fact; do not convert inference into documentation.

### 5. Prove the README

Run the narrowest available checks:

1. execute quickstart or usage commands when safe and practical;
2. verify relative links, referenced paths, image targets, and heading anchors;
3. run the repository's Markdown formatter or linter when configured;
4. compare the final diff against the evidence ledger;
5. reread only the rendered reader path: identity → value → first success → next steps.

If a command requires credentials, external infrastructure, payment, publishing, or destructive state, verify its syntax and prerequisites without performing the side effect. State that limitation in the report.

**Gate:** report each check as passed, failed, or not run with a reason. A README with unsupported claims or broken local references is not complete.

## Deliverable

Return:

- the README change or audit findings;
- the audience and archetype used;
- evidence inspected;
- checks run and their results;
- unresolved facts or unverified external steps.
