---
name: skill-creator
description: 创建、编写和改进 Pi 的 Agent Skills(技能)的元技能。指导 SKILL.md 结构与 frontmatter 规范、渐进式披露、触发词描述写法、验证与测试流程。Use when the user asks to create a new skill, write or improve a SKILL.md, turn a recurring workflow into a skill, or install/adapt a third-party skill for Pi. 中文触发:创建skill、创建技能、写skill、skill模板、把工作流做成技能。
---

# Skill Creator(技能创建器)

本技能教你如何为 Pi 创建、改进和验证 Agent Skills。

## 何时使用

- 用户要求"创建 skill / 创建技能"、把重复工作流固化为技能
- 用户给了一段 prompt 或流程,想让它变成可复用技能
- 从生态安装的技能需要按 Pi 环境适配(改写 SKILL.md、剔除其他 harness 的专用机制)
- 现有技能触发不佳、说明过时,需要改进 description 或正文

## 核心原则

1. **渐进式披露**:SKILL.md 只放高频核心指令(建议 <500 行)。深度细节放 `references/`(按需 read)、可执行逻辑放 `scripts/`、静态素材放 `assets/`。
2. **description 决定触发**:模型只常驻看到 description,它必须同时写明"做什么 + 何时用"。
3. **相对路径以技能目录为基准**:SKILL.md 里引用 `scripts/x.sh`、`references/y.md` 时,一律相对技能目录解析。
4. **面向 Pi 的工具**:只假设 Pi 的工具存在(`read`/`bash`/`edit`/`write`/`ask_user_question`/`todo`,以及项目里已配好的 MCP 工具)。不得假设 Claude Code 的 `Task`/`Glob`/`WebFetch`/`TodoWrite` 等专用工具。
5. **安全**:技能可指挥模型执行任意操作;若含脚本,创建后先审阅,分发前必查。

## 创建流程

1. **澄清需求**——问清领域、触发场景、是否需要脚本/参考文档。不明确时用 `ask_user_question`。
2. **确定位置**——全局 `~/.pi/agent/skills/<name>/`(个人常用)或项目 `.pi/skills/<name>/`(团队共享、需信任项目)。
3. **写 frontmatter**——`name` + `description`,规则见下。
4. **写 SKILL.md 正文**——结构:何时使用 → 分步工作流(含具体命令/代码)→ 注意事项/检查清单 → 指向 references。
5. **按需添加** `scripts/`、`references/`、`assets/`。
6. **验证**——按下方检查清单逐项核对,脚本做语法检查(`bash -n`)。
7. **测试**——新会话加载,或 `/skill:<name>` 强制加载;用一个真实任务验证能正确触发并执行。

## Frontmatter 规则

```yaml
---
name: my-skill                 # 必需:1-64 字符,小写字母/数字/连字符;不能以连字符开头或结尾;无连续连字符
description: 做什么 + 何时用     # 必需:≤1024 字符;缺失则技能不会被加载
# 可选字段:
license: MIT
compatibility: 环境要求,≤500 字符
metadata: { key: value }
allowed-tools: 预批准工具列表(实验性)
disable-model-invocation: true  # true 时不进系统提示,仅 /skill:name 可用
---
```

- Pi 允许 `name` 与目录名不同(标准不允许,Pi 放宽了此条)。
- 合法:`pdf-processing`、`data-analysis`;非法:`PDF-Processing`、`-pdf`、`pdf--processing`。

## Description 写法(决定触发质量)

差:`description: Helps with PDFs.`
好:`description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents.`

要包含:领域关键词 + 具体动作 + 触发场景(Use when / 中文触发词)。

## 检查清单

- [ ] `name`、`description` 存在且合法;description ≤1024 字符
- [ ] description 含"做什么 + 何时用",含用户可能使用的触发词
- [ ] 正文直接进入操作步骤,不重复背景介绍
- [ ] 相对路径按技能目录解析,引用文件真实存在
- [ ] 脚本显式调用(`bash scripts/x.sh`)或已加可执行位
- [ ] 无其他 harness 专用机制:`agents/` 子代理定义、硬编码 `~/.claude` 路径、`Task`/`Glob`/`TodoWrite` 等工具假设
- [ ] 已用新会话或 `/skill:<name>` 实测触发与执行

## 详细参考

- 完整 SKILL.md 模板:[references/skill-template.md](references/skill-template.md)
- Pi 技能规则速查(位置、加载、验证、命令):[references/pi-skill-rules.md](references/pi-skill-rules.md)
- Pi 官方文档:Pi 安装目录下的 `docs/skills.md`。全局 npm 安装时用 bash 定位:
  ```bash
  cat "$(npm root -g)/@earendil-works/pi-coding-agent/docs/skills.md"
  ```
- Agent Skills 规范:https://agentskills.io/specification
