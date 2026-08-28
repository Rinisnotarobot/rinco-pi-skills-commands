#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=${REPO_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
SKILLS_DIR=${SKILLS_DIR:-$REPO_ROOT/skills}
MANIFEST=${MANIFEST:-$REPO_ROOT/tests/skills_manifest.tsv}
README_FILE=${README_FILE:-$REPO_ROOT/README.md}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[[ -d "$SKILLS_DIR" ]] || fail "skills directory not found: $SKILLS_DIR"
[[ -f "$MANIFEST" ]] || fail "manifest not found: $MANIFEST"
[[ -f "$README_FILE" ]] || fail "README not found: $README_FILE"

expected_names=
expected_count=0

validate_links() {
  local skill_dir=$1
  local file link target

  while IFS= read -r -d '' file; do
    while IFS= read -r link; do
      [[ -n "$link" ]] || continue
      target=${link##*\(}
      target=${target%\)}
      case "$target" in
        \#*|http://*|https://*|mailto:*) continue ;;
      esac
      target=${target%%#*}
      target=${target%%\?*}
      [[ -n "$target" ]] || continue
      [[ -e "$(dirname -- "$file")/$target" ]] || fail "broken link in $file: $target"
    done < <(grep -Eo '\[[^]]+\]\([^)]+\)' "$file" || true)
  done < <(find "$skill_dir" -type f -name '*.md' -print0)
}

while IFS=$'\t' read -r name invocation extra; do
  [[ -n "$name" ]] || continue
  [[ $name == \#* ]] && continue
  [[ -z ${extra:-} ]] || fail "unexpected manifest field for $name"
  [[ $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "invalid skill name: $name"
  [[ $invocation == model || $invocation == user ]] || fail "invalid invocation for $name: $invocation"
  ! grep -Fx -- "$name" <<<"$expected_names" >/dev/null || fail "duplicate manifest entry: $name"
  expected_names+="${expected_names:+$'\n'}$name"
  ((expected_count += 1))

  skill_dir=$SKILLS_DIR/$name
  skill_file=$skill_dir/SKILL.md
  [[ -d "$skill_dir" ]] || fail "manifest skill directory missing: $skill_dir"
  [[ -f "$skill_file" ]] || fail "SKILL.md missing: $skill_file"
  [[ $(sed -n '1p' "$skill_file") == '---' ]] || fail "frontmatter must start on line 1: $skill_file"

  frontmatter=$(awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { closed = 1; exit }
    in_frontmatter { print }
    END { if (!closed) exit 1 }
  ' "$skill_file") || fail "frontmatter is not closed: $skill_file"

  grep -Fx -- "name: $name" <<<"$frontmatter" >/dev/null || \
    fail "frontmatter name does not match directory: $skill_file"
  grep -Eq '^description:[[:space:]]*[^[:space:]].*$' <<<"$frontmatter" || \
    fail "frontmatter description missing: $skill_file"

  if [[ $invocation == user ]]; then
    grep -Fx -- 'disable-model-invocation: true' <<<"$frontmatter" >/dev/null || \
      fail "user-invoked skill lacks disable-model-invocation: true: $name"
  else
    ! grep -Fx -- 'disable-model-invocation: true' <<<"$frontmatter" >/dev/null || \
      fail "model-invoked skill disables model invocation: $name"
    grep -E '^description:.*Use when ' <<<"$frontmatter" >/dev/null || \
      fail "model-invoked description lacks a Use when trigger: $name"
  fi

  grep -F -- "(skills/$name/)" "$README_FILE" >/dev/null || \
    fail "README does not list promoted skill: $name"
  validate_links "$skill_dir"
done < "$MANIFEST"

((expected_count > 0)) || fail 'manifest contains no skills'

for skill_file in "$SKILLS_DIR"/*/SKILL.md; do
  [[ -e "$skill_file" ]] || fail "no promoted SKILL.md files under $SKILLS_DIR"
  name=$(basename -- "$(dirname -- "$skill_file")")
  grep -Fx -- "$name" <<<"$expected_names" >/dev/null || \
    fail "promoted skill missing from manifest: $name"
done

printf 'PASS: promoted Skill contracts, links, invocation modes, and README entries are valid\n'
