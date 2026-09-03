# UI Prototype

Generate **several radically different UI variations** on a single route, switchable from a floating bottom bar. The user flips between variants in the browser, picks one (or steals bits from each), then throws the rest away.

If the question is about logic/state rather than what something looks like, this is the wrong branch. Use [Logic Prototype](logic.md).

## When this is the right shape

- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- Any time the user would otherwise spend a day picking between three vague mockups in their head.

## Two sub-shapes: strongly prefer sub-shape A

A UI prototype is much easier to judge when it's **butting up against the rest of the app**: real header, real sidebar, real data, real density. A throwaway route on its own is a vacuum: every variant looks fine in isolation. Default to sub-shape A whenever there's a plausible existing page to host the variants. Only reach for sub-shape B if the prototype genuinely has no nearby home.

### Sub-shape A: adjustment to an existing page (preferred)

The route already exists. All sub-shape A work happens **on the throwaway branch**: the host page's render path is edited on that branch, never on the working branch. On the throwaway branch, variants are rendered **on the same route**, gated by a `?variant=` URL search param. The existing data fetching, params, and auth all stay. Only the rendering swaps — on the throwaway branch.

Default is the original: with no `?variant=` param, the page renders exactly what it renders today. Prototype variants appear only when the param is present, and the switcher and the whole variant path gate on a non-production check, so a stray merge of prototype code cannot surface variants or the bar in a production build.

If the prototype is for something that doesn't yet have a page but *would naturally live inside one* (a new section of the dashboard, a new card on the settings screen, a new step in an existing flow), it's still sub-shape A. Mount the variants inside the host page's copy on the throwaway branch.

### Sub-shape B: a new page (last resort)

Only use this when the thing being prototyped genuinely has no existing page to live inside (an entirely new top-level surface, or a flow that can't be embedded anywhere sensible).

Create a **throwaway route** following whatever routing convention the project already uses. Don't invent a new top-level structure. Name it so it's obviously a prototype (include the word `prototype` in the path or filename). Same `?variant=` pattern.

Before committing to sub-shape B, sanity-check: is there really no existing page this could be embedded in? An empty route hides design problems that a populated one would expose.

In both sub-shapes the floating bottom bar is identical.

## Process

### 1. State the question and pick N

Default to **3 variants**. More than 5 stops being radically different and starts being noise, so cap there.
Write down the plan in one line, in the prototype's location or a top-of-file comment, naming the question from the main skill:

> "Question: which layout fits the settings page's data density? Three variants, switchable via `?variant=`, on the existing `/settings` route, on the prototype branch."

### 2. Generate radically different variants

Draft each variant. Hold each one to:

- The page's purpose and the data it has access to.
- The project's component library / styling system.
- A clear exported component name, e.g. `VariantA`, `VariantB`, `VariantC`.

Variants must be **structurally different**: different layout, different information hierarchy, different primary affordance, not just different colours. Three slightly-tweaked card grids isn't a UI prototype, it's wallpaper. If two drafts come out too similar, redo one with explicit "do not use a card grid" guidance.

### 3. Wire them together

Create a single switcher component on the route:

```tsx
// pseudo-code, adapt to the project's framework — throwaway branch only
const variant = searchParams.get('variant'); // no default: absent param renders the original
return (
  <>
    {!variant && <OriginalPage {...data} />}
    {isPrototypeEnv && variant === 'A' && <VariantA {...data} />}
    {isPrototypeEnv && variant === 'B' && <VariantB {...data} />}
    {isPrototypeEnv && variant === 'C' && <VariantC {...data} />}
    {isPrototypeEnv && <PrototypeSwitcher variants={['A','B','C']} current={variant} />}
  </>
);
```

The floating bottom bar:

- Shows the current variant; clicking cycles; keyboard `←`/`→` also cycle.
- Visually distinct from the page (e.g. high-contrast pill, subtle shadow) so it's obviously not part of the design being evaluated.
- Gated, together with the entire variant render path, on a non-production check.

Put the switcher in a single shared component on the throwaway branch so both sub-shapes can reuse it.

### 4. Hand it over

Surface the URL (and the `?variant=` keys). The user will flip through whenever they get to it. The interesting feedback is usually **"I want the header from B with the sidebar from C"**, which is the actual design they want.

### 5. Capture the answer and clean up

Once a variant has won, capture the answer (which variant — or which hybrid — and why) per the main skill's handoff. Cleanup is mechanized by construction: the entire prototype — all variants, the switcher, and any sub-shape A route edits — lives on the throwaway branch, so finishing means recording the answer and keeping or deleting that branch. The working branch never had prototype code and needs no cleanup, whether the prototype concluded or was abandoned. Rebuilding the winning variant as production code is a later plan's decision, implemented through `tdd` — never a direct promote during the prototype.

## Anti-patterns

- **Variants that differ only in colour or copy.** That's a tweak, not a prototype. Real variants disagree about structure.
- **Sharing too much code between variants.** A shared header is fine; a shared layout defeats the point. Each variant should be free to throw out the layout.
- **Wiring variants to real mutations.** Read-only prototypes are fine. If a variant needs to mutate, point it at a stub: the question is "what should this look like", not "does the backend work".
- **Promoting the prototype directly to production.** The variant code was written under prototype constraints (no tests, minimal error handling). A later plan re-implements it properly through `tdd`.
