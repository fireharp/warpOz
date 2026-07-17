#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_BIN="${CODEX_BIN:-codex}"
RUN_DIR="$ROOT/.run"

command -v "$CODEX_BIN" >/dev/null 2>&1 || {
  echo "error: Codex CLI not found: $CODEX_BIN" >&2
  exit 127
}
command -v python3 >/dev/null 2>&1 || {
  echo "error: python3 is required" >&2
  exit 127
}
git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "error: run this playground from a Git checkout" >&2
  exit 2
}

if [[ -z "${CODEX_API_KEY:-}" ]]; then
  "$CODEX_BIN" login status >/dev/null
fi

mkdir -p "$RUN_DIR"
rm -f "$ROOT/workspace/result.json" "$RUN_DIR/events.jsonl" "$RUN_DIR/final.json"

args=(
  exec
  --cd "$ROOT"
  --ephemeral
  --ignore-user-config
  --strict-config
  --sandbox workspace-write
  --config 'approval_policy="never"'
  --config 'web_search="disabled"'
  --config 'allow_login_shell=false'
  --disable multi_agent
  --output-schema "$ROOT/schema/final.schema.json"
  --output-last-message "$RUN_DIR/final.json"
  --json
  -
)

if [[ -n "${CODEX_MODEL:-}" ]]; then
  args=(exec --model "$CODEX_MODEL" "${args[@]:1}")
fi

"$CODEX_BIN" "${args[@]}" < "$ROOT/task.md" | tee "$RUN_DIR/events.jsonl"
python3 "$ROOT/tests/verify.py"

echo "verified: workspace/result.json"
