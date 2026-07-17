#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT"/scripts/*.sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover \
  -s "$ROOT/tests" -p 'test_*.py' -v

echo "contract: passed"
