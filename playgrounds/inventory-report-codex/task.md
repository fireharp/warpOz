Complete this deterministic repository-local task.

1. Read `workspace/inventory.csv`.
2. Create or replace only `workspace/result.json`.
3. Sort rows by `name` in ascending bytewise order.
4. For each row, emit an object with keys in this order: `name`, `quantity`,
   `unit_price_cents`, `subtotal_cents`. The subtotal is quantity multiplied by
   unit price.
5. Emit top-level keys in this order: `items`, `item_count`, `total_quantity`,
   `total_value_cents`. All numeric values must be JSON integers.
6. Format the file as UTF-8 JSON with two-space indentation and a final newline.
7. Do not use the network and do not modify any other file.
8. Run `python3 tests/verify.py` from the playground root. If it fails, correct
   only `workspace/result.json` and rerun it.
9. Return the schema-constrained completion object after verification passes.
