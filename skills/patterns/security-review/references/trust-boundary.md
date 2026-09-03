# Trust Boundary Analysis

The source-to-sink method behind every finding. Read this before tracing a candidate path.

## What a trust boundary is

A line where data or execution crosses between actors with different trust levels: HTTP request into server logic, server into database, service into service, build pipeline into artifact, filesystem into process. Security properties are enforced *at* boundaries or not at all.

## Source classification

Before tracing, classify the input's origin:

| Class | Examples | Attacker control? |
|---|---|---|
| Request data | query/body/headers/params, file uploads, websocket frames | Yes — full control |
| Indirect request data | filenames derived from uploads, redirect targets, IDs echoed from user input | Yes — often overlooked |
| Server configuration | settings, environment variables, config files, feature flags | No — operator control |
| Constants and literals | hardcoded URLs, enum values, compile-time strings | No |
| Authenticated trusted data | records written by other internal services, admin-maintained rows | No — but verify the writer's own boundary |
| Persistence of earlier input | database rows a user previously wrote | Yes at the write boundary — a stored-XSS/second-order source when read back into a sink |

The last row is the classic miss: data that was attacker-controlled at write time is still attacker-controlled at read time, even though the read site looks like "internal data".

## Sink inventory

Sinks by category — the operations that make input dangerous (see the domain guides for specifics):

- **Execution**: SQL construction, shell commands, template rendering, dynamic imports, eval-family calls, deserialization of untrusted bytes;
- **Traversal and access**: file path construction, URL construction, SSRF-reachable network calls;
- **Exposure**: error messages, logs, responses reflecting input, cache keys leaking secrets;
- **Privilege**: authorization decisions, permission checks, session issuance, password/secret handling.

## Tracing the path

Walk from source to sink, and at each intermediate step record the guard that should stop the attack and why it does not:

1. parse/validation layer — what is actually checked (length? type? charset? allowlist?) and what passes through;
2. encoding/escaping — applied where, correctly for the sink's context or not;
3. framework protections — ORM parameterization, auto-escaping, CSP, typed routes;
4. business rules — authentication requirements, ownership checks, state preconditions;
5. configuration — debug modes, trust proxies, CORS, cookie flags.

A guard that "probably exists elsewhere in the codebase" is not a guard — find it or the path stands. When you cannot find it, that is a MEDIUM note with the exact question, not a HIGH finding.

## Second-order and cross-boundary paths

Follow data across boundaries, not just within one: request → persistence → admin view (stored XSS); request → queue → worker shell call (delayed injection); upload → filename → filesystem → downstream parser. The sink may be in a different service than the source; the finding still needs the whole path.

## Severity from impact and reachability

- **critical**: unauthenticated remote code execution, auth bypass, secret disclosure;
- **high**: authenticated injection with meaningful data exposure or modification;
- **medium**: reflected issues requiring interaction, limited-scope privilege problems, low-impact SSRF.

Base severity on the traced path's worst realistic outcome, not the sink category's theoretical worst.
