#!/bin/sh
set -eu

API_URL=${WARP_API_URL:-"https://app.warp.dev/api/v1/agent/runs?limit=1"}
BODY=$(mktemp "${TMPDIR:-/tmp}/warpoz-api.XXXXXX")
trap 'rm -f "$BODY"' EXIT HUP INT TERM

if [ -n "${WARP_API_KEY:-}" ]; then
  STATUS=$(curl --silent --show-error --max-time 20 \
    --header "Authorization: Bearer $WARP_API_KEY" \
    --output "$BODY" --write-out '%{http_code}' "$API_URL")
elif [ -f "$HOME/.onecli/env.sh" ]; then
  # OneCLI injects the Authorization header at its HTTPS proxy boundary.
  # shellcheck disable=SC1091
  . "$HOME/.onecli/env.sh"
  STATUS=$(curl --silent --show-error --max-time 20 \
    --output "$BODY" --write-out '%{http_code}' "$API_URL")
else
  echo "error: set WARP_API_KEY or configure the OneCLI Warp connection" >&2
  exit 2
fi

python3 - "$STATUS" "$BODY" <<'PY'
import json
import pathlib
import sys

status = sys.argv[1]
path = pathlib.Path(sys.argv[2])
try:
    data = json.loads(path.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as error:
    raise SystemExit(f"Warp API returned HTTP {status} with invalid JSON: {error}")

if status != "200":
    error = data.get("error", data)
    for key in ("connect_url", "claim_url", "blocked_by_policy", "retry_after_secs"):
        if key in error:
            print(f"{key}: {error[key]}", file=sys.stderr)
    message = error.get("message") or error.get("code") or "request failed"
    raise SystemExit(f"Warp API returned HTTP {status}: {message}")

if not isinstance(data.get("runs"), list) or "page_info" not in data:
    raise SystemExit("Warp API response is missing runs/page_info")
print(f"PASS: Warp API reachable and authenticated (HTTP 200, {len(data['runs'])} runs returned)")
PY
