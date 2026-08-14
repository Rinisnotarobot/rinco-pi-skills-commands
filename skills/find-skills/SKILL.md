---
name: find-skills
description: 'Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. After downloading a skill, automatically applies Pi adaptation: tool mapping (Task/Glob/WebFetch/TodoWrite → Pi tools), frontmatter fixes, and stripping harness-specific machinery. Use when the user is looking for functionality that might exist as an installable skill. 中文触发:找skill、搜索技能、安装技能、下载技能。'
---

# Find Skills (Pi-first)

This skill helps you discover and install skills for Pi from the open agent skills ecosystem. Pi implements the [Agent Skills standard](https://agentskills.io/specification), so any standard-compliant `SKILL.md` works — but always verify Pi compatibility before recommending.

## When to Use This Skill

Use this skill when the user:

- Asks "how do I do X" where X might be a common task with an existing skill
- Says "find a skill for X" or "is there a skill for X"
- Asks "can you do X" where X is a specialized capability
- Expresses interest in extending Pi's capabilities
- Wants to search for tools, templates, or workflows
- Mentions they wish they had help with a specific domain (design, testing, deployment, etc.)

## Where Pi Loads Skills From

Pi discovers skills at startup from:

- Global: `~/.pi/agent/skills/` and `~/.agents/skills/`
- Project: `.pi/skills/`, or `.agents/skills/` in `cwd` and ancestors (project must be trusted)
- Packages: `skills/` directories or `pi.skills` entries in `package.json`

A skill is a directory containing `SKILL.md` with YAML frontmatter (`name` + `description`). After installing a skill, Pi needs a **new session** (or the skill must be loaded explicitly) to pick it up.

## How to Help Users Find Skills

### Step 1: Understand What They Need

When a user asks for help with something, identify:

1. The domain (e.g., React, testing, design, deployment)
2. The specific task (e.g., writing tests, creating animations, reviewing PRs)
3. Whether this is a common enough task that a skill likely exists

### Step 2: Prefer Pi-Native Sources

Check **Pi-oriented sources first**, then the general ecosystem:

- `badlogic/pi-skills` — the primary Pi skills repository (web search, browser automation, Google APIs, transcription, and more)
- https://skills.sh/ — the open Agent Skills ecosystem registry and leaderboard (ranks skills by installs; skills from any harness work if they follow the Agent Skills standard)

### Step 3: Search for Skills

The Skills CLI (`npx skills`) is the package manager for the open Agent Skills ecosystem:

- `npx skills find [query] [--owner <owner>]` — search by keyword, optionally scoped to a GitHub owner
- `npx skills add <package>` — install a skill
- `npx skills update` — update installed skills

Examples:

- User asks "how do I make my React app faster?" → `npx skills find react performance`
- User asks "can you help me with PR reviews?" → `npx skills find pr review`
- User asks "I need to create a changelog" → `npx skills find changelog`

### Step 4: Verify Pi Compatibility Before Recommending

**Do not recommend a skill based solely on search results.** Verify:

1. **Install count** — prefer skills with 1K+ installs; be cautious with anything under 100.
2. **Source reputation** — maintained sources (`badlogic/pi-skills`, `vercel-labs`, `microsoft`) are more trustworthy than unknown authors.
3. **GitHub stars** — treat a skill from a repo with <100 stars with skepticism.
4. **Standard compliance** — inspect the `SKILL.md` before installing:
   - Frontmatter has `name` and a specific `description` (trigger guidance)
   - No Claude Code-only machinery: `agents/` subagent definitions, `eval-viewer/` directories, hard-coded `~/.claude` paths, or instructions that assume Claude Code tools (`Task`, `Glob`, `WebFetch`, `TodoWrite`) exist
   - No hard-coded harness assumptions that Pi cannot satisfy (check the workflow steps)
   - Review any bundled `scripts/` for safety before running them

Skills that fail the Pi compatibility check are still installable: **adaptation is applied automatically after download** — see Step 6. The verdict only tells the user what to expect (ready / will be adapted / not recommended).

### Step 5: Present Options to the User

When you find relevant skills, present them with:

1. The skill name and what it does
2. The install count and source
3. The install command
4. A link to learn more at skills.sh
5. A Pi compatibility verdict (ready / will be auto-adapted after install / not recommended)

Example response:

```
I found a skill that might help! The "react-best-practices" skill provides
React and Next.js performance optimization guidelines from Vercel Engineering.
(185K installs)

Pi compatibility: ready (standard SKILL.md, no harness-specific machinery).

To install it:
npx skills add vercel-labs/agent-skills@react-best-practices

Learn more: https://skills.sh/vercel-labs/agent-skills/react-best-practices
```

### Step 6: Install for Pi

```bash
npx skills add <owner/repo@skill> -g -y
```

`-g` installs to `~/.agents/skills/` (the shared global location Pi loads), `-y` skips confirmation. If the skill installs to a non-Pi location, copy it into `~/.pi/agent/skills/` or add that directory to Pi's `skills` array in settings.

### Step 7: Auto-Apply Adaptation (必做,无需询问用户)

下载完成后**立即自动**按以下流程适配,不要停在“提醒用户”这一步。详细映射表见 skill-adapter 技能(`~/.pi/agent/skills/skill-adapter/`),必要时 read 它的 `references/tool-mapping.md` 与 `references/worked-example.md`。

1. **定位**:找到安装后的技能目录,`read` 其 SKILL.md,`ls` 看完整目录结构。
2. **红旗扫描**:查 `Task` 子代理、`Glob`/`Grep`、`WebFetch`/`WebSearch`、`TodoWrite`、`AskUserQuestion`、硬编码 `~/.claude`/`~/.codex` 路径、`agents/`、`eval-viewer/`、`.claude-plugin/` 目录。无红旗 → 跳过改写,直接进入第 7 步。
3. **工具映射改写**(edit SKILL.md):
   - `Task`/子代理 → 改为主代理分步执行;删除 `agents/` 目录
   - `Glob` → `bash` + `rg --files` / `find`;`Grep` → `rg -n`
   - `WebFetch`/`WebSearch` → 项目已配 MCP(context7-docs、gh 等)或 `curl`;都没有则改提示用户提供材料
   - `TodoWrite` → `todo` 工具;`AskUserQuestion` → `ask_user_question`
   - 硬编码 `~/.claude/...` → 技能目录内相对路径(如 `scripts/x.sh`)
4. **Frontmatter 修正**:
   - `name` 改小写字母/数字/连字符(≤64);缺 `description` 必须补(否则不加载)
   - `description` 补“做什么 + 何时用”,外文技能补中文触发词
   - 删 Claude 专用字段(`model`、`context` 等);核对 `allowed-tools` 里的工具名是 Pi 工具
5. **精简目录**:删 `eval-viewer/`、`.claude-plugin/`、`plugin.json` 等 harness 专属文件;单文件 `.md` 技能统一建目录放 `SKILL.md`。
6. **脚本安全检查**:`scripts/` 先 `read` 再决定是否运行;改后 `bash -n scripts/*.sh` 做语法检查。
7. **验证与交付**:
   - 确认 frontmatter 合法、引用文件真实存在(`ls` 核对)
   - 汇报给用户:适配前状态 → 做了哪些修改 → 最终结论(可直接用/已适配/不建议并说明原因)
   - 提醒**新会话生效**,或当前会话 `/skill:<name>` 测试
   - 若用户之前未同意安装,先给 verdict 再安装(见 Step 5);已同意安装则直接执行完上述全部步骤

## Common Skill Categories

When searching, consider these common categories:

| Category        | Example Queries                          |
| --------------- | ---------------------------------------- |
| Web Development | react, nextjs, typescript, css, tailwind |
| Testing         | testing, jest, playwright, e2e           |
| DevOps          | deploy, docker, kubernetes, ci-cd        |
| Documentation   | docs, readme, changelog, api-docs        |
| Code Quality    | review, lint, refactor, best-practices   |
| Design          | ui, ux, design-system, accessibility     |
| Productivity    | workflow, automation, git                |

## Tips for Effective Searches

1. **Use specific keywords**: "react testing" is better than just "testing"
2. **Try alternative terms**: If "deploy" doesn't work, try "deployment" or "ci-cd"
3. **Pi first**: Start with `badlogic/pi-skills`; for everything else, inspect each candidate for Pi compatibility before installation

## When No Skills Are Found

If no relevant skills exist:

1. Acknowledge that no existing skill was found
2. Offer to help with the task directly using your general capabilities
3. Offer to create a Pi skill for the recurring task — a directory with `SKILL.md` (frontmatter: `name`, `description`) placed in `~/.pi/agent/skills/<skill-name>/`, optionally with `scripts/`, `references/`, and `assets/`

Example:

```
I searched for skills related to "xyz" but didn't find any matches.
I can still help you with this task directly! Would you like me to proceed?

If this is something you do often, I can create a Pi skill for it:
~/.pi/agent/skills/my-xyz-skill/SKILL.md
```
