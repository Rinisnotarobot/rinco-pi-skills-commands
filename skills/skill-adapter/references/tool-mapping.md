# 工具映射表(Claude Code / Codex → Pi)

改写 SKILL.md 时,把对其他 harness 工具的引用替换为 Pi 等价物。

## 直接对应(改名字即可)

| 其他 harness | Pi | 备注 |
|--------------|-----|------|
| `Read` | `read` | 语义相同 |
| `Write` / `Edit` | `write` / `edit` | Pi 的 edit 用精确文本替换(edits[] 不重叠) |
| `Bash` / `Shell` | `bash` | 语义相同 |
| `TodoWrite` | `todo` | 4 态:pending → in_progress → completed / deleted;支持 blockedBy |
| `AskUserQuestion` | `ask_user_question` | 每条问题 2-4 选项,可 multiSelect |
| `Skill` 加载 | `/skill:<name>` | 参数以 `User: <args>` 追加 |

## 需要改写逻辑

### Task(子代理)

Claude 写法:
```markdown
Use the `research` subagent (agents/researcher.md) to gather requirements.
```

Pi 改写:
```markdown
由本代理直接执行:先 `read` 需求文档,再用 `ask_user_question` 澄清关键决策。
```
- 删除 `agents/` 目录;子代理的职责拆成 SKILL.md 里的分步步骤。
- 若子代理逻辑复杂(有独立循环/工具集),评估是否值得拆成多个 Pi 技能,分别 `/skill:` 加载。

### Glob(按模式找文件)

Claude 写法:
```markdown
Use Glob with pattern `**/*.test.ts` to find test files.
```

Pi 改写:
```markdown
找测试文件:
```bash
rg --files -g '*.test.ts'
```
```

### Grep(内容搜索)

Claude 写法:
```markdown
Use Grep for "TODO" in src/.
```

Pi 改写:
```markdown
```bash
rg -n "TODO" src/
```
```

### WebFetch / WebSearch(联网)

按项目已有能力降级,优先级:

1. 已配的 MCP 工具(context7-docs 查库文档、brave-search 搜索、gh 查 GitHub)
2. `bash` 里 `curl`(用户环境允许时)
3. 都没有 → 改为提示用户粘贴内容 / 确认无法联网

Claude 写法:
```markdown
WebFetch the API docs at https://example.com/docs and summarize.
```

Pi 改写:
```markdown
用 context7-docs 查该库的最新文档;若无,请用户粘贴 https://example.com/docs 相关内容。
```

### NotebookEdit(Notebook 编辑)

无等价物。改写为:用 `bash` 执行 `python`/`jupyter nbconvert` 脚本处理,或生成脚本让用户运行。

## 常见 harness 专用文件(直接删除)

| 文件/目录 | 用途 | 处理 |
|-----------|------|------|
| `agents/` | 子代理定义 | 逻辑并入 SKILL.md 后删除 |
| `eval-viewer/` | 技能评测 UI | 删除 |
| `.claude-plugin/` | Claude 插件元数据 | 删除 |
| `.claude/`、`CLAUDE.md`(技能内) | Claude 上下文文件 | 删除;要点并入 SKILL.md |
| `*.json` 的插件清单(`plugin.json` 等) | harness 清单 | 删除 |

## 路径改写

| 原路径 | Pi 改写 |
|--------|---------|
| `~/.claude/skills/x` | `~/.pi/agent/skills/x`(全局)或项目 `.pi/skills/x` |
| `~/.codex/skills/x` | 同上 |
| 技能内绝对路径 | 优先改为技能目录内相对路径(`scripts/x.sh`),Pi 按技能目录解析 |
