---
status: accepted
date: 2026-09-03
---

# 自选安装 Skill，以推荐套装适配工作流

[ADR 0001](0001-rinco-evidence-kernel-with-matt-discovery-layer.md) 把「启动 profile」列为组合依赖管理的机制之一，仓库随之实现了 `profiles/` 下的 4 个固定任务启动器（shape / build / fix / review）、共享的 `lib.sh` 和 `validate.sh` 的 profile 门禁。实际审视后发现：启动器把组合关系硬编码在 shell 层，与「Skill 既可单独使用、又按需组合」的模型相抵触——组合所必需的机制本来就已内建于每个 Skill。

## 上下文

依赖管理在 Skill 层已经闭环，无需外层脚本参与：

- **frontmatter `compatibility`**：每个工作流显式声明所需伙伴，例如 `tdd` 声明 "Requires verification unless an upstream orchestrator owns the final verdict"；
- **运行时可用性检查**：Skill 在使用依赖前确认其已安装并加载，缺失时停止；
- **可执行的重启指令**：缺失依赖以 `BLOCKED` / `PENDING` 返回，指名缺失的 Skill 并给出补齐后重启会话的具体方式。

启动器在此之上只额外提供一件事：首次启动预载一组搭配好的 Skill，省掉一次 `BLOCKED` → 重启往返。这是便利性而非架构必需，其代价是 5 个 shell 脚本、一道专用校验门禁、4 种硬编码的任务形状，以及 README、AGENTS.md、ADR、Skill 正文中的多处措辞耦合。

同时，Pi 在启动时自动发现已安装的 Skill（项目 `.pi/skills/` 或全局技能目录）。用户完全可以自己决定装哪些：从仓库浏览、按需复制安装，Pi 重启后即可用。仓库不需要也不应该用脚本替用户做这个决定。

## 决策

1. **删除 `profiles/` 与 `validate.sh` 的 profile 门禁**；不提供任何启动器或命令配方作为使用入口。
2. **使用模型 = 按需自选安装**：用户从 `skills/` 浏览并挑选所需 Skill，把 Skill 目录复制进 Pi 的发现路径（项目 `.pi/skills/` 或全局技能目录），重启 Pi 即生效。仓库仍不提供安装、升级或发布工具（与 AGENTS.md 的现状约束一致）；安装动作就是复制目录，`.pi/skills/` 镜像是本仓库自用的安装示例。
3. **README 提供推荐套装**：沿用原启动器验证过的搭配，按任务类型给出四套推荐组合（shape / build / fix / review），说明每套适配的工作流链路与各成员角色。套装是建议而非机制——用户可以整套装用、只装其中一个，或自由混搭；未安装的依赖由 `compatibility` 声明、运行时检查和 `BLOCKED` 重启指令兜底。
4. 组合依赖管理完全由 ADR 0001 其余三项机制承担：`compatibility`、运行时可用性检查、可执行的重启指令。
5. 本决定取代 ADR 0001 「Pi 运行时约束」一节中「启动 profile」作为依赖管理机制的表述，以及「后果」中「需要维护任务型 Pi 启动 profile」一项；ADR 0001 其余内容（权威所有者、选择性吸收、文件型记忆、迁移期确定性规则）不变。

## 后果

- Skill 的重启指令改为：「安装或启用指名的缺失 Skill，然后重启会话」；临时试用未安装 Skill 时仍可显式传 `pi --no-skills --skill <path>`。
- 首次使用若未装齐推荐套装，可能出现一次 `BLOCKED` → 安装重启的往返；这是诚实组合的可接受成本，推荐套装将其降到最低。
- ADR 0001 的迁移期规则不变：不同时完整加载 Rinco 与 Matt 两仓库，避免同名 Skill 的发现顺序决定行为——用户安装时按套装选择性复制即天然满足。
- `session-handoff`、`verification`、`resilience` 等 Skill 输出的重启指令指名缺失 Skill 与安装位置，不再引用启动器路径。
- 校验面收窄：Skill 结构门禁（frontmatter、链接、孤儿引用、README 清点、调用契约、镜像副本）保留，profile 专用门禁随目录一起删除。

## 重新评估条件

当多个代表性真实任务反复出现会话组合错误（装错、装漏、同名冲突频发），以致自选安装明显拖慢真实工作时，重新评估是否提供最小安装工具。单次的便利诉求不构成重建启动器或强制安装器的证据。
