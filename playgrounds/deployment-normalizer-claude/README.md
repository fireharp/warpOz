# Deployment normalizer — Claude Code

This small scenario runs a deterministic repo-local task with Claude Code in
non-interactive mode. Claude reads `input.txt` and writes a normalized
`output.json`; the verifier checks the result exactly.

## Prerequisites

- Claude Code installed ([official setup](https://code.claude.com/docs/en/getting-started))
- Claude authentication already configured (`claude auth login`, then
  `claude auth status`)
- Python 3 for the local verifier

No application API keys or other playground secrets are required. The runner
uses the existing Claude Code authentication.

## Run

From this directory:

```sh
./scripts/run.sh
./scripts/verify.sh
```

The runner finds `claude` on `PATH`, then falls back to the native install path
`~/.local/bin/claude`. Runtime files go in the ignored `run/` directory.

Claude is invoked with:

- print mode and JSON output for automation;
- only the built-in `Read` and `Write` tools;
- safe mode, no Chrome, and strict empty MCP configuration;
- no session persistence;
- at most four agentic turns and a USD 0.25 budget cap.

These flags follow Anthropic's [CLI reference](https://code.claude.com/docs/en/cli-usage).
The task prompt also confines writes to `output.json` in the prepared workspace.

To use a particular binary or a separate state directory (for example in Oz):

```sh
CLAUDE_BIN=/path/to/claude PLAYGROUND_STATE_DIR=/tmp/claude-playground ./scripts/run.sh
PLAYGROUND_STATE_DIR=/tmp/claude-playground ./scripts/verify.sh
```

## Test without model access

```sh
./tests/test.sh
```

This substitutes a deterministic fake CLI, verifies the safety flags passed by
the runner, and runs the same output verifier. It makes no network requests.
