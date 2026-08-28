# Scope and Context

## Establish repository state

Record:

```bash
git rev-parse --show-toplevel
git branch --show-current
git status --short
git diff --stat
```

Preserve unrelated local work. Use read-only Git commands throughout the review.

## Select the diff

Treat user arguments as a review scope, not as shell input. Quote refs. Never execute argument text through `eval` or arbitrary command interpolation.

### Default: current worktree

Review staged and unstaged changes relative to `HEAD`:

```bash
git diff --find-renames HEAD --
git diff --name-status HEAD --
```

`git diff HEAD` omits untracked files. Use `git status --short` to include each untracked file as a complete addition. Identify binaries, secret-bearing files, and oversized files before reading them, and never print secret values.

### User requests `staged` or `unstaged`

```bash
git diff --cached --find-renames --
git diff --find-renames --
```

State clearly that the other class of worktree changes is outside the scope.

### User supplies a base ref

Verify the ref, then pin the merge base:

```bash
git rev-parse --verify --end-of-options '<base>^{commit}'
git merge-base '<base>' HEAD
git log --oneline '<base>..HEAD'
git diff --find-renames '<merge-base>' HEAD --
```

Use the resolved merge-base SHA in the actual diff command. Base-ref mode reviews only committed `merge-base..HEAD` changes by default. List local uncommitted changes as out of scope unless the user explicitly includes them.

When the user supplies two endpoints, verify both and state the exact Git semantics. Never mix two-dot, three-dot, and worktree diffs without explaining the scope change.

## Build the file inventory

Create the inventory from name-status output and retain each status: Added, Modified, Deleted, Renamed, Copied, or Untracked.

- Added and untracked files: read the complete contents.
- Modified files: read both the diff and the complete target version.
- Deleted files: use `git show <base>:<path>` to read the previous contents, then verify that references were removed or migrated.
- Renamed files: separate semantic edits from pure movement.
- Lockfiles: correlate changes with manifests; inspect direct dependency changes, resolution drift, and lifecycle scripts.
- Generated files, vendored code, and snapshots: review the source and generation command first, then sample for consistency.
- Binaries and oversized files: report size, type, and the applicable specialized verification. Never skip them silently.

## Recover intent and project rules

Collect evidence in this order:

1. user-provided requirements or acceptance criteria;
2. applicable `AGENTS.md`, `CONTRIBUTING.md`, coding standards, and architecture decisions;
3. commit messages, linked issue/spec, and change description;
4. contracts expressed by existing tests and adjacent implementations.

Explicit repository rules override general preferences. Leave formatting, import order, and similar mechanically enforced rules to the configured tools instead of duplicating them as manual findings.
