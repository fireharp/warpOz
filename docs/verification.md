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
- Publication: the complete playground catalog and managed-secret dispatcher
  are pushed to `master` on `fireharp/warpOz`, which is GitHub's default branch.
- Oz personal environment `JkiAkbyrmUncRAsFpYk9Np` was created from that
  repository using `warpdotdev/dev-base:latest-agents`, with no setup commands.
- Warp-hosted Claude: `deployment-normalizer-claude` completed successfully in
  provider run `019f70cc-49aa-7639-a4c2-57c81938f474`. Its Oz status confirms
  the expected JSON artifact passed semantic verification and no files outside
  the scenario `run/` directory changed.

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Warp-hosted blockers

- GitHub is connected to the authenticated Oz account and the personal
  environment has matching typed managed credentials for the Claude and Codex
  harnesses. The provider values were never read by this repository or its
  evidence tools.
- Warp-hosted Codex is currently blocked in the provider platform bootstrap,
  not authentication, repository setup, or model tier. Three independent
  `inventory-report-codex` attempts, `019f70cd-2bfa-791e-8287-a84f483a1657`
  `019f70ce-58a4-7697-bf01-652df47467ad`, and
  `019f70dc-27e2-77a8-a45e-4a4423c6de61`, failed with
  `environment_setup_failed` while installing Warp's required
  `orchestration@codex-warp` plugin. The final attempt explicitly requested
  `gpt-5-2-codex-low`; the identical failure occurs before the model runs. The
  environment has no setup commands, so this is not caused by a
  repository-relative setup script.

See [`2026-07-17-warp-hosted-execution.json`](../artifacts/evidence/2026-07-17-warp-hosted-execution.json)
for the safe, current hosted evidence. Historical credit/setup blockers remain
in the evidence directory for chronology.

Self-hosted execution was intentionally not attempted; it remains a later task.
Use [`docs/oz.md`](oz.md) and `scripts/playground reconcile` for future retries.
