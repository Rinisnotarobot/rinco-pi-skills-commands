#!/usr/bin/env bash
# Structural validation for the promoted-skill portfolio.
#
# Revives the structural gates removed with tests/ in 56255be, per the roadmap
# item "dependency-free Bash using repository-local files"
# (docs/plans/2026-08-28-skill-roadmap.md, manifest-validation section).
#
# FAIL blocks promotion; WARN is informational only.
#   1. frontmatter: starts on line 1, name present and kebab-case, name equals
#      directory name, description non-empty
#   2. every local Markdown link under skills/ resolves to an existing file
#   3. every references/ file is reachable from its SKILL.md or a sibling
#      reference (no orphan progressive-disclosure targets)
#   4. README inventory: every promoted skill is linked, every skills/ link
#      target exists
#   5. invocation contract: workflows table matches disable-model-invocation;
#      patterns/tools/meta stay model-invoked (no README column for them)
#   6. .pi/skills copies are byte-identical to their canonical skills/ source
#   7. global-install mirrors (informational; repository copies are canonical)
#   8. git diff --check is clean
#
# Usage: scripts/validate.sh   (run from anywhere; exit 0 = all gates green)

set -u -o pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

failures=0
warnings=0

ok()   { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1"; failures=$((failures + 1)); }
warn() { printf 'WARN: %s\n' "$1"; warnings=$((warnings + 1)); }
note() { printf 'note: %s\n' "$1"; }

frontmatter_block() { # <file>
  awk 'NR == 1 && $0 ~ /^---[[:space:]]*$/ { infm = 1; next }
       infm && $0 ~ /^---[[:space:]]*$/ { exit }
       infm { print }' "$1"
}

fm_value() { # <file> <key>
  frontmatter_block "$1" | sed -n "s/^$2:[[:space:]]*//p" | head -1 | tr -d '[:space:]'
}

fm_has() { # <file> <key>
  frontmatter_block "$1" | grep -q "^$2:"
}

# ---------------------------------------------------------------- 1. frontmatter
for sk in skills/*/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  dir=${sk%/SKILL.md}
  name=$(basename "$dir")

  if [[ $(sed -n '1p' "$sk") != '---' ]]; then
    fail "$sk: frontmatter must start on line 1"
    continue
  fi
  fm_name=$(fm_value "$sk" name)
  if [[ -z "$fm_name" ]]; then
    fail "$sk: missing required name field"
  elif [[ ! "$fm_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    fail "$sk: name '$fm_name' is not kebab-case"
  elif [[ "$fm_name" != "$name" ]]; then
    fail "$sk: frontmatter name '$fm_name' disagrees with directory '$name'"
  fi
  desc=$(frontmatter_block "$sk" | sed -n 's/^description:[[:space:]]*//p' | head -1 | tr -d '[:space:]')
  [[ -n "$desc" ]] || fail "$sk: missing or empty description"
done
ok "frontmatter name/description for all promoted skills"

# ---------------------------------------------------------------- 2. local links
strip_fences() { # print file without fenced code blocks (template examples are not links)
  awk '/^[[:space:]]*(```|~~~)/ { f = !f; next } !f { print }' "$1"
}

link_fail=0
while IFS= read -r -d '' file; do
  while IFS= read -r link; do
    target=${link#*\(}
    target=${target%)}
    case "$target" in
      ''|'#'*|http://*|https://*|mailto:*|/*) continue ;;
    esac
    target=${target%%#*}
    target=${target%%\?*}
    [[ -n "$target" ]] || continue
    [[ -e "$(dirname -- "$file")/$target" ]] || { fail "broken link in $file: $target"; link_fail=1; }
  done < <(strip_fences "$file" | grep -Eo '\[[^]]*\]\([^)]+\)' 2>/dev/null || true)
done < <(find skills -type f -name '*.md' -print0)
[[ $link_fail -eq 0 ]] && ok "all local Markdown links under skills/ resolve"

# ---------------------------------------------------------------- 3. orphan references
orphan_fail=0
for sk in skills/*/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  refdir=${sk%/SKILL.md}/references
  [[ -d "$refdir" ]] || continue
  for ref in "$refdir"/*; do
    [[ -f "$ref" ]] || continue
    base=$(basename "$ref")
    if ! grep -qF -- "$base" "$sk" \
       && ! grep -rqF --exclude="$base" -- "$base" "$refdir"; then
      fail "orphan reference: $ref is reachable from neither its SKILL.md nor sibling references"
      orphan_fail=1
    fi
  done
done
[[ $orphan_fail -eq 0 ]] && ok "every references/ file is reachable"

# ---------------------------------------------------------------- 4. README inventory
inventory_fail=0
for sk in skills/*/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  reldir=${sk%/SKILL.md}
  grep -qF -- "($reldir/)" README.md \
    || { fail "README inventory missing: $reldir"; inventory_fail=1; }
done
while IFS= read -r link; do
  target=${link#*(}
  target=${target%)}
  [[ -d "$target" ]] || { fail "README links to missing skills/ path: $target"; inventory_fail=1; }
done < <(grep -oE '\(skills/[a-z0-9-]+/[a-z0-9-]+/\)' README.md | sort -u)
[[ $inventory_fail -eq 0 ]] && ok "README inventory matches skills/ tree"

# ---------------------------------------------------------------- 5. invocation contract
inv_fail=0
for sk in skills/workflows/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  name=$(basename "${sk%/SKILL.md}")
  row=$(grep -F -- "skills/workflows/$name/" README.md | grep '^|' | head -1)
  if fm_has "$sk" disable-model-invocation; then
    [[ "$row" == *显式* && "$row" != *自动* ]] \
      || { fail "README workflows table: $name is explicit-only but its row does not say 显式 (row: ${row:-missing})"; inv_fail=1; }
  else
    [[ "$row" == *自动* ]] \
      || { fail "README workflows table: $name is model-invocable but its row lacks 自动 / 显式 (row: ${row:-missing})"; inv_fail=1; }
  fi
done
for sk in skills/patterns/*/SKILL.md skills/tools/*/SKILL.md skills/meta/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  if fm_has "$sk" disable-model-invocation; then
    fail "$sk: explicit-only outside workflows/ has no README invocation column; move it or make it model-invocable"
    inv_fail=1
  fi
done
[[ $inv_fail -eq 0 ]] && ok "invocation contract matches README"

# ---------------------------------------------------------------- 6. .pi/skills parity
pi_fail=0
for d in .pi/skills/*/; do
  [[ -d "$d" ]] || continue
  name=$(basename "$d")
  canonical=$(find skills -mindepth 2 -maxdepth 2 -type d -name "$name" | head -1)
  if [[ -z "$canonical" ]]; then
    warn ".pi/skills/$name has no canonical skills/ copy"
    continue
  fi
  diff -rq "$d" "$canonical" >/dev/null 2>&1 \
    || { fail ".pi/skills/$name drifted from $canonical"; pi_fail=1; }
done
[[ $pi_fail -eq 0 ]] && ok ".pi/skills copies match their canonical skills/ source"

# ---------------------------------------------------------------- 7. global mirrors
GLOBAL_SKILLS="${HOME}/.pi/agent/skills"
if [[ -d "$GLOBAL_SKILLS" ]]; then
  mirrored=0
  drifted=0
  for d in skills/*/*/; do
    name=$(basename "$d")
    [[ -d "$GLOBAL_SKILLS/$name" ]] || continue
    mirrored=$((mirrored + 1))
    if diff -rq "$d" "$GLOBAL_SKILLS/$name" >/dev/null 2>&1; then
      :
    else
      warn "global install $name differs from the repository copy (repository is canonical; refresh the global install when convenient)"
      drifted=$((drifted + 1))
    fi
  done
  note "global mirror check: $mirrored mirrored, $drifted drifted (informational)"
else
  note "global skills directory not present; mirror check skipped"
fi

# ---------------------------------------------------------------- 8. git hygiene
if git diff --check >/dev/null 2>&1; then
  ok "git diff --check is clean"
else
  fail "git diff --check reported whitespace or conflict-marker problems"
  git diff --check 2>/dev/null | head -10
fi
note "worktree status: $(git status --short | wc -l) changed path(s)"

printf '\nRESULT: %d failure(s), %d warning(s)\n' "$failures" "$warnings"
[[ $failures -eq 0 ]]
