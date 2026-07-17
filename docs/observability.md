# Run artifacts and observability

Every live catalog invocation is observed by the root dispatcher:

```sh
./scripts/playground local inventory-report-codex
./scripts/playground oz inventory-report-codex --environment <id>
./scripts/playground reconcile <local-run-id-or-prefix>
./scripts/playground runs
./scripts/playground show <run-id-or-prefix>
```

The first two commands create `artifacts/runs/<run-id>/run.json`, capture the
combined console stream, and copy every file declared by the playground's
`artifact_paths`. The record includes UTC start/finish times, exact duration,
exit status, harness, execution location, checksums, and, when Oz returns them,
the provider run ID, state, and session link.

`oz` is asynchronous: a clean dispatcher exit records a hosted run as
`submitted` unless it already reports a terminal state. Reconcile it after Oz
has run the harness. `reconcile` asks only for the provider run metadata and
stores the terminal state, session link, timestamp, and a short status summary;
it does not store the provider's prompt or transcript. A failed remote run
causes `reconcile` to exit with status 1.

Raw run directories are local and gitignored because provider output can
contain repository context. `artifacts/evidence/` contains deliberately small,
committed milestone records: verification state, hashes, client versions, and
external blockers, but no credentials or raw prompts.

For a hosted run, use the Oz run ID from `run.json` with:

```sh
oz run get <run-id>
```

or let the dispatcher update its local record:

```sh
./scripts/playground reconcile <local-run-id-or-prefix>
```

This separates three layers cleanly:

- contract result: did the scenario verifier pass?
- harness result: did Claude or Codex complete its local/cloud process?
- control-plane result: did Oz schedule the job and expose a session/run ID?
