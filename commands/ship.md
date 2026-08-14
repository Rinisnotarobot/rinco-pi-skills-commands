---
description: 在完整验证后准备提交、Pull Request、CI 检查和部署交付。
argument-hint: "[base 分支、--draft 或交付目标]"
---

# Ship Workflow

交付 `${ARGUMENTS:-当前分支的已完成变更}`。

按顺序加载并遵循：
1. `verification-loop` — 构建、类型、lint、测试、安全和 diff 必须有证据。
2. `git-workflow` — 检查分支、工作区、提交边界和提交信息。
3. 使用任何 `gh` 命令前必须加载 `gh`；PR、CI、Release 操作加载 `github-ops`。
4. 涉及部署、容器、健康检查或回滚时加载 `deployment-patterns`。

先展示状态、拟提交文件、提交信息、PR 标题/正文、目标分支和验证结果。提交可按用户明确要求执行；首次 push、创建/更新 PR、Release 或部署前必须再次取得明确确认。不得使用 `--force`，必要时仅在说明风险后使用 `--force-with-lease`。
