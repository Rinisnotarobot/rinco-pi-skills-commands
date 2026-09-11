# NestJS Shape

Use this reference for the NestJS expression of the decisions in this skill's other references. Read those for the reasoning; read this one for where the framework puts it. For Express or Fastify without Nest, the rules in the other references apply directly and this file does not.

## Ownership

Nest provides a module system, an injector, a request pipeline, and a testing harness. It does not decide layering, transaction scope, error taxonomy, or delivery semantics — those come from `backend-patterns` and from this skill's other references.

| Concern | Where |
|---|---|
| Module boundaries, composition root, middleware order, lifecycle | [app-structure-and-boundaries.md](app-structure-and-boundaries.md) |
| Validation entry point, error mapping, identity derivation | [validation-errors-and-identity.md](validation-errors-and-identity.md) |
| Transactions, outbox, workers, acknowledgement | [persistence-transactions-and-jobs.md](persistence-transactions-and-jobs.md) |
| Which Nest decorator, token, or hook expresses it | Here |

**A registered provider is not a boundary.** Nest makes any provider injectable from anywhere it is imported; the dependency direction still has to be maintained deliberately, because the injector will happily let an application service depend on a controller's module.

## Modules

### A module is the feature boundary

Follow the boundary that `backend-patterns` decided, and let one module correspond to it: the transport surface it exposes, the application operations it owns, its access to its own data, and its own input and output types.

- `imports` and `exports` are the public surface. A provider that is not exported is internal, and reaching it from another module's internals is the same violation as importing another feature's internal file in a plain Node project.
- Exported providers are the interface; internal providers are the implementation. Keep the exported set as small as the module's callers require.
- A module that exports everything it declares has no boundary, only a folder.

### Avoid global modules

`@Global()` removes the need to import, and with it the visible dependency edge. A provider used by many modules is usually either genuinely cross-cutting (configuration, logger, telemetry) or a shared concept that belongs in a module the others import explicitly. Confirm which before reaching for `@Global()`.

### Dynamic modules for configured providers

When a provider needs configuration or a client instance, expose `forRoot`/`forRootAsync`-style static methods that build it, and consume `ConfigService` in an async factory rather than reading the environment inside the provider. One configured client per process, constructed by the composition root ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)).

### Circular module references are a boundary symptom

`forwardRef` resolves the injection error without resolving the design problem. Move the shared concept to its own module, or invert the dependency, rather than adding indirection that hides the cycle.

## Providers and injection

### Class providers and tokens

A class provider is injected by its class. Anything else — an interface, a configured client, a value — needs an explicit token, and the token is a design decision: a class used as a token, a `Symbol`, or a string. Use the project's existing convention, and use `Symbol` or a constant rather than a bare string when starting fresh, so a typo cannot silently become a second provider.

### Custom providers

`useClass`, `useValue`, `useFactory`, and `useExisting` bind a token to an implementation. This is the seam that lets a test substitute a port without patching a module ([testing-node-services.md](testing-node-services.md)). Register the substitution through the token the code actually resolves.

### Scope

Nest's scopes are `DEFAULT` (one instance per application), `REQUEST`, and `TRANSIENT`. Two consequences decide most designs:

- **Request scope bubbles up.** A request-scoped provider makes every provider that injects it request-scoped as well, transitively, and each request then constructs the affected chain. This is a real per-request cost, not a detail. Prefer passing request data as parameters or through a context mechanism unless the project has already accepted request-scoped providers.
- **Request data must not live on a default-scoped provider.** A singleton holding the current user is a cross-request leak that single-request tests do not detect ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)).

Confirm the scope semantics in the installed major rather than assuming them.

### Constructor injection

Take dependencies as constructor parameters, and mark the class `@Injectable()`. Property injection hides a dependency from the signature and makes the class harder to construct outside the container. Where a dependency must be resolved lazily or optionally, make that explicit rather than reaching for the container as a service locator, which defeats the injector's only real benefit: a visible dependency graph.

## The request lifecycle

### Order is semantics

Nest's order differs from "middleware first, then everything else" in a plain framework. Establish it from the installed framework documentation and keep the ordering assertion in one test or one comment, because the registration is spread across modules.

The pipeline a request traverses, in order: middleware, then guards, then interceptors (before the handler), then pipes, then the handler, then interceptors (after the handler), then exception filters.

| Stage | Use it for | Do not use it for |
|---|---|---|
| Middleware | Raw request pre-processing, body parsing, request context | Anything needing the selected route handler or resolved identity metadata |
| Guard | Authorization and admission decisions | Business rules that depend on the loaded entity |
| Interceptor | Response shaping, timing, timeouts, cross-cutting logging, result transformation | Validation, which belongs to a pipe |
| Pipe | Validation and transformation of a handler's parameters | Authorization |
| Exception filter | The single mapping from a classified failure to a transport response | Retrying or swallowing failures |

### Guards express authorization

A guard is the point every authoritative route passes through, which is why it is the right place for the check that a new route must not be able to omit ([validation-errors-and-identity.md](validation-errors-and-identity.md)). Route metadata plus the reflector is the idiomatic way to mark public routes: a global guard denies by default, and a decorator opts a route out. The inverse — default allow, opt in to protection — is how routes end up unprotected.

Guard decisions that need the loaded entity belong in the application layer, where the entity exists; a guard that refetches the row to decide authorization duplicates the operation and races with it.

### Pipes validate

Apply the project's `ValidationPipe` (or its equivalent) where it belongs — globally, per controller, or per parameter — with DTO classes for the input shapes. Confirm the behavior of the whitelisting, rejection, and transformation options in the installed version, and decide explicitly whether unknown properties are stripped or rejected: stripping silently changes the effective input, and rejecting is the stricter default for a documented contract.

Pipes transform as well as validate; a pipe that mutates its input in place hides the transformation from the handler's signature.

### Interceptors for cross-cutting response concerns

Use an interceptor for response envelope shaping, per-request timing, timeout enforcement, and consistent logging, and read the project's existing interceptors before adding one. An interceptor that catches everything turns a failure into a success response and removes the failure from the error path; if a failure is being handled, it belongs in a filter or in the application layer.

### Exception filters are the one mapping point

Map classified failures to transport responses in filters, not in each controller ([validation-errors-and-identity.md](validation-errors-and-identity.md)). Framework HTTP exceptions are fine for transport-level conditions; a domain failure should be raised as a domain error and mapped once, so it does not depend on the HTTP layer. Confirm the filter's precedence in the installed version and keep one filter responsible for each class of failure.

### Registering globals

Global guards, pipes, interceptors, and filters registered through the container-aware mechanism participate in dependency injection; those registered by calling the application instance's `useGlobalX` methods are constructed outside it and cannot inject providers. Use the container-aware registration unless the component genuinely has no dependencies, and confirm which mechanism the project uses before adding a second.

## Configuration

- Use `ConfigModule` with a validation schema so a missing mandatory variable fails at startup ([project-and-runtime-setup.md](project-and-runtime-setup.md)).
- Expose configuration as namespaced, typed access rather than passing `ConfigService` into feature code that reads string keys at the point of use; a typed configuration provider keeps the key names in one place.
- Never give a secret a default value, and never read `process.env` in feature code.
- Confirm the installed version's loading and caching behavior for environment files and for `ConfigModule` global registration before relying on either.

## Lifecycle and shutdown

| Hook | Runs | Use it for |
|---|---|---|
| `onModuleInit` | Once the module's providers are resolved | Work that must happen before the application accepts traffic |
| `onApplicationBootstrap` | After all modules initialized | Cross-module initialization |
| `beforeApplicationShutdown` | On shutdown, before providers are destroyed | Draining, closing listeners |
| `onApplicationShutdown` | After in-flight work has been given time | Releasing clients, flushing telemetry |
| `onModuleDestroy` | When the application closes | Per-module cleanup |

- Enable shutdown hooks in the entry point and confirm the process responds to the signal the deployment platform sends; without that, containers are killed rather than drained ([app-structure-and-boundaries.md](app-structure-and-boundaries.md)).
- Providers with a `close()` are released when the application closes, which is why the entry point must close the application rather than exiting.
- Confirm the actual ordering of shutdown across modules by test, since the order determines whether a client is closed before or after the work using it.

## Testing

- Build the application for a test with `Test.createTestingModule`, composing the real modules and overriding only the providers the test must substitute.
- `overrideProvider` must name the exact token the code resolves. A test that overrides a token nothing uses will pass while the real client is still in place.
- Distinguish `compile()` from `init()`: the first builds the graph, the second runs module initialization. Test whether initialization is part of the behavior under test.
- Close the application in teardown so hooks run and clients are released ([testing-node-services.md](testing-node-services.md)).
- Override a global guard or pipe explicitly when the test is about the handler and not about admission; leaving the production guard in place is the more honest default.
- End-to-end tests go through the HTTP adapter; `supertest`-style request helpers against the initialized application are the common shape. Confirm which adapter the project uses, since request and response objects differ between Express and Fastify.

## Version sensitivity

NestJS majors move modules between packages, change adapter requirements, and change defaults for pipes and configuration. Before writing Nest-specific code:

- read the pinned `@nestjs/*` versions from `package.json` and the lockfile;
- search the repository for an existing controller, guard, filter, or module of the same shape and copy it;
- confirm the behavior of anything option-dependent in the installed version rather than from recall;
- treat an upgrade of the framework major as a change to the runtime, and verify the application actually starts ([project-and-runtime-setup.md](project-and-runtime-setup.md)).

## Verification

- Confirm a route added without an authorization decorator is denied by the global guard.
- Confirm a request that reaches a handler has been through validation, by sending a payload the DTO rejects and observing the classified failure.
- Confirm exactly one filter produces the response for each classified domain failure, and that a stack trace never reaches the client.
- Confirm the request pipeline order with one test that exercises a guard, a pipe, an interceptor, and a filter together.
- Confirm a request-scoped provider does not make the whole graph request-scoped without that being intended.
- Confirm a substituted provider in a test is reached by the code under test — remove the substitution and observe the test fail.
- Confirm shutdown drains in-flight work and releases clients, by sending a signal during a request.
- Confirm the application starts from the built artifact with the production module configuration.
