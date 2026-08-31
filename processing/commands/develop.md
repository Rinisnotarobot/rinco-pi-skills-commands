---
description: 按技术栈模式、安全检查和验证循环实现功能。
argument-hint: "<已确认计划、功能或行为>"
---

# Development Workflow

实现 `${ARGUMENTS:-已经确认的功能或计划}`。

加载并遵循：
1. `coding-standards` — 保持最小、清晰、符合现有风格的改动。
2. 按检测结果加载 `python-patterns`、`fastapi-patterns`、`react-patterns`、`backend-patterns` 或 `frontend-patterns`。
3. 涉及边界输入、鉴权、API、密钥或敏感数据时加载 `security-review`。
4. 每个逻辑增量后使用 `verification` 验证。

先读相关代码与项目约定，再写满足目标行为的最小实现。不得静默安装依赖、扩大范围或跳过失败检查。完成后报告变更文件、验证结果、限制和后续建议。
