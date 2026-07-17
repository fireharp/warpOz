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

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Warp-hosted blockers

- The Warp-hosted smoke run reached the scheduler but was rejected before run
  creation because the team has no remaining add-on credits.
- No Oz environment exists yet because this repository has no GitHub remote for
  Oz to clone.
- `oz secret list` is empty; Codex and Claude cloud harnesses require managed
  OpenAI and Anthropic API-key secrets, respectively.
- Local GitHub CLI authentication for `fireharp` is expired, so a repository
  cannot currently be created/pushed through `gh`.

Self-hosted execution was intentionally not attempted; it remains a later task.
After restoring credits, GitHub access, and provider secrets, run the exact
commands in [`docs/oz.md`](oz.md) and capture the returned Oz run/session IDs.
