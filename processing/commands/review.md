---
description: 对本地变更或指定范围执行正确性、安全和架构审查。
argument-hint: "[路径、diff 范围或 PR 编号]"
---

# Review Workflow

审查 `${ARGUMENTS:-当前未提交变更}`，不修改被审代码；最终审查报告必须落盘。

加载并遵循：
- `coding-standards` — 正确性、可读性、不可变性和维护性。
- `security-review` — 输入、鉴权、密钥、注入和敏感数据风险。
- 按技术栈加载对应 Patterns Skills。
- `verification` — 运行项目已配置的类型、lint、构建和 diff 检查。
- 输入为 GitHub PR 且需要 `gh` 时，必须加载 `gh`；需要 PR 运营时再加载 `github-ops`。

读取完整相关上下文，不只看 diff 片段。每项发现给出严重级别、`file:line`、证据、影响和具体修复建议；区分已有问题与本次引入问题。最后给出验证结果和 APPROVE、APPROVE WITH COMMENTS、REQUEST CHANGES 或 BLOCK。

结论确定后才写文件。优先使用用户指定路径，其次使用仓库已有 review 目录，否则写入 `docs/reviews/YYYY-MM-DD-<slug>.md`。`<slug>` 取变更主题或分支名的 lowercase ASCII kebab-case；无法生成时使用 `code-review`。同名文件已存在时追加 `-2`、`-3`，不得覆盖。写入后重新读取并确认报告完整；对话中只返回文件路径、结论、发现数量和验证摘要。
