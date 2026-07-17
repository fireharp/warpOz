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
- Canonical Oz personal environment `pnhqL0eT4VPpCfAr7BizuN`
  (`warpoz-playgrounds`) uses `warpdotdev/dev-base:latest`, repository
  `fireharp/warpOz`, `master`, and no setup commands.
- Warp-hosted Codex: `inventory-report-codex` completed in provider run
  `019f70e0-a289-733b-af01-a2cd12267b45` using `gpt-5-2-codex-low`; its
  independent `python3 tests/verify.py` passed.
- Warp-hosted Claude: `deployment-normalizer-claude` completed in provider run
  `019f70e2-5e9b-7246-be57-1eec3f6046d7` using `claude-4-5-haiku`; its output
  semantically matched the expected JSON without changing files outside `run/`.

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Resolved hosted-image issue

- GitHub is connected to the authenticated Oz account and the personal
  environment has matching typed managed credentials for the Claude and Codex
  harnesses. The provider values were never read by this repository or its
  evidence tools.
- The former `warpoz-playgrounds-agents-legacy` environment used
  `warpdotdev/dev-base:latest-agents`. Three `inventory-report-codex` attempts
  there—`019f70cd-2bfa-791e-8287-a84f483a1657`,
  `019f70ce-58a4-7697-bf01-652df47467ad`, and
  `019f70dc-27e2-77a8-a45e-4a4423c6de61`, failed with
  `environment_setup_failed` while installing Warp's required
  `orchestration@codex-warp` plugin. The final legacy attempt explicitly
  requested `gpt-5-2-codex-low`, so the error occurred before model execution.
  The plain `dev-base:latest` image resolved that bootstrap issue for both
  harnesses without setup commands.

See [`2026-07-17-warp-hosted-execution.json`](../artifacts/evidence/2026-07-17-warp-hosted-execution.json)
for the safe, current hosted evidence. Historical credit/setup blockers remain
in the evidence directory for chronology.

Self-hosted execution was intentionally not attempted; it remains a later task.
Use [`docs/oz.md`](oz.md) and `scripts/playground reconcile` for future retries.
