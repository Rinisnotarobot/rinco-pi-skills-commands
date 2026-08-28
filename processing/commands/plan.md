---
description: 基于需求和代码库证据生成可执行、可验证的实现计划，并等待确认。
argument-hint: "<功能说明或需求文档路径>"
---

# Implementation Planning

为 `${ARGUMENTS:-待澄清的实现目标}` 制定计划，不直接编码。

加载并遵循：
- `product-capability` — 提取能力边界、接口、不变量和未决决策。
- `codebase-onboarding` — 定位入口、相似实现、数据流和测试约定。
- `coding-standards` — 保证方案遵循现有命名和模块边界。
- 检测到具体技术栈时，条件加载对应 Patterns Skill。
- 涉及敏感功能时加载 `security-review`。

计划必须包含：需求复述、代码库证据、方案与备选、文件级改动、按依赖排序的任务、测试策略、验证命令、风险和非目标。所有命令使用项目既有工具；Python 使用 `uv`。展示计划后等待用户明确确认，再进入 `/develop`。
