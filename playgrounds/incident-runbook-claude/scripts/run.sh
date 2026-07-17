#!/bin/sh
set -eu

ROOT=$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)
STATE_DIR=${PLAYGROUND_STATE_DIR:-"$ROOT/run"}
WORK_DIR="$STATE_DIR/workspace"
RESULT_FILE="$STATE_DIR/claude-result.json"

if [ -n "${CLAUDE_BIN:-}" ]; then
  :
elif command -v claude >/dev/null 2>&1; then
  CLAUDE_BIN=$(command -v claude)
elif [ -x "$HOME/.local/bin/claude" ]; then
  CLAUDE_BIN="$HOME/.local/bin/claude"
else
  echo "Claude Code was not found. Install it or set CLAUDE_BIN." >&2
  exit 2
fi

mkdir -p "$WORK_DIR"
cp "$ROOT/fixtures/incident.json" "$WORK_DIR/incident.json"
cp "$ROOT/fixtures/observations.csv" "$WORK_DIR/observations.csv"
cp "$ROOT/fixtures/service-context.md" "$WORK_DIR/service-context.md"
rm -f "$WORK_DIR/runbook.md" "$RESULT_FILE"

echo "Using $("$CLAUDE_BIN" --version)"
echo "Running incident synthesis in $WORK_DIR"

if (
  cd "$WORK_DIR"
  "$CLAUDE_BIN" \
    --print \
    --output-format json \
    --safe-mode \
    --no-chrome \
    --disable-slash-commands \
    --strict-mcp-config \
    --mcp-config '{"mcpServers":{}}' \
    --tools Read,Write \
    --allowedTools Read,Write \
    --permission-mode dontAsk \
    --no-session-persistence \
    --max-turns 6 \
    --max-budget-usd 0.50 \
    < "$ROOT/prompt.txt" \
    > "$RESULT_FILE"
); then
  :
else
  claude_status=$?
  if grep -F 'Not logged in' "$RESULT_FILE" >/dev/null 2>&1; then
    echo "Claude Code is not authenticated. Run: $CLAUDE_BIN auth login" >&2
  fi
  echo "Claude failed; result metadata: $RESULT_FILE" >&2
  exit "$claude_status"
fi

echo "Claude finished; transcript metadata: $RESULT_FILE"
PLAYGROUND_STATE_DIR="$STATE_DIR" "$ROOT/scripts/verify.sh"

