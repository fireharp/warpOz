# Runtime run ledger

`scripts/playground local` and `scripts/playground oz` create one timestamped
directory here per invocation. Generated run directories are intentionally
gitignored because their console logs may contain repository context.

Each run contains:

- `run.json`: status, exact duration, harness, execution location, redacted
  command, captured-artifact checksums, and Oz run/session identifiers when
  available;
- `console.log`: combined process output;
- `outputs/`: copies of the scenario's declared `artifact_paths`.

Use `./scripts/playground runs` and `./scripts/playground show <run-id>` rather
than browsing directories manually.
