#!/usr/bin/env bash
# Rinco "Build" profile: planned implementation work.
# plan -> tdd -> verification -> code-review with standards and tooling.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
launch_pi \
  skills/workflows/plan \
  skills/workflows/tdd \
  skills/workflows/systematic-debugging \
  skills/workflows/verification \
  skills/workflows/code-review \
  skills/patterns/coding-standards \
  skills/tools/terminal-ops \
  "$@"
