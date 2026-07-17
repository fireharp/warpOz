# Repository Guidelines

## Project Structure & Module Organization

Each direct child of `playgrounds/` is one developer scenario named
`<task>-<harness>`. Its `playground.json` is the catalog contract: keep the name,
task, harness, runtime class, local entrypoint, offline contract test, and Oz
prompt accurate. Scenario fixtures, verifiers, and generated runtime state stay
inside that directory. Root `scripts/playground` discovers manifests and is the
only shared dispatcher. `docs/oz.md` owns the local-to-cloud operating flow;
`docs/api.md` owns the control-plane probe.

## Build, Test, and Development Commands

- `make list`: inspect the discovered task catalog.
- `make setup`: validate manifests and report available local CLIs.
- `make test`: validate every manifest and run every offline contract suite.
- `make local PLAYGROUND=<name>`: execute one live native Claude or Codex run.
- `make api-check`: verify authenticated Warp API reachability without exposing
  credentials or run data.
- `make oz-create OZ_REPO=owner/repo`: register the shared personal Oz
  environment.
- `make oz-run PLAYGROUND=<name> OZ_ENVIRONMENT_ID=<id>`: dispatch one scenario
  to its Oz harness.

Use `./scripts/playground oz <name> --environment test --dry-run` to inspect a
cloud command without creating a run.

## Coding Style & Naming Conventions

Keep shell scripts POSIX `sh` unless Bash features are required; start them with
`set -eu` or `set -euo pipefail`. Python uses the standard library, type hints,
four-space indentation, and no generated dependencies. Never commit provider
keys, Warp keys, Claude state, Codex state, or playground runtime output.

## Testing Guidelines

Every playground needs an independent verifier and an offline contract test.
Contract tests must not call a model or network. A live provider run supplements
these tests but does not replace them. Run `make test` before handoff.

## Commit & Pull Request Guidelines

There is no commit history yet, so no repository-specific message convention is
established. Keep commits focused by task or shared infrastructure. Before a
commit, run `coherence review --base=HEAD --worktree --json`; stage only relevant
files, then let `.githooks/pre-commit` run the staged Coherence scan.
