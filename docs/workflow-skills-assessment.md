# Rinco Pi Workflow 技能组评估报告

> 文档角色：探索性评估快照，不是当前安装规范。现行使用约定见 [README「快速开始」](../README.md#快速开始)，维护决策见 [AGENTS.md](../AGENTS.md)。

## 使用前提校正（2026-09-08）

用户确认：workflow Skills 面向大型持续开发项目，采用一次性完整安装，在一个长 session 或多个 session 中完成任务。用户平常启动 coding agent，不应承担按任务选择 Skills、记住启动参数或在阶段切换时补装的成本。

这改变了原评估的改进方向：

- `shape / build / fix / review` 是整套能力内的任务路径，不是安装套装。「按任务装配」和「为只装单个提供路径」不再作为目标。
- 缺失伙伴、发现异常和来源冲突属于安装异常；保留 `BLOCKED` / `PENDING` 及恢复后的调用指引，不再要求每个 workflow 拼出参数化启动命令。正常阶段交接留在当前 session，跨 session 依靠制品、证据状态和下一调用续接。
- 整套安装不等于正文全量注入或所有阶段自动执行。Pi 仍按调用模式暴露入口、按需读取正文；显式授权、唯一 owner 和证据新鲜度规则保持不变。

本轮已对齐 README、AGENTS 及原报告指出的 8 处 Skill 恢复说明。下文保留原始评估，以呈现误设「自由混搭安装」带来的设计摩擦；其中 12 个 workflow、样板数量、评分等均为历史统计，不是当前状态，也未在本次校正中重新评估。仅抽取重启样板而保留按任务装配，不能解决这一使用前提偏差。

---

**范围**:`skills/workflows/` 12 个 Skill 的约束体系、设计使用方式与"拧巴程度"评估
**方法**:通读 README.md、AGENTS.md 及 12 个 `SKILL.md` 全文;`references/` 仅核对目录清单;辅以词频/样板统计(grep);未实际运行技能,未跑 `scripts/validate.sh`
**结论预览**:概念层一致性很强(约束 2/10 拧巴);文本层与运行层拧巴明显(8/10)——整体约 **6.5/10**,根因是"软约束被写成硬条款形态,而宿主无强制执行手段,文档以重复与自我引用代偿"

---

## 一、体系概览

```text
模糊变更: shape → spec → plan → tdd → verification → code-review
未知故障: fix → systematic-debugging → tdd → verification → code-review
```

箭头 = 证据与所有权交接,不是自动调用。权威源三层:README「设计原则」→ 各 `SKILL.md`(Workflow / Completion Criterion / Guardrails)→ `references/`。另有两份纪律文档:`AGENTS.md`(维护规则、既定决策)、`README.md`(设计原则、套装)。

### 1.1 成员与调用模式

| 类别 | 标记 | 触发 | 成员 |
|---|---|---|---|
| model-invoked(自动/显式) | 无 `disable-model-invocation` | 模型按 description 选中,可 `/skill:xxx` | grilling、plan、prototype、systematic-debugging、tdd、verification、readme |
| user-invoked(显式) | `disable-model-invocation: true` | 仅用户 `/skill:xxx` | spec、fix、code-review、publish-tickets、session-handoff |

### 1.2 核心约束体系(九类)

1. **单一权威 owner**:一个责任一个 owner,下游不平行复制上游结论;`verification` 独占 `READY`/`NOT READY`/`BLOCKED`;`code-review` 独立结论不复制验证状态;`systematic-debugging` 证明根因即停、不改生产行为。
2. **交接与停止**:固定字段 handoff、指名 next owner 与显式调用;user-invoked 阶段交接即停,不链式调用另一 user-invoked。
3. **状态词表与结论门禁**:`READY`/`NOT READY`/`BLOCKED`(verification)、`PENDING`(下游/可选)、`N/A`(仅"不适用",禁止为凑 READY 挪用)、`INCONCLUSIVE`(review)、`UNASSIGNED`(debugging);fail 归因 change-introduced / baseline / environment / unknown。
4. **证据约束**:新鲜且同状态(绑定 revision/worktree);命令级可复现、首条失败不截断、flaky 后次 pass 不抹前次 fail;verification 只读运行、前后 `git status`、不自动修复;报告先于声明。
5. **依赖声明与启动协议**:frontmatter `compatibility` 声明 + 运行时可用性检查;缺失 → `BLOCKED` + 指名缺失项 + 安装目的地 + 精确重启命令;可选下游缺失 → `PENDING`;不提供安装/启动/发布机制。
6. **作用域固定**:开工前钉死 claim、stage、比较点(缺省 = 全部 worktree 改动 vs HEAD)、允许范围;无目标则 `BLOCKED`。
7. **行为边界 / Guardrails**:改生产行为前必须走对应通道;副作用(持久数据、生产、外发、成本、依赖变更、破坏性 git、迁移)先问;诊断信息消毒。
8. **每步 Completion Criterion 门控**:每步以可验证完成判据收尾(全组共 71 处)。
9. **制品纪律**:产出型 workflow 唯一期望的仓库变更 = 单个 Markdown artifact;路径优先级(用户指定 → 仓库权威目录 → `docs/specs|plans|reviews/YYYY-MM-DD-<slug>.md`),存在则 `-2/-3` 不覆盖;写完读回;会话只回路径+摘要;`session-handoff` 写 `$TMPDIR`、只给 path+revision、禁止推断填空。

### 1.3 当时文档声明的使用方式

- **安装 = 目录复制**:项目级 `.pi/skills/<name>/` 或全局 `~/.pi/agent/skills/<name>/`;重启或 `/reload` 生效;删除即卸载;`skills/` 为权威安装源。
- **按任务装配 + 推荐套装**(shape / build / fix / review),套装带"必需参考内容":`codebase-design`(plan/tdd/code-review 共享词汇)、`living-docs-governance`(session-handoff 格式唯一来源)。
- **运行姿势**:阶段内模型自主执行(证据门控),阶段边界用户拍板(显式调用、副作用批准、决策确认);模型跑腿取证,不替用户做产品决策、不批准评审/发布。
- **恢复协议**:核心伙伴缺失 → `BLOCKED` + `pi --no-skills --skill <实际安装路径> ...` 精确重启命令 + 显式调用。

---

## 二、拧巴程度评估

### 2.1 总评

| 层 | 拧巴度 | 说明 |
|---|---|---|
| 概念层 | 低(2/10) | owner/交接/证据绑定自洽,边界声明彼此对得上 |
| 文本层 | 高(8/10) | 恢复协议样板 ×8、报告模板家族、自我引用深 |
| 运行层 | 高(8/10) | 关键协议(显式调用语义、compatibility、owner-token)全部软执行 |
| **综合** | **≈6.5/10** | 系统性自洽,工程化过度,靠文档自律运转 |

### 2.2 三大主要拧巴点

**拧巴点 1:BLOCKED-重启协议被平行复制 8 次(最高原则的自我违背)**

AGENTS.md 最高原则是"Rinco 唯一内核、下游结论不平行复制",但体系内复制度最高的恰是自己的恢复协议:`pi --no-skills --skill <path> ...` 样板完整出现在 **8 个文件**(code-review、fix、plan、publish-tickets、session-handoff、tdd、verification、patterns/resilience),每处 100–200 字、同构不同措辞("保留 X 加装 Y""派生自本安装""标为安装前置条件""checkout 示例不可移植")。改一处措辞,7 处漂移;`validate.sh` 查不出语义漂移。按自身"单一 owner"逻辑,此协议应收敛为单一引用源,而非 8 份拷贝。

**拧巴点 2:门禁语言承诺可验证性,多数 Completion Criterion 只能自证**

全组 71 处 Completion criterion 分三类:

- **真门禁**(少):"测试以预期原因失败"、"gate 有新鲜 PASS/FAIL/BLOCKED 证据"——可被命令输出证伪;
- **声明式门禁**(多):"every round asked only frontier questions"、"every blocker is answered, delegated, or reported"、"two readers can agree on what success includes"——无法被任何观察证伪,模型宣布满足即满足;
- **仪式性门禁**:spec/plan/code-review 的"write artifact, read it back, confirm no section truncated"——自我检查无强制力。

"证据门控"在关键处退化为自我声明,恰是它们批评建议性文字时所指的空话,只是穿了门禁外衣。

**拧巴点 3:关键协议全部无运行时强制,靠 prompt 文本纪律续命**

- `disable-model-invocation` 挡不住模型流程中途"顺手开写 spec/评审";README 承认需人工三态核验(模型列表 / `/skill:` 命令 / 执行授权);
- owner-token 传递协议("orchestrator must pass that ownership instruction when invoking TDD; do not infer it from surrounding context")的 token 是自然语言句子,验证手段是 read back;上下文压缩/会话切换即断链;
- 结论:8 份重启样板不是懒惰,是软执行系统的必然产物——**协议越不可强制,文档越要反复自我重申**。这是整个体系拧巴的总根源:把软件工程纪律翻译成只能劝说的文本,却保留纪律的完整词汇与仪式。

### 2.3 次要拧巴点

- **装配自由是虚假承诺**:README 宣称可自由混搭,但 tdd 依赖 codebase-design 词汇、session-handoff 依赖 living-docs-governance 格式,语义依赖图使"只装一个"悬空(能跑,引用语义丢失),自由混搭的真实代价是高频 `BLOCKED` 中断。
- **`BLOCKED` 同词异义**:fix=缺依赖、verification=缺证据无法结论、publish-tickets=输入非 plan artifact、code-review=伙伴缺失——家族相似,勉强可辩护,新读者需逐语境学习。
- **显式调用链摩擦(有意为之)**:fix 完成须停住请用户再敲 `/skill:code-review`;verification 每轮前后 `git status` + 全量 gate,小修复 = 全链重跑。安全性明确优先于流畅性,真实使用中摩擦高。

### 2.4 相对不拧巴的部分

- 交接双轨(对话摘要 vs 落盘 artifact):spec/plan 明确"回路径+计数、不复制全文",避免上下文爆炸;
- 状态词核心三分 + `PENDING`/`N/A` 的决策规则机械清晰("required failure + blocker 并存 → `NOT READY`"),是全套词表最不漂移的部分;
- prototype、publish-tickets 边界陈述简洁无重叠("一个问题一个原型""绝不自己重切片"),写得最不拧巴。

### 2.5 根因分析

拧巴的根因不是想得乱,而是**想得太满**:每个软性约束都被写成硬性条款的形态,而宿主(Pi + LLM)没有提供硬性执行手段。文档因此承担了本应由机制承担的强制力,以重复、自我引用与仪式代偿。

---

## 三、原改进建议(历史记录，安装相关建议已由上文校正取代)

1. **收敛恢复协议为单一引用源**:把 BLOCKED-重启样板抽成一份共享引用(如 `references/recovery-protocol.md` 或 meta skill),8 处改为指向它,只保留一行的差异描述;把"本安装路径""前置条件"等易漂移措辞收口。
2. **Completion Criterion 分档标注**:区分 `[verifiable]`(命令/观察可证伪)与 `[declarative]`(进度声明)两类,或把声明式判据改写为"下一步可观察产物";至少停止用不可证伪句子冒充门禁。
3. **承认并标注软执行边界**:在 README/AGENTS 中明确"协议依赖模型行为,无运行时强制",把人工核验点(模型列表/命令/授权三态)收敛为一个检查清单,减少每文档各写一遍的防御性说明。
4. **为"只装单个"提供真实路径**:要么放宽语义依赖(词汇引用降级为可选),要么明示最低携带组合,消除虚假的装配自由承诺。
5. **模板字段收敛**:verification / fix / review / debugging / tdd 的报告模板是家族相似重写,可抽共享字段定义(claim/scope/worktree/verdict/residual),供 validate.sh 做结构比对。

---

## 四、附录:统计证据

| 指标 | 值 | 出处 |
|---|---|---|
| workflow SKILL.md 行数 | 1,219 行(58–158/文件) | `wc -l skills/workflows/*/SKILL.md` |
| Completion criterion 总数 | 71(verification/systematic-debugging/spec/plan/fix/code-review 各 7;tdd 6;publish-tickets/prototype/grilling 各 5;session-handoff 3;readme 0) | `grep -rc 'Completion criterion'` |
| 重启指令样板文件数 | 8(code-review、fix、plan、publish-tickets、session-handoff、tdd、verification、resilience) | `grep -rl 'pi --no-skills --skill'` |
| `BLOCKED` 词频(workflows SKILL.md) | 27 | `grep -ro` |
| references/ 分布 | code-review 3、systematic-debugging 3、tdd 4、verification 4、plan/spec/prototype/readme 各若干 | 目录清单 |

**评估限制**:未运行 `scripts/validate.sh`;未实测任何 skill 在真实会话中的行为(所有"运行层"判断基于文本推演);`references/` 子文件未逐篇精读,模板家族重复度的判断基于 SKILL.md 主文件。
