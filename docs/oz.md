# Moving a personal playground into Oz

## What stays the same

The repository is the parity layer: task inputs, prompts, contract tests, and
verification commands are identical locally and in Oz. Locally, developers run
their native `codex` or `claude` CLI. In the cloud, Oz starts that provider as
the selected harness inside one shared environment.

Oz does not currently reproduce its cloud environment locally. The official
[environment documentation](https://docs.warp.dev/platform/environments/)
describes local hosting as coming soon, so parity is contractual rather than a
byte-identical runtime.

## One-time setup

1. Commit and push this repository to GitHub. Oz environments clone GitHub
   repositories; `owner/repo` is therefore required.
2. Register the personal environment:

   ```sh
   ./scripts/playground oz-create --repo owner/repo
   ```

   This uses Warp's public `warpdotdev/dev-base:latest-agents` image, which
   contains Claude Code and Codex, then validates all playground manifests.
3. Create provider-specific managed secrets. The CLI reads each value securely
   from standard input:

   ```sh
   oz secret create claude api-key --personal anthropic-api
   oz secret create codex api-key --personal openai-api
   oz secret list
   ```

   Warp control-plane authentication and provider harness authentication are
   separate. Local Claude subscriptions and ChatGPT login state do not transfer
   into Oz; cloud harnesses require provider API credentials.

## Dispatch and observe

```sh
export OZ_ENVIRONMENT_ID=<environment-id>
./scripts/playground oz deployment-normalizer-claude
./scripts/playground oz python-bugfix-codex

oz run list --name python-bugfix-codex
oz run get <run-id>
```

Override the default secret names with `OZ_CLAUDE_AUTH_SECRET` or
`OZ_CODEX_AUTH_SECRET`. `--dry-run` validates command construction without
dispatching or printing secret values.

There is no separate environment manifest upload or publish command in the
current CLI. `oz environment create` registers the server-side environment;
`oz agent run-cloud` then dispatches named tasks into it. See the official
[environment guide](https://docs.warp.dev/platform/environments/),
[harness authentication](https://docs.warp.dev/platform/harnesses/authentication/),
and [Oz CLI reference](https://docs.warp.dev/reference/cli).
