---
description: 将旧 `/fix` 入口转交给已验证的 `fix` Skill。
argument-hint: "<错误信息、失败命令或受影响路径>"
---

# Fix Compatibility Pointer

此旧模板不再维护修复流程，也不执行诊断或修改。请让用户改为显式调用：

```text
/skill:fix ${ARGUMENTS:-<错误信息、失败命令或受影响路径>}
```

`fix` Skill 是诊断、最小修复、验证与可选评审交接的唯一工作流来源。在用户显式调用前停止。
