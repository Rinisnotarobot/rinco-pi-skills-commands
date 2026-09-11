# 设计说明

这份文件记录**跨 family 的设计决定**：知识分几层、每层归谁、边界怎么裁决、什么能进正式目录。面向维护者和贡献者。

**权威顺序**（冲突时按此，各写各的那部分，不重复维护）：

1. 各件 `SKILL.md` 是它自己流程的唯一准绳；
2. [AGENTS.md](AGENTS.md) 是在本仓库改动时的常驻约定、提升步骤与收工门禁（Pi 每次会话自动加载）；
3. 根 [README](README.md) 负责安装、清单与调用方式；
4. [skills/workflows/README.md](skills/workflows/README.md) 负责阶段链与 16 件 Workflows 的简介；
5. 本文负责上面都没写的那部分：分层、依赖方向、设计约束，以及几处刻意取舍的原因。

本文档不随 `scripts/install.sh` 分发（它只复制 `skills/<family>/<name>/`）。

## 1. 一句话

这套 Skill 不是知识库，而是**把工程结论变成可检查证据的流程约束**：一件 Skill 只负责一个阶段或领域，各自声明"到哪里为止"，靠 `description` 按需加载，跨 Skill 只做**路由**（转交给 owner），不做覆盖。

## 2. 知识分三层

| 层 | 内容 | 落在哪 |
|---|---|---|
| 方法论（与语言无关） | 阶段怎么走、结论怎么下、什么算证据 | `workflows/`、`patterns/` |
| 技术栈常识 | 这门语言或框架通常怎么做，以及怎么从仓库里读出来 | `stacks/` |
| 具体 API | 某个版本的确切签名与默认值 | **不写进 Skill**，只留取证纪律 |

第三层为什么不写：API 手册会随版本过期，而 Skill 没有版本号。`stacks/` 里的做法是"读锁文件拿到固定版本 → 在仓库里找现成调用点照抄 → 找不到就标 unverified 并就地确认"，并留一行可逆占位指向全局 `context7-docs` skill（外部文档查找默认不在范围内）。

## 3. 四个 family

| family | 件数 | 负责 | 触发方式 |
|---|---|---|---|
| `workflows/` | 16 | 一个阶段一件：澄清、规格、计划、诊断、实现、验证、评审、治理、交接 | 14 件自动 + 显式；2 件只能点名 |
| `patterns/` | 3 | 与语言、框架无关的架构与安全决策 | 自动 + 显式 |
| `stacks/` | 4 | 语言底座（`python-project`）与框架（`fastapi`、`ts-frontend`、`ts-backend`）的具体写法 | 自动 + 显式 |
| `tools/` | 1 | 本仓库自己的工具（`readme`） | 自动 + 显式 |

`skills/meta/` 在 `scripts/validate.sh` 里是合法 family，目前为空。

`patterns/` 与 `stacks/` 的分工：中立层持有"选哪个方案"的决策，栈层持有"这项目实际怎么写"的惯例。**栈知识不进中立 owner 的 `references/`**——那些文件没有自己的触发描述，内容进去就等于不可达。

## 4. 依赖方向：唯一的硬不变量

把 24 件 Skill 的 `SKILL.md` 与全部 `references/` 一起扫反引号里的 Skill 名，得到跨 family 的引用边（2026-09-11 快照）：

| 方向 | 边数 |
|---|---|
| `stacks` → `workflows` + `patterns` | 30 |
| `patterns` → `workflows` | 14 |
| `workflows` → `patterns` | 5 |
| `workflows` → `workflows` | 45 |
| `stacks` → `stacks` | 2 |
| **`workflows` → `stacks`** | **0** |

**不变量：`workflows/` 从不引用 `stacks/`。** 阶段方法与技术栈无关，这不是一句声明，而是上表里没有反向边。

三条推论：

1. `stacks/` 是叶子：没有任何 Skill 依赖它来定义自己的规则，只有 `patterns/` 里两条"要具体写法就转交"的路由指回来。所以往 `stacks/` 加内容不会污染上层的通用性。
2. 被引用最多的是门禁类：`tdd`（14 个来源）、`plan`（13）、`verification`（11），其次是 `resilience` 与 `backend-patterns`。它们是系统里的共享契约，改动代价最高。
3. `tools/readme` 没有出边，自成一体。

抽查单条边的办法：

```bash
grep -rn '`verification`' skills --include='*.md' | wc -l    # 谁在引用 verification
```

完整依赖图的扫法是一次性脚本，没有进仓库（见第 10 节）。

## 5. 五条设计约束

| 约束 | 规则 | 违反后的症状 |
|---|---|---|
| 切分 | 一件 Skill 负责一个阶段或领域，结论不串门 | 报告里冒出"整体没问题"这类越权结论 |
| 触发 | 只有 `name` + `description` 常驻上下文，由 `description` 决定加载（上限 1024 字符）；正文里的 `## When to Activate` 不触发 | 内容写了但不加载，等于死码 |
| 权威 | 仓库 > Skill。栈层是"惯例"，与仓库冲突时仓库赢，并报告差异 | Skill 变成模板，覆盖项目自己的写法 |
| 证据 | 完成 = 新鲜证据；旧结果不算数；"没装那件 Skill" 不是 `BLOCKED` 的理由 | 拿过期报告免检，拿缺件当借口 |
| 权限 | 只读 / 可写 / 只能点名三级，会对外部世界产生副作用的只能点名 | agent 自作主张发工单、写交接文档 |

## 6. 统一骨架

```text
description             触发句 + 中文触发词
├── ## Workflow          编号步骤，每步一条 completion criterion
├── ## <家族专属 Rules>  Baseline / Service / Component / Route / Pattern Selection / Boundaries
├── ## Output Contract   固定输出槽位（可选）
├── ## Guardrails        安全红线（可选）
└── references/*.md      渐进披露；分支表写"读哪份文档"或"转交给哪件 Skill"
```

量级快照（2026-09-11）：

| 项 | 值 | 复核命令 |
|---|---|---|
| Skill 数 | 24 | `find skills -name SKILL.md \| wc -l` |
| reference 文件数 | 68 | `find skills -path '*/references/*.md' \| wc -l` |
| `SKILL.md` 总行数 | 2,578 | `find skills -name SKILL.md -exec cat {} + \| wc -l` |
| 以 `## Workflow` 为骨架 | 22 | `find skills -name SKILL.md -exec grep -l '^## Workflow' {} + \| wc -l` |
| 带 `## Output Contract` | 9 | 同上，换成 `'^## Output Contract'` |
| 带 `## Guardrails` | 8 | 同上，换成 `'^## Guardrails'` |
| `description` 带 `Use when` | 21 | `find skills -name SKILL.md -exec grep -l 'Use when' {} + \| wc -l` |

正文（去掉 frontmatter）中位 99 行、最长 183 行，`description` 中位 346 字符。这三项是行为特征快照，不是门禁指标，新增 Skill 后不必回来同步。

`frontmatter` 只要求 `name` + `description`；`disable-model-invocation` 是唯一影响加载方式的功能字段（目前 `publish-tickets`、`session-handoff` 在用）；来源说明写在 `metadata:` 下。字段级约定见 [AGENTS.md](AGENTS.md)。

## 7. 边界与裁决：路由，而不是覆盖

多数 Skill 系统写"能做什么"，这套写**"到哪里为止"**：

- `resilience` 不下"实现完成"的结论——设计阶段把要证明的失败场景交给 `plan`，评审已有实现时把验证要求交给 `verification`；
- `python-project` 明说 "does not issue `READY`, `NOT READY`, or `BLOCKED`"；
- `tdd` 只留行为测试证据，不替验证阶段宣布整体没问题；
- `verification` 是 `READY` / `NOT READY` / `BLOCKED` 合成规则的唯一来源，`code-review` 遵守同一套；
- `code-review` 只读、报告落盘、不改被审代码。

冲突怎么裁决：**路由，不是覆盖**。另一种常见做法是用优先级让专用规则盖掉通用规则（"specific overrides general"，像 CSS 权重）；这里改成"中立层持有决策、栈层只表达惯例、各自声明 owner"，正文里直接写 “Invoke `resilience`; do not invent failure policy here” 这样的句子。代价是没有自动一致性检查（见第 10 节），收益是不会出现伪装成"通用"的栈知识。

## 8. 治理

- **结构门禁**：`bash scripts/validate.sh` 六道门（frontmatter / 本地链接可达 / `references/` 无孤儿 / README 清单与树一致 / 调用契约与 README 匹配 / `git diff --check` 干净）。其中 frontmatter 这道门调 Pi 自己的加载器（`scripts/validate-skills.mjs`），判定标准是“会话真能加载这份 Skill”，而不是本仓库重写一遍 frontmatter 解析；机器上没有 node 或 Pi 时降级为 WARN 加内建检查。它**只查结构与加载**，不代表 Skill 在实际任务中的效果已经验证。
- **草稿区**：`processing/` 只放还没进正式目录的东西，提升步骤与门禁见 [AGENTS.md](AGENTS.md)。
- **提升成本固定**：新增一件要同步 7 处硬编码计数（根 README 4 处、`assets/readme/hero.svg` 2 处、`validate.sh` 门 4），所以**按 family 成批提升**，不零敲碎打。
- **唯一原件**：跨 Skill 共用的格式只保留一份。交接文档的格式由 `living-docs-governance` 持有，`session-handoff` 只负责把它写出来——所以点名安装 `session-handoff` 会自动补装前者。

## 9. 几处刻意的取舍

下面这些做法在别处很常见，这里选了另一条路，理由都是可核对的：

| 常见做法 | 这里的做法 | 原因 |
|---|---|---|
| 门面写满代码示例，把正文压到很长 | 门面写主干，细节进 `references/`（渐进披露） | 长代码示例会挤掉"先探测仓库"的注意力 |
| 把阈值与强制流程写进 Skill（覆盖率 80%、必须 RED→GREEN→REFACTOR） | 阈值交给项目或调用方，Skill 只要求取证 | 阈值属于项目策略，写进 Skill 就会与仓库冲突 |
| 用优先级让专用规则盖掉通用规则 | 路由：转交给 owner | 见第 7 节 |
| 复制即分发（同一内容镜像到多个框架目录） | 单一来源 + 安装时复制（`scripts/install.sh`） | 复制出来的副本没法维护 |
| 引用框架自带的 agent、命令、persona | 不引用本仓库里不存在的东西 | 单独摘出来就是死链 |

## 10. 已知取舍与未解

1. **L3 不写 API 手册**：换来不过期，代价是每次都要现场取证。
2. **没有语义一致性工具**：六道门全是结构检查，跨 Skill 的重复与冲突靠人发现。第 4 节那张依赖图目前没有门禁，候选做法是把它做成第 7 道门。
3. **`skills/meta/` 是合法但空的 family**。
4. **中文触发词有误触发风险**：`ts-frontend` 在 Vue、Svelte 项目里也可能被触发（已接受）。
5. **策略阈值一律不由 Skill 规定**：覆盖率、重试上限、超时值交给项目或调用方。

## 11. 改动时同步哪几处

- **新增或删除 Skill**：按 [AGENTS.md](AGENTS.md) 的第 3 步同步数字与目录表；涉及 workflows 时再同步 `skills/workflows/README.md`。
- **改了阶段边界或结论规则**：`skills/workflows/README.md` 与相关 `SKILL.md` 一起改。
- **改了分层、依赖方向或设计约束**：本文与 [AGENTS.md](AGENTS.md) 一起改。
- **收工前**：`bash scripts/validate.sh` 全绿。
