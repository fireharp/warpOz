# Warp Oz developer playgrounds

This repository models a developer moving repeatable agent work from a personal
Codex or Claude setup into an Oz-managed herd. Playgrounds are named for the
job first and the harness second, so the catalog describes work rather than a
vendor directory.

## Playground catalog

| Playground | Harness | Runtime class | Goal |
| --- | --- | --- | --- |
| `inventory-report-codex` | Codex | small | Convert inventory CSV into a verified report. |
| `deployment-normalizer-claude` | Claude | small | Normalize deployment inputs into verified JSON. |
| `python-bugfix-codex` | Codex | medium | Diagnose and repair a small Python defect from tests. |
| `incident-runbook-claude` | Claude | medium | Turn incident evidence into a checked runbook. |

The manifest in each directory records its task, harness, expected duration,
local command, contract test, and Oz prompt. List the live catalog with:

```sh
make list
make test
```

Run one scenario with the developer's existing CLI authentication:

```sh
make local PLAYGROUND=inventory-report-codex
```

## Promote the same task to Oz

Oz cloud runs use the same repository and task artifacts, but select a managed
Claude or Codex harness. Register one shared environment after the repository
has a GitHub remote with `master` as its default branch:

```sh
make oz-create OZ_REPO=owner/repo
export OZ_ENVIRONMENT_ID=<environment-id>
make oz-run PLAYGROUND=inventory-report-codex
```

Provider credentials stay in Oz, never in this repository: use authentication
already configured for the environment (`OZ_ENVIRONMENT_AUTH=1`) or a managed
secret. See [docs/oz.md](docs/oz.md) for the one-time setup and the
local-versus-cloud parity boundary.

## Control-plane check

`make api-check` makes an authenticated, read-only request to the Warp runs API.
It uses `WARP_API_KEY` when set, otherwise it sources the OneCLI gateway loader
and lets OneCLI inject the header. The script reports only HTTP/schema status.

## Run observability

Live local and Oz invocations write a gitignored run ledger with exact duration,
status, console output, output copies, checksums, and Oz identifiers:

```sh
./scripts/playground runs
./scripts/playground show <run-id>
```

Safe milestone summaries are committed under `artifacts/evidence/`. See
[docs/observability.md](docs/observability.md) for the record boundary.
The latest local/hosted outcomes and external blockers are in
[docs/verification.md](docs/verification.md).

Current interfaces are based on the official [Oz CLI reference](https://docs.warp.dev/reference/cli),
[harness guide](https://docs.warp.dev/platform/harnesses/), and
[API reference](https://docs.warp.dev/reference/api-and-sdk/).
