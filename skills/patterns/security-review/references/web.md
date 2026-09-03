# Web and Input Surfaces

Evidence rules for the web trust-boundary domain: request input, rendering, and session surfaces. Use while tracing paths through web layers; framework-protection facts here exist to prevent false positives, not to replace reading the code.

Reference base: OWASP Cheat Sheet Series (https://cheatsheetseries.owasp.org/), CC BY-SA 4.0 — concepts adapted, check the project's framework version for current behavior.

## Injection sinks

- SQL: parameterized queries and ORMs treat values as data — a value passed through the query builder's binding API is not injectable by itself. Injection requires string-concatenated SQL, dynamic table/column names from input, or raw query APIs fed unescaped input.
- Shell: prefer argument-array process APIs over string shells. An environment variable interpolated into a command string is a finding only if attacker-controlled values can reach it.
- Template: auto-escaping engines escape by default per context; a finding requires an explicit unsafe/mark-raw escape of attacker input, or a template engine with escaping off.
- Deserialization: untrusted bytes into a native deserializer is a finding by construction — format is the guard, not the parser.

## XSS

- Reflected: input returned in a response and rendered. Frameworks that contextually auto-escape make this a finding only where raw rendering is used.
- Stored: attacker input persisted, then rendered elsewhere — often at an internal admin surface. The source is the write boundary; do not clear the finding because the read site looks internal.
- DOM: source into `innerHTML`-family sinks, URL fragments into script. Trace the client-side path.

## Authentication and session surfaces

- Credential comparison: constant-time comparison at the right layer; plaintext or reversibly-encoded storage is a finding at the write boundary.
- Session issuance: what the token encodes, who can mint it, transport flags, expiry, and invalidation on privilege change.
- Password reset flows: token entropy, single-use, expiry, and channel — the classic auth-bypass surface.

## CSRF and CORS

- CSRF applies to state-changing requests from authenticated browsers; check the framework's CSRF middleware covers the changed route and method, and that exceptions are deliberate.
- CORS misconfiguration findings require an attacker-reachable origin that the policy actually admits with credentials.

## File upload

- Validate type at the boundary (content, not only extension), store outside the web root or with generated names, and never parse uploads with privileged tools on the server path.
- The filename itself is input: traversal comes from path construction, not the upload.

## Framework-protection quick checks

Before flagging, verify the protection is actually in play for this code path: escaping default on for this template engine and context, ORM binding used for this query (not a raw escape), CSRF middleware on this route, CSP actually set on this response. The protection must be evidenced in the repository, not assumed from framework reputation.
