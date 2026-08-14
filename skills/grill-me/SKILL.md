---
name: grill-me
description: 启动一场不留情面的结构化追问，以打磨计划、设计、决策或想法。Use when the user explicitly says grill-me、拷问我、盘问方案，或希望压力测试自己的思路。
disable-model-invocation: true
---

# Grill Me

这是 `grilling` 的显式快捷入口。

1. 在当前会话加载并执行 `/skill:grilling`；若用户在 `/skill:grill-me` 后提供了主题或参数，将其作为本次追问的主题传递。
2. 如果无法嵌套调用技能，则直接按以下规则执行同等流程：
   - 把待确认决策组织为设计树；只询问前置条件已经确定的当前“前沿”。
   - 分轮提问，每轮覆盖整个前沿，并给出推荐答案。
   - 环境事实由本代理使用可用工具亲自查明，不让用户代查，也不调用子代理。
   - 所有分支都确认且用户认可共同理解后才结束；未经用户确认，不实施方案。
