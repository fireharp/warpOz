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

1. Commit and push this repository to GitHub. Oz environments clone GitHub's
   default branch; `owner/repo` is therefore required, and this repository's
   default branch must be `master`.
2. Register the personal environment:

   ```sh
   ./scripts/playground oz-create --repo owner/repo
   ```

   This uses Warp's public `warpdotdev/dev-base:latest-agents` image. No setup
   command is used because Oz executes setup in a shell without a stable
   repository-relative working directory; each task prompt verifies its own
   artifact after the harness starts.
3. Create provider-specific typed managed secrets. The CLI reads each value
   securely from standard input:

   ```sh
   oz secret create claude api-key --personal anthropic-api-test
   oz secret create codex api-key --personal openai-api-test
   oz secret list
   ```

   Warp control-plane authentication and provider harness authentication are
   separate. Local Claude/Codex CLI login, Claude subscriptions, ChatGPT
   subscriptions, and desktop BYOK do not transfer into Oz. Cloud third-party
   harnesses require the matching Anthropic/OpenAI API credential stored in Oz.

## Dispatch and observe

```sh
export OZ_ENVIRONMENT_ID=<environment-id>
export OZ_CLAUDE_AUTH_SECRET=anthropic-api-test
export OZ_CODEX_AUTH_SECRET=openai-api-test
./scripts/playground oz deployment-normalizer-claude
./scripts/playground oz python-bugfix-codex

oz run list --name python-bugfix-codex
oz run get <run-id>
```

The dispatcher also records the redacted command, duration, result, captured
outputs, and returned Oz identifiers. Inspect them with
`./scripts/playground runs` and `./scripts/playground show <local-run-id>`.

Override the default secret names with `OZ_CLAUDE_AUTH_SECRET` or
`OZ_CODEX_AUTH_SECRET`. `--dry-run` validates command construction without
dispatching or printing secret values. Use `*-test` names for temporary
personal credentials and separate production names/scope when promoting a
playground.

There is no separate environment manifest upload or publish command in the
current CLI. `oz environment create` registers the server-side environment;
`oz agent run-cloud` then dispatches named tasks into it. See the official
[environment guide](https://docs.warp.dev/platform/environments/),
[harness authentication](https://docs.warp.dev/platform/harnesses/authentication/),
and [Oz CLI reference](https://docs.warp.dev/reference/cli).
