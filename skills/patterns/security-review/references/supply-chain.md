# Supply Chain and Build Surfaces

Evidence rules for the trust boundaries around dependencies, build, and delivery — the boundaries the diff crosses when it changes what runs, not just how.

## Dependency changes

- A new dependency is a boundary expansion: what it executes at install time, what it reads, what it exfiltrates. Findings require evidence of the risk, not unfamiliarity.
- Version pinning: floating ranges in lockfile-consumed manifests are hardening notes unless the diff pins a known-vulnerable version (check the advisory, not memory — use the package registry/advisory source the project documents).
- Known-vulnerable version + reachable use of the vulnerable API = HIGH finding; advisory without reachability = MEDIUM note naming the call site to verify.

## Install-time execution

- Post-install scripts run with developer privileges: a finding requires the script to exist in the changed package and to do something evidence-backed (network egress of local data, filesystem writes outside the package). Reputation is not evidence.
- Lockfile integrity: changes that bypass or rewrite lockfile hashes without the corresponding manifest change are findings — the lockfile is the boundary artifact.

## Build pipeline changes

- CI workflow changes are trust boundaries: pull_request_target-family triggers with checkout of untrusted refs, secrets exposed to forked-code steps, cache poisoning across branches.
- A workflow finding needs: the untrusted input source (PR ref, PR title, comment), the sink (script execution, secret reference), and the step where the guard (permission boundary, ref pinning) fails.
- Runner permissions: check what the job's token can write (releases, other workflows) — write scopes plus untrusted input reaching workflow-writing steps are HIGH.

## Artifacts and delivery

- Artifact signing/verification changes: removing a verification step is a **direct-boundary-removal finding** — the removed step was the guard itself; the evidence is the regression in the diff. Adding one is not a finding.
- Container base images and digest pinning: floating tags in production paths are hardening notes; a digest mismatch between build and deploy is a finding.

## What stays out

- Licenses, code quality, deprecation notices — not trust boundaries.
- "No SCA/SAST tool configured" — hardening, unless the diff removed a configured gate (that removal is then a finding with the regression as evidence).
