---
description: 认识当前项目，建立架构地图，并选择完成任务所需的 Skills。
argument-hint: "[项目目标或待调查问题]"
---

# Project Discovery

调查 `${ARGUMENTS:-当前项目的结构、约定和可用能力}`。

按顺序加载并遵循：
1. `codebase-onboarding` — 识别技术栈、入口、数据流、测试和项目规则。
2. `terminal-ops` — 用可复现命令收集证据，不凭印象推断。
3. `find-skills` — 仅当现有 Skills 无法覆盖明确需求时搜索替代能力。

输出项目地图、关键文件、可用命令、风险、推荐 Skills 和下一步。此工作流默认只调查；未经确认不要修改项目配置、安装依赖或生成文件。
