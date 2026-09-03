# Shared profile validation for Rinco Pi launchers.
# Each launcher sources this file, then calls launch_pi with its skill list
# followed by any extra arguments to pass through to pi.

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[1]:-.}")/.." && pwd)}"

validate_profile() {
  local failed=0
  local -A seen=()
  local skill_path name
  for skill_path in "$@"; do
    local abs="$REPO_ROOT/$skill_path"
    if [ ! -f "$abs/SKILL.md" ]; then
      echo "PROFILE ERROR: missing $skill_path/SKILL.md" >&2
      failed=1
      continue
    fi
    name="$(sed -n 's/^name:[[:space:]]*//p' "$abs/SKILL.md" | head -1 | tr -d '[:space:]')"
    if [ -z "$name" ]; then
      echo "PROFILE ERROR: $skill_path/SKILL.md has no name field" >&2
      failed=1
      continue
    fi
    if [ -n "${seen[$name]:-}" ]; then
      echo "PROFILE ERROR: duplicate skill name '$name' ($skill_path and ${seen[$name]})" >&2
      failed=1
    else
      seen["$name"]="$skill_path"
    fi
  done
  if [ "$failed" -ne 0 ]; then
    echo "Profile rejected before launch. Fix the profile definition." >&2
    exit 1
  fi
}

launch_pi() {
  local skills=()
  while [ $# -gt 0 ] && [[ "$1" != -* ]]; do
    skills+=("$1")
    shift
  done
  validate_profile "${skills[@]}"
  local args=(--no-skills)
  local skill_path
  for skill_path in "${skills[@]}"; do
    args+=(--skill "$REPO_ROOT/$skill_path")
  done
  exec pi "${args[@]}" "$@"
}
