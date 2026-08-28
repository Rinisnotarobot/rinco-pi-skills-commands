---
name: github
description: README authoring, optimization, and GitHub SEO. Use when the user asks to "create/write/improve a README", write "README.md", 写README, 项目说明文档, or mentions "GitHub README", "profile README", "README structure". Also covers GitHub SEO, parasite SEO, GEO (AI citation), curated Awesome lists, repository metadata optimization ("GitHub SEO", "GitHub GEO", "awesome list", "pinned repositories", "About section", "GitHub description", "GitHub topics", "Website field", "GitHub Pages", "github.io", "GitHub gist", "curated list", "navigation list"). Not for Medium or other non-GitHub platforms.
metadata:
  version: 3.0.0
---

# GitHub README 写作与优化

Primary purpose: **create, rewrite, or improve READMEs** (project repos and profile repos). Secondary purpose: GitHub SEO/GEO — full platform strategy lives in `references/github-seo.md`; load it only when the user asks about SEO, parasite SEO, GEO strategy, awesome lists, or repository metadata optimization.

## Workflow

1. **Review the project first**: explore the codebase, entry points, scripts, and existing docs. Never invent features that don't exist.
2. **Identify the archetype** (below) and follow its structure priorities.
3. **Write the README** per the structure and GEO practices below.
4. **Validate** against the checklist, then present the result.

## Repository Archetypes

| Archetype | Intent | First-screen emphasis |
|-----------|--------|------------------------|
| **Product / library** | Installable software, SDK, CLI, service | Install, quickstart, proof (CI, license), support path |
| **Curated / resource** | Awesome-style lists, indexes | Scope, curation bar, contribution rules |
| **Personal profile hub** | Public **`username/username`** README on the profile | Identity + canonical links + **pinned** flagship repos; **no** duplication of full product READMEs |

## README Structure & Components

Targets **repository (project) READMEs** unless noted. **Profile README** overrides: shorter, fewer sections — see below.

| Section | Purpose | SEO/GEO |
|---------|---------|---------|
| **Title + tagline** | H1 + 1–2 sentence summary; keywords in first paragraph | Critical; first 100 words weighted |
| **Table of contents** | Links to H2/H3; **for long repo READMEs** (>500 words). **Skip on profile README** | Navigation; crawlability |
| **Installation / Quick start** | Prerequisites; exact commands; copy-paste ready | Use-case clarity |
| **Usage examples** | Code blocks; common scenarios | Citable; extractable |
| **Screenshots / GIFs** | Demo, output; alt text required | Engagement; accessibility |
| **Badges** | Build, version, license | Trust signals |
| **Contributing** | Link to CONTRIBUTING.md | Community signal |
| **License** | Link to LICENSE | Completeness |

**Word count**: No hard limit; **500–1,500 words** typical for **product / library** repos. Lead with value; expand later.

## Formatting Rules

- Use **GFM** (GitHub Flavored Markdown).
- Use GitHub [admonition syntax](https://github.com/orgs/community/discussions/16925) (`> [!NOTE]`, `> [!TIP]`, `> [!WARNING]`) where appropriate.
- **Do not overuse emojis**; keep the README concise and to the point.
- **Skip sections with dedicated files**: no "LICENSE", "CONTRIBUTING", or "CHANGELOG" sections — link to the dedicated files instead.
- If the project has a **logo or icon**, use it in the README header.

## README GEO / AI Citation

Make the README citable by ChatGPT, Perplexity, and similar tools:

| Practice | Guideline |
|----------|-----------|
| **Answer-first** | Direct answer in first 1–2 sentences (40–60 words) |
| **Short paragraphs** | 2–3 sentences max; extractable clarity |
| **Question-style headings** | H2/H3 as questions where relevant |
| **Data inclusion** | Stats, numbers; cited content ~40% more likely to include data |
| **Freshness** | Update regularly; ~76% of cited content updated within 30 days |

**Entity signals**: Clear project name, author, maintainer; consistent identity across repo, README, and About.

## README Checklist — repository (default)

- [ ] Project title with keywords
- [ ] Concise description in first paragraph
- [ ] H2/H3 structure; alt text for images
- [ ] Installation + usage examples
- [ ] Screenshots or demo
- [ ] Badges; Contributing; License
- [ ] Internal links to related docs/repos
- [ ] 6–20 topics on repo

## Profile README (`username/username`)

**Not the same as a product repo README.** Optimize for **identity + navigation** in ~15–40 lines of rendered content unless the user explicitly wants a long-form CV. Official setup: [Managing your profile README](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme).

| Principle | Do | Avoid |
|-----------|-----|--------|
| **Length** | Short, scannable sections; **omit ToC** | Applying product-repo word counts here |
| **Headings** | `###` blocks (e.g. *What I do · Open source · Find me*) | Many nested `##` + long narrative |
| **Links** | Each primary URL **once** in a **Find me / Connect** line (or badges **or** a slim table) | Duplicate site/LinkedIn/email in badges, tables, and prose |
| **Repos block** | **Bold repo name** + **≤2 short lines** + at most **one** copy-paste command (e.g. `npm i <pkg>`) | Full feature matrices or install docs pasted into the profile file |
| **Layout** | Optional **centered** header (`<div align="center">`) for **name + tagline + badges only**; body stays left-aligned | Center-wrapping the entire README |
| **Optional widgets** | Compact Shields (flat style); optional [github-readme-stats](https://github.com/anuraghazra/github-readme-stats) / [star-history](https://star-history.com) — treat as **social proof**, not core SEO | Wall of `for-the-badge` badges repeating the same CTAs |

**Minimal outline (typical profile):**

1. Title + answer-first tagline (+ slim badge row).
2. `### What I do` — identity, proof link(s), **without** repeating the same URLs again later.
3. `### Open source` — bold repo links + pitches + optional one code fence.
4. `### Find me` — single line of deduped links (site · bio · cases · social · email).
5. `### Activity` (optional) — small **github-readme-stats** + **star-history**; **alt text** on `<img>`.

Reference pattern (high-signal, low-noise): scan-first profiles such as [alchaincyf](https://github.com/alchaincyf) — short `###` blocks, bold product/repo names, one "find me" cluster.

**Entity hub pattern:** When the person has a canonical site, lead with it in the **opening line** and mirror the same URL in **Pinned** / **profile About** so **site ↔ GitHub OSS** stay aligned.

### Profile README checklist

- [ ] H1 + **one** answer-first tagline (keywords: role, stack, domain)
- [ ] Canonical **outbound** links (site, social, email) **deduplicated**
- [ ] **Pinned** repos (≤6) match the story told in the README
- [ ] Optional: **Activity** section — group stats / star-history under one heading
- [ ] **Last updated** footnote for freshness (GEO signal)

## Repository Metadata (quick README-adjacent fixes)

While working on a README, also check these high-weight metadata fields:

| Field | Guideline |
|-------|-----------|
| **About description** | 350 chars hard limit; ~128 optimal; primary keyword + what it does + who it's for |
| **Topics** | 6–20 (6–10 recommended); lowercase, hyphens; mix of technology, purpose, category |
| **Website field** | One canonical docs/product URL, aligned with README links |
| **Repository name** | Descriptive, keyword-rich, hyphenated, concise |

## Output Format

- **Use case** (README authoring / profile README / SEO)
- **Archetype** and **surface scope** (profile vs repository)
- **README structure** (sections, word count, GEO practices) — for profile README: short outline + deduped links
- **Metadata fixes** (name, About, Topics) if applicable
- **Ready-to-use** copy or structure

## Related Reference

For full GitHub platform strategy — parasite SEO surfaces (Pages, gists, wiki, issues), GEO platform tactics, awesome-list creation, discovery mechanics, and community engagement — read `references/github-seo.md`. Load it when the user asks about SEO, rankings, AI citation strategy, or curated lists.
