# Rinco Pi Skills & Commands

面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程 Skills 集合：用**单一所有者、无环交接和新鲜证据**连接需求、计划、实现、验证与评审。

[快速开始](#快速开始) · [选择工作流](#选择工作流) · [Skills 目录](#skills-目录) · [设计原则](#设计原则) · [参与维护](#参与维护)

> [!IMPORTANT]
> 项目仍在建设中，尚未提供统一的安装、升级或发布机制，也不会自动修改用户的 Pi 全局配置。`skills/` 中的内容已通过仓库内审查，但不等同于已发布的软件包；`processing/` 中的草稿不应作为稳定 Skill 使用。

## 为什么使用 Rinco

- **按任务加载**：只启动当前工作需要的 Skills，减少上下文与同名冲突。
- **职责唯一**：规格、计划、诊断、实现、验证和评审各有一个明确 owner。
- **证据门控**：结论必须绑定命令、观察结果和具体 worktree 状态。
- **可恢复交接**：阶段间传递可检查的 handoff；后续变更会使旧证据失效。
- **渐进式披露**：核心流程留在 `SKILL.md`，分支规则放入 `references/`。

## 快速开始

### 试用单个 Skill

前置条件：已安装 `pi`，并在本仓库根目录执行命令。

```bash
pi --no-skills --skill skills/workflows/readme
```

进入 Pi 后调用：

```text
/skill:readme
```

`--no-skills` 可避免本机或项目中的同名 Skill 产生冲突；将目录替换为下方任一稳定 Skill 即可临时试用。

### 启动完整任务通道

```bash
./profiles/shape.sh
```

启动器会先检查 Skill 路径、frontmatter `name` 和重复名称，再以确定的依赖集合启动 Pi。附加的 Pi 参数可直接放在脚本后面。

## 选择工作流

| 你的任务 | 启动命令 | 主要链路 |
|---|---|---|
| 需求模糊，需要先澄清 | `./profiles/shape.sh` | grilling → domain-modeling → spec → plan |
| 已有计划，开始实现 | `./profiles/build.sh` | plan → tdd → verification → code-review |
| 故障根因未知 | `./profiles/fix.sh` | fix → systematic-debugging → tdd → verification |
| 独立审查当前变更 | `./profiles/review.sh` | verification → code-review |

Profile 会同时加载所需的模式、工具与 `session-handoff`。如果下游依赖未加载，Skill 应返回可执行的 `BLOCKED` 或 `PENDING` 重启指令，而不是假设运行时可以动态发现依赖。

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

箭头表示证据与所有权交接，不代表 Pi 能在当前会话中动态加载缺失 Skill。

核心约束：

1. 一个责任只有一个权威 owner。
2. `verification` 独占 `READY`、`NOT READY`、`BLOCKED` 实现门禁结论。
3. `code-review` 给出独立评审结论，不复制验证状态。
4. `systematic-debugging` 证明根因后停止，不修改生产行为。
5. 后续相关修改会使状态绑定的验证与评审证据失效。
6. user-invoked 阶段完成交接后停止，不继续执行另一个 user-invoked 阶段。

架构依据见 [ADR 0001：Rinco evidence kernel with Matt discovery layer](docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md)，实施记录见 [融合计划](docs/plans/2026-09-03-rinco-matt-skill-integration.md)。

## 仓库结构

```text
.
├── skills/
│   ├── workflows/   # 端到端工程工作流
│   ├── patterns/    # 可复用工程纪律与设计语言
│   ├── tools/       # CLI 和外部文档工具纪律
│   └── meta/        # agent 文档元技能
├── processing/      # 待调研、重构或验证的草稿
├── profiles/        # shape / build / fix / review 启动器
├── docs/
│   ├── adr/         # 架构决策
│   ├── plans/       # 实施与组合计划
│   └── pilots/      # 组合验证协议
└── AGENTS.md        # 本仓库的权威维护规则
```

每个 Skill 以 `SKILL.md` 为入口，并按需通过 `references/`、`scripts/` 或 `assets/` 披露细节。

## 当前状态

已稳定的 Skills 位于 [`skills/`](skills/)；待处理候选位于 [`processing/skills/`](processing/skills/)。剩余组合工作见 [Skill portfolio focus](docs/plans/2026-09-03-skill-portfolio-focus.md)。在全部目标 Skills 完成并验证前，本仓库不维护安装、复制或发布工具。

## 参与维护

先阅读 [`AGENTS.md`](AGENTS.md)。新增或重写 Skill 时：

1. 调研规定的一手来源，并用 `npx skills find <query>` 检查现有实现。
2. 在 `processing/skills/<name>/` 起草，明确调用契约和可验证门控。
3. 检查 frontmatter、目录名、本地引用，以及正向、非触发、阻塞和干净场景。
4. 验证后移入 `skills/workflows/`、`skills/patterns/`、`skills/tools/` 或 `skills/meta/`。
5. 同步更新本 README，并在提交或 PR 中列出实际参考的来源 URL。
