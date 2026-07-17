# Inventory report — Codex playground

This playground runs one deterministic, repo-local agent task with `codex exec`:
read a small inventory CSV, calculate a sorted JSON report, write it to
`workspace/result.json`, and verify the calculations independently.

## Prerequisites

- Codex CLI (`codex --version`)
- Python 3
- A Git checkout
- Either saved Codex authentication (`codex login`) or `CODEX_API_KEY` scoped to
  the single runner invocation

Do not commit API keys or Codex auth files.

## Run locally

From this directory:

```bash
./scripts/test.sh
./scripts/run.sh
```

The runner uses the current CLI authentication and writes:

- `workspace/result.json`: the task artifact
- `.run/events.jsonl`: machine-readable Codex events
- `.run/final.json`: the schema-constrained final agent message

Set `CODEX_BIN` to test another CLI executable or `CODEX_MODEL` to explicitly
select a model:

```bash
CODEX_BIN=/path/to/codex CODEX_MODEL=gpt-5.4 ./scripts/run.sh
```

## Safety and determinism

The invocation is non-interactive and explicit: `workspace-write` sandbox,
`approval_policy="never"`, web search disabled, user config ignored, and an
ephemeral session. The prompt forbids network use and limits edits to the one
result file. `tests/verify.py` derives the expected report from the CSV instead
of trusting the agent's final message.

For local execution, `./scripts/run.sh` starts Codex CLI. When Codex is already
running inside Oz, give it `oz-prompt.md` instead; that prompt performs the task
directly and does not recursively invoke Codex. Scenario metadata lives in
`playground.json`.

References:

- [Codex non-interactive mode](https://learn.chatgpt.com/docs/non-interactive-mode)
- [Codex sandbox and approvals](https://learn.chatgpt.com/docs/agent-approvals-security#common-sandbox-and-approval-combinations)
