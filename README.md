# Rinco Pi Skills & Commands

面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程 Skills 集合：用**单一所有者、无环交接和新鲜证据**连接需求、计划、实现、验证与评审。

[快速开始](#快速开始) · [推荐套装](#推荐套装) · [Skills 目录](#skills-目录) · [设计原则](#设计原则) · [参与维护](#参与维护)

> [!IMPORTANT]
> 项目仍在建设中，尚未提供统一的安装、升级或发布机制，也不会自动修改用户的 Pi 全局配置。`skills/` 中的内容已通过仓库内审查，但不等同于已发布的软件包；`processing/` 中的草稿不应作为稳定 Skill 使用。

## 为什么使用 Rinco

- **按任务装配**：只安装当前工作需要的 Skills，减少上下文与同名冲突。
- **职责唯一**：规格、计划、诊断、实现、验证和评审各有一个明确 owner。
- **证据门控**：结论必须绑定命令、观察结果和具体 worktree 状态。
- **可恢复交接**：阶段间传递可检查的 handoff；后续变更会使旧证据失效。
- **渐进式披露**：核心流程留在 `SKILL.md`，分支规则放入 `references/`。

## 快速开始

### 按需安装

每个 Skill 是自包含目录（`SKILL.md` + `references/`）。安装就是复制目录：从 [`skills/`](skills/) 挑选需要的 Skill，复制进 Pi 的发现路径之一：

- 项目级：`<你的项目>/.pi/skills/<name>/`（仅该项目可用）
- 全局级：`~/.pi/agent/skills/<name>/`（所有项目可用）

重启 Pi 后生效；移除 Skill 就是删除对应目录。本仓库不提供安装、升级或卸载工具，[`skills/`](skills/) 下的目录即安装源。

### 试用单个 Skill

不想安装时，可在本仓库根目录临时试用任一 Skill：

```bash
pi --no-skills --skill skills/workflows/readme
```

进入 Pi 后调用：

```text
/skill:readme
```

`--no-skills` 可避免本机或项目中的同名 Skill 产生冲突。

## 推荐套装

套装是建议安装组合，不是机制，可以整套装用、只装其中一个，或自由混搭。未安装的依赖不会静默失败——工作流通过 frontmatter `compatibility` 声明伙伴，运行时检查可用性，缺失时以 `BLOCKED` 指名缺失的 Skill 并给出安装后重启的指令。

| 套装 | 适配任务 | 链路 |
|---|---|---|
| shape | 需求模糊，需要先澄清再规格化 | grilling → domain-modeling → spec → plan |
| build | 已有计划，开始实现 | plan → tdd → verification → code-review |
| fix | 故障根因未知 | fix → systematic-debugging → tdd → verification |
| review | 独立审查当前变更 | verification → code-review |

**shape**：workflows `grilling`、`spec`、`plan`、`session-handoff`；patterns `domain-modeling`、`codebase-design`、`resilience`；tools `terminal-ops`、`context7-docs`。

**build**：workflows `plan`、`tdd`、`systematic-debugging`、`verification`、`code-review`、`session-handoff`；patterns `coding-standards`、`resilience`；tools `terminal-ops`。

**fix**：workflows `fix`、`systematic-debugging`、`tdd`、`verification`、`code-review`、`session-handoff`；patterns `coding-standards`、`resilience`；tools `terminal-ops`。

**review**：workflows `code-review`、`verification`、`session-handoff`；patterns `coding-standards`、`resilience`；tools `terminal-ops`。

**必需参考内容**：以上套装还需携带 patterns `codebase-design`（plan、tdd、code-review 的共享词汇）和 `living-docs-governance`（session-handoff 的唯一格式来源）；已有的无需重复复制。携带完整目录及引用文件，不代表每个任务都执行整个文档治理流程。build / fix / review 的合并集合共 12 个目录。

## Skills 目录

“显式”表示只能由用户调用；“自动 / 显式”表示既可由 Pi 按 frontmatter 描述选择，也可通过 `/skill:<name>` 调用。

### Workflows

| Skill | 调用 | 作用 |
|---|---|---|
| [`grilling`](skills/workflows/grilling/) | 自动 / 显式 | 在规格前压力测试决策树，确认共同理解后交接。 |
| [`spec`](skills/workflows/spec/) | 显式 | 产出可追踪、可验收的行为规格。 |
| [`plan`](skills/workflows/plan/) | 自动 / 显式 | 将契约映射为代码路径、切片、依赖和验证步骤。 |
| [`prototype`](skills/workflows/prototype/) | 自动 / 显式 | 用抛弃式原型回答一个设计问题，不触碰生产分支。 |
| [`publish-tickets`](skills/workflows/publish-tickets/) | 显式 | 将已批准计划按原切片发布为调度票，不重新规划。 |
| [`fix`](skills/workflows/fix/) | 显式 | 编排诊断、最小修复与最终验证。 |
| [`systematic-debugging`](skills/workflows/systematic-debugging/) | 自动 / 显式 | 用最小复现和因果实验证明根因，修复前停止。 |
| [`tdd`](skills/workflows/tdd/) | 自动 / 显式 | 按垂直切片执行 RED → GREEN → REFACTOR。 |
| [`verification`](skills/workflows/verification/) | 自动 / 显式 | 发现并执行仓库门禁，独占 readiness 结论。 |
| [`code-review`](skills/workflows/code-review/) | 显式 | 独立审查 diff，输出证据化评审报告。 |
| [`readme`](skills/workflows/readme/) | 自动 / 显式 | 创建、重写、审计 README，并验证关键声明与链接。 |
| [`session-handoff`](skills/workflows/session-handoff/) | 显式 | 将当前会话压缩为临时、可恢复的导航式交接文档。 |

### Patterns

| Skill | 作用 |
|---|---|
| [`backend-patterns`](skills/patterns/backend-patterns/) | 按约束选择服务边界、一致性、消息、缓存、安全和可观测性模式。 |
| [`codebase-design`](skills/patterns/codebase-design/) | 提供 module、interface、depth、seam、adapter、leverage、locality 等设计词汇。 |
| [`coding-standards`](skills/patterns/coding-standards/) | 基于仓库证据应用语言无关的代码质量基线。 |
| [`domain-modeling`](skills/patterns/domain-modeling/) | 维护领域词汇，并只为难逆转且存在真实权衡的决策创建 ADR。 |
| [`living-docs-governance`](skills/patterns/living-docs-governance/) | 为长期文档分派 Constitution、Map、Status、History 角色与新鲜度规则。 |
| [`resilience`](skills/patterns/resilience/) | 设计并审查 deadline、重试、幂等、过载、局部失败和恢复策略及其证据要求。 |
| [`security-review`](skills/patterns/security-review/) | 深查变更触及的信任边界，只报告有完整利用路径的安全发现。 |

### Tools & Meta

| Skill | 作用 |
|---|---|
| [`context7-docs`](skills/tools/context7-docs/) | 获取当前且版本明确的第三方文档与示例。 |
| [`find-skills`](skills/tools/find-skills/) | 搜索和评估生态中的可安装 Skills。 |
| [`gh`](skills/tools/gh/) | 以结构化输出和明确回退策略操作 GitHub CLI。 |
| [`terminal-ops`](skills/tools/terminal-ops/) | 用真实命令输出驱动仓库检查、修改和验证。 |
| [`writing-for-agents`](skills/meta/writing-for-agents/) | 编写和维护 Skills、`AGENTS.md`、`CLAUDE.md` 等 agent 文档。 |

## 设计原则

```text
模糊变更：shape → spec → plan → tdd → verification → code-review
未知故障：fix → systematic-debugging → tdd → verification → code-review
```

箭头表示证据与所有权交接，不授权自动调用下一个显式 Skill。Pi 在启动时发现 Skills，也支持 `/reload` 重载；本仓库以安装后重启作为依赖恢复流程，提示词或读取源文件本身不会完成安装或发现。必需依赖缺失时返回 `BLOCKED`，可选下游保留 `PENDING`，并指名恢复所需的实际安装路径。

显式 Skill 可从模型列表隐藏，不能仅凭未出现在列表就判为未安装；同时检查 `/skill:<name>` 命令及对应来源。模型列表、命令注册和执行授权是不同状态。同名冲突会告警并保留先发现项，不会自动阻止运行；消除冲突、确认实际来源后再继续。

核心约束：

1. 一个责任只有一个权威 owner。
2. `verification` 独占 `READY`、`NOT READY`、`BLOCKED` 实现门禁结论。
3. `code-review` 给出独立评审结论，不复制验证状态。
4. `systematic-debugging` 证明根因后停止，不修改生产行为。
5. 后续相关修改会使状态绑定的验证与评审证据失效。
6. user-invoked 阶段完成交接后停止，不继续执行另一个 user-invoked 阶段。

架构依据见 [ADR 0001：Rinco evidence kernel with Matt discovery layer](docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md) 与 [ADR 0002：自选安装 Skill，以推荐套装适配工作流](docs/adr/0002-self-install-skills-with-recommended-bundles.md)。

## 仓库结构

```text
.
├── skills/
│   ├── workflows/   # 端到端工程工作流
│   ├── patterns/    # 可复用工程纪律与设计语言
│   ├── tools/       # CLI 和外部文档工具纪律
│   └── meta/        # agent 文档元技能
├── processing/      # 待调研、重构或验证的草稿
├── scripts/         # 仓库结构校验（validate.sh）
├── docs/
│   └── adr/         # 架构决策
└── AGENTS.md        # 本仓库的权威维护规则
```

每个 Skill 以 `SKILL.md` 为入口，并按需通过 `references/`、`scripts/` 或 `assets/` 披露细节。

## 当前状态

已稳定的 Skills 位于 [`skills/`](skills/)；待处理候选位于 [`processing/skills/`](processing/skills/)。在全部目标 Skills 完成并验证前，本仓库不维护安装、复制或发布工具。

## 参与维护

先阅读 [`AGENTS.md`](AGENTS.md)。新增或重写 Skill 时：

1. 调研规定的一手来源，并用 `npx skills find <query>` 检查现有实现。
2. 在 `processing/skills/<name>/` 起草，明确调用契约和可验证门控。
3. 检查 frontmatter、目录名、本地引用，以及正向、非触发、阻塞和干净场景。
4. 验证后移入 `skills/workflows/`、`skills/patterns/`、`skills/tools/` 或 `skills/meta/`。
5. 同步更新本 README，运行 `scripts/validate.sh` 确认全绿，并在提交或 PR 中列出实际参考的来源 URL。
