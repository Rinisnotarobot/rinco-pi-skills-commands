---
status: accepted
date: 2026-09-03
---

# 以 Rinco 作为证据内核，选择性吸收 Matt 的发现层

2026 年 2 月至 3 月，ECC 风格的 `spec → plan → tdd → verification → code-review` 流程已经在一个从零到一的 TypeScript 全栈博客项目中得到实际验证。迁移到 Pi 后，项目继续以 Rinco 的单一所有者、无环交接和证据门禁作为唯一交付内核，只选择性吸收 Matt 技能体系中改善需求发现、领域语言、模块设计、任务切片和上下文管理的能力，不全盘替换 Rinco，也不长期并行运行两套完整流程。

## 决策

### 权威所有者

| 职责 | 唯一所有者 |
|---|---|
| 行为、约束和验收契约 | `spec` |
| 仓库实现策略、切片和验证合同 | `plan` |
| 未知故障的根因证明 | `systematic-debugging` |
| 行为实现及 RED、GREEN、REFACTOR 证据 | `tdd` |
| 当前代码状态的门禁结论 | `verification` |
| Git diff 的独立评审结论 | `code-review` |
| 修复流程的路由与交接 | `fix` |

引用型或原语型 Skill 可以只拥有词汇、纪律或访谈机制，不必制造 verdict。编排型 Skill 只拥有路由状态，不复制下游阶段的结论。

### 选择性吸收

优先适配以下 Matt 能力：

- `grilling`：在规格前压力测试决策树，事实由 agent 查证，决策由用户作出；
- `domain-modeling`：维护纯领域词汇的 `CONTEXT.md`，并只为难以逆转、缺少上下文会令人意外且存在真实权衡的决定创建 ADR；
- `codebase-design`：提供 module、interface、depth、seam、adapter、leverage、locality 的共享设计语言；
- `prototype`：为无法通过讨论解决的单一设计问题生产可运行证据；
- tracer-bullet、blocking edges、phase boundary 和 context pointer 等方法。

`to-tickets` 只以窄适配器的形式吸收。该适配器把已经批准的 Rinco plan slices 发布为调度票，不重新切片、不重写需求、不产生第二份验证合同。

`wayfinder`、架构扫描和通用 research 属于后续可选分支，只有真实任务证明需要时才进入正式组合。

### 不引入重叠工作流

正式 Rinco profile 不加载 Matt 的 `to-spec`、`implement`、`tdd`、`diagnosing-bugs` 或 `code-review`。这些 Skill 与现有所有者重叠，会产生平行规格、根因、实现、验证或评审结论。

### Pi 运行时约束

Pi 在启动时发现 Skill，prompt template 只能展开提示词，不能使未发现的依赖在运行中出现。组合流程必须通过启动 profile、`compatibility`、运行时可用性检查和可执行的重启命令管理依赖；核心依赖缺失为 `BLOCKED`，可选下游缺失为 `PENDING`。

不得同时完整加载 Rinco 和 Matt 两个仓库。迁移期使用 `pi --no-skills --skill <path> ...` 建立按任务划分的确定性 profile，避免同名 Skill 的发现顺序决定实际行为。

### 文件型记忆

Pi 缺少通用长期记忆时，以有类型、有所有者和有寿命的文件产物恢复上下文：

- 长期权威：简短的 `AGENTS.md` 指针、`CONTEXT.md` 和 ADR；
- 任务生命周期：spec、plan 和 ticket；
- 代码状态绑定：verification 与 review 报告，相关状态变化后即视为陈旧；
- 探索性证据：research、prototype 及其 artifact pointer；
- 会话交接：当前 owner、phase、HEAD、worktree、阻塞项和下一次显式调用。

不建立无边界的“记忆垃圾桶”，也不把任务状态、规格或实现细节写入 `CONTEXT.md`。

## 后果

- Rinco 保留已经被实际项目证明有效的安全与交付闭环。
- Matt 的能力成为可替换的上游和参考层，而不是第二套权威流程。
- 小改动可以省略 grilling、spec、plan 或 ticket 产物，但不能在缺少当前证据时宣称完成。
- 所有引入内容先进入 `processing/skills/`，记录上游来源和本地改动，通过组合验证后才提升到 `skills/`。
- 需要维护任务型 Pi 启动 profile，并承担适配上游更新的成本。
- 每个 artifact 必须声明其权威范围和失效条件，防止文件型记忆变成陈旧缓存。

详细迁移步骤见 [`../plans/2026-09-03-rinco-matt-skill-integration.md`](../plans/2026-09-03-rinco-matt-skill-integration.md)。

## 重新评估条件

只有在多个代表性真实任务中，另一套流程能够以更少返工和相同或更强的缺陷拦截能力稳定取代 Rinco 内核时，才重新评估本决策。单个演示、流行度或文档上的优雅不构成替换证据。
