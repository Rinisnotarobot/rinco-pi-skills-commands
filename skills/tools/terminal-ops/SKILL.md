---
name: terminal-ops
description: Evidence-first repository execution workflow. Use when running commands, inspecting repository state, debugging failures, making narrow fixes, or verifying changes.
---

# Terminal Ops

Use this skill for repository tasks that require real command output, local changes, or verification.

## Core Workflow

### 1. Establish the working state

Confirm:

- repository path
- current branch
- local changes
- requested mode: inspect, fix, verify, or push

### 2. Inspect before changing

Read the error, relevant files, tests, logs, and Git state before editing. Preserve unrelated local work.

### 3. Make the smallest useful change

Address one dominant failure at a time. Start with the narrowest relevant command or test, and only expand verification after the immediate issue is resolved.

### 4. Verify the result

Rerun the proving command after changes. Do not claim a fix, commit, or push unless it actually succeeded.

### 5. Report the exact state

Clearly distinguish:

- inspected
- changed locally
- verified locally
- committed
- pushed
- blocked

Include the repository, branch, action taken, and verification command when relevant.
