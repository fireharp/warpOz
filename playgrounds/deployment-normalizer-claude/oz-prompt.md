# Deployment normalizer task

You are already running as the Oz-managed Claude harness. Perform this task
directly with your file tools. Do not invoke `claude`, `scripts/run.sh`, or any
other agent harness.

Work only inside `playgrounds/deployment-normalizer-claude/`:

1. Read `fixtures/input.txt` and `prompt.txt`.
2. Create `run/workspace/` if needed and copy the fixture to
   `run/workspace/input.txt` without changing it.
3. Produce `run/workspace/output.json` according to `prompt.txt`.
4. Confirm the artifact is valid JSON and semantically matches
   `fixtures/expected-output.json`.
5. Do not create or change files outside `run/`.

Report the artifact path and the verification result.

