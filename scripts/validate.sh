#!/usr/bin/env bash
# Structural validation for the promoted-skill portfolio.
#
# Revives the structural gates removed with tests/ in 56255be.
#
# FAIL blocks promotion; WARN is informational only.
#   1. frontmatter: starts on line 1, name present and kebab-case, name equals
#      directory name, description non-empty, standalone closing delimiter. The
#      same gate runs Pi's own skill loader over skills/ (validate-skills.mjs),
#      so "what a session loads" is the loader's verdict rather than a re-parse;
#      on a machine without node or Pi it degrades to WARN plus a built-in check
#      for values a plain YAML scalar cannot carry (': ' or a trailing ':'), the
#      shape that made Pi drop whole skills
#   2. every local Markdown link under skills/ resolves to an existing file
#   3. every references/ file is reachable from its SKILL.md or a sibling
#      reference (no orphan progressive-disclosure targets)
#   4. README inventory (runs only when README.md exists): every promoted
#      skill is linked, every skills/ link target exists
#   5. invocation contract (runs only when README.md exists): workflows table
#      matches disable-model-invocation; patterns/tools/meta/stacks stay
#      model-invoked (no README column for them)
#   6. git diff --check is clean
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
       infm && $0 ~ /^---[[:space:]]*$/ { closed = 1; exit }
       infm { print }
       END { exit !closed }' "$1"
}

fm_value() { # <file> <key>
  frontmatter_block "$1" | sed -n "s/^$2:[[:space:]]*//p" | head -1 | tr -d '[:space:]'
}

fm_has() { # <file> <key>
  frontmatter_block "$1" | grep -q "^$2:"
}

fm_unsafe() { # <file>  -> reason string for the first YAML-unsafe value, else empty
  frontmatter_block "$1" | awk '
    BEGIN { sq = sprintf("%c", 39); dq = "\"" }
    function brief(text) { return length(text) > 80 ? substr(text, 1, 80) "..." : text }
    {
      body = $0
      sub(/[ \t]+#.*$/, "", body)            # trailing comment is not scalar text
      if (body ~ /^[ \t]*$/) next
      indented = (body ~ /^[ \t]+/)

      if (body !~ /^[ \t]*[A-Za-z0-9_.-]+[ \t]*:/) {   # not a key line
        if (!indented) scalar = 0            # a plain scalar may wrap onto
        next                                  # lines that do not look like keys
      }
      if (indented && scalar) {
        print "continuation line reads as a mapping key: " brief($0)
        next
      }
      key = body
      sub(/[ \t]*:.*$/, "", key)
      sub(/^[ \t]*/, "", key)
      val = body
      sub(/^[ \t]*[A-Za-z0-9_.-]+[ \t]*:[ \t]*/, "", val)
      if (val == "") { scalar = 0; next }      # block mapping follows
      if (substr(val, 1, 1) == dq || substr(val, 1, 1) == sq) { scalar = 0; next }
      if (val ~ /: / || val ~ /:$/)
        print "unquoted value contains \": \" or ends with \":\": " key ": " brief(val)
      scalar = !indented
    }'
}

# ---------------------------------------------------------------- 1. frontmatter
# Pi's own loader is authoritative when it is available: it reports exactly what
# a session would load from skills/. The heuristic in the per-file loop below is
# the fallback for machines where the loader cannot run.
loader_available=0
expected=""
for sk in skills/*/*/SKILL.md; do
  [[ -e "$sk" ]] && expected+="$sk"$'\n'
done
if command -v node >/dev/null 2>&1; then
  loader_err=$(mktemp)
  loader_out=$(printf '%s' "$expected" \
    | node "$REPO_ROOT/scripts/validate-skills.mjs" "$REPO_ROOT" "$REPO_ROOT/skills" 2>"$loader_err")
  loader_rc=$?
  if [[ $loader_rc -eq 0 || $loader_rc -eq 1 ]]; then
    loader_available=1
    while IFS= read -r line; do
      case "$line" in
        FAIL:*) fail "${line#FAIL: }" ;;
        note:*) note "${line#note: }" ;;
      esac
    done <<< "$loader_out"
    [[ $loader_rc -eq 0 ]] && ok "Pi's loader loads every promoted skill with no diagnostics"
  else
    warn "Pi's skill loader unavailable ($(head -1 "$loader_err")); using this script's frontmatter check instead"
  fi
  rm -f "$loader_err"
else
  warn "node not found; Pi's skill loader cannot run, using this script's frontmatter check instead"
fi

for sk in skills/*/*/SKILL.md; do
  [[ -e "$sk" ]] || continue
  dir=${sk%/SKILL.md}
  name=$(basename "$dir")

  if [[ $(sed -n '1p' "$sk") != '---' ]]; then
    fail "$sk: frontmatter must start on line 1"
    continue
  fi
  if ! frontmatter_block "$sk" >/dev/null; then
    fail "$sk: frontmatter missing closing delimiter"
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
  if [[ $loader_available -eq 0 ]]; then
    unsafe=$(fm_unsafe "$sk" | head -1)
    [[ -z "$unsafe" ]] || fail "$sk: $unsafe"
  fi
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
if [[ -f README.md ]]; then
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
else
  ok "README.md absent; README inventory gate skipped"
fi

# ---------------------------------------------------------------- 5. invocation contract
if [[ -f README.md ]]; then
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
  for sk in skills/patterns/*/SKILL.md skills/tools/*/SKILL.md \
            skills/meta/*/SKILL.md skills/stacks/*/SKILL.md; do
    [[ -e "$sk" ]] || continue
    if fm_has "$sk" disable-model-invocation; then
      fail "$sk: explicit-only outside workflows/ has no README invocation column; move it or make it model-invocable"
      inv_fail=1
    fi
  done
  [[ $inv_fail -eq 0 ]] && ok "invocation contract matches README"
else
  ok "README.md absent; invocation-contract gate skipped"
fi

# ---------------------------------------------------------------- 6. git hygiene
if git diff --check >/dev/null 2>&1; then
  ok "git diff --check is clean"
else
  fail "git diff --check reported whitespace or conflict-marker problems"
  git diff --check 2>/dev/null | head -10
fi
note "worktree status: $(git status --short | wc -l) changed path(s)"

printf '\nRESULT: %d failure(s), %d warning(s)\n' "$failures" "$warnings"
[[ $failures -eq 0 ]]
