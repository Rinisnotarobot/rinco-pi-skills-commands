# Rinco Pi Skills & Commands — 项目规则

本仓库维护面向 Pi coding agent 的 Skills 与斜杠命令。`processing/` 存放待处理内容，
根目录 `skills/` 只保留已重构并验证的 Skills。完整 Skill 组合尚在建设中；在全部目标
Skills 完成前，不维护安装、复制或发布机制。

## 构建新 Skill 必须先查参考源

新建或重写任何 Skill 前，**先调研下列参考源**，再动手写：

| 参考源 | 用途 |
|---|---|
| https://github.com/mattpocock/skills | 首选风格基准：小而可组合、user-invoked / model-invoked 分层、门控式流程（grill → spec → tdd → code-review）。同时参考其 `writing-for-agents` 与 ADR 写法。 |
| https://github.com/affaan-m/ECC | 大规模 Skill 体系参考：plan → test → implement → review → verify → remember 的工程闭环、agents/skills/commands/rules 的职责切分、安装与分发约定。 |
| `find-skills` 技能（`npx skills find`、https://skills.sh/） | 检索生态中是否已有成熟实现，并按安装量/来源信誉/仓库星数筛选。 |

调研要求：

- 用 `crawl4ai_md`（`fit`，长页面用 `bm25` + 聚焦 query）读上述仓库的 README 与具体
  `SKILL.md`；需要文件级内容时用 GitHub raw 链接。不要凭记忆复述这两个仓库的内容。
- 加载 `find-skills` 技能并实际执行搜索，而不是直接假设生态中没有同类技能。
- 只从上述一手来源取用；不要引用第三方镜像或转载。
- 若已有高星、高安装量的 Skill 能覆盖需求，先提出「直接复用/包装」方案，再考虑自研。

## 新 Skill 的产出规则

1. **先在 `processing/skills/<name>/` 起草**，验证通过后才移入根目录 `skills/`。
2. 结构：`SKILL.md` + 必要的引用文件；frontmatter 必须有 `name` 与写清触发条件的
   `description`（"use when …"），保持渐进式披露，细节放引用文件。
3. 明确该 Skill 是 user-invoked（编排、需显式调用）还是 model-invoked（可被自动选中的
   可复用纪律），并在描述中体现；user-invoked 不应调用另一个 user-invoked。
4. 流程型 Skill 要有可验证的门控（失败测试、命令输出、评审结论），而不是只有建议性文字。
5. 写作遵循全局 `writing-for-agents` 技能：祈使句、无套话、路径与命令写全。
6. 在提交说明或 PR 描述中列出实际参考的来源 URL；说明借用了哪些模式、做了哪些改动。

## 校验

- 改动 `skills/` 后，运行仓库中的 Skill 契约、交接和行为测试；安装与发布测试推迟到完整
  Skill 组合完成后统一设计。
- 新增 Command 时同步更新 `README.md` 的命令表；新增 Skill 时同步更新 Skills 列表。
- 若 Crawl4AI 或 `npx skills` 不可用，明确说明未能核对，不要把记忆当作已验证的调研结果。
