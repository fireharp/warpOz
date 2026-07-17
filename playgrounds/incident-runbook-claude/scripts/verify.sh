#!/bin/sh
set -eu

ROOT=$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)
STATE_DIR=${PLAYGROUND_STATE_DIR:-"$ROOT/run"}

python3 - "$ROOT" "$STATE_DIR" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
state = pathlib.Path(sys.argv[2])
workspace = state / "workspace"

expected = (root / "fixtures/expected-runbook.md").read_text()
actual = (workspace / "runbook.md").read_text()


def canonical_markdown(value):
    """Ignore list-marker choice and trailing whitespace, not source facts/order."""
    lines = []
    for line in value.replace("\r\n", "\n").splitlines():
        lines.append(re.sub(r"^(?:\d+\.|-)\s+", "- ", line.rstrip()))
    return "\n".join(lines).strip()


if canonical_markdown(actual) != canonical_markdown(expected):
    raise SystemExit("runbook.md does not match the canonical source-backed artifact")

source_names = ["incident.json", "observations.csv", "service-context.md"]
for name in source_names:
    if (workspace / name).read_bytes() != (root / "fixtures" / name).read_bytes():
        raise SystemExit(f"source file was modified: {name}")

entries = sorted(path.name for path in workspace.iterdir())
expected_entries = sorted(source_names + ["runbook.md"])
if entries != expected_entries:
    raise SystemExit(f"unexpected workspace entries: {entries!r}")

result = json.loads((state / "claude-result.json").read_text())
if result.get("is_error") is True:
    raise SystemExit("Claude reported an error")

print("PASS: runbook.md matches the canonical source-backed artifact")
print("PASS: all three source files are unchanged and no extras exist")
print("PASS: claude-result.json is valid JSON and reports no error")
PY
