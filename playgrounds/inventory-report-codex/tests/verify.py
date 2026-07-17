#!/usr/bin/env python3
"""Verify the Codex playground artifact against the source CSV."""

from __future__ import annotations

import csv
import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = ROOT / "workspace" / "inventory.csv"
DEFAULT_OUTPUT = ROOT / "workspace" / "result.json"


def expected_report(input_path: Path) -> dict[str, Any]:
    with input_path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))

    items = []
    for row in sorted(rows, key=lambda value: value["name"]):
        quantity = int(row["quantity"])
        unit_price = int(row["unit_price_cents"])
        items.append(
            {
                "name": row["name"],
                "quantity": quantity,
                "unit_price_cents": unit_price,
                "subtotal_cents": quantity * unit_price,
            }
        )

    return {
        "items": items,
        "item_count": len(items),
        "total_quantity": sum(item["quantity"] for item in items),
        "total_value_cents": sum(item["subtotal_cents"] for item in items),
    }


def verify(input_path: Path, output_path: Path) -> None:
    with output_path.open(encoding="utf-8") as handle:
        actual = json.load(handle)
    expected = expected_report(input_path)
    if actual != expected:
        raise AssertionError(
            "result mismatch\n"
            f"expected: {json.dumps(expected, sort_keys=True)}\n"
            f"actual:   {json.dumps(actual, sort_keys=True)}"
        )


def main(argv: list[str]) -> int:
    input_path = Path(argv[1]) if len(argv) > 1 else DEFAULT_INPUT
    output_path = Path(argv[2]) if len(argv) > 2 else DEFAULT_OUTPUT
    try:
        verify(input_path, output_path)
    except (OSError, ValueError, AssertionError) as error:
        print(f"verification failed: {error}", file=sys.stderr)
        return 1
    print("verification passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
