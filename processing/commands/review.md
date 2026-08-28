---
description: 对本地变更或指定范围执行正确性、安全、架构和测试审查。
argument-hint: "[路径、diff 范围或 PR 编号]"
---

# Review Workflow

审查 `${ARGUMENTS:-当前未提交变更}`，默认只报告，不修改代码。

加载并遵循：
- `coding-standards` — 正确性、可读性、不可变性和维护性。
- `security-review` — 输入、鉴权、密钥、注入和敏感数据风险。
- 按技术栈加载对应 Patterns 与 Testing Skills。
- `verification-loop` — 运行项目已配置的类型、lint、测试、构建和 diff 检查。
- 输入为 GitHub PR 且需要 `gh` 时，必须加载 `gh`；需要 PR 运营时再加载 `github-ops`。

读取完整相关上下文，不只看 diff 片段。每项发现给出严重级别、`file:line`、证据、影响和具体修复建议；区分已有问题与本次引入问题。最后给出验证结果和 APPROVE、APPROVE WITH COMMENTS、REQUEST CHANGES 或 BLOCK。
