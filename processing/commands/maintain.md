---
description: 维护项目文档、仓库卫生、README、依赖和部署配置。
argument-hint: "<docs | cleanup | readme | dependencies | deployment | 维护目标>"
---

# Maintenance Workflow

维护 `${ARGUMENTS:-项目的文档、仓库卫生和部署配置}`。

按目标条件加载：
- 文档治理与漂移：`living-docs-governance`。
- 创建项目 README：`create-readme`。
- 死代码、旧依赖、产物或归档：`repo-cleanup`。
- CI/CD、容器、健康检查、环境配置或生产发布：`deployment-patterns`。
- 执行命令与收集证据：`terminal-ops`。
- 变更完成验收：`verification`。

先建立基线并展示维护计划。保留手写内容和现有配置；删除文件、移除依赖、修改生产部署配置、创建新文档或大范围替换前必须确认。Python 操作统一使用 `uv`。输出改动、节省或改善、验证结果、跳过项和持续维护建议。
