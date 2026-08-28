---
name: skill-adapter
description: 将第三方 Agent Skills(Claude Code、OpenAI Codex、skills.sh 生态等)审查、改写并适配到 Pi 的元技能。覆盖:兼容性审查(harness 专用机制识别)、工具映射改写(Task/Glob/WebFetch/TodoWrite → Pi 工具)、frontmatter 修正、安装与验证。Use when the user wants to install a foreign skill, adapt/port a Claude Code or Codex skill to Pi, or fix a skill that assumes another harness's tools. 中文触发:适配skill、移植技能、转换claude技能、装第三方技能、这个skill能在pi里用吗。
---

# Skill Adapter(技能适配器)

把其他 harness(Claude Code、Codex 等)的技能安全地移植到 Pi。

## 何时使用

- 用户想安装生态里找到的第三方技能(来自 skills.sh、GitHub 仓库等)
- 用户手头有 Claude Code / Codex 的 SKILL.md 或技能目录,想用在 Pi 里
- 技能装上了但表现异常(假设了别的 harness 的工具)
- 用户问"这个 skill 能在 pi 里用吗"

## 适配流程

1. **定位来源**——技能在哪:GitHub 仓库、`~/.claude/skills/`、`~/.codex/skills/`、skills.sh 安装产物。先 `read` 其 SKILL.md 与目录结构。
2. **兼容性审查**——按下方"红旗清单"逐项扫描 SKILL.md 与 `scripts/`。结论分三档:
   - **可直接用**:标准 SKILL.md,无 harness 专用机制 → 原样安装
   - **需适配**:有小问题(工具名、路径、frontmatter)→ 改写后安装
   - **不建议**:深度绑定(agents/ 子代理逻辑、私有 CLI 依赖)且改写成本高 → 告知用户并给替代方案
3. **改写**——按 [references/tool-mapping.md](references/tool-mapping.md) 做工具映射,修正 frontmatter,处理路径。
4. **精简目录**——删除 harness 专用文件(见下)。
5. **安装**——改写版放入 `~/.pi/agent/skills/<name>/`(全局)或 `.pi/skills/`(项目);或在 `settings.json` 的 `skills` 数组直接引用原目录(只读使用,不推荐分发)。
6. **验证与测试**——检查清单逐项核对,`bash -n` 检查脚本,新会话或 `/skill:<name>` 实测。

## 红旗清单(审查时逐项查)

| 红旗 | 说明 | 处理 |
|------|------|------|
| `Task` 工具 / 子代理 | 调用 subagent 或引用 `agents/` 目录 | 无等价物:改写成主代理分步执行;删除 `agents/` 目录定义 |
| `Glob` / `Grep` | Claude 专用文件检索工具 | 改写为 `bash`: `find`/`rg` |
| `WebFetch` / `WebSearch` | Claude 专用联网工具 | 改写为项目已配的 MCP(如 context7-docs)或 `curl`;没有则改提示用户提供材料 |
| `TodoWrite` | Claude 专用任务清单 | 改写为 Pi 的 `todo` 工具 |
| `AskUserQuestion` | Claude 专用提问工具 | 改写为 `ask_user_question` |
| 硬编码 `~/.claude/`、`~/.codex/` 路径 | 路径不存在 | 改为对应 Pi 路径或技能目录内相对路径 |
| `eval-viewer/`、`.claude-plugin/` | Claude 评测/插件机制 | 直接删除 |
| `agents/` 目录 | 子代理定义 | 删除(逻辑并入 SKILL.md) |
| frontmatter 中 `model`、`context` 等 Claude 字段 | Pi 忽略未知字段 | 可删(无害);`allowed-tools` 里的工具名要核对为 Pi 工具 |
| 单文件 `.md` 技能(Claude 常见) | Pi 在 `~/.pi/agent/skills/` 接受根级 .md,但 `~/.agents/skills/` 忽略 | 统一建目录放 `SKILL.md` |
| `scripts/` 里跑安装命令、联网下载、改系统文件 | 安全风险 | 先读后跑;改写为需用户确认 |

## Frontmatter 修正要点

- `name`:改成小写字母/数字/连字符(≤64,无首尾/连续连字符)。Pi 允许与目录名不同,但建议一致。
- `description`:≤1024 字符,必须含"做什么 + 何时用";外文技能建议补中文触发词。
- 缺失 description 的技能 **不会加载**——必须补上。
- 可加 `compatibility: 需 curl/rg 等` 注明环境要求。

## 安装后的测试

1. 新会话让 Pi 自动发现;当前会话用 `/skill:<name>` 强制加载
2. 用一个真实任务走一遍技能流程,确认:
   - 能正确触发(description 有效)
   - 每个引用的工具都存在
   - 相对路径全部可解析(`ls` 核对)
   - 脚本能跑通

## 详细参考

- 工具映射表(Claude Code / Codex → Pi,含改写示例):[references/tool-mapping.md](references/tool-mapping.md)
- 完整适配实例(一个 Claude 技能 → Pi 的全程改写):[references/worked-example.md](references/worked-example.md)
- Pi 技能规则速查:`~/.pi/agent/skills/skill-creator/references/pi-skill-rules.md`
