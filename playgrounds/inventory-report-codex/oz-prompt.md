# Oz task: generate the inventory report

You are the Codex agent already running inside Oz. Perform this task directly;
do not invoke `codex` and do not run `scripts/run.sh`.

Work from this scenario directory:

1. Read `workspace/inventory.csv`.
2. Create or replace only `workspace/result.json`.
3. Sort rows by `name` ascending.
4. Emit item keys `name`, `quantity`, `unit_price_cents`, and
   `subtotal_cents`, where subtotal is quantity multiplied by unit price.
5. Emit top-level keys `items`, `item_count`, `total_quantity`, and
   `total_value_cents`; all numeric values must be JSON integers.
6. Use two-space JSON indentation and a final newline.
7. Do not use the network or modify any other file.
8. Run `python3 tests/verify.py`. If it fails, correct only the result and rerun
   verification.

Finish only after verification passes and report the artifact path.
