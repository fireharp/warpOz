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
  repository using `warpdotdev/dev-base:latest-agents`.

Safe summaries are under [`artifacts/evidence/`](../artifacts/evidence/).

## Warp-hosted blockers

- GitHub is connected to the authenticated Oz account and the personal
  environment exists. There are no managed secrets. Cloud Claude Code and
  Codex require typed Warp-managed Anthropic/OpenAI credentials; local CLI
  sessions and subscriptions cannot be reused in Oz.
- The hosted Claude `deployment-normalizer-claude` and Codex
  `inventory-report-codex` dispatches initially failed at environment setup: an
  obsolete `git switch master` command ran outside a Git worktree. The command
  was removed because GitHub's default branch is already `master`. A second
  retry showed that Oz setup commands have no stable repository-relative
  working directory, so the manifest-check setup command is removed too. The
  runs can be retried after their corresponding auth secrets are added. See
  [`2026-07-17-warp-environment-hosted-blocked.json`](../artifacts/evidence/2026-07-17-warp-environment-hosted-blocked.json).

Self-hosted execution was intentionally not attempted; it remains a later task.
The live retries use the exact commands in [`docs/oz.md`](oz.md); capture their
returned Oz run/session IDs and verifier results as safe evidence.
