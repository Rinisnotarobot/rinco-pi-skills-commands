#!/usr/bin/env bash
# Rinco "Fix" profile: unknown-cause defect repair.
# fix -> systematic-debugging -> tdd -> verification -> code-review.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
launch_pi \
  skills/workflows/fix \
  skills/workflows/systematic-debugging \
  skills/workflows/tdd \
  skills/workflows/verification \
  skills/workflows/code-review \
  skills/patterns/coding-standards \
  skills/tools/terminal-ops \
  skills/workflows/session-handoff \
  "$@"
