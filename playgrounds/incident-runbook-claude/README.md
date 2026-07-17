# Incident runbook — Claude Code

This medium scenario asks Claude Code to synthesize an operator-ready incident
runbook from three independent fixture sources: incident metadata, observed
signals, and approved service procedures.

## Prerequisites

- Claude Code installed ([official setup](https://code.claude.com/docs/en/getting-started))
- Claude authentication configured (`claude auth login`, then
  `claude auth status`)
- Python 3 for verification

No scenario-specific keys or secrets are required.

## Run locally

From this directory:

```sh
./scripts/run.sh
./scripts/verify.sh
```

The ignored `run/` directory receives fresh copies of the sources, the generated
`runbook.md`, and Claude's JSON result metadata. Claude is limited to `Read` and
`Write`, safe mode, a strict empty MCP configuration, six turns, and a USD 0.50
budget cap. The verifier requires the canonical runbook, unchanged source files,
no extra workspace files, and a successful result envelope.

Use `CLAUDE_BIN` to select a binary and `PLAYGROUND_STATE_DIR` to redirect all
runtime files.

## Offline contract test

```sh
./tests/test.sh
```

The test uses an isolated fake Claude CLI, checks every safety flag, and runs the
scenario's independent verifier without model access or network requests.

CLI behavior follows Anthropic's [CLI reference](https://code.claude.com/docs/en/cli-usage).

