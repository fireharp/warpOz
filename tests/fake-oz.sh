#!/bin/sh
set -eu

if [ "$1" = "run" ] && [ "$2" = "get" ]; then
  if [ "$3" = "run-test-failed" ]; then
    printf '%s\n' '{"run_id":"run-test-failed","state":"FAILED","status_message":{"message":"platform bootstrap failed"}}'
    exit 0
  fi
  printf '%s\n' '{"run_id":"run-test-123","state":"SUCCEEDED","session_link":"https://oz.warp.dev/runs/run-test-123","updated_at":"2026-07-17T16:30:00Z","status_message":{"message":"contract passed"}}'
  exit 0
fi

printf '%s\n' 'Spawned ambient agent with run ID: run-test-123'
printf '%s\n' 'Agent state: InProgress'
printf '%s\n' 'View agent session: https://oz.warp.dev/runs/run-test-123'
