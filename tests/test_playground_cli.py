from __future__ import annotations

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CLI = ROOT / "scripts" / "playground"
FAKE_OZ = ROOT / "tests" / "fake-oz.sh"


class PlaygroundCliTest(unittest.TestCase):
    def test_oz_run_is_observed_and_redacted(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            environment = dict(
                os.environ,
                OZ_BIN=str(FAKE_OZ),
                PLAYGROUND_RUNS_DIR=temporary,
            )
            completed = subprocess.run(
                [
                    str(CLI),
                    "oz",
                    "inventory-report-codex",
                    "--environment",
                    "env-test",
                ],
                cwd=ROOT,
                env=environment,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stdout)

            records = list(Path(temporary).glob("*/run.json"))
            self.assertEqual(1, len(records))
            record = json.loads(records[0].read_text(encoding="utf-8"))
            self.assertEqual("warp-hosted", record["execution"])
            self.assertEqual("succeeded", record["status"])
            self.assertEqual("run-test-123", record["provider_run_id"])
            self.assertEqual("QUEUED", record["provider_state"])
            self.assertEqual(
                "https://oz.warp.dev/runs/run-test-123", record["session_link"]
            )
            command = " ".join(record["command"])
            self.assertIn("<OZ_CODEX_AUTH_SECRET>", command)
            self.assertIn("<oz-prompt.md>", command)
            self.assertNotIn("openai-api", command)


if __name__ == "__main__":
    unittest.main()
