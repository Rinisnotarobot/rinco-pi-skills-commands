# Rinco Pi Skills & Commands

Rinco Pi Skills & Commands 是一套面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程实践技能与斜杠命令集合。仓库使用 `processing/` 保存待处理内容，根目录 `skills/` 只保留已完成重构和验证的 Skills。

## 当前状态

完整 Skill 组合仍在建设中。仓库暂不提供安装、复制或发布脚本，也不会修改用户的 Pi 全局配置。等路线图中的目标 Skills 全部完成并通过组合验证后，再统一设计可审查、可回滚的分发机制。

## 如何使用

Commands 是待完善的 Pi prompt templates；Skills 是当前优先建设和验证的工作流。以下名称描述预期调用界面，不代表仓库当前提供自动安装：

```text
/project
/requirements
/develop
/review
/ship
```

在手动接入 Pi 或未来分发机制完成后，model-invoked Skills 可由 Pi 按任务描述加载，也可以显式调用：

```text
/skill:backend-patterns
/skill:code-review
/skill:context7-docs
/skill:find-skills
/skill:gh
/skill:plan
/skill:spec
/skill:systematic-debugging
/skill:tdd
/skill:terminal-ops
/skill:verification
/skill:writing-for-agents
```

`spec` 与 `code-review` 是 user-invoked Skills，仅在显式调用时执行；`systematic-debugging` 与 `verification` 是 model-invoked Skills，前者在故障原因未证实时建立根因证据链，后者在完成重要改动、声称完成或准备评审与发布时执行最终门禁。

## 包含哪些 Commands

| Command | 用途 |
|---|---|
| `/project` | 认识当前项目，建立架构地图并选择所需 Skills |
| `/requirements` | 兼容入口；提示改用显式调用的 `/skill:spec` |
| `/plan` | 基于需求和代码库证据生成可执行计划，并落盘到 `docs/plans/` |
| `/develop` | 按 TDD、技术栈模式和安全要求实现功能 |
| `/fix` | 证据化复现并修复构建、测试或运行时问题 |
| `/review` | 审查正确性、安全性、架构和测试覆盖，并落盘到 `docs/reviews/` |
| `/ship` | 完成验证、提交、PR、CI 和部署交付准备 |
| `/maintain` | 维护文档、仓库卫生、依赖和部署配置 |

每个命令的完整定义位于 [`processing/commands/`](processing/commands/) 目录。

## 包含哪些 Skills

### 已处理并验证

- [`backend-patterns`](skills/backend-patterns/)：语言与框架无关的后端架构模式，通过问题、约束、不变量和权衡选择实现方案。
- [`code-review`](skills/code-review/)：显式审查 Git diff，以证据门控发现，并将最终报告写入 `docs/reviews/`。
- [`context7-docs`](skills/context7-docs/)：通过 ctx7 CLI 获取当前且版本明确的第三方文档和示例。
- [`find-skills`](skills/find-skills/)：搜索生态中已有的可安装 agent Skills。
- [`gh`](skills/gh/)：以结构化输出和受限环境回退策略执行 GitHub CLI 操作。
- [`plan`](skills/plan/)：基于代码库证据生成文件、symbol、依赖和验证明确的实现计划，并写入 `docs/plans/`。
- [`spec`](skills/spec/)：显式调用的规格工作流，将已探索的需求写成带 `REQ`、`INV`、`AC` 追踪关系的 `docs/specs/` 持久化契约。
- [`systematic-debugging`](skills/systematic-debugging/)：model-invoked 的根因优先诊断流程，通过最小复现、因果追踪和单假设实验，将已证实根因交给 TDD。
- [`tdd`](skills/tdd/)：行为优先、垂直切片的 RED → GREEN → REFACTOR 工作流。
- [`terminal-ops`](skills/terminal-ops/)：以仓库证据为基础执行命令、修复与验证。
- [`verification`](skills/verification/)：model-invoked 的证据门控验证流程，从仓库配置发现权威命令，区分变更、基线与环境失败，并输出 `READY`、`NOT READY` 或 `BLOCKED`。
- [`writing-for-agents`](skills/writing-for-agents/)：编写和维护面向 agent 的 Skills 与项目指令。

### 待处理

其余 Skills 保存在 [`processing/skills/`](processing/skills/) 中。完成重构和验证后，将对应目录移入 `skills/`；在完整组合完成前，提升仅表示仓库内验证通过，不表示已安装或发布。

每个 Skill 都位于独立目录中，并以 `SKILL.md` 作为入口。

## 目录结构

```text
.
├── skills/                # 已处理并通过仓库验证的 Pi Skills
└── processing/
    ├── commands/          # 待完善的 Pi prompt templates
    └── skills/            # 尚待处理的 Skill 草稿
```

## 添加内容

新增或待重构的 Skill 先放在 `processing/skills/<skill-name>/`。完成处理和验证后，将整个目录移入 `skills/`。新增 Command 时，在 `processing/commands/<command-name>.md` 中创建提示词模板；文件名将作为未来接入 Pi 时的斜杠命令名。

不要把仓库内容复制到用户的 Pi 全局配置；分发机制将在完整 Skill 组合完成后单独设计。
