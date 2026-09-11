# Validation, Errors, and Identity

Use this reference for the Node.js and TypeScript expression of input validation, failure classification, and request identity at the transport boundary.

## Ownership

The error taxonomy, authorization model, and auditability requirements are **decided** by `backend-patterns` — `security-and-observability.md` for authentication, authorization, and telemetry, `contracts-and-evolution.md` for what a consumer may depend on. This reference owns the Node.js mechanics: where validation runs, how a failure becomes a status code, and how identity is derived from a request.

| Decision | Owner |
|---|---|
| Authorization model, audit requirements, error taxonomy | `backend-patterns` |
| Retry classification, idempotency, unknown-outcome handling | `resilience` |
| Trust-boundary review of a changed surface | `security-review` |
| Runtime validation entry point, error mapping, serialization, identity derivation | Here |

When a statement here disagrees with the `backend-patterns` decision, that decision wins.

**A TypeScript type is not validation.** An annotation describes what the compiler was told; the value that arrived on the wire was produced by a client. Every external value — request body, query, header, cookie, environment, queue payload, CLI argument, third-party response — is `unknown` until a runtime check accepts it.

## Runtime validation at the edge

### Parse, then hand inward

Validate with the project's existing validator and pass the parsed result inward. An unvalidated value should not be able to acquire the domain type; if a function's parameter type says `CreateOrderCommand`, the only ways to construct one should be a parse or an explicit construction by trusted code.

- Reuse the project's validator. Two validators in one service produce two error shapes and two sets of defaults.
- Where the project infers types from the schema, keep the schema as the source and the type as the inference. Hand-writing the type and the schema separately is how the two drift.
- Apply the same treatment to non-HTTP entries: a queue consumer and a CLI command receive untrusted input too, and often skip validation precisely because there is no request object.
- Validate configuration at startup in the same spirit, with the same failure semantics ([project-and-runtime-setup.md](project-and-runtime-setup.md)).

### Distinguish missing, null, and wrong

A field that is absent, a field that is explicitly `null`, and a field of the wrong type are three different inputs. Choose the behavior deliberately, and be aware that optionality flags in the compiler do not enforce presence at runtime — only the schema does.

### Treat caught values as unknown

In a `catch`, the value is `unknown`, not an `Error`. Narrow it before reading a message or a code, and preserve the original as a cause rather than replacing it. A caught value that is inspected with an unchecked cast is how a non-`Error` throw becomes a crash inside error handling.

## Error classification

### Classify before mapping

Decide in the application layer what kind of failure occurred, and map it to transport semantics once at the boundary. Express expected failures as classified errors or typed outcomes according to project convention — not as `Error` instances distinguished by message text, which cannot be matched reliably and invites string comparison across layers.

- Keep the classification free of status codes so the application layer does not depend on the transport.
- Keep the mapping in one place — a single handler, filter, or mapping function — so the same condition cannot produce different codes on different routes.
- For HTTP, distinguish at least: malformed input, failed authentication, denied authorization, missing resource, conflict, rate limiting, and unexpected fault.

| Condition | Typical transport result |
|---|---|
| Input rejected by validation | `400` |
| Credentials absent or invalid | `401` |
| Identity known, action not permitted | `403` |
| Target not found, or not visible to this identity | `404` |
| State conflict, uniqueness violation, concurrent modification | `409` |
| Request rejected by a limit | `429` |
| Unclassified failure | `500` |

Confirm the project's actual mapping rather than assuming this table, and confirm that "not found" and "not authorized to know it exists" are distinguished or deliberately conflated according to the project's disclosure policy.

### Do not leak internals

Never serialize a stack trace, a dependency message, a query, a connection string, or an internal identifier to a client. Log the detail against a correlation identifier and return a stable, non-revealing body.

- Unexpected failures get a generic body; the diagnostic value belongs in the log.
- A database constraint violation must be caught where the write happens and translated, since a pre-check alone has a race window.
- Queues and scheduled jobs do not share the HTTP status model. A failing job is retried, dead-lettered, or recorded — decide which, and do not express it as a status code.

## Serialization boundaries

### Return an explicit output shape

Convert to a declared output shape at the boundary. Returning the persistence entity or the internal object is how stored fields leak, and it makes every internal refactor a potential API change.

- Sensitive fields must be absent from the output shape, not deleted at runtime after being populated.
- Check what the serializer does with `Date`, `BigInt`, `undefined`, `Map`, `Set`, and class instances: JSON conversion applies its own rules, and a `BigInt` throws where a `Date` silently changes format.
- Where the project generates an output schema from a contract, keep the contract as the source.

## Identity and client address

### Verify, then authorize

Verify credentials and tokens at runtime, including the claims that decide admission — issuer, audience, expiry, algorithm. A decoded payload typed with an interface is still unvalidated data.

- Authentication establishes who is calling; authorization evaluates whether that identity may perform this action on this resource, in this context. Keep them as separate, individually testable steps.
- Enforce authorization at a point every authoritative route passes through, so a new route cannot omit it by default. An inline conditional in one handler is how one route ends up unprotected.
- Load secrets through the configuration boundary and never log them ([project-and-runtime-setup.md](project-and-runtime-setup.md)).

### Derive the client address from the trusted configuration

Behind a proxy or load balancer, the peer address is the proxy. Read the client address only through the framework's trusted-proxy configuration; reading `x-forwarded-for` or a similar header directly trusts caller-controlled input and breaks any rate limit, audit record, or allowlist built on it.

- Confirm how many proxy hops are trusted; an unbounded trust setting lets a caller choose its own address.
- The same applies to protocol and host derivation used to build redirects or absolute URLs.
- Do not log or store an identity claim that the client supplied but the boundary did not verify.

### Redact on the way out

Credentials, cookies, authorization headers, tokens, and session identifiers are redacted by the logger, not by remembering to omit them at each call site ([telemetry-and-runtime-health.md](telemetry-and-runtime-health.md)).

## Verification

- Send a payload the compiler's type accepted but the schema rejects, and confirm a `400` rather than a business-logic failure.
- Confirm an unvalidated value cannot reach an application operation: remove the parse at the boundary and observe the check fail.
- Force the same failure condition on two different routes and confirm one identical status and body shape.
- Confirm a thrown string, `null`, or plain object is handled without the error path itself crashing.
- Confirm a stack trace, database message, or internal identifier never appears in a client response for a `500`.
- Request a resource belonging to another identity and confirm denial — and confirm the code path runs without an inline authorization check in the handler.
- Send a request with a forged forwarding header and confirm the derived client address is unchanged.
- Confirm a response cannot contain a field that is absent from the declared output shape.
