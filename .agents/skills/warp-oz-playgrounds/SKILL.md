---
name: warp-oz-playgrounds
description: Use when listing, running, validating, publishing, or troubleshooting task-named Claude and Codex playgrounds in this repository or Warp Oz.
---

# Warp Oz playground workflow

1. Run `./scripts/playground list` and select the scenario by task name, not just
   by provider.
2. Validate offline with `./scripts/playground verify <name>`.
3. For a personal local run, use `./scripts/playground local <name>`. Preserve
   the scenario's sandbox, tool, budget, and output restrictions.
4. For Oz, verify `OZ_ENVIRONMENT_ID` and use authentication already configured
   in the environment (`--environment-auth` or `OZ_ENVIRONMENT_AUTH=1`); fall
   back to the matching managed secret name when environment auth is absent.
   Do not invoke `codex` or `claude` recursively inside Oz: `--harness` already
   starts the selected provider.
5. Inspect the returned run with `oz run get <run-id>` and report its state,
   session link, verifier result, and any blocker.
6. Inspect local evidence with `./scripts/playground runs` and
   `./scripts/playground show <run-id>`. Raw logs remain gitignored; only commit
   sanitized records under `artifacts/evidence/`.
7. Use `./scripts/check-warp-api.sh` for a read-only control-plane check. Never
   print API keys, managed-secret values, provider auth files, or run content.
8. Refresh `docs/verification.md` after live local or hosted checks. Keep
   self-hosted work explicitly deferred unless the user brings it into scope.

Environment registration is server-side via `./scripts/playground oz-create`;
there is no separate publish artifact. Oz clones GitHub's default branch, which
must be `master` for this repository. If no GitHub remote exists, stop before
environment creation and report that Oz has no repository to clone.
