# 草稿区

`processing/` 是草稿区：还没准备好进入 `skills/<family>/<name>/` 的 Skill 先放这里。这里的内容**不随 `scripts/install.sh` 分发，也不计入根 README 的 Skill 计数**。

分层、依赖方向与设计约束见 [DESIGN.md](../DESIGN.md)。

## 提升前的自查清单

按顺序检查，任一项不过就不要提升。清单来自那批没能提升的草稿留下的实际失败模式。

1. **归属**：先确认这些内容在已发布 Skill 里有没有 owner。已被覆盖的部分不要搬进来，只留真正空白的那部分。分工见 [Workflows 设计与用法](../skills/workflows/README.md)和 `skills/patterns/*/SKILL.md`。
2. **触发与 frontmatter**：`description` 要带 `Use when …` 触发句和 `中文触发：` 一行。Pi 只在上下文里常驻 `name` 和 `description`，由 `description` 决定是否加载（上限 1024 字符），写在正文里的 `## When to Activate` 不会触发加载。顶层字段只用 `name`、`description`，以及需要点名叫用时才用的 `disable-model-invocation`（目前只有 `publish-tickets` 和 `session-handoff` 用它）。来源说明写在 `metadata:` 下（`tools/readme` 记 `version`/`origin`/`upstream`/`note`）。不要带 `keywords`、`file_patterns`、`confidence` 这类外部注册表字段——Pi 不读它们。
3. **不写版本绑定内容**：不写覆盖率阈值、不写具体门禁命令、不写框架或库的 API 手册。阈值和门禁归 `tdd` 与 `verification`；版本相关的行为改成"读锁文件版本 → 抄现成调用点 → 拿不准标 unverified"。
4. **不引用不存在的东西**：写下其他 Skill、agent 或 slash 命令的名字之前，先确认它在本仓库存在。从外部框架搬来的草稿常引用本仓库并不存在的 persona、编排协议和斜杠命令（`Personas (Thinking Modes)`、`Delegation Protocol`、`Tool Coordination` 这类分节名就是签名）。
5. **结构**：内部链接写 `references/<file>.md`，不要带 `skills/<name>/` 前缀；每个 reference 结尾要有 `## Verification` 分节，并且必须能从 `SKILL.md` 走到。

## 提升

放进 `skills/<family>/<name>/`，再同步根 README 的计数、目录表和 `assets/readme/hero.svg`，最后运行 `bash scripts/validate.sh`。
