# 在本仓库工作的约定

Pi 每次会话自动加载这份文件。这里放每次都要守的约定；为什么这样设计见 [DESIGN.md](docs/DESIGN.md)，每件 Skill 自己的流程见它的 `SKILL.md`。

## 每次改动

1. **先认 owner**：一个阶段或领域一件 Skill。已有内容覆盖了这件事，就把结论交回它的 owner，不复制一份。
2. **依赖单向**：`stacks/` 引用 `workflows/` 与 `patterns/`；这两层不反过来引用 `stacks/`。技术栈内容只进 `stacks/`，`patterns/` 里只留与语言无关的决策。
3. **不写会过期的断言**：覆盖率阈值、门禁命令清单、库的 API 手册都不进 Skill。版本相关的行为走"读锁文件版本 → 抄仓库里现成的调用点 → 拿不准标 unverified"。
4. **名字要真实存在**：写下其他 Skill、agent、slash 命令的名字之前，先确认它在本仓库里（`ls skills/*/<name>`）。
5. **触发面只有 description**：`description` 决定加载（上限 1024 字符），带 `Use when …`；正文里的 `## When to Activate` 不触发；`keywords`、`file_patterns`、`confidence` 这类注册表字段 Pi 不读。

## 新增或删除一件 Skill

1. 草稿放 `processing/skills/<name>/`，按上面五条对照一遍。
2. 移进 `skills/<family>/<name>/`。
3. 同步写死的数字：根 `README.md` 正文有 Skill 总数与分解，`assets/readme/hero.svg` 里也有一份，要连带安装就改 `scripts/install.sh` 的路由。`validate.sh` 只核对 README 里的目录链接，数字它查不到。

## 收工

`bash scripts/validate.sh` 到 0 failure。它查结构、查 Pi 能否加载，不证明 Skill 在真实任务里的效果。

## 会话开头

`docs/handoffs/current.md` 存在时先读它当导航；里面的结论按当前分支、HEAD、工作区核对，过期就当没有。
