# 完整适配实例:一个 Claude Code 技能 → Pi

假设从 GitHub 拿到技能 `pr-reviewer`,目录如下:

```
pr-reviewer/
├── SKILL.md
├── agents/
│   └── reviewer.md          # 子代理定义
├── scripts/
│   └── fetch-pr.sh
└── eval-viewer/
    └── index.html
```

## 原 SKILL.md(节选)

```markdown
---
name: PR Reviewer
description: Reviews pull requests.
model: claude-sonnet-4-5
---

# PR Reviewer

## Workflow

1. Use Glob to find changed files with pattern `**/*.{ts,tsx}`
2. Dispatch the `reviewer` subagent with Task to analyze each file
3. Use TodoWrite to track findings
4. Run `~/.claude/skills/pr-reviewer/scripts/fetch-pr.sh <pr-number>` to fetch PR data
```

## 审查结论

| 红旗 | 判定 |
|------|------|
| `Task` + `agents/reviewer.md` | 需改写 |
| `Glob` | 需改写 |
| `TodoWrite` | 需改写 |
| 硬编码 `~/.claude/...` 路径 | 需改写 |
| `model` frontmatter 字段 | 可删 |
| name 有大写/空格 | 需修正 |
| `eval-viewer/` | 删除 |
| `scripts/fetch-pr.sh` | 先审阅内容再决定 |

## 改写后的 SKILL.md

```markdown
---
name: pr-reviewer
description: 审查 GitHub Pull Request:查找变更文件、分析 diff、按安全/正确性/风格分类记录问题。Use when reviewing a PR, 触发词:审查PR、review pull request、code review。
compatibility: 需要 gh CLI 已登录
---

# PR Reviewer

## 工作流

1. 找变更文件:
   ```bash
   rg --files -g '*.{ts,tsx}'
   ```
2. 本代理直接逐个 `read` 文件,按检查项分析(安全、正确性、风格)
3. 用 `todo` 工具跟踪每个文件的审查进度
4. 拉取 PR 数据(gh CLI 已登录):
   ```bash
   bash scripts/fetch-pr.sh <pr-number>
   ```

## 注意事项

- 先审阅 `scripts/fetch-pr.sh` 内容再运行
- 结论按严重程度分组输出

## 参考

- 详细检查项:[references/review-checklist.md](references/review-checklist.md)
```

## 改写要点回顾

1. **name 修正**:`PR Reviewer` → `pr-reviewer`(小写连字符)
2. **删除 `model` 字段**(Pi 忽略未知字段,删掉更干净)
3. **Task 子代理** → 主代理分步执行;删除 `agents/` 目录
4. **Glob** → `rg --files`;**TodoWrite** → `todo`
5. **硬编码路径** → 技能内相对路径 `scripts/fetch-pr.sh`
6. **删除 `eval-viewer/`**
7. **description 补齐**:做什么 + 何时用 + 中英文触发词

## 安装与验证

```bash
# 改写后的目录放入全局
mv pr-reviewer ~/.pi/agent/skills/
# 语法检查脚本
bash -n ~/.pi/agent/skills/pr-reviewer/scripts/fetch-pr.sh
```

- 当前会话:`/skill:pr-reviewer` 强制加载测试
- 新会话:确认描述出现在技能列表且能触发
