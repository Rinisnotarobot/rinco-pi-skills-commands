# Rinco Pi Skills & Commands

面向大型持续开发项目的 [Pi coding agent](https://github.com/badlogic/pi-mono) 工程 Skills 集合：**一次性完整安装，在长会话或多个 session 中持续使用**，以单一所有者、无环交接和新鲜证据连接需求、计划、实现、验证与评审。

[快速开始](#快速开始) · [任务路径](#任务路径) · [Skills 目录](#skills-目录) · [设计原则](#设计原则) · [参与维护](#参与维护)

> [!IMPORTANT]
> 项目仍在建设中，尚未提供统一的安装、升级或发布机制，也不会自动修改用户的 Pi 全局配置。`skills/` 中的内容已通过仓库内审查，但不等同于已发布的软件包；`processing/` 中的草稿不应作为稳定 Skill 使用。

## 为什么使用 Rinco

- **整套常备**：完整安装全部已完成 Skills，阶段切换时选择调用，不重新选择安装组合。
- **职责唯一**：规格、计划、诊断、实现、验证和评审各有一个明确 owner。
- **证据门控**：结论必须绑定命令、观察结果和具体 worktree 状态。
- **可恢复交接**：阶段间传递可检查的 handoff；后续变更会使旧证据失效。
- **渐进式披露**：核心流程留在 `SKILL.md`，分支规则放入 `references/`。

## 快速开始

### 一次性完整安装

将 [`skills/`](skills/) 下 `workflows/`、`patterns/`、`tools/`、`meta/` 的全部已完成 Skills 一次性复制到同一 Pi 发现范围，保留每个 Skill 的 `SKILL.md` 及引用、脚本和资源。可保留分类目录层级，Pi 会递归发现 `SKILL.md`。

选择一个安装范围，而不是选择一个任务套装：

- 项目级：`<你的项目>/.pi/skills/`（项目受信任后可用）
- 全局级：`~/.pi/agent/skills/`（跨项目可用）

配套的工程纪律、工具与共享引用一并携带；`processing/` 草稿不在安装范围内。若使用 `.pi/skills/` 维护镜像，不要将其当作完整安装清单。安装源以 `skills/` 为准；目前仍不提供安装、升级或卸载工具。

### 平常启动与持续使用

完整安装后，在目标项目目录按平常方式启动：

```bash
pi
```

无需每次按任务拼接 `--skill`，也不以 `--no-skills` 隔离子集作为正常入口。阶段切换不要求重启或补装：在当前 session 中按任务选择 Skill，显式阶段仍由用户调用。

Pi 的「整套可用」不等于把所有正文一次塞进上下文：启动时发现已安装 Skills，将 model-invoked 的名称与描述放入上下文，正文与引用按任务读取；user-invoked 仍保留为显式入口。机制见 [Pi Skills 文档](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md)。

跨 session 时仍使用同一整套 Skills，传递当前 owner、制品路径与版本、证据适用状态、阻塞项及下一调用；新 session 据此恢复并核对证据新鲜度，而不是重新挑选安装组合。需要打包当前会话时显式调用 `/skill:session-handoff`，新 session 读取其交接文档；不假定新会话继承了旧对话。

## 任务路径

以下是同一整套 Skills 内的常见任务路径，不是安装套装，也不要求每项任务执行全部 Skills。箭头表示交接顺序，调用授权见「设计原则」。

| 路径 | 适配任务 | 链路 |
|---|---|---|
| shape | 需求模糊，需要先澄清再规格化 | grilling → domain-modeling → spec → plan |
| build | 已有计划，开始实现 | plan → tdd → verification → code-review |
| fix | 故障根因未知 | fix → systematic-debugging → tdd → verification |
| review | 独立审查当前变更 | verification → code-review |

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
| [`readme`](skills/tools/readme/) | 创建、重写、审计 README，并验证关键声明与链接。 |
| [`writing-for-agents`](skills/meta/writing-for-agents/) | 编写和维护 Skills、`AGENTS.md`、`CLAUDE.md` 等 agent 文档。 |

## 设计原则

[任务路径](#任务路径)中的箭头表示证据与所有权交接，不授权自动调用下一个显式 Skill。`compatibility` 声明与运行时可用性检查用于发现异常，不是引导用户按阶段补装。必需依赖不可用时返回 `BLOCKED`，可选下游保留 `PENDING`；报告缺失项、已核实的发现路径或来源冲突，请用户修复完整安装后正常启动 Pi，再按原制品与调用恢复。仅仅尚未读取正文不算依赖缺失，读取源文件也不等于安装或注册 Skill。

显式 Skill 可从模型列表隐藏，不能仅凭未出现在列表就判为未安装；同时检查 `/skill:<name>` 命令及对应来源。模型列表、命令注册和执行授权是不同状态。同名冲突会告警并保留先发现项，不会自动阻止运行；消除冲突、确认实际来源后再继续。

核心约束：

1. 一个责任只有一个权威 owner。
2. `verification` 独占 `READY`、`NOT READY`、`BLOCKED` 实现门禁结论。
3. `code-review` 给出独立评审结论，不复制验证状态。
4. `systematic-debugging` 证明根因后停止，不修改生产行为。
5. 后续相关修改会使状态绑定的验证与评审证据失效。
6. user-invoked 阶段完成交接后停止，不继续执行另一个 user-invoked 阶段。

以上约束的权威维护规则见 [`AGENTS.md`](AGENTS.md)。

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
└── AGENTS.md        # 本仓库的权威维护规则
```

每个 Skill 以 `SKILL.md` 为入口，并按需通过 `references/`、`scripts/` 或 `assets/` 披露细节。

## 当前状态

已稳定的 Skills 位于 [`skills/`](skills/)；待处理候选位于 [`processing/skills/`](processing/skills/)。在全部目标 Skills 完成并验证前，本仓库不维护安装、复制或发布工具。

**2026-09-08：自然组合重构方向已确定，尚未实施。** 见[维护决策](AGENTS.md#自然组合重构方向)与[试点范围、估算和未决项](docs/natural-skill-composition.md)。上面的 Skills 列表与调用模式仍描述现行实现。

## 参与维护

先阅读 [`AGENTS.md`](AGENTS.md)。新增或重写 Skill 时：

1. 调研规定的一手来源，并用 `npx skills find <query>` 检查现有实现。
2. 在 `processing/skills/<name>/` 起草，明确调用契约和可验证门控。
3. 检查 frontmatter、目录名、本地引用，以及正向、非触发、阻塞和干净场景。
4. 验证后移入 `skills/workflows/`、`skills/patterns/`、`skills/tools/` 或 `skills/meta/`。
5. 同步更新本 README，运行 `scripts/validate.sh` 确认全绿，并在提交或 PR 中列出实际参考的来源 URL。
