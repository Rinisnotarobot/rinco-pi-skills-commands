# Pi 技能规则速查

提炼自 Pi 文档 `docs/skills.md`。创建技能时以此为准。

## 加载位置

- 全局:`~/.pi/agent/skills/`、`~/.agents/skills/`
- 项目(需信任):`.pi/skills/`、`.agents/skills/`(cwd 及祖先目录,直至 git 根或文件系统根)
- 包:`package.json` 的 `skills/` 目录或 `pi.skills` 条目
- 设置:`settings.json` 的 `skills` 数组;CLI:`--skill <path>`

发现规则:`~/.pi/agent/skills/` 与 `.pi/skills/` 下根级 `.md` 文件也算技能;所有位置中,含 `SKILL.md` 的目录递归发现;`~/.agents/skills/` 与项目 `.agents/skills/` 的根级 `.md` 被忽略。

## 如何生效

1. 启动时扫描,提取 name 与 description
2. 系统提示以 XML 注入技能列表(仅 description)
3. 任务匹配时,模型用 `read` 加载完整 SKILL.md(不一定自动发生;可提示或 `/skill:name` 强制)
4. 相对路径基于技能目录解析

## 命令

- `/skill:name` 加载并执行;`/skill:name <args>` 参数会以 `User: <args>` 追加到技能内容后
- 开关:settings 中 `enableSkillCommands: true`
- 启动参数:`--no-skills` 禁用发现(显式 `--skill` 仍加载)

## Frontmatter

| 字段 | 必需 | 规则 |
|------|------|------|
| name | 是 | ≤64 字符;小写 a-z、0-9、连字符;无首尾连字符、无连续连字符。Pi 不要求与目录名一致 |
| description | 是 | ≤1024 字符;做什么 + 何时用。**缺失则技能不加载** |
| license | 否 | 许可证名或文件引用 |
| compatibility | 否 | ≤500 字符,环境要求 |
| metadata | 否 | 任意键值 |
| allowed-tools | 否 | 空格分隔的预批准工具(实验性) |
| disable-model-invocation | 否 | true 时从系统提示隐藏,仅 `/skill:name` 可用 |

## 验证行为

- 大多问题只警告仍加载:name 超长/非法字符/首尾或连续连字符、description 超 1024
- 未知 frontmatter 字段被忽略
- 同名冲突:警告并保留先发现的

## 兼容其他 harness 的技能

把 Claude Code / Codex 的技能目录加进 settings:

```json
{ "skills": ["~/.claude/skills", "~/.codex/skills"] }
```

项目级可放 `.pi/settings.json`:`{ "skills": ["../.claude/skills"] }`

## 安装后生效

新会话才扫描到新技能;当前会话可用 `/skill:<name>` 直接加载。

## 官方仓库

- Pi Skills:https://github.com/badlogic/pi-skills
- Anthropic Skills:https://github.com/anthropics/skills
- 生态注册表:https://skills.sh/
