#!/bin/sh
set -eu

ROOT=$(unset CDPATH; cd -- "$(dirname -- "$0")/.." && pwd)

command -v python3 >/dev/null 2>&1 || {
  echo "error: python3 is required" >&2
  exit 1
}

python3 "$ROOT/scripts/playground" check --manifest-only

for tool in codex claude oz; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "found: $tool ($(command -v "$tool"))"
  else
    echo "optional local CLI not on PATH: $tool"
  fi
done

if [ -x /Applications/Warp.app/Contents/Resources/bin/oz ]; then
  echo "found: bundled Oz CLI (/Applications/Warp.app/Contents/Resources/bin/oz)"
fi
