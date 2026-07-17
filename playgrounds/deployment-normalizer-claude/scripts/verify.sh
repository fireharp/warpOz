#!/bin/sh
set -eu

ROOT=$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)
STATE_DIR=${PLAYGROUND_STATE_DIR:-"$ROOT/run"}

python3 - "$ROOT" "$STATE_DIR" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
state = pathlib.Path(sys.argv[2])
workspace = state / "workspace"

expected = json.loads((root / "fixtures/expected-output.json").read_text())
actual = json.loads((workspace / "output.json").read_text())
if actual != expected:
    raise SystemExit(f"output mismatch\nexpected: {expected!r}\nactual:   {actual!r}")

fixture_input = (root / "fixtures/input.txt").read_text()
if (workspace / "input.txt").read_text() != fixture_input:
    raise SystemExit("input.txt was modified")

entries = sorted(path.name for path in workspace.iterdir())
if entries != ["input.txt", "output.json"]:
    raise SystemExit(f"unexpected workspace entries: {entries!r}")

result = json.loads((state / "claude-result.json").read_text())
if result.get("is_error") is True:
    raise SystemExit("Claude reported an error")

print("PASS: output.json matches the expected normalized result")
print("PASS: input.txt is unchanged and no extra workspace files exist")
print("PASS: claude-result.json is valid JSON and reports no error")
PY
