# Python bugfix — Codex playground

This medium scenario asks Codex to reproduce a deterministic failing Python
test, diagnose a semantic-version ordering defect, make the smallest production
code fix, and rerun the full suite.

## Local Codex run

Prerequisites: Codex CLI, Python 3, a Git checkout, and either saved Codex login
or a `CODEX_API_KEY` scoped to the runner invocation. Never store credentials in
this directory.

```bash
./scripts/contract-test.sh
./scripts/run.sh
```

`scripts/run.sh` resets the buggy source fixture before invoking Codex. It uses
an ephemeral, non-interactive `workspace-write` sandbox with approvals and web
search disabled. Events and the final message are written beneath `.run/`.

The offline contract suite accepts the known single baseline failure or a fully
passing fixed workspace; any different failure is rejected. The strict success
check is `./scripts/verify.sh`.

## Oz run

When Codex is already running in Oz, give it `oz-prompt.md`. That prompt resets,
fixes, and tests the workspace directly without recursively invoking `codex`.
Scenario metadata is in `playground.json`.
