# Rinco Pi Skills & Commands

Rinco Pi Skills & Commands 是一套可直接安装到 [Pi coding agent](https://github.com/badlogic/pi-mono) 的工程实践技能与斜杠命令集合。仓库当前包含 **29 个 Skills** 和 **8 个 Commands**，覆盖需求澄清、开发、测试、审查、交付、仓库维护以及 Skill 创作等常见工作流。

## 快速安装

在仓库根目录运行：

```bash
./install.sh
```

安装脚本会将内容复制到 Pi 的全局配置目录：

| 仓库内容 | 安装位置 | Pi 中的用途 |
|---|---|---|
| `skills/` | `~/.pi/agent/skills/` | 按任务按需加载的专业工作流 |
| `commands/` | `~/.pi/agent/prompts/` | 通过 `/命令名` 调用的提示词模板 |

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
/skill:security-review
/skill:react-testing
/skill:repo-cleanup
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

每个命令的完整定义位于 [`commands/`](commands/) 目录。

## 包含哪些 Skills

### 工程基础

- `coding-standards`、`error-handling`
- `tdd-workflow`、`verification-loop`、`terminal-ops`

### 前端、后端与测试

- `backend-patterns`、`frontend-patterns`、`fastapi-patterns`
- `python-patterns`、`python-testing`
- `react-patterns`、`react-testing`

### GitHub、交付与安全

- `git-workflow`、`gh`、`github-ops`
- `deployment-patterns`、`security-review`
- `repo-cleanup`、`codebase-onboarding`

### 产品与文档

- `product-lens`、`product-capability`
- `intent-driven-development`
- `living-docs-governance`、`github`

### Skill 创作与方案压力测试

- `find-skills`、`skill-adapter`、`skill-creator`
- `grilling`、`grill-me`

每个 Skill 都位于独立目录中，并以 `SKILL.md` 作为入口。完整内容见 [`skills/`](skills/)。

## 更新已安装内容

获取仓库更新后重新运行安装脚本：

```bash
git pull
./install.sh
```

脚本使用自身所在目录定位 `skills/` 和 `commands/`，因此可以从任意工作目录调用。

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
├── commands/              # Pi prompt templates，对应斜杠命令
├── skills/                # Pi Skills，每个目录包含 SKILL.md
├── tests/
│   └── install_test.sh    # 安装脚本集成测试
└── install.sh             # 全局安装脚本
```

## 添加内容

新增 Skill 时，在 `skills/<skill-name>/SKILL.md` 中提供有效的 `name` 和 `description` frontmatter。新增 Command 时，在 `commands/<command-name>.md` 中创建提示词模板；文件名将成为安装后的斜杠命令名。

完成修改后运行测试，再执行 `./install.sh` 更新本机 Pi 配置。
