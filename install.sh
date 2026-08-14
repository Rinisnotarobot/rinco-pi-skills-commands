#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SKILLS_SOURCE="$SCRIPT_DIR/skills"
COMMANDS_SOURCE="$SCRIPT_DIR/commands"

if [[ -n ${PI_AGENT_DIR:-} ]]; then
  AGENT_DIR=$PI_AGENT_DIR
else
  : "${HOME:?HOME must be set when PI_AGENT_DIR is not provided}"
  AGENT_DIR="$HOME/.pi/agent"
fi

install_tree() {
  local source=$1
  local destination=$2
  local label=$3

  [[ -d "$source" ]] || {
    printf 'Error: %s source directory not found: %s\n' "$label" "$source" >&2
    exit 1
  }
  [[ ! -e "$destination" || -d "$destination" ]] || {
    printf 'Error: %s destination is not a directory: %s\n' "$label" "$destination" >&2
    exit 1
  }

  mkdir -p -- "$destination"
  cp -a -- "$source/." "$destination/"
  printf 'Installed %s to %s\n' "$label" "$destination"
}

install_tree "$SKILLS_SOURCE" "$AGENT_DIR/skills" 'skills'
install_tree "$COMMANDS_SOURCE" "$AGENT_DIR/prompts" 'commands'

printf 'Pi installation complete. Restart Pi to load the installed content.\n'
