---
description: 基于需求和代码库证据生成可执行、可验证的实现计划，写入文件并等待确认。
argument-hint: "<功能说明或需求文档路径>"
---

# Implementation Planning

为 `${ARGUMENTS:-待澄清的实现目标}` 制定计划，不直接编码；最终计划必须落盘。

加载并遵循：
- 参数包含已完成的规格文件时，先读取并保留其中的 `REQ`、`INV`、`AC` 标识；若仍缺少会改变行为或安全性的产品决策，停止并要求用户先显式调用 `/skill:spec`。
- `codebase-onboarding` — 定位入口、相似实现、数据流和项目约定。
- `coding-standards` — 保证方案遵循现有命名和模块边界。
- 检测到具体技术栈时，条件加载对应 Patterns Skill。
- 涉及敏感功能时加载 `security-review`。

计划必须包含：需求复述、代码库证据、方案与备选、文件级改动、按依赖排序的任务、验证命令、风险和非目标。所有命令使用项目既有工具；Python 使用 `uv`。

自检通过后才写文件。优先使用用户指定路径，其次使用仓库已有 plan 目录，否则写入 `docs/plans/YYYY-MM-DD-<slug>.md`。`<slug>` 取计划标题的 lowercase ASCII kebab-case；无法生成时使用 `implementation-plan`。同名文件已存在时追加 `-2`、`-3`，不得覆盖。写入后重新读取并确认计划完整；对话中只返回文件路径、摘要和阻塞问题，然后等待用户明确确认，再进入 `/develop`。
