# 第三方组件

根目录的 [`LICENSE`](LICENSE) 覆盖本仓库自己的内容。下面这些文件来自第三方仓库，版权归原作者，按各自的许可证使用。

## `.pi/skills/`

这三个辅助 Skill 用于维护本仓库，不随 `scripts/install.sh` 分发。来源与内容哈希记录在 [`skills-lock.json`](skills-lock.json)。

### writing-for-agents

- 来源：<https://github.com/mattpocock/skills>，路径 `skills/productivity/writing-for-agents`
- 许可证：MIT
- 版权：Copyright (c) 2026 Matt Pocock

### beautify-github-readme

- 来源：<https://github.com/oil-oil/beautify-github-readme>
- 许可证：MIT
- 版权：Copyright (c) 2026 oil-oil

### humanizer-zh

- 来源：<https://github.com/op7418/humanizer-zh>，实体文件在 `.agents/skills/humanizer-zh/`，`.pi/skills/` 与 `.claude/skills/` 下是软链
- 许可证：MIT
- 版权：Copyright (c) 2026 歸藏
- 说明：正文翻译自 <https://github.com/blader/humanizer>，快速检查清单与质量评分参考 <https://github.com/hardikpandya/stop-slop>，模式清单出自维基百科的 [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)

## 这三个组件的 MIT 许可证全文

```text
MIT License

Copyright (c) 2026 Matt Pocock (writing-for-agents)
Copyright (c) 2026 oil-oil (beautify-github-readme)
Copyright (c) 2026 歸藏 (humanizer-zh)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
