# Security, Privacy, and Observability

Use this reference for client trust boundaries, sensitive-data exposure, browser storage, raw rendering, third parties, analytics, and diagnostic signals. Invoke `security-review` when a change crosses a trust boundary and needs exploit-path analysis; this reference selects architecture and evidence without issuing a security verdict.

## Browser trust model

Treat all client code, state, storage, navigation, and requests as observable and modifiable by the user or an attacker controlling the browser environment. The server remains authoritative for authentication, authorization, validation, pricing, entitlement, and protected state transitions.

A hidden control, disabled button, client guard, route redirect, obfuscated bundle, or TypeScript type is not an authorization boundary.

## Data minimization and exposure

Inventory data crossing into:

- HTML and serialized hydration payloads;
- URLs, history, referrers, bookmarks, and screenshots;
- browser storage, caches, service workers, and offline databases;
- logs, analytics, traces, session replay, crash reports, and support exports;
- clipboard, downloads, notifications, and third-party frames or scripts.

Send and retain only what the journey requires. Define classification, redaction, consent, retention, deletion, tenant isolation, and what happens on logout or privilege change. Masked presentation does not undo transmission to the browser.

## Candidate controls

### Server-authoritative access

Render navigation and affordances from known permissions for usability, but enforce every protected operation and resource on the server. Handle permission changes and stale cached identity without revealing prior sensitive data.

### Safe rendering boundary

Use the framework's contextual escaping and safe DOM APIs. Raw HTML, URL-to-DOM flows, rich-text rendering, Markdown, templates, and third-party content require an owned sanitization and URL policy at the boundary.

Do not label a path vulnerable from pattern matching alone; route changed source-to-sink analysis to `security-review`.

### Session and credential handling

Prefer platform session mechanisms and existing project policy. Keep long-lived credentials out of script-readable storage when the architecture permits it. Define CSRF, origin, cookie, refresh, logout, expiry, multi-tab, and privilege-change behavior with the server boundary.

### Browser policy

Use CSP, Trusted Types, permissions, sandboxing, integrity, referrer, and cross-origin isolation policies when supported by the threat model and delivery architecture. A header or policy is defense in depth, not proof that unsafe data flow is absent.

### Third-party isolation

Every script, tag, widget, font, frame, SDK, or session-replay tool is a data and execution dependency. Require an owner, purpose, approved data fields, consent basis, load condition, failure behavior, update policy, and removal path. Prefer server mediation or sandboxed isolation when direct browser access grants excessive capability.

## Frontend observability

Measure user-visible outcomes rather than component internals:

- route and task success, failure, abandonment, and recovery;
- loading, responsiveness, visual stability, and resource failure;
- stale data, mutation conflicts, failed chunks, hydration disagreement, and offline transitions;
- error boundaries and degraded states with release, route, browser, and correlation context.

Keep event names and bounded dimensions stable. User IDs, URLs, search text, error payloads, DOM captures, and arbitrary component props can create sensitive or high-cardinality telemetry. Sample and retain according to an explicit budget; expose telemetry loss rather than silently discarding incident evidence.

Error presentation should provide a safe user action and correlation handle where useful without exposing stack traces, dependency messages, tokens, personal data, or policy internals.

## Privacy-preserving defaults

- Use synthetic or domain-generic examples.
- Add analytics, tracking, session replay, external fonts, or new data sinks only with explicit approval.
- Avoid collecting data merely because a browser API makes it available.
- Keep consent withdrawal and deletion behavior consistent across client storage and third parties.
- Treat URL state and client telemetry as potential disclosure surfaces.

## Verification

- Verify protected operations reject unauthorized and wrong-tenant requests at the server despite client manipulation.
- Inspect HTML, hydration data, URLs, storage, caches, logs, analytics, traces, exports, and third-party requests for unintended data.
- Exercise logout, expiry, privilege change, multi-tab, stale cache, offline storage, and shared-device behavior.
- Test raw-rendering and navigation boundaries with representative untrusted content; use `security-review` for exploit findings.
- Validate consent gating, withdrawal, retention, deletion, third-party failure, and policy loading behavior.
- Confirm telemetry dimensions and payloads remain bounded and redacted during error storms and adversarial input.
