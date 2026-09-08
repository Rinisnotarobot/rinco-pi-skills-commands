#!/usr/bin/env bash
# install.sh — mirror skills from this repo into a Pi discovery scope.
#
# Simplest possible install: flatten each selected skill folder (SKILL.md plus
# its references/) into <scope>/<name>/. No registry, no versioning — the repo
# stays the single source of truth; re-run to refresh.
#
# Usage:
#   bash scripts/install.sh                       # all skills -> ~/.pi/agent/skills (global)
#   bash scripts/install.sh spec plan tdd         # only the named skills
#   bash scripts/install.sh --scope .pi/skills    # project scope instead of global
#
# Uninstall: rm -rf <scope>/<name> for each installed skill.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCOPE="${HOME}/.pi/agent/skills"

# --- args --------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      [[ $# -ge 2 ]] || { echo "error: --scope needs a directory" >&2; exit 2; }
      SCOPE="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,10p' "$0"; exit 0 ;;
    --)
      shift; break ;;
    -*)
      echo "error: unknown option $1 (see -h)" >&2; exit 2 ;;
    *)
      break ;;
  esac
done
NAMES=("$@")

# --- inventory ----------------------------------------------------------
# All promoted skills live as skills/<family>/<name>/SKILL.md; folder basename
# is the skill name and matches frontmatter. tools/readme is a skills-family
# folder too, so families = workflows | patterns | tools.
mapfile -t AVAILABLE < <(find "$REPO_ROOT/skills" -name SKILL.md -printf '%h\n' \
  | sed "s|$REPO_ROOT/skills/||; s|/| |" | sort)

AVAIL_NAMES=(); declare -A SRC_OF
for fam_name in "${AVAILABLE[@]}"; do
  fam="${fam_name%% *}"; name="${fam_name##* }"
  AVAIL_NAMES+=("$name")
  SRC_OF["$name"]="$REPO_ROOT/skills/$fam/$name"
done

if [[ ${#NAMES[@]} -eq 0 ]]; then
  NAMES=("${AVAIL_NAMES[@]}")
fi
for want in "${NAMES[@]}"; do
  [[ -n "${SRC_OF[$want]:-}" ]] || {
    echo "error: unknown skill '$want'. available: ${AVAIL_NAMES[*]}" >&2
    exit 1
  }
done

# --- install ------------------------------------------------------------
mkdir -p "$SCOPE"
echo "installing ${#NAMES[@]} skill(s) into $SCOPE"
for name in "${NAMES[@]}"; do
  mkdir -p "$SCOPE/$name"
  cp -R "${SRC_OF[$name]}/." "$SCOPE/$name/"   # content copy: idempotent, overwrites per file
  echo "  ✓ $name"
done
echo
echo "next: in Pi, verify with /skill:${NAMES[0]} or restart to load the model-invoked"
echo "ones; refresh = re-run this script; uninstall = rm -rf $SCOPE/<name>."
