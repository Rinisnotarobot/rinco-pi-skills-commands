# Project and Runtime Setup

Use this reference for the Node.js and TypeScript project configuration a service runs on, once the service's structure has already been chosen.

## Ownership

The framework, transport shape, dependency injection model, validation entry point, and error mapping are **decided** by this skill's other references and by `backend-patterns`. This reference owns only the layer underneath them: which runtime the code runs on, which module system it is loaded as, which compiler options are in force, and how a compiled or transpiled artifact is started.

| Decision | Owner |
|---|---|
| Framework, composition root, injection scope, middleware order | [app-structure-and-boundaries.md](app-structure-and-boundaries.md) |
| Validator choice, error classification, status mapping | [validation-errors-and-identity.md](validation-errors-and-identity.md) |
| Layering, transaction scope, consistency, contract evolution | `backend-patterns` |
| Runtime version pins, module system, compiler options, build and run scripts, alias resolution, configuration loading | Here |
| Deployment platform, process manager, container topology, replica count | Not owned here |

**A compiler option is a runtime decision.** `module`, `moduleResolution`, `target`, and `package.json` `type` jointly determine which imports compile, which packages can be loaded at all, and how the artifact must be started. Change one without the others and the build can succeed while the process fails at startup.

## Runtime and version pins

Read the Node.js version from the sources the project already maintains — `engines` in `package.json`, `.nvmrc`, `.node-version`, CI configuration, or the container base image — and treat the lowest declared version as the floor the code must run on.

- If several sources disagree, that disagreement is the finding: a local version newer than the container base is how code reaches production that never ran there.
- Node.js major versions change module loading, built-in APIs, and error behavior. When a feature decides correctness, confirm it exists in the floor version rather than the version on the current machine.
- TypeScript version comes from `package.json` or the lockfile. A globally installed `tsc` is not the project's compiler; run the local one.

## Package type and module system

### The settings that must agree

| Setting | Where | Controls |
|---|---|---|
| `type` | `package.json` | How `.js` files in the package are interpreted |
| `module`, `moduleResolution` | `tsconfig.json` | Which import forms compile, and how specifiers resolve |
| `target`, `lib` | `tsconfig.json` | Emitted syntax and which standard library types exist |
| Build tool or bundler | project config | Whether output is emitted at all, and in which format |

Establish all four before writing code that depends on them, and record in the change which of them moved. A repository may legitimately be CommonJS, ESM, or a deliberate hybrid; the failure mode is being an unintended hybrid.

### Interop failure signatures

These symptoms almost always mean the module system, not the code:

- a specifier fails to resolve after compilation — a relative import without a file extension surviving into ESM output, or an alias that only `tsc` understood;
- `require`-ing a package that only publishes ESM, or importing a package that only publishes CommonJS through a named import that the interop layer does not provide;
- a default export arriving as the module object (or the reverse) because the two sides disagree about interop;
- two copies of the same dependency loaded, one per module format, so a singleton, class identity check, or `instanceof` stops holding.

When a dual-published dependency is involved, decide which format this project consumes and keep that decision in one place rather than working around it per import.

### Changing the module system

Treat the change as a runtime change with a migration: entry points, dynamic imports, `__dirname`-equivalent usage, test configuration, and the build output layout all participate. Verify the artifact actually starts, rather than verifying that type checking passed.

## Path aliases

### An alias that compiles is not an alias that resolves

`paths` in `tsconfig.json` is a compiler instruction only. The emitted code keeps the alias text, so the runtime loader, bundler, or test runner must be given the same mapping — through the build tool's configuration, a loader, a subpath import map in `package.json`, or package-level exports. Whichever mechanism the project already uses, reuse it; adding a second alias mechanism produces imports that work in one context and fail in another.

```jsonc
// One mapping, declared once, consumed by the compiler and the runtime.
{ "compilerOptions": { "baseUrl": ".", "paths": { "@app/*": ["src/*"] } } }
```

Prefer relative imports or workspace packages when they already express the boundary; an alias that exists to shorten paths adds a resolution layer to every entry point.

## Build and run

### Decide whether there is a build artifact

Two legitimate shapes, and the difference matters operationally:

- **emitted** — `tsc` or a bundler produces `dist/`, and the process starts the emitted JavaScript. Startup cost is paid at build time; source maps and the output layout must be configured deliberately.
- **directly executed** — a development runner or loader executes the TypeScript. Convenient locally, and a different runtime contract from production unless production uses the same mechanism.

Do not let development and production differ in module format, resolution mode, or environment loading. The failure mode is code that starts locally and crashes in the container on the first import.

### Keep build and type checking separate

A build that transpiles without checking will ship type errors, and a type check that is part of the build hides the difference between "does not compile" and "does not run". Where the project has both, keep both as distinct gates and record which one was run.

## Configuration and environment

### Load configuration once, at process start

Read the environment in the composition root, validate it, and pass the result inward as a typed object. Reading `process.env` scattered through the code makes the set of required variables unknowable, untestable, and impossible to validate before the first request.

```ts
// One boundary: parse, validate, fail loudly, expose a frozen object.
const Config = parseConfig(process.env)
```

- Validate at startup, including presence, type, and range. A missing mandatory variable must stop the process with a clear message, not surface as `undefined` inside a request.
- Distinguish configuration from secrets: secrets come through the same boundary, are never logged, and never receive a default.
- Treat an absent optional value and an explicitly empty one as different where the behavior differs.

## Type posture

- Read the strictness flags in force (`strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, and related options) before writing code that assumes them, and do not weaken one to make a change compile.
- Keep runtime types honest: infer them from the validation schema where the project does so, and let generated types from the database or API layer stay generated rather than being hand-copied.
- Keep ambient declarations and third-party type packages to the narrowest scope that needs them; a global ambient file silently changes what every file can compile.

## Dependencies and lockfile

- Add a dependency only when the project has no existing one and the need is real; a second library for the same job is a maintenance cost paid on every upgrade.
- Keep the lockfile change in the same change as the manifest change, and use the package manager the lockfile belongs to.
- Record whether a new dependency changes the runtime format requirement (for example, an ESM-only package in a CommonJS process).

## Verification

- Start the built artifact, not only the development runner, and confirm it imports successfully.
- Confirm every declared configuration variable is validated at startup: remove a mandatory one and observe the process failing with a clear message rather than serving a request.
- Trace one aliased import from source through the build output to the runtime resolution path.
- Confirm the Node.js version the process reports is at or above the declared floor.
- Confirm the lockfile matches the manifest and that a clean install reproduces the same tree.
- Confirm the module format of a representative third-party import in the running process — one copy loaded, one interop interpretation.
