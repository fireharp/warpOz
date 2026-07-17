from __future__ import annotations

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


SPEC = importlib.util.spec_from_file_location(
    "verify", Path(__file__).with_name("verify.py")
)
assert SPEC and SPEC.loader
VERIFY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(VERIFY)


class VerifyTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tempdir = tempfile.TemporaryDirectory()
        self.root = Path(self.tempdir.name)
        self.source = self.root / "inventory.csv"
        self.output = self.root / "result.json"
        self.source.write_text(
            "name,quantity,unit_price_cents\n"
            "beta,2,30\n"
            "alpha,3,20\n",
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.tempdir.cleanup()

    def test_expected_report_is_sorted_and_totaled(self) -> None:
        report = VERIFY.expected_report(self.source)
        self.assertEqual(["alpha", "beta"], [item["name"] for item in report["items"]])
        self.assertEqual(2, report["item_count"])
        self.assertEqual(5, report["total_quantity"])
        self.assertEqual(120, report["total_value_cents"])

    def test_verify_accepts_expected_and_rejects_drift(self) -> None:
        report = VERIFY.expected_report(self.source)
        self.output.write_text(json.dumps(report), encoding="utf-8")
        VERIFY.verify(self.source, self.output)

        report["total_value_cents"] = 0
        self.output.write_text(json.dumps(report), encoding="utf-8")
        with self.assertRaises(AssertionError):
            VERIFY.verify(self.source, self.output)


if __name__ == "__main__":
    unittest.main()
