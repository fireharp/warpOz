# Oz task: fix the Python release selector

You are the Codex agent already running inside Oz. Perform the task directly;
do not invoke `codex` and do not run `scripts/run.sh`.

1. From this scenario directory, run `./scripts/reset.sh` to prepare the known
   buggy workspace.
2. Run `./scripts/verify.sh` to reproduce the failing tests.
3. Inspect `workspace/src/release_selector.py` and the tests. Fix the production
   defect so release artifacts are selected by semantic numeric version order.
4. Preserve the public function signature and input behavior. Do not edit tests,
   fixture files, or scripts. Do not add dependencies or use the network.
5. Run `./scripts/verify.sh` again and finish only when all tests pass.

Report the changed source path and the passing test result.
