"""Select release archives for a named service."""

from __future__ import annotations

import re
from collections.abc import Iterable


ARTIFACT_PATTERN = re.compile(
    r"^(?P<service>[a-z][a-z0-9-]*)-(?P<version>\d+\.\d+\.\d+)\.tar\.gz$"
)


def select_latest_artifact(artifacts: Iterable[str], service: str) -> str:
    """Return the newest valid release archive for *service*."""
    candidates = []
    for artifact in artifacts:
        match = ARTIFACT_PATTERN.fullmatch(artifact)
        if match and match.group("service") == service:
            candidates.append(artifact)

    if not candidates:
        raise ValueError(f"no release artifact found for {service!r}")

    # BUG: lexical ordering considers 1.9.0 newer than 1.10.0.
    return max(candidates)
