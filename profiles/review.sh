#!/usr/bin/env bash
# Rinco "Review" profile: independent review of current changes.
# code-review consuming fresh verification evidence, with standards and tooling.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
launch_pi \
  skills/workflows/code-review \
  skills/workflows/verification \
  skills/patterns/coding-standards \
  skills/tools/terminal-ops \
  skills/workflows/session-handoff \
  "$@"
