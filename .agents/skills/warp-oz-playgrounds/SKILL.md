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
4. For Oz, verify `OZ_ENVIRONMENT_ID` and the matching managed secret name, then
   run `./scripts/playground oz <name>`. Do not invoke `codex` or `claude`
   recursively inside Oz: `--harness` already starts the selected provider.
5. Inspect the returned run with `oz run get <run-id>` and report its state,
   session link, verifier result, and any blocker.
6. Use `./scripts/check-warp-api.sh` for a read-only control-plane check. Never
   print API keys, managed-secret values, provider auth files, or run content.

Environment registration is server-side via `./scripts/playground oz-create`;
there is no separate publish artifact. If no GitHub remote exists, stop before
environment creation and report that Oz has no repository to clone.
