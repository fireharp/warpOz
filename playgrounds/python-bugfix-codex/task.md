Fix the deterministic Python defect in this repository-local scenario.

1. Run `./scripts/verify.sh` to reproduce the failure.
2. Inspect `workspace/src/release_selector.py` and the tests.
3. Make the smallest production-code change that selects matching release
   artifacts by semantic numeric version order.
4. Preserve the public function signature and existing input behavior.
5. Modify only `workspace/src/release_selector.py`. Do not add dependencies or
   use the network.
6. Rerun `./scripts/verify.sh` and finish only when every test passes.
7. Return the schema-constrained completion object.
