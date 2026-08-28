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
/skill:plan
/skill:spec
/skill:systematic-debugging
/skill:tdd
/skill:verification
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
- [`plan`](skills/plan/)：基于代码库证据生成文件、symbol、依赖和验证明确的实现计划，并写入 `docs/plans/`。
- [`spec`](skills/spec/)：显式调用的规格工作流，将已探索的需求写成带 `REQ`、`INV`、`AC` 追踪关系的 `docs/specs/` 持久化契约。
- [`systematic-debugging`](skills/systematic-debugging/)：model-invoked 的根因优先诊断流程，通过最小复现、因果追踪和单假设实验，将已证实根因交给 TDD。
- [`tdd`](skills/tdd/)：行为优先、垂直切片的 RED → GREEN → REFACTOR 工作流。
- [`verification`](skills/verification/)：model-invoked 的证据门控验证流程，从仓库配置发现权威命令，区分变更、基线与环境失败，并输出 `READY`、`NOT READY` 或 `BLOCKED`。

### 待处理

其余 Skills 保存在 [`processing/skills/`](processing/skills/) 中。完成重构和验证后，将对应目录移入 `skills/`；在完整组合完成前，提升仅表示仓库内验证通过，不表示已安装或发布。

每个 Skill 都位于独立目录中，并以 `SKILL.md` 作为入口。

## 验证仓库内容

项目包含 Skill 契约、Skill 交接和专项行为测试。它们会验证 frontmatter、调用模式、引用链接、上下游证据所有权、verdict 分离和 README 清单：

```bash
./tests/skills_test.sh
./tests/skill_handoffs_test.sh
./tests/spec_test.sh
./tests/systematic_debugging_test.sh
```

也可以先执行语法检查：

```bash
bash -n tests/skills_test.sh tests/skill_handoffs_test.sh tests/spec_test.sh tests/systematic_debugging_test.sh
```

## 目录结构

```text
.
├── skills/                # 已处理并通过仓库验证的 Pi Skills
├── processing/
│   ├── commands/          # 待完善的 Pi prompt templates
│   └── skills/            # 尚待处理的 Skill 草稿
├── tests/
│   ├── skills_manifest.tsv  # 已提升 Skill 及调用模式清单
│   ├── skills_test.sh       # Skill 契约与引用校验
│   ├── skill_handoffs_test.sh # Skill 交接契约校验
│   ├── spec_test.sh         # 规格行为与产物契约校验
│   └── systematic_debugging_test.sh # 系统化调试行为校验
```

## 添加内容

新增或待重构的 Skill 先放在 `processing/skills/<skill-name>/`。完成处理和验证后，将整个目录移入 `skills/`。新增 Command 时，在 `processing/commands/<command-name>.md` 中创建提示词模板；文件名将作为未来接入 Pi 时的斜杠命令名。

完成修改后运行 `./tests/skills_test.sh`、`./tests/skill_handoffs_test.sh` 与对应专项行为测试（当前包括 `./tests/spec_test.sh` 和 `./tests/systematic_debugging_test.sh`）。不要把仓库内容复制到用户的 Pi 全局配置；分发机制将在完整 Skill 组合完成后单独设计。
