# Rinco Pi Skills & Commands — 项目规则

本仓库维护面向 Pi coding agent 的 Skills。`processing/` 存放待处理内容，
根目录 `skills/` 按功能域分类存放已重构并验证的 Skills（`workflows/`、`patterns/`、
`tools/`、`meta/`，不得平铺在 `skills/` 根下）。完整 Skill 组合尚在建设中；在全部目标
Skills 完成前，不维护安装、复制或发布机制。

## 工作流架构决策

引入外部 Skill、修改职责或组合方式前，先核对以下现行约定。重构方向见下一节，决策沿革见 Git 历史。
- **Rinco 是唯一证据与交付内核**：`spec`、`plan`、`systematic-debugging`、`tdd`、`verification`、`code-review`、`fix` 各有一个唯一 owner，下游结论不平行复制（见 README「设计原则」）。
- **Matt/ECC 只作选择性适配的发现、词汇和上下文层**：不整套引入与上述 owner 重叠的工作流（如 to-spec、implement、diagnosing-bugs、重复的 tdd/code-review）。
- **整套安装、普通启动**：面向大型持续开发项目，一次性安装全部已完成 Skills（含 workflows 及 patterns/tools/meta 配套内容），在长会话或多个 session 中持续使用。以 Pi 默认发现为入口，不要求按任务选装或每次启动传 Skill 参数；安装范围与任务路径见 README「快速开始」「任务路径」。
- **依赖检查用于异常恢复**：用 `compatibility` 声明和运行时检查识别安装缺失、发现异常与来源冲突；必需伙伴不可用时 `BLOCKED`，可选下游保留 `PENDING`，修复完整安装后正常重启。区分整套可用、正文按需加载与阶段执行授权；跨 session 传递制品、证据状态和下一调用，不重新装配 Skills。

### 自然组合重构方向

**2026-09-08 决定：agent 组织工作，Skills 提供专业方法，工具与产物提供反馈。** 方向已确定、尚未实施；现行职责和调用契约在对应修改获确认并验证前继续有效。

- **按问题选择能力**：在用户授权范围内，根据意图、风险和已有证据选择方法；不要求每个任务经过固定阶段链。
- **让成果自然衔接**：明确触发条件，接受内容充分且来源可信的对话、代码、测试结果或文档。保留结论的权威来源和职责区别，不要求逐阶段宣告 owner、指定上游来源或重复填写交接报告。
- **先删无效工作，再共享必要规则**：删除无消费者的字段、重复调查和行政性完成声明。保留可复核判断与完成条件，不预设全量标签、通用模板、调度 token 或专用协议检查器。
- **保留安全和真实反馈**：不把猜测当根因、不虚报检查、不复用过期证据、不将验证通过等同于评审或发布批准。重要副作用仍需相应授权，必需检查仍按项目风险和权威命令执行。
- **按实测推进**：逐项确认调用模式，先试点修复/实现路径，再推广需求/规划路径；以正确性、证据、遗漏、重复工作和用户干预评估效果。不新增工作流引擎、Pi 扩展或安装发布机制。

试点范围、估算、参考和未决项见[自然组合重构记录](docs/natural-skill-composition.md)。先确认试点契约并重订实施计划；本决策不自动放开现有显式入口。

## 构建新 Skill 必须先查参考源

新建或重写任何 Skill 前，**先调研下列参考源**，再动手写：

| 参考源 | 用途 |
|---|---|
| https://github.com/mattpocock/skills | 首选风格基准：小而可组合、任务入口与可复用纪律分层、薄编排；参考 `writing-for-agents` 与 ADR 写法。 |
| https://github.com/affaan-m/ECC | 参考 agents/skills/commands/rules 的职责切分、反馈闭环，以及文本纪律与运行机制的边界。 |
| `find-skills` 技能（`npx skills find`、https://skills.sh/） | 检索生态中是否已有成熟实现，并按安装量/来源信誉/仓库星数筛选。 |

调研要求：

- 用 `crawl4ai_md`（`fit`，长页面用 `bm25` + 聚焦 query）读上述仓库的 README 与具体
  `SKILL.md`；需要文件级内容时用 GitHub raw 链接。不要凭记忆复述这两个仓库的内容。
- 加载 `find-skills` 技能并实际执行搜索，而不是直接假设生态中没有同类技能。
- 只从上述一手来源取用；不要引用第三方镜像或转载。
- 若已有高星、高安装量的 Skill 能覆盖需求，先提出「直接复用/包装」方案，再考虑自研。

## 新 Skill 的产出规则

1. **先在 `processing/skills/<name>/` 起草**，验证通过后才移入根目录 `skills/` 下匹配
   功能的分类子目录（`workflows/`、`patterns/`、`tools/`、`meta/`）。
2. 结构：`SKILL.md` + 必要的引用文件；frontmatter 必须有 `name` 与写清触发条件的
   `description`（"use when …"），保持渐进式披露，细节放引用文件。
3. 明确该 Skill 是 user-invoked（编排、需显式调用）还是 model-invoked（可被自动选中的
   可复用纪律），并在描述中体现；user-invoked 不应调用另一个 user-invoked。
4. 流程型 Skill 要有可验证的门控（命令输出、评审结论、可复现证据），而不是只有建议性文字。
5. 写作遵循全局 `writing-for-agents` 技能：祈使句、无套话、路径与命令写全。
6. 在提交说明或 PR 描述中列出实际参考的来源 URL；说明借用了哪些模式、做了哪些改动。

## 校验

- 新增 Skill 时同步更新 `README.md` 的 Skills 列表。
- 提升或修改 Skill 后运行 `scripts/validate.sh`，全绿才算通过结构门禁（frontmatter、本地链接、孤儿引用、README 清点、调用模式）。
- `skills/` 是所有 Skill 的权威副本；`.pi/skills/` 与 `~/.pi/agent/skills/` 中的镜像漂移时以仓库为准刷新；`metadata.origin` 等 provenance frontmatter 是镜像间唯一预期的差异。
- 若 Crawl4AI 或 `npx skills` 不可用，明确说明未能核对，不要把记忆当作已验证的调研结果。
