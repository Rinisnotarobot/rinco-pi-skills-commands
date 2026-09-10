# Interaction and Accessibility

Use this reference when designing controls, forms, keyboard behavior, focus, announcements, responsive interaction, motion, localization, or progressive enhancement. Accessibility is a correctness property of the user journey, not final polish.

## Start with the task invariant

For each task, name:

- semantic structure and accessible name;
- supported input modalities and equivalent actions;
- focus entry, movement, trapping where required, and restoration;
- visible and programmatic state, status, error, and completion feedback;
- zoom, reflow, text expansion, contrast, color, motion, and timing constraints;
- locale, writing direction, formatting, and content-length variation;
- behavior when script, network, media, or enhanced controls are unavailable.

Prefer native elements and browser behavior. Add ARIA to supply missing semantics, not to recreate semantics a native element already provides.

## Candidate patterns

### Native control

Use buttons, links, inputs, labels, headings, lists, tables, details, dialogs, and landmarks according to their semantics before building custom roles.

**Invariant:** name, role, value, keyboard behavior, form behavior, and assistive-technology expectations follow the platform contract.

### Composite widget

Use only when the interaction genuinely matches a recognized composite pattern such as tabs, listbox, grid, tree, menu, or combobox.

Define orientation, active item, selected value, roving focus or active descendant, escape behavior, typeahead, disabled items, and focus restoration. Partial keyboard support is not an acceptable custom control.

### Disclosure or progressive reveal

Keep primary tasks and status understandable before secondary detail appears. The trigger exposes state programmatically; revealed content enters a predictable reading and focus order. Do not hide required information behind hover alone.

### Modal interaction

Use when attention must remain within a temporary task. Give it a label, move focus predictably, contain focus while active, make background content unavailable, support the accepted dismissal policy, and restore focus to a meaningful destination.

A visual overlay is not necessarily modal. Prefer non-modal composition when users need to reference or interact with background content.

### Form workflow

Use explicit labels, instructions before input, appropriate input purpose and autocomplete, grouped related fields, and errors connected to fields plus a navigable summary when useful.

Preserve user input after recoverable failure. Distinguish validation, authorization, conflict, network, and unknown submission outcomes without exposing sensitive server details.

### Status and live feedback

Announce asynchronous results when they are not evident from focus or surrounding content. Choose polite versus assertive behavior from urgency, avoid repeated announcements, and retain visible status for users who miss transient output.

### Motion and gesture

Motion must communicate hierarchy or continuity rather than block comprehension. Respect reduced-motion preference, avoid essential information conveyed only by animation, and provide non-gesture alternatives for path-based, multipoint, or device-motion actions.

### Responsive and input-adaptive interaction

Design from content and task constraints rather than named device sizes. Preserve source order, reading order, target reachability, zoom/reflow, and feature parity. Do not infer capability from viewport width or remove functionality for keyboard, touch, pointer, or orientation without an accepted requirement.

## Localization and content resilience

Treat translated length, pluralization, dates, numbers, names, bidirectional text, and writing direction as inputs. Keep content out of layout assumptions, avoid string concatenation that breaks translation, and mirror only what directionality requires.

## Verification

- Inspect the semantic and accessibility tree, accessible names, states, relationships, and landmark/heading structure.
- Complete each critical journey using keyboard alone and the supported pointer/touch paths.
- Verify focus order, visibility, containment, restoration, route-change behavior, and error-summary navigation.
- Test announcements with representative assistive technology; automated checks cannot prove task usability.
- Exercise zoom, reflow, text spacing, high contrast or forced colors where supported, reduced motion, text expansion, RTL, and long localized content.
- Test disabled, readonly, required, invalid, pending, success, and failure states without relying on color or motion alone.
