from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class ManifestTest(unittest.TestCase):
    def test_manifest_contract(self) -> None:
        manifest = json.loads((ROOT / "playground.json").read_text(encoding="utf-8"))
        self.assertEqual(
            {
                "name",
                "task",
                "harness",
                "runtime_class",
                "estimated_minutes",
                "local_command",
                "contract_test_command",
                "cloud_prompt_file",
                "artifact_paths",
            },
            set(manifest),
        )
        self.assertEqual(ROOT.name, manifest["name"])
        self.assertEqual("codex", manifest["harness"])
        self.assertEqual(["./scripts/run.sh"], manifest["local_command"])
        self.assertEqual(
            ["./scripts/contract-test.sh"], manifest["contract_test_command"]
        )
        self.assertTrue((ROOT / manifest["cloud_prompt_file"]).is_file())
        self.assertIn("workspace/result.json", manifest["artifact_paths"])


if __name__ == "__main__":
    unittest.main()
