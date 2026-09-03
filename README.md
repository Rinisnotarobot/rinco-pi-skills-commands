# Rinco Pi Skills & Commands

一组面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程 Skills。仓库以“小而可组合、按需加载、证据门控”为设计原则：稳定内容进入 `skills/`，仍在重构的内容留在 `processing/`。

> [!IMPORTANT]
> 项目仍在建设中。目前没有统一的安装、升级或发布机制，也不会自动修改用户的 Pi 全局配置。`skills/` 表示已通过仓库内审查，不等同于已发布的软件包。

## 架构方向

Rinco 保留单一所有者、无环交接和证据门禁作为唯一交付内核，并选择性吸收 Matt 技能体系的需求发现、领域语言、模块设计、任务切片与上下文管理能力。完整决策见 [ADR 0001](docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md)，实施顺序见 [Rinco 与 Matt Skill 融合计划](docs/plans/2026-09-03-rinco-matt-skill-integration.md)。

## 快速试用

从仓库根目录直接让 Pi 加载一个已验证的 Skill，无需复制文件：

```bash
pi --no-skills --skill skills/workflows/readme
```

进入 Pi 后显式调用：

```text
/skill:readme
```

`--skill` 是 Pi 提供的临时加载参数，`--no-skills` 可避免本机或项目中已有的同名 Skill 产生冲突。其他独立 Skill 也可替换为下表中的目录；是否自动触发由各自的 frontmatter 决定。

`fix` 是组合工作流，临时试用时同时加载其三个核心依赖：

```bash
pi --no-skills \
  --skill skills/workflows/fix \
  --skill skills/workflows/systematic-debugging \
  --skill skills/workflows/tdd \
  --skill skills/workflows/verification
```

进入 Pi 后调用 `/skill:fix <错误信息、失败命令或受影响路径>`。需要转交规格、计划或代码评审时，还应在启动时加载相应的 `spec`、`plan` 或 `code-review` Skill。使用 `--no-skills` 单独试用 `tdd` 或 `code-review` 时，也应按其 `compatibility` 字段同时加载所列依赖。

## 启动 Profile

确定性任务通道用仓库自带启动器启动，避免发现顺序与同名冲突；启动器会在启动前校验：路径存在、frontmatter 有 `name`、列表内无重名，不满足则拒绝启动：

| Profile | 任务形态 | 加载的 Skills |
|---|---|---|
| [`profiles/shape.sh`](profiles/shape.sh) | 模糊变更：需求发现与规格 | grilling、domain-modeling、codebase-design、spec、plan、terminal-ops、context7-docs、session-handoff |
| [`profiles/build.sh`](profiles/build.sh) | 已规划实现 | plan、tdd、systematic-debugging、verification、code-review、coding-standards、terminal-ops、session-handoff |
| [`profiles/fix.sh`](profiles/fix.sh) | 未知根因缺陷 | fix、systematic-debugging、tdd、verification、code-review、coding-standards、terminal-ops、session-handoff |
| [`profiles/review.sh`](profiles/review.sh) | 独立评审当前变更 | code-review、verification、coding-standards、terminal-ops、session-handoff |

用法：`./profiles/shape.sh [附加 pi 参数]`。Skill 的 `BLOCKED`/`PENDING` 报告会给出所需依赖的精确重启命令；prompt template 只做薄入口，不承担加载职责。

## 已验证的 Skills

### 工程工作流

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`plan`](skills/workflows/plan/) | 自动或显式 | 基于代码库证据生成包含文件、symbol、依赖和验证步骤的实现计划。 |
| [`readme`](skills/workflows/readme/) | 自动或显式 | 创建、重写、审查或更新 README，并验证关键声明、命令和本地链接。 |
| [`grilling`](skills/workflows/grilling/) | 自动或显式 | 在规格之前分轮压力测试决策树，达成共同理解后输出决策 handoff 并停止。 |
| [`prototype`](skills/workflows/prototype/) | 自动或显式 | 用抛弃式原型回答单一命名设计问题，返回证据 handoff（答案、产物位置、观察结果、局限），不碰生产分支。 |
| [`spec`](skills/workflows/spec/) | 仅显式 | 将已探索的产品或工程变更写成可追踪、可验收的持久规格。 |
| [`fix`](skills/workflows/fix/) | 仅显式 | 编排缺陷诊断、最小安全修复与最终验证，并保留单一证据结论。 |
| [`publish-tickets`](skills/workflows/publish-tickets/) | 仅显式 | 把已批准实现计划的切片序列化为调度票（一票一切片、依赖边、需求追溯、基准 revision），不重新分解。 |
| [`session-handoff`](skills/workflows/session-handoff/) | 仅显式 | 把当前会话序列化为 fresh session 可接手的交接文档（格式归 living-docs-governance 所有，写到临时目录、含精确重启命令），仅限用户显式请求。 |
| [`tdd`](skills/workflows/tdd/) | 自动或显式 | 以行为优先的垂直切片执行 RED → GREEN → REFACTOR。 |
| [`systematic-debugging`](skills/workflows/systematic-debugging/) | 自动或显式 | 在修复前通过最小复现、因果追踪和单假设实验确认根因。 |
| [`verification`](skills/workflows/verification/) | 自动或显式 | 从仓库配置发现并执行质量门禁，输出基于新鲜证据的验证结论。 |
| [`code-review`](skills/workflows/code-review/) | 仅显式 | 审查 Git diff，并将证据化报告写入 `docs/reviews/`。 |

### 架构模式

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`backend-patterns`](skills/patterns/backend-patterns/) | 自动或显式 | 根据约束和权衡选择服务边界、数据一致性、消息、缓存、韧性、安全与可观测性模式。 |
| [`codebase-design`](skills/patterns/codebase-design/) | 自动或显式 | 提供 module、interface、depth、seam、adapter、leverage、locality 的共享模块设计词汇与深模块评估原则；纯参考层，不自主重构。 |
| [`coding-standards`](skills/patterns/coding-standards/) | 自动或显式 | 按仓库证据应用语言无关的命名、可读性、控制流、重复、变更与错误处理基线。 |
| [`domain-modeling`](skills/patterns/domain-modeling/) | 自动或显式 | 建立并锐化项目领域词汇（纯词汇表 CONTEXT.md），只为难逆转、缺上下文会意外且真实权衡的决策创建 ADR；变更范围受限并随 handoff 报告。 |
| [`living-docs-governance`](skills/patterns/living-docs-governance/) | 自动或显式 | 为既有文档分派 Constitution/Map/Status/History 四角色，定义产物寿命与新鲜度规则，治理项目入口的瘦读取序列与删除区。 |
| [`security-review`](skills/patterns/security-review/) | 自动或显式 | 深度审查变更触及的信任边界，只报有证据支撑的利用路径（源→汇→路径 + 置信度门），独立于 code-review 的一般性结论。 |

### 工具与集成

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`context7-docs`](skills/tools/context7-docs/) | 自动或显式 | 通过 ctx7 CLI 获取当前且版本明确的第三方文档和示例。 |
| [`find-skills`](skills/tools/find-skills/) | 自动或显式 | 搜索并评估生态中已有的可安装 Skills。 |
| [`gh`](skills/tools/gh/) | 自动或显式 | 以结构化输出和受限环境回退策略执行 GitHub CLI 操作。 |
| [`terminal-ops`](skills/tools/terminal-ops/) | 自动或显式 | 以真实命令输出为依据检查、修改和验证仓库。 |

### 元技能

| Skill | 调用方式 | 用途 |
|---|---|---|
| [`writing-for-agents`](skills/meta/writing-for-agents/) | 自动或显式 | 编写和维护 Skills、`AGENTS.md`、`CLAUDE.md` 等 agent 消费的文档。 |

“仅显式”表示 frontmatter 设置了 `disable-model-invocation: true`；其余 Skill 既可由 Pi 按描述自动加载，也可通过 `/skill:<name>` 调用。

## 工作流 Skill 最佳实践

### 先划分职责，再连接流程

让一个 Skill 只拥有一种结论，组合 Skill 只负责路由和交接：

| 角色 | 当前 Skill | 唯一职责 |
|---|---|---|
| 需求契约 | `spec` | 定义期望行为、约束与验收证据意图。 |
| 实现计划 | `plan` | 把契约映射到代码路径、切片和验证合同。 |
| 根因诊断 | `systematic-debugging` | 证明因果链并返回 handoff，不修改生产行为。 |
| 行为实现 | `tdd` | 持有 RED → GREEN → REFACTOR 和受影响测试证据。 |
| 门禁结论 | `verification` | 独占 `READY`、`NOT READY`、`BLOCKED`。 |
| 代码评审 | `code-review` | 独立给出 diff 评审结论，不复制验证结论。 |
| 修复编排 | `fix` | 选择路径、传递 owner，并保证最终只验证一次。 |

典型链路：

```text
行为变更：spec → plan → tdd → verification → code-review
故障修复：fix → systematic-debugging → tdd → verification → code-review
```

箭头表示证据和所有权交接，不表示下游一定能被动态加载。Pi 在启动时发现 Skills；组合工作流必须通过 `compatibility`、README 加载示例和运行时检查声明依赖。

### 保持无环、单一所有者

- user-invoked Skill 负责编排和需要人类决策的入口；model-invoked Skill 提供可复用纪律。
- 为诊断、实现、验证和评审各指定一个 owner。上游返回 handoff 后停止，不继续执行下游职责。
- 调用链保持有向无环。下游需要回到上游能力时，请求一个限定范围的 handoff，再从原阶段恢复；例如 TDD 请求 diagnosis handoff，而不是让 debugging 再次启动 TDD。
- 后续修改会使旧验证结论失效；回到实现阶段后，只由 verification 在最终状态重新给出一次 verdict。

### 使用可检查的证据交接

至少传递：

```text
Producer: <证据生产者>
Claim: <可观察主张>
Scope: <比较点、路径、包或服务>
Owner: <下一阶段负责人>
Method and result: <命令或观察、退出状态、关键信号>
Sequence and worktree: <证据产生时点、前后状态>
Prerequisites and limits: <环境要求与不能证明的内容>
```

下游仅在 claim、scope、sequence、worktree、authority、result 和 prerequisites 仍匹配时复用证据；否则重新运行安全门禁或明确返回 `BLOCKED`。

### 为每一步设置门控

- 用可观察且穷尽的 completion criterion 结束每一步，避免“分析完成”“应该可用”等主观状态。
- 先建立能命中目标故障的最窄 RED，再实施修改；无法安全复现时，明确 observational gate 的局限和批准要求。
- 将 `PASS`、`FAIL`、`BLOCKED`、`N/A`、`PENDING` 分开。缺失工具或授权是 `BLOCKED`，后续阶段负责的证据是 `PENDING`，不适用才是 `N/A`。
- 对依赖安装、锁文件、公共契约、迁移、生产访问和外部副作用设置显式批准门。
- 保留无关工作；每个执行型门禁前后检查 worktree，命令产生未批准修改时立即停止。

### 验证组合而不只验证单个文件

发布到 `skills/` 前至少覆盖这些场景：

1. 正常路径能到达唯一最终 verdict；
2. 未知根因能诊断后恢复原工作流，且不会递归；
3. 下游 Skill 未加载时得到可执行的 `BLOCKED` 或 `PENDING`；
4. 陈旧 handoff 被拒绝或刷新；
5. observational、外部副作用和高风险评审分支有明确 owner；
6. 所有 frontmatter、相对引用、README 加载命令和 worktree 完整性检查通过。

把所有分支都需要的步骤保留在 `SKILL.md`，只把特定分支的规则和长篇参考放入 `references/`。保持顶层流程短、顺序明确，并让每个引用旁边写清加载条件。

## 待处理内容

尚未完成重构的 Skills 位于 [`processing/skills/`](processing/skills/)。它们可能包含重复、过时或尚未验证的规则，不应与 `skills/` 中的已验证实现等同使用。

## 仓库结构

```text
.
├── AGENTS.md               # 本仓库的 agent 编写与校验规则
├── README.md
├── docs/
│   ├── adr/                # 架构决策记录
│   └── plans/              # 路线图与实现计划
├── skills/                 # 已重构并通过仓库验证的 Skills
│   ├── workflows/          # 端到端工程工作流
│   ├── patterns/           # 可复用参考纪律：架构模式、设计语言、文档治理
│   ├── tools/              # CLI 与外部文档工具纪律
│   └── meta/               # 编写 agent 文档的元技能
├── processing/
│   └── skills/             # 待调研、重构或验证的 Skill 草稿
└── profiles/               # 确定性任务通道启动器（shape/build/fix/review）
```

每个 Skill 以 `SKILL.md` 为入口，并可通过 `references/`、`scripts/` 或 `assets/` 渐进披露细节。

## 如何贡献或提升 Skill

先阅读 [`AGENTS.md`](AGENTS.md)；它是本仓库的权威维护规则。基本流程是：

1. 调研指定的一手参考源，并用 `npx skills find <query>` 检查生态中是否已有成熟实现。
2. 在 `processing/skills/<name>/` 创建或重构草稿。
3. 明确 user-invoked 或 model-invoked 契约，并为流程步骤设置可验证门控。
4. 检查 frontmatter、目录名、本地引用和手工场景。
5. 验证通过后移入 `skills/workflows/`、`skills/patterns/`、`skills/tools/` 或 `skills/meta/`。
6. 同步更新本 README；在提交或 PR 描述中列出实际使用的来源 URL 与本地改动。

当前架构决策与实施顺序见 [ADR 0001](docs/adr/0001-rinco-evidence-kernel-with-matt-discovery-layer.md) 与 [Rinco 与 Matt Skill 融合计划](docs/plans/2026-09-03-rinco-matt-skill-integration.md)。剩余 Skill 组合（security-review、resilience、frontend-patterns）见 [Skill 组合重点计划](docs/plans/2026-09-03-skill-portfolio-focus.md)。在组合完成并通过验证前，仓库不维护安装、复制或发布工具。
