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
    def test_oz_create_uses_only_server_side_environment_options(self) -> None:
        completed = subprocess.run(
            [
                str(CLI),
                "oz-create",
                "--repo",
                "fireharp/warpOz",
                "--dry-run",
            ],
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        self.assertEqual(0, completed.returncode, completed.stdout)
        self.assertIn("--repo fireharp/warpOz", completed.stdout)
        self.assertNotIn("--setup-command", completed.stdout)

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
            self.assertEqual("submitted", record["status"])
            self.assertEqual("run-test-123", record["provider_run_id"])
            self.assertEqual("InProgress", record["provider_state"])
            self.assertEqual(
                "https://oz.warp.dev/runs/run-test-123", record["session_link"]
            )
            command = " ".join(record["command"])
            self.assertIn("<OZ_CODEX_AUTH_SECRET>", command)
            self.assertIn("--model gpt-5-2-codex-low", command)
            self.assertIn("<oz-prompt.md>", command)
            self.assertNotIn("openai-api", command)

            reconciled = subprocess.run(
                [str(CLI), "reconcile", record["run_id"]],
                cwd=ROOT,
                env=environment,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=False,
            )
            self.assertEqual(0, reconciled.returncode, reconciled.stdout)
            record = json.loads(records[0].read_text(encoding="utf-8"))
            self.assertEqual("succeeded", record["status"])
            self.assertEqual("SUCCEEDED", record["provider_state"])
            self.assertEqual("contract passed", record["provider_status_message"])
            self.assertEqual("2026-07-17T16:30:00Z", record["provider_updated_at"])

            failed = subprocess.run(
                [
                    str(CLI),
                    "reconcile",
                    record["run_id"],
                    "--provider-run-id",
                    "run-test-failed",
                ],
                cwd=ROOT,
                env=environment,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=False,
            )
            self.assertEqual(1, failed.returncode, failed.stdout)
            record = json.loads(records[0].read_text(encoding="utf-8"))
            self.assertEqual("failed", record["status"])
            self.assertEqual("platform bootstrap failed", record["provider_status_message"])

    def test_oz_model_can_be_overridden(self) -> None:
        completed = subprocess.run(
            [
                str(CLI),
                "oz",
                "inventory-report-codex",
                "--environment",
                "env-test",
                "--model",
                "gpt-5-3-codex-low",
                "--dry-run",
            ],
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
        self.assertEqual(0, completed.returncode, completed.stdout)
        self.assertIn("--model gpt-5-3-codex-low", completed.stdout)

if __name__ == "__main__":
    unittest.main()
