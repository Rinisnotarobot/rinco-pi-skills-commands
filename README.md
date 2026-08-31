# Rinco Pi Skills & Commands

一组面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程 Skills 与斜杠命令草稿。仓库以“小而可组合、按需加载、证据门控”为设计原则：稳定内容进入 `skills/`，仍在重构的内容留在 `processing/`。

> [!IMPORTANT]
> 项目仍在建设中。目前没有统一的安装、升级或发布机制，也不会自动修改用户的 Pi 全局配置。`skills/` 表示已通过仓库内审查，不等同于已发布的软件包。

## 快速试用

从仓库根目录直接让 Pi 加载一个已验证的 Skill，无需复制文件：

```bash
pi --no-skills --skill skills/workflows/readme
```

进入 Pi 后显式调用：

```text
/skill:readme
```

`--skill` 是 Pi 提供的临时加载参数，`--no-skills` 可避免本机或项目中已有的同名 Skill 产生冲突。其他 Skill 也可替换为下表中的目录；是否自动触发由各自的 frontmatter 决定。

## 已验证的 Skills

### 工程工作流

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`plan`](skills/workflows/plan/) | 自动或显式 | 基于代码库证据生成包含文件、symbol、依赖和验证步骤的实现计划。 |
| [`readme`](skills/workflows/readme/) | 自动或显式 | 创建、重写、审查或更新 README，并验证关键声明、命令和本地链接。 |
| [`spec`](skills/workflows/spec/) | 仅显式 | 将已探索的产品或工程变更写成可追踪、可验收的持久规格。 |
| [`tdd`](skills/workflows/tdd/) | 自动或显式 | 以行为优先的垂直切片执行 RED → GREEN → REFACTOR。 |
| [`systematic-debugging`](skills/workflows/systematic-debugging/) | 自动或显式 | 在修复前通过最小复现、因果追踪和单假设实验确认根因。 |
| [`verification`](skills/workflows/verification/) | 自动或显式 | 从仓库配置发现并执行质量门禁，输出基于新鲜证据的验证结论。 |
| [`code-review`](skills/workflows/code-review/) | 仅显式 | 审查 Git diff，并将证据化报告写入 `docs/reviews/`。 |

### 架构模式

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`backend-patterns`](skills/patterns/backend-patterns/) | 自动或显式 | 根据约束和权衡选择服务边界、数据一致性、消息、缓存、韧性、安全与可观测性模式。 |

### 工具与集成

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`context7-docs`](skills/tools/context7-docs/) | 自动或显式 | 通过 ctx7 CLI 获取当前且版本明确的第三方文档和示例。 |
| [`find-skills`](skills/tools/find-skills/) | 自动或显式 | 搜索并评估生态中已有的可安装 Skills。 |
| [`gh`](skills/tools/gh/) | 自动或显式 | 以结构化输出和受限环境回退策略执行 GitHub CLI 操作。 |
| [`terminal-ops`](skills/tools/terminal-ops/) | 自动或显式 | 以真实命令输出为依据检查、修改和验证仓库。 |

### 元技能

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`writing-for-agents`](skills/meta/writing-for-agents/) | 自动或显式 | 编写和维护 Skills、`AGENTS.md`、`CLAUDE.md` 等 agent 消费的文档。 |

“仅显式”表示 frontmatter 设置了 `disable-model-invocation: true`；其余 Skill 既可由 Pi 按描述自动加载，也可通过 `/skill:<name>` 调用。

## Commands 与待处理内容

`processing/commands/` 中的文件是待完善的 Pi prompt templates，目前不是已发布命令：

| Command | 目标 |
|---|---|
| `/project` | 建立代码库地图并选择任务所需 Skills。 |
| `/requirements` | 将需求入口转交给规格工作流。 |
| `/plan` | 基于需求与代码库证据生成实现计划。 |
| `/develop` | 按计划、技术栈纪律和验证循环实现变更。 |
| `/fix` | 证据化复现、诊断并修复失败。 |
| `/review` | 审查本地变更或指定 diff 范围。 |
| `/ship` | 准备提交、PR、CI 与部署交付。 |
| `/maintain` | 维护文档、仓库卫生、依赖和部署配置。 |

尚未完成重构的 Skills 位于 [`processing/skills/`](processing/skills/)。它们可能包含重复、过时或尚未验证的规则，不应与 `skills/` 中的已验证实现等同使用。

## 仓库结构

```text
.
├── AGENTS.md               # 本仓库的 agent 编写与校验规则
├── README.md
├── docs/
│   └── plans/              # 路线图与实现计划
├── skills/                 # 已重构并通过仓库验证的 Skills
│   ├── workflows/          # plan、readme、spec、tdd、debug、verification、review
│   ├── patterns/           # 可复用架构模式
│   ├── tools/              # CLI 与外部文档工具纪律
│   └── meta/               # 编写 agent 文档的元技能
└── processing/
    ├── commands/           # 尚未发布的命令模板
    └── skills/             # 待调研、重构或验证的 Skill 草稿
```

每个 Skill 以 `SKILL.md` 为入口，并可通过 `references/`、`scripts/` 或 `assets/` 渐进披露细节。

## 如何贡献或提升 Skill

先阅读 [`AGENTS.md`](AGENTS.md)；它是本仓库的权威维护规则。基本流程是：

1. 调研指定的一手参考源，并用 `npx skills find <query>` 检查生态中是否已有成熟实现。
2. 在 `processing/skills/<name>/` 创建或重构草稿。
3. 明确 user-invoked 或 model-invoked 契约，并为流程步骤设置可验证门控。
4. 检查 frontmatter、目录名、本地引用和手工场景。
5. 验证通过后移入 `skills/workflows/`、`skills/patterns/`、`skills/tools/` 或 `skills/meta/`。
6. 同步更新本 README；在提交或 PR 描述中列出实际使用的来源 URL 与本地改动。

当前目标组合与剩余工作记录在 [`docs/plans/2026-08-28-skill-roadmap.md`](docs/plans/2026-08-28-skill-roadmap.md)。在路线图完成并通过组合验证前，仓库不维护安装、复制或发布工具。
