#!/bin/sh
set -eu

ROOT=$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/incident-runbook-claude.XXXXXX")
trap 'rm -rf "$TMP_ROOT"' EXIT HUP INT TERM

export CLAUDE_BIN="$ROOT/tests/fake-claude.sh"
export PLAYGROUND_STATE_DIR="$TMP_ROOT/state"
export FAKE_CLAUDE_ARGS_FILE="$TMP_ROOT/args.txt"
export FAKE_EXPECTED_RUNBOOK="$ROOT/fixtures/expected-runbook.md"

"$ROOT/scripts/run.sh"

args=$(cat "$FAKE_CLAUDE_ARGS_FILE")
for required in \
  --print \
  --safe-mode \
  --no-chrome \
  --disable-slash-commands \
  --strict-mcp-config \
  --no-session-persistence
do
  printf '%s\n' "$args" | grep -Fx -- "$required" >/dev/null
done

for required_pair in \
  "--output-format json" \
  "--mcp-config {\"mcpServers\":{}}" \
  "--tools Read,Write" \
  "--allowedTools Read,Write" \
  "--permission-mode dontAsk" \
  "--max-turns 6" \
  "--max-budget-usd 0.50"
do
  flag=${required_pair% *}
  value=${required_pair##* }
  awk -v flag="$flag" -v value="$value" '
    previous == flag && $0 == value { found = 1 }
    { previous = $0 }
    END { exit(found ? 0 : 1) }
  ' "$FAKE_CLAUDE_ARGS_FILE"
done

echo "PASS: incident runner supplied the expected safety contract"

