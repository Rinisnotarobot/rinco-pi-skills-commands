---
description: 把产品或工程想法转成有证据、有边界、可验收的能力定义。
argument-hint: "<需求、问题或产品想法>"
---

# Requirements Workflow

定义 `${ARGUMENTS:-用户尚未说明的需求}`。

按顺序加载并遵循：
1. `product-lens` — 验证问题、用户、证据、价值和为何现在做。
2. `intent-driven-development` — 明确范围、非目标、约束、风险和可测试验收标准。
3. `product-capability` — 涉及跨模块、跨服务或 PRD 时形成实现就绪的能力契约。
4. `security-review` — 涉及鉴权、输入、密钥、支付或敏感数据时条件加载。

关键事实缺失时集中提问，不编造需求。输出问题陈述、范围、非目标、验收标准、开放问题和风险；未解决会改变方案的歧义前，不进入编码。
