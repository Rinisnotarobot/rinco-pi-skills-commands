---
description: GitHub CLI (`gh`) operations for issues, pull requests, workflow runs, reviews, or API queries, especially in restricted shells where structured output and fallback choice matter. You MUST load this skill when working with the `gh` command and its subcommands.
license: MIT
metadata:
    github-path: gh
    github-ref: refs/heads/main
    github-repo: https://github.com/Cogni-AI-OU/cogni-ai-agent-skills
    github-tree-sha: 759eb864c6e540c2c961a600a2e8967e2c741703
name: gh
---
<!-- markdownlint-disable MD013 MD023 MD031 MD032 -->
# gh

Use `gh` as a structured client first. Prefer native fields, explicit routing,
and bounded fallbacks over brittle shell post-processing.

## When to Use

- User asks to use `gh`, GitHub CLI, or to query GitHub from shell.
- Task involves issues, PRs, reviews, workflow runs, jobs, discussions, or GitHub REST endpoints.
- Execution is inside CI, Codespaces, or another restricted shell.

## Mindmap of Commands

```mermaid
mindmap
  root((gh))
    agent-task
      create
        Create an agent task
      list
        List agent tasks
      view
        View an agent task session
    alias
      delete
        Delete set aliases
      import
        Import aliases
      list
        List aliases
      set
        Create a shortcut
    api
      Make authenticated API request
    attestation
      download
        Download attestations
      trusted-root
        Output trusted root
      verify
        Verify integrity
    auth
      login
        Log in to a GitHub account
      logout
        Log out of a GitHub account
      refresh
        Refresh stored authentication credentials
      setup-git
        Set up Git with GitHub CLI
      status
        Display active account and authentication state
      switch
        Switch active GitHub account
      token
        Print the authentication token
    browse
      Open repositories, issues, PRs in browser
    cache
      delete
        Delete GitHub Actions caches
      list
        List GitHub Actions caches
    codespace
      code
        Open in VS Code
      cp
        Copy files
      create
        Create a codespace
      delete
        Delete codespaces
      edit
        Edit a codespace
      jupyter
        Open in JupyterLab
      list
        List codespaces
      logs
        Access codespace logs
      ports
        List ports
      rebuild
        Rebuild a codespace
      ssh
        SSH into a codespace
      stop
        Stop a codespace
      view
        View details
    config
      clear-cache
        Clear cli cache
      get
        Print value
      list
        Print keys/values
      set
        Update configuration
    extension
      browse
        UI for extensions
      create
        Create new extension
      exec
        Execute extension
      install
        Install extension
      list
        List extensions
      remove
        Remove extension
      search
        Search extensions
      upgrade
        Upgrade extensions
    gist
      clone
        Clone locally
      create
        Create new gist
      delete
        Delete a gist
      edit
        Edit a gist
      list
        List gists
      rename
        Rename a file in a gist
      view
        View a gist
    gpg-key
      add
        Add a GPG key
      delete
        Delete a GPG key
      list
        List GPG keys
    issue
      (Load gh-issue skill if required)
    label
      clone
        Clone labels
      create
        Create new label
      delete
        Delete a label
      edit
        Edit a label
      list
        List labels
    models
      (Load gh-models skill if required)
    org
      list
        List organizations
    pr
      (Load gh-pr skill if required)
    project
      close
        Close a project
      copy
        Copy a project
      create
        Create a project
      delete
        Delete a project
      edit
        Edit a project
      field-create
        Create a field
      field-delete
        Delete a field
      field-list
        List fields
      item-add
        Add item
      item-archive
        Archive item
      item-create
        Create item
      item-delete
        Delete item
      item-edit
        Edit item
      item-list
        List items
      link
        Link project
      list
        List projects
      mark-template
        Mark as template
      unlink
        Unlink project
      view
        View a project
    release
      create
        Create a new release
      delete
        Delete a release
      delete-asset
        Delete an asset
      download
        Download assets
      edit
        Edit a release
      list
        List releases
      upload
        Upload assets
      verify
        Verify attestation
      verify-asset
        Verify asset
      view
        View information
    repo
      archive
        Archive a repository
      autolink
        Manage autolink references
      clone
        Clone locally
      create
        Create a new repository
      delete
        Delete a repository
      deploy-key
        Manage deploy keys
      edit
        Edit settings
      fork
        Create a fork
      gitignore
        List gitignore templates
      license
        Explore licenses
      list
        List repositories
      rename
        Rename a repository
      set-default
        Configure default
      sync
        Sync a repository
      unarchive
        Unarchive
      view
        View a repository
    ruleset
      check
        View rules for branch
      list
        List rulesets
      view
        View information
    run
      (Load gh-run skill if required)
    search
      (Load gh-search skill if required)
    skill
      (Load gh-skill skill if required; GitHub CLI version v2.90.0 or later)
    secret
      delete
        Delete secrets
      list
        List secrets
      set
        Create or update secrets
    ssh-key
      add
        Add an SSH key
      delete
        Delete an SSH key
      list
        List SSH keys
    status
      Show work status
    variable
      delete
        Delete variables
      get
        Get variables
      list
        List variables
      set
        Create or update variables
    workflow
      (Load gh-run skill if required)
```

## When Not to Use

- For interacting with raw git mechanisms (use `git` instead).
- When a dedicated GraphQL client or specific SDK is better suited for a massive data synchronization task than CLI iteration.
- For non-GitHub version control platforms (e.g., GitLab, Bitbucket).

## Common Pitfalls

- **Paginating Endlessly**: Using `gh api` to fetch thousands of records without a `--jq` filter or `--paginate` limit, causing out-of-memory errors or API rate limits.
- **Shell Pipeline Brittleness**: Piping `gh` JSON output through `grep` and `awk` instead of natively querying with `--jq`, leading to broken scripts when GitHub's API response order shifts.
- **Interactive Hangs**: Running commands like `gh pr create` without the `--fill` or `--body` flags in a headless environment, causing the workflow to stall indefinitely waiting for a TTY editor.

## Core Process

1. Verify availability and auth first: `gh --version`, then `gh auth status`.
2. Choose the narrowest native `gh` surface before reaching for `gh api`:
   - `gh issue view/comment` for issues; see the `gh-issue` and `github-issue` skills
     for issue-specific guidance and runtime routing
   - `gh pr view/comment/review` for pull requests; see the `gh-pr` and `github-pr` skills
     for PR-specific guidance and runtime routing
   - `gh api` only when native subcommands do not expose the needed field
3. Prefer structured output over shell filtering:
   - use `--json`, `--jq`, or `--template` instead of `grep`/`rg`
   - use `gh api` for metadata, not ad hoc HTML scraping
4. Query the smallest object that answers the question:
   - issue metadata before comments
5. After each command, verify progress explicitly:
   - non-empty stdout or expected JSON field
   - no warning that changes command semantics
   - result actually answers the current question
6. If the same normalized command shape fails twice with the same warning,
   error, or empty result, pivot strategy instead of retrying.

## Structured Query Patterns

- Use `gh pr view <number> --json headRefName,baseRefName,commits` to extract PR commit history
  (e.g. for visualization to generate topology data like `mermaid` `gitGraph` diagrams without cloning explicitly)
- Prefer native JSON first:
  - `gh issue view <number> --json comments,number,title,state,author,url`
  - `gh pr view <number> --json number,title,state,reviewDecision,url`
  - `gh pr view <number> --json comments,reviews`
- Use `gh api` for objects that native subcommands do not expose cleanly (load `gh-api` skill for details).
- Use `--jq` or `--template` before external filters.

## Preferred Patterns

- Comment directly without touching workspace files:
  `gh issue comment <number> --body "..."`
- Reply through the originating GitHub surface:
  - issue thread -> `gh issue comment`; see `gh-issue` or `github-issue` for routing
  - pull request comment/review thread -> see `gh-pr` or `github-pr` for PR routing
  - inline review thread -> `gh api .../replies`
- For long comments, avoid heredocs which can cause hangs. Write to a temporary file and use `--body-file`:
  `gh issue comment <number> --body-file /tmp/comment.md`
- For GraphQL mutations with large bodies from files:
  `gh api graphql -f query='mutation($body: String!) { ... }' -F body=@file.md`
- For non-code-change tasks, verify workspace cleanliness after posting.

## GitHub Actions Runtime

For high-level routing guidance, response detection, workspace invariants, and branch sync policies
in GitHub Actions, refer to the **github-issue** and **github-pr** skills.

### GitHub Runtime Decision Policy

- **Default to Best Practice:** Implement the most recommended path autonomously when multiple options exist.
- **Document Trade-offs:** Capture unresolved decisions, explicit options, and impacts in the PR description.
- **Never Stall:** Proceed immediately with safe defaults. Request preference feedback in the PR instead of waiting.
- **Report Defensively:** Present recommended option first; list alternatives only if they alter scope or risk.

## Restricted Shell Rules

- In allowlisted shells, do not assume `grep`, `rg`, or complex pipelines are
  permitted just because `gh` is permitted.
- Prefer `gh --json/--jq/--template` over external text filters.
- Probe one command shape first before parallel fan-out.
- If a shell policy blocks a `gh`-adjacent command shape, classify it as
  `POLICY_DENIED` and pivot immediately.

## Failure Signatures

- Empty stdout from a supposedly successful `gh` query is a signal, not a
  success. Check whether the subcommand supports the requested mode in this
  environment.
- If a shell policy blocks a `gh`-adjacent command shape, classify it as
  `POLICY_DENIED` and pivot immediately.

## What to Avoid

- Do not use `-f` (`--raw-field`) when you intend to read a value from a file
  using `@`; always use `-F` (`--field`) for file expansion.
- Do not build `gh ... | grep ... | grep ...` chains as the default diagnostic
  path.
- Do not retry the same `gh` command shape after semantic warnings.
- Do not create temp files for comments or analysis when direct `gh`
  subcommands are available.

## Related Skills

- **gh-api**:
  You MUST load this skill when working with the `gh api` command.
- **gh-issue**:
  You MUST load this skill when working with the `gh issue` command.
- **gh-pr**:
  You MUST load this skill when working with the `gh pr` command.
- **gh-run**:
  You MUST load this skill when working with the `gh run` and the `gh workflow` commands.
- **gh-search**:
  You MUST load this skill when working with the `gh search` command.
- **gh-skill**:
  You MUST load this skill when working with the `gh skill` command.
- **gh-models**:
  You MUST load this skill when working with the `gh models` command.
- **github-issue**:
  You MUST load this skill when working with issues or when the runtime was triggered by an issue comment.
- **github-pr**:
  You MUST load this skill when working with changes associated with a pull request or when the runtime was triggered by a PR comment.
- **github-topics**:
  You MUST load this skill when searching for relevant tools, libraries, or curated resources.
