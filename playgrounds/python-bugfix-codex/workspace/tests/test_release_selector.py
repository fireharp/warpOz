from __future__ import annotations

import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from release_selector import select_latest_artifact


class ReleaseSelectorTest(unittest.TestCase):
    def test_selects_multi_digit_semantic_version(self) -> None:
        artifacts = [
            "api-1.9.0.tar.gz",
            "api-1.10.0.tar.gz",
            "api-1.2.12.tar.gz",
        ]
        self.assertEqual("api-1.10.0.tar.gz", select_latest_artifact(artifacts, "api"))

    def test_ignores_other_services_and_unrelated_files(self) -> None:
        artifacts = [
            "worker-9.0.0.tar.gz",
            "api-latest.tar.gz",
            "notes.txt",
            "api-2.1.0.tar.gz",
        ]
        self.assertEqual("api-2.1.0.tar.gz", select_latest_artifact(artifacts, "api"))

    def test_accepts_a_generator(self) -> None:
        artifacts = (name for name in ["api-2.0.0.tar.gz", "api-3.0.0.tar.gz"])
        self.assertEqual("api-3.0.0.tar.gz", select_latest_artifact(artifacts, "api"))

    def test_raises_when_no_matching_artifact_exists(self) -> None:
        with self.assertRaisesRegex(ValueError, "no release artifact"):
            select_latest_artifact(["worker-1.0.0.tar.gz"], "api")


if __name__ == "__main__":
    unittest.main()
