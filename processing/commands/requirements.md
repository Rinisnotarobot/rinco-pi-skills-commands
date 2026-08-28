---
description: 把产品或工程想法转成有证据、有边界、可验收的能力定义。
argument-hint: "<需求、问题或产品想法>"
---

# Requirements Workflow

此兼容入口已由 user-invoked 的 `spec` Skill 取代。不要从该 Command 自动调用另一个 user-invoked Skill，也不要生成第二套需求格式。

请用户显式运行：

```text
/skill:spec ${ARGUMENTS}
```

`spec` 负责确认需求权威来源、解决阻塞决策、定义 `REQ` / `INV` / `AC` 追踪关系，并将最终规格写入 `docs/specs/`。
