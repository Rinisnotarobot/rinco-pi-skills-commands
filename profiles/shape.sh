#!/usr/bin/env bash
# Rinco "Shape" profile: ambiguous-change work.
# grilling -> domain-modeling -> spec -> plan, with discovery vocabulary and tooling.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
launch_pi \
  skills/workflows/grilling \
  skills/patterns/domain-modeling \
  skills/patterns/codebase-design \
  skills/workflows/spec \
  skills/workflows/plan \
  skills/tools/terminal-ops \
  skills/tools/context7-docs \
  "$@"
