#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$ROOT/fixture/release_selector.py" "$ROOT/workspace/src/release_selector.py"
echo "workspace: reset to buggy fixture"
