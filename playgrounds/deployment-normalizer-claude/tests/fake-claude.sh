#!/bin/sh
set -eu

if [ "${1:-}" = "--version" ]; then
  echo "0.0.0-test (Claude Code fake)"
  exit 0
fi

: "${FAKE_CLAUDE_ARGS_FILE:?FAKE_CLAUDE_ARGS_FILE is required}"
printf '%s\n' "$@" > "$FAKE_CLAUDE_ARGS_FILE"

cat >/dev/null
cp "${FAKE_EXPECTED_OUTPUT:?FAKE_EXPECTED_OUTPUT is required}" output.json
printf '%s\n' '{"type":"result","subtype":"success","is_error":false,"result":"output.json is complete"}'

