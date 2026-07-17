# Verification snapshot — 2026-07-17

## Passed

- Catalog: four task-named manifests validated.
- Offline contracts: all four playground suites passed without model/network
  access.
- Local Codex `0.144.0-alpha.4`: `inventory-report-codex` and
  `python-bugfix-codex` both completed and passed independent verifiers.
- Local Claude Code `2.1.209`: `deployment-normalizer-claude` and
  `incident-runbook-claude` both completed and passed independent verifiers.
- Warp API through OneCLI: authenticated `GET /api/v1/agent/runs?limit=1`
  returned HTTP 200 with `runs` and `page_info`.
- Run ledger: captures duration, status, logs, checksums, and output copies;
  `runs`/`show` were exercised against live Claude runs.
- Publication: the complete playground catalog and environment-auth support are
  pushed to `master` on `fireharp/warpOz`. Environment setup explicitly checks
  out `master` after cloning.
- Oz personal environment `JkiAkbyrmUncRAsFpYk9Np` was created from that
  repository using `warpdotdev/dev-base:latest-agents`. Its server-side setup
  switches to `master` and validates the four manifests.

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Warp-hosted blockers

- GitHub is connected to the authenticated Oz account and the personal
  environment exists. There are no managed secrets; both provider dispatches
  deliberately used environment authentication and did not read key values.
- The hosted Claude `deployment-normalizer-claude` and Codex
  `inventory-report-codex` dispatches each reached the scheduler but were
  rejected before run creation because the team has no remaining add-on credits.
  `oz run list` is empty, so no provider run ID, session link, or harness output
  exists to verify yet. See
  [`2026-07-17-warp-environment-hosted-blocked.json`](../artifacts/evidence/2026-07-17-warp-environment-hosted-blocked.json).

Self-hosted execution was intentionally not attempted; it remains a later task.
After restoring credits, GitHub access, and provider secrets, run the exact
commands in [`docs/oz.md`](oz.md) and capture the returned Oz run/session IDs.
