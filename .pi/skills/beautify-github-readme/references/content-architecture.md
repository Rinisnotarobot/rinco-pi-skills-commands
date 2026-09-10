# README content architecture

## The first-screen test

Without scrolling, a new visitor should understand:

1. What is this?
2. What can it do for me?
3. What should I look at next?

The hero should answer the first two. The next module should provide proof.

## Plain-language sequence

Use this sequence unless the repository has a stronger information need:

```text
Value → Proof → Mechanism → First use → Detail
```

Do not begin with architecture, contributor instructions, a command, or a long table of contents when the project is unfamiliar.

## Editing rules

- Explain the mechanism once; remove repeated versions of the same promise.
- Put the shortest working install path before advanced configuration.
- Keep limitations visible when they affect user choice.
- Prefer one example that succeeds end-to-end over many disconnected snippets.
- Use “we” or direct language when it reduces distance, but do not fake community size.

## Write for the person using the project

- Explain what the project does, how to try it, and what the reader should expect. Name concrete actions and results instead of internal process terms or promotional claims.
- Match the reader's language and technical background. Keep necessary technical names, explain unfamiliar terms at first use, and preserve exact command and API names.
- Prefer direct sentences with one main point. Plain language should clarify the behavior, not exaggerate certainty or turn a recommendation into a guarantee.

Illustrative rewrites (use only when supported by the repository):

| Abstract wording | Concrete wording |
| --- | --- |
| Provides a unified configuration governance solution. | Checks your configuration files for missing settings. |
| Execute the final verification gate. | Run the tests and report which checks passed or failed. |
| 形成可验收的行为规格。 | 写清楚要做什么、出错时怎么办、怎样算完成。 |

Before accepting the copy, check that each feature description names something the reader can do or observe. Replace vague claims with an example or remove them.

## Fold secondary detail, keep the first use visible

- Keep prerequisites, the shortest working install path, one complete usage example, and its expected result outside collapsed blocks.
- Put optional configuration, exhaustive parameters, alternative installation methods, or lengthy troubleshooting in `<details>` when they interrupt the main reading path. Use a descriptive `<summary>` so readers know what is inside.
- Keep compatibility limits, destructive actions, overwrite warnings, and costs visible before the affected command; a collapsed block is not a place to hide a decision-changing warning.
- Use a dedicated linked document when a topic needs its own navigation or is too long even when folded. Preserve useful detail rather than deleting it solely to shorten the page.

```markdown
<details>
<summary>Alternative installation methods and advanced settings</summary>

Put secondary instructions here, with blank lines around Markdown content.

</details>
```

Check the rendered README with every block closed: a new reader must still be able to complete the default first use safely.

## Use emoji and alerts sparingly

- Use text headings by default. Add an emoji only when it helps scanning or fits the project's established voice; keep the label understandable without it.
- Reserve GitHub alerts for information that changes what the reader should do, such as compatibility limits or file replacement. Ordinary explanations belong in paragraphs, not repeated callout boxes.
- Pick the alert type that matches the consequence: `NOTE` for useful context, `TIP` for optional advice, `IMPORTANT` for essential information, and `WARNING` or `CAUTION` for risks. State the consequence and the action the reader should take.

Example, only for an installer that actually replaces files:

```markdown
> [!WARNING]
> Reinstalling replaces files with the same names. Back up your local edits first.
```

Keep each alert next to the relevant instruction. If it merely repeats nearby text or decorates a section, remove it.

## Link to existing documents instead of copying them

- Inspect existing documentation before adding maintenance, contribution, release-history, or license sections. Link to the authoritative file rather than copying its full contents into the README.
- Keep a short summary when it helps someone decide whether or how to use the project. A verified license name and link, for example, can remain useful even when `LICENSE` exists.
- Retain essential setup and safety information in the README; a link should carry detail, not force readers to hunt for prerequisites.
- Verify each link target. If a dedicated document is absent, keep necessary information inline rather than inventing a file or removing the information to fit a template. Creating or moving documentation requires that scope to be authorized.

Before finishing, check that each linked topic has one authoritative home and that the README summary agrees with it.

## Visual-to-text division

Use visuals for hierarchy, identity, comparison, sequence, and proof. Use Markdown for explanation, commands, API details, links, compatibility, and contribution instructions.

If a sentence needs to be copied, searched, translated, or frequently updated, keep it out of SVG.
