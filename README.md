# Rinco Pi Skills

面向 [Pi coding agent](https://github.com/earendil-works/pi) 的工程方法 Skills 集合：19 件 Skill 各定义一个阶段的方法（诊断、规格、计划、TDD、验证、评审、交接……），由 agent 按问题自由组合。装入 Pi 的某个发现范围即按需触发——不要求"整套同场安装"；唯一例外：`session-handoff` 点名安装时自动同装其格式宿主 `living-docs-governance`。

[安装](#安装) · [组合方式](#组合方式) · [Skills 目录](#skills-目录) · [设计原则](#设计原则) · [仓库结构](#仓库结构) · [参与维护](#参与维护)

> [!NOTE]
> `skills/` 是权威副本，结构由 `bash scripts/validate.sh` 校验；`processing/` 是草稿区，不是稳定 Skill。仓库不维护版本清单——克隆即最新；升级 = 重拉 + 重装。

## 安装

最简单路径：克隆本仓库，在 Pi 中打开，让 agent 代装——它会先确认"装哪些、装到哪"再执行：

1. **装哪些**：默认全部 19 件（16 workflows + 2 patterns + readme）；可点名子集，如 `spec plan tdd`。
2. **装到哪**：默认全局 `~/.pi/agent/skills/`（所有项目可用）；仅当前项目则 `--scope .pi/skills`。
3. **执行**：`bash scripts/install.sh [--scope <目录>] [skill...]`——把每件 Skill 连同 `references/` 镜像到 `<scope>/<name>/`，幂等：重复执行只覆盖同名文件。

不想让 agent 代劳时，上面三步等价于直接跑 install.sh（无参数 = 全部装到全局）。

**依赖例外**：`session-handoff` 的交接格式只存在于 `living-docs-governance`（单一真源）；点名安装 `session-handoff` 时 install.sh 自动同装该宿主并提示。除这一条外，其余 Skill 均可独立安装使用——缺失时当前会话按同一方法自跑，不因缺 Skill 降证据标准。

**确认成功**：`ls ~/.pi/agent/skills/<name>/SKILL.md`（或对应 scope）；自动触发的 Skill 自下个会话按描述生效，`/skill:<name>` 立即可显式调用（事件型 `publish-tickets` / `session-handoff` 只能这样调）。**卸载** = `rm -rf <scope>/<name>`；**升级** = 拉取仓库最新后重跑 install.sh。

## 组合方式

组合由 agent 按问题选择，不由 Skill 预设链路强制：

- **方法在 Skill，阶段可组合。** 每件 Skill 只对自己阶段的标准流程与证据负责；相邻阶段（"证因 → 实现 → 验证"、"需求 → 规格 → 计划"）是自然的交接方向，不是必须一次走完的管道。
- **Skill 在场 = 该阶段最完整形态；不在场按同一方法自跑**，不许因缺 Skill 跳过门禁或虚报 gate。
- **输入即会话证据。** 阶段产物（决策集、规格 ID、计划切片、诊断 handoff、测试记录）是可选输入：存在且新鲜则复用，缺失就从仓库直接做；没有必须收集的上游仪式。
- **调用模式表达"谁可发起"。** 方法型 workflow 为自动——Pi 按触发词自主选择，也可 `/skill:<name>` 显式调用；事件型 `publish-tickets` / `session-handoff` 仅由用户点名触发，防止模型自主发起外部副作用或打包动作。调用模式不代表"必须与别的 Skill 同场安装"。

### 真实场景组合

读法：每格是一个阶段方法；上一阶段产物是下一阶段的**可选输入**——存在且新鲜则复用，缺失就从仓库直接做。箭头是自然交接方向，不是强制管道；每阶段以证据停止点收尾。

| 场景(典型开口) | 组合 | 关键产物与停止点 | 可调入的 Skill |
|---|---|---|---|
| 新功能,需求模糊(“我想做个 X…”) | grilling → spec → plan → tdd → verification → code-review | 决策集 → REQ/INV/AC → 切片 → RED/GREEN → 验证报告 → 评审报告 | domain-modeling、codebase-design |
| 需求已清,直接实现(“按这份规格做…”) | spec(已有) → plan(compact) → tdd → verification | 最小计划:路径/改动/测试/验证 | coding-standards |
| Bug 根因未知(最常见修复) | systematic-debugging → tdd → verification →(可选)code-review | 证因前硬闸:未证因不进实现;RED 必须真红 | resilience(超时/重试类) |
| 构建/类型/CI 失败,原因直接 | fix(直接非行为路线) → verification | 逐因修改,每改重跑聚焦 gate;签名变了回分类 | — |
| 数据/API/依赖迁移 | spec(consequential) → plan(rollout) →(可选)publish-tickets → 逐票 tdd → verification → code-review | 迁移/回滚/可观测即执行契约;frontier 票=当前阶段 | resilience |
| 评审变更(“review 这个 PR”) | verification(pre-review 状态) → code-review | Review Verdict 与 Verification State 分列;报告只读落盘 | security-review、codebase-design |
| 设计没把握,先试(“这状态机撑得住吗”) | prototype → grilling/spec → plan → tdd | 原型只答一问、只出证据,不进生产分支 | — |
| 拷问想法 | grilling | 决策+拒绝项+未决阻塞,不产出规格 | — |
| 大计划拆票分执行 | plan → publish-tickets →(每票一 session)tdd → verification → code-review | 票+base revision 防过期;跨 session 用票 ID | — |
| 长会话交接新会话 | session-handoff | 交接文档落仓库 `docs/handoffs/current.md`，只存路径与修订，不复制内容；新会话由用户指向读取，AGENTS signpost 接线前不自动发现 | living-docs-governance(格式+接线宿主) |

**三个贯穿分叉**（agent 每次组合都要回答）：① **根因已知吗?** 未证因先诊断,禁止直接改生产行为；② **改行为还是改需求?** 行为已符合意图却要改 = 新需求,路由 spec/plan,不让 fix 硬接；③ **要证明什么?** 实现完跑 verification 拿新鲜门禁,要独立结论跑 code-review——两者都不自封评审或发布批准。

## Skills 目录

调用列读法："自动 / 显式" = Pi 可按描述自主选择，也可 `/skill:<name>` 由用户调用；"显式" = 仅由用户调用（事件型入口，防自主发起副作用）。目录是权威副本；要在 Pi 中使用，将对应 Skill 镜像到某个发现范围（如项目 `.pi/skills/` 或 `~/.pi/agent/skills/`），Pi 递归发现 `SKILL.md`。

### Workflows

> 方法/流程/纪律类技能：阶段方法 + 通用工程流程与规则。

| Skill | 调用 | 作用 |
|---|---|---|
| [`grilling`](skills/workflows/grilling/) | 自动 / 显式 | 以轮询边界问题拷问设计决策树,达成共识即止,只交接决策集。 |
| [`spec`](skills/workflows/spec/) | 自动 / 显式 | 将已澄清意图固化为可追踪、可验收、与实现无关的行为规格。 |
| [`plan`](skills/workflows/plan/) | 自动 / 显式 | 基于仓库证据把契约映射为代码路径、切片、依赖与验证步骤。 |
| [`prototype`](skills/workflows/prototype/) | 自动 / 显式 | 抛弃式原型回答一个设计问题;证据进决策,不进生产分支。 |
| [`publish-tickets`](skills/workflows/publish-tickets/) | 显式 | 将已批准计划的切片一对一发布为调度票，不重切、不改图。 |
| [`fix`](skills/workflows/fix/) | 自动 / 显式 | 端到端修复：证因 → 最小修复 → 终局验证，阶段按方法组合。 |
| [`systematic-debugging`](skills/workflows/systematic-debugging/) | 自动 / 显式 | 用最小复现与可证伪实验证明根因和违反的不变量,修复前停止。 |
| [`tdd`](skills/workflows/tdd/) | 自动 / 显式 | 垂直切片 RED → GREEN → REFACTOR,行为先于实现。 |
| [`verification`](skills/workflows/verification/) | 自动 / 显式 | 以新鲜仓库证据跑门禁,给出 `READY` / `NOT READY` / `BLOCKED`。 |
| [`code-review`](skills/workflows/code-review/) | 自动 / 显式 | 只读评审 diff：四 lens、证据分级，报告落盘，不复制验证状态。 |
| [`codebase-design`](skills/workflows/codebase-design/) | 自动 / 显式 | 提供 module、interface、depth、seam、adapter、leverage、locality 等设计词汇，供切片与测试接口选词。 |
| [`coding-standards`](skills/workflows/coding-standards/) | 自动 / 显式 | 基于仓库证据应用语言无关的代码质量基线。 |
| [`domain-modeling`](skills/workflows/domain-modeling/) | 自动 / 显式 | 维护领域词汇，只为难逆转且存在真实权衡的决策创建 ADR。 |
| [`living-docs-governance`](skills/workflows/living-docs-governance/) | 自动 / 显式 | 为长期文档分派 Constitution、Map、Status、History 角色与新鲜度规则；唯一持有 session-continuation 交接格式。 |
| [`resilience`](skills/workflows/resilience/) | 自动 / 显式 | 设计并审查 deadline、重试、幂等、过载、局部失败和恢复策略及其证据要求。 |
| [`session-handoff`](skills/workflows/session-handoff/) | 显式 | 仅当用户要求时，把当前会话压缩为仓库内活槽位（默认 `docs/handoffs/current.md`）的导航式交接文档；新会话由用户指向读取，AGENTS signpost 接线前不宣称自发现。 |

### Patterns

> 特定编程领域的概念与规则库——领域专属；通用方法与纪律见 Workflows。

| Skill | 作用 |
|---|---|
| [`backend-patterns`](skills/patterns/backend-patterns/) | 按约束选择服务边界、一致性、消息、缓存、安全和可观测性模式。 |
| [`security-review`](skills/patterns/security-review/) | 深查变更触及的信任边界，只报告有完整利用路径的安全发现。 |

### Tools

| Skill | 作用 |
|---|---|
| [`readme`](skills/tools/readme/) | 创建、重写、审计 README,验证关键声明与链接。 |

其余工具与文档类 Skills（如 `writing-for-agents`、`find-skills`、`terminal-ops`）随全局 agent 配置维护，不在本仓库清单内。

## 设计原则

1. **一个阶段一个方法。** 诊断、实现、验证、评审各有独立方法与证据要求；结论不跨阶段复制，也不因兄弟 Skill 缺席而降低标准。
2. **证据门控，不以在场门控。** 结论必须绑定命令、观察结果与 worktree 状态；旧运行不证明当前状态。`BLOCKED` 只用于真实阻断（缺证据、缺授权、环境不可用），不用于"某个 Skill 未安装"。
3. **安全线不因去耦放松。** 副作用前询问；验证通过不等于评审或发布批准；原型代码不折叠进生产；评审结论不与验证状态混同。
4. **渐进式披露。** 核心流程留在 `SKILL.md`，分支与细则放 `references/`；内容写作遵循 `writing-for-agents` 的原则（正面对靶、删套话、单一事实来源）。

## 仓库结构

```text
.
├── skills/
│   ├── workflows/   # 阶段方法与通用工程流程/纪律
│   ├── patterns/    # 特定编程领域概念与规则库
│   ├── tools/       # 工具纪律
│   └── meta/        # (预留)agent 文档元技能
├── processing/      # 待调研、重构或验证的草稿
└── scripts/         # 仓库结构校验(validate.sh)
```

每个 Skill 以 `SKILL.md` 为入口，按需通过 `references/` 披露细节。`bash scripts/validate.sh` 校验 frontmatter、引用可达性、目录清单与调用契约。

## 参与维护

1. 新 Skill 先在 `processing/skills/<name>/` 起草并验证，再移入 `skills/` 对应分类目录。
2. 写作前加载本仓库 `writing-for-agents` 技能（`.pi/skills/writing-for-agents/`）；需检索第三方技能时用 `find-skills` 技能，不凭记忆复述。
3. 检查 frontmatter（`name` kebab-case 且与目录同名、`description` 写明触发条件与调用方式）、本地引用与 references 可达性。
4. 新增或改动 Skill 后同步更新本 README 清单，运行 `bash scripts/validate.sh`，全绿（exit 0）才算通过结构门禁；README 缺失时清单相关 gate 自动跳过。
