# Incident runbook task

You are already running as the Oz-managed Claude harness. Perform the synthesis
directly with your file tools. Do not invoke `claude`, `scripts/run.sh`, or any
other agent harness.

Work only inside `playgrounds/incident-runbook-claude/`:

1. Read `prompt.txt` and all source files in `fixtures/` except the expected
   artifact.
2. Create `run/workspace/` if needed and copy `incident.json`,
   `observations.csv`, and `service-context.md` into it unchanged.
3. Create `run/workspace/runbook.md` by following `prompt.txt` exactly.
   Keep the four Immediate response actions as a numbered list in source order.
4. Confirm it matches `fixtures/expected-runbook.md` and that no source fact was
   changed or invented.
5. Do not create or change files outside `run/`.

Report the artifact path and verification result.
