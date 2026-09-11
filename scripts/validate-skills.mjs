#!/usr/bin/env node
/**
 * Frontmatter gate that runs Pi's own skill loader.
 *
 * `scripts/validate.sh` owns the structural rules (name is kebab-case, name
 * equals the directory, description is non-empty). This script answers the one
 * question a hand-written frontmatter parser cannot: what does Pi actually load
 * from `skills/`? It imports `loadSkills` from the public entry point of the
 * installed Pi package, so the verdict is the loader's, not a re-implementation
 * of it. A YAML value that parses differently than intended therefore fails
 * here -- as a missing skill -- instead of at session start.
 *
 * Usage:
 *   printf '%s\n' skills/<family>/<name>/SKILL.md ... \
 *     | node scripts/validate-skills.mjs <repo-root> <skills-dir>
 *   node scripts/validate-skills.mjs <repo-root> <skills-dir>   # TTY: walks <skills-dir> itself
 *
 *   PI_PACKAGE_DIR=/path/to/@earendil-works/pi-coding-agent   # override resolution
 *
 * stdout: "FAIL: ..." for everything Pi would reject or skip, "note: ..." for
 * context. Callers relay those lines verbatim.
 * exit:   0 = every expected skill loaded with no diagnostics
 *         1 = a problem was reported on stdout
 *         2 = Pi's loader could not be resolved (reason on stderr; caller may
 *             fall back to its own frontmatter checks)
 */
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync, realpathSync, statSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const PI_PACKAGE_NAME = "@earendil-works/pi-coding-agent";

const [rootArg, skillsArg] = process.argv.slice(2);
if (!rootArg || !skillsArg) {
  console.error("usage: validate-skills.mjs <repo-root> <skills-dir>");
  process.exit(2);
}
const root = resolve(rootArg);
const skillsDir = resolve(root, skillsArg);

const problems = [];
const fails = (message) => problems.push(`FAIL: ${message}`);

// ---------------------------------------------------------------- expectations
function walkExpected(dir, depth = 0) {
  const found = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (!entry.isDirectory() || entry.name.startsWith(".") || entry.name === "node_modules") continue;
    const full = join(dir, entry.name);
    if (existsSync(join(full, "SKILL.md"))) {
      found.push(join(full, "SKILL.md"));
      continue;
    }
    if (depth < 1) found.push(...walkExpected(full, depth + 1));
  }
  return found;
}

// The caller decides what should exist; a standalone run derives it the same
// way validate.sh does (skills/<family>/<name>/SKILL.md, one level of nesting).
function readExpectedFromStdin() {
  if (process.stdin.isTTY) return [];
  try {
    return readFileSync(0, "utf8")
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean)
      .map((rel) => resolve(root, rel));
  } catch {
    return [];   // no stdin to read (e.g. run by hand with stdin closed)
  }
}

const expected = readExpectedFromStdin();
const expectedSet = new Set(expected.length > 0 ? expected : walkExpected(skillsDir));

// ---------------------------------------------------------------- Pi resolution
function tryExec(command, args) {
  try {
    return execFileSync(command, args, { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
  } catch {
    return "";
  }
}

function entryOf(pkgDir) {
  const manifest = join(pkgDir, "package.json");
  if (!existsSync(manifest)) return null;
  let pkg;
  try {
    pkg = JSON.parse(readFileSync(manifest, "utf8"));
  } catch {
    return null;
  }
  if (pkg.name !== PI_PACKAGE_NAME) return null;
  const dot = pkg.exports?.["."];
  const main = (typeof dot === "string" ? dot : dot?.import ?? dot?.default) ?? pkg.main ?? "dist/index.js";
  const entry = join(pkgDir, main);
  return existsSync(entry) ? entry : null;
}

function resolvePiEntry() {
  const candidates = [];
  if (process.env.PI_PACKAGE_DIR) candidates.push(process.env.PI_PACKAGE_DIR);
  // `pi` is normally a symlink into the package; walk up from its real location.
  const bin = tryExec("sh", ["-c", "command -v pi"]);
  if (bin && existsSync(bin)) {
    let dir = dirname(realpathSync(bin));
    for (let i = 0; i < 5; i += 1) {
      candidates.push(dir);
      const parent = dirname(dir);
      if (parent === dir) break;
      dir = parent;
    }
  }
  const globalRoot = tryExec("npm", ["root", "-g"]);
  if (globalRoot) candidates.push(join(globalRoot, PI_PACKAGE_NAME));

  for (const candidate of candidates) {
    const entry = entryOf(resolve(candidate));
    if (entry) return { entry, pkgDir: resolve(candidate) };
  }
  return null;
}

const resolved = resolvePiEntry();
if (!resolved) {
  console.error(`could not resolve the ${PI_PACKAGE_NAME} package (tried PI_PACKAGE_DIR, \`pi\` on PATH, \`npm root -g\`)`);
  process.exit(2);
}

let loadSkills;
let version = "unknown";
try {
  ({ loadSkills } = await import(pathToFileURL(resolved.entry).href));
  version = JSON.parse(readFileSync(join(resolved.pkgDir, "package.json"), "utf8")).version ?? version;
} catch (error) {
  console.error(`failed to import the loader from ${resolved.entry}: ${error.message}`);
  process.exit(2);
}
if (typeof loadSkills !== "function") {
  console.error(`the installed ${PI_PACKAGE_NAME}@${version} does not export loadSkills`);
  process.exit(2);
}

// ---------------------------------------------------------------- the check
// includeDefaults: false keeps this to skills/ -- no user or project skills, no
// settings, no network. What it loads is what a session would load from here.
const { skills, diagnostics } = await loadSkills({
  cwd: root,
  skillPaths: [skillsDir],
  includeDefaults: false,
});

const rel = (p) => relative(root, resolve(p)) || ".";
const loaded = new Map(skills.map((skill) => [resolve(skill.filePath), skill]));

for (const path of expectedSet) {
  if (!loaded.has(resolve(path))) {
    fails(`${rel(path)}: Pi's loader did not load this file (frontmatter it cannot parse, or an empty description)`);
  }
}
for (const path of loaded.keys()) {
  if (!expectedSet.has(path)) {
    fails(`${rel(path)}: Pi's loader picked up a file this gate does not expect`);
  }
}

for (const diagnostic of diagnostics ?? []) {
  const where = diagnostic.path ? `${rel(diagnostic.path)}: ` : "";
  if (diagnostic.type === "collision") {
    const { name, winnerPath, loserPath } = diagnostic.collision ?? {};
    fails(`${where}skill name "${name}" collides with ${rel(winnerPath ?? "?")}; Pi keeps only one, rename ${rel(loserPath ?? "?")}`);
  } else {
    fails(`${where}${diagnostic.message}`);
  }
}

const quiet = skills.filter((skill) => skill.disableModelInvocation).length;
process.stdout.write(`note: Pi ${version} loader: ${skills.length} skill(s) loaded from ${rel(skillsDir)}, ${quiet} explicit-only, ${(diagnostics ?? []).length} diagnostic(s)\n`);
for (const problem of problems) process.stdout.write(`${problem}\n`);
process.exit(problems.length > 0 ? 1 : 0);
