# Data and Storage Surfaces

Evidence rules for persistence and data-flow trust boundaries: databases, secrets, and inter-service data.

## SQL and query construction

- Parameterized values (bound parameters, ORM value APIs) are data, not code — not injectable by themselves.
- Injection findings require: string-concatenated SQL fragments containing input, dynamically assembled identifiers (table/column names) from request data, or `ORDER BY`/`LIMIT` clauses built from unvalidated input.
- ORM raw-query and `whereRaw`-family APIs are sinks equal to string SQL — trace what reaches them.

## Secrets handling

A secret is sensitive material whose disclosure breaks a boundary: credentials, tokens, signing keys, session material, PII regulated by the project's compliance context.

- Hardcoded secrets in source are **direct-disclosure findings** (the core rule's explicit exception): the write into source is itself the source and sink; no further attacker path is needed.
- Secrets in logs, error messages, and analytics events are exposure findings of the same class — the output is the sink.
- Secret comparison must be constant-time where the comparison gates access.
- Client-visible responses: a field is a leak when the requesting identity is not entitled to it — trace who can call the endpoint, not just what the field contains.

## Access control and authorization

- The check must bind the requesting identity to the object: tenant/ownership filters in the query, not only an existence lookup plus a role check elsewhere.
- IDOR paths: request references a record by guessable identifier; the guard is an ownership predicate. Missing predicate + reachable record = HIGH finding with the path — this is a failed-guard bypass, not an authenticated path to clear.
- Privilege changes must invalidate derived state (sessions, cached authorizations, issued tokens).

## Inter-service boundaries

- Service-to-service calls inherit trust only from the transport's authentication — mutual auth, signed requests, or network policy. Unauthenticated internal endpoints are findings when the network is not itself a verified boundary (check the deployment facts, not the topology diagram).
- Serialized data crossing service boundaries is untrusted at the receiver: validate again at the consumer's boundary.
- Message queues: producer input is attacker-controlled if the producer accepts user input; consumers must not assume queue arrival sanitizes.

## Configuration as a boundary

- Debug modes, verbose errors, and dev tooling enabled in the production configuration path are **MEDIUM notes** (needs verification): the configuration evidence is checkable, but the attacker path (what the verbose output actually exposes) must be traced before any finding.
- Trust-proxy and header-override settings decide whether request headers (client IP, scheme, protocol) are trusted input or attacker-controlled — trace which setting governs the changed code.
