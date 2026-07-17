from __future__ import annotations

import json
import os
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class ScenarioContractTest(unittest.TestCase):
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

    def test_workspace_is_known_baseline_or_fixed(self) -> None:
        environment = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
        completed = subprocess.run(
            [str(ROOT / "scripts" / "verify.sh")],
            cwd=ROOT,
            env=environment,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        if completed.returncode == 0:
            return

        output = completed.stdout
        self.assertIn("test_selects_multi_digit_semantic_version", output)
        self.assertIn("Ran 4 tests", output)
        self.assertIn("FAILED (failures=1)", output)
        self.assertNotIn("ERROR", output)


if __name__ == "__main__":
    unittest.main()
