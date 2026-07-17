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

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Warp-hosted blockers

- The Warp-hosted smoke run reached the scheduler but was rejected before run
  creation because the team has no remaining add-on credits.
- No Oz environment exists yet. The initial registration triggered a GitHub
  connection for `demo.alex@gmail.com`, while the Warp app is signed in as
  `alex@fireharp.com`; the accounts must be aligned before Oz can clone.
- The CLI account has no managed secrets. Environment authentication is now a
  supported alternative; when selected in Oz it is dispatched with
  `OZ_ENVIRONMENT_AUTH=1` and does not expose key values.

Self-hosted execution was intentionally not attempted; it remains a later task.
After restoring credits, GitHub access, and provider secrets, run the exact
commands in [`docs/oz.md`](oz.md) and capture the returned Oz run/session IDs.
