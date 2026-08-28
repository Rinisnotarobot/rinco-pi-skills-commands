# Rinco Pi Skills & Commands

Rinco Pi Skills & Commands 是一套面向 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程实践技能与斜杠命令集合。仓库使用 `processing/` 保存待处理内容，只有根目录 `skills/` 中已完成重构和验证的 Skills 会被安装。

## 快速安装

在仓库根目录运行：

```bash
./install.sh
```

安装脚本会将内容复制到 Pi 的全局配置目录：

| 仓库内容 | 安装位置 | Pi 中的用途 |
|---|---|---|
| `skills/` | `~/.pi/agent/skills/` | 已处理并验证的专业工作流 |
| `processing/commands/` | `~/.pi/agent/prompts/` | 通过 `/命令名` 调用的提示词模板 |

安装完成后重启 Pi，使新内容被重新发现。

> [!NOTE]
> 安装会更新目标目录中的同名文件，但不会删除其他已有的 Skills 或提示词模板。因此可以重复运行脚本完成升级。

### 安装到自定义目录

通过 `PI_AGENT_DIR` 指定其他 Pi agent 配置目录：

```bash
PI_AGENT_DIR=/path/to/pi/agent ./install.sh
```

这也适合隔离测试或维护多套 Pi 配置。

## 如何使用

Commands 是 Pi 的 prompt templates。安装后可直接输入对应斜杠命令，例如：

```text
/project
/requirements
/develop
/review
/ship
```

Skills 会由 Pi 根据任务描述按需加载。启用 Pi 的 Skill Commands 后，也可以显式调用：

```text
/skill:backend-patterns
/skill:plan
/skill:tdd
```

## 包含哪些 Commands

| Command | 用途 |
|---|---|
| `/project` | 认识当前项目，建立架构地图并选择所需 Skills |
| `/requirements` | 将产品或工程想法转成有边界、可验收的能力定义 |
| `/plan` | 基于需求和代码库证据生成可执行计划 |
| `/develop` | 按 TDD、技术栈模式和安全要求实现功能 |
| `/fix` | 证据化复现并修复构建、测试或运行时问题 |
| `/review` | 审查正确性、安全性、架构和测试覆盖 |
| `/ship` | 完成验证、提交、PR、CI 和部署交付准备 |
| `/maintain` | 维护文档、仓库卫生、依赖和部署配置 |

每个命令的完整定义位于 [`processing/commands/`](processing/commands/) 目录。

## 包含哪些 Skills

### 已处理并安装

- [`backend-patterns`](skills/backend-patterns/)：语言与框架无关的后端架构模式，通过问题、约束、不变量和权衡选择实现方案。
- [`plan`](skills/plan/)：基于代码库证据生成文件、symbol、依赖和验证明确的实现计划。
- [`tdd`](skills/tdd/)：行为优先、垂直切片的 RED → GREEN → REFACTOR 工作流。

### 待处理

其余 Skills 保存在 [`processing/skills/`](processing/skills/) 中，不会由安装脚本复制。完成重构和验证后，将对应目录移入 `skills/` 才会进入安装范围。

每个 Skill 都位于独立目录中，并以 `SKILL.md` 作为入口。

## 更新已安装内容

获取仓库更新后重新运行安装脚本：

```bash
git pull
./install.sh
```

脚本使用自身所在目录定位 `skills/` 和 `processing/commands/`，因此可以从任意工作目录调用。

## 验证安装脚本

项目包含一个无副作用的 Bash 集成测试。测试会使用临时目录验证默认路径、自定义路径、重复安装以及已有无关文件保留行为：

```bash
./tests/install_test.sh
```

也可以先执行语法检查：

```bash
bash -n install.sh tests/install_test.sh
```

## 目录结构

```text
.
├── skills/                # 已处理并验证、会被安装的 Pi Skills
├── processing/
│   ├── commands/          # Pi prompt templates，对应斜杠命令
│   └── skills/            # 尚待处理、不会被安装的 Skills
├── tests/
│   └── install_test.sh    # 安装脚本集成测试
└── install.sh             # 全局安装脚本
```

## 添加内容

新增或待重构的 Skill 先放在 `processing/skills/<skill-name>/`。完成处理和验证后，将整个目录移入 `skills/`。新增 Command 时，在 `processing/commands/<command-name>.md` 中创建提示词模板；文件名将成为安装后的斜杠命令名。

完成修改后运行测试，再执行 `./install.sh` 更新本机 Pi 配置。
