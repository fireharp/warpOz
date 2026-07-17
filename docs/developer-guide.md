# Developer guide — move a local agent task into Oz

## Executive summary

This repository is the handoff point between a developer's local Claude Code or
Codex workflow and an Oz-managed cloud run. A playground is named for its job
first and its harness second, such as `inventory-report-codex` or
`deployment-normalizer-claude`.

The same task contract travels through every stage: inputs, prompt, independent
verifier, and declared output artifacts. A developer proves the task locally,
commits it to `master`, then Oz clones that branch and starts the selected
managed harness. The team keeps credentials in Oz; they never go in Git, a
task prompt, or a local `.env` file.

```text
  LOCAL DEVELOPER             GIT + OZ                  EVIDENCE

  +------------------+        +------------------+      +------------------+
  | task + verifier  |------->| master + env     |----->| ledger + session |
  | Codex or Claude  |        | managed secret   |      | safe milestone   |
  +------------------+        +------------------+      +------------------+
       prove task                 dispatch job               inspect result
```

The verified shared environment is:

| Setting | Current value |
| --- | --- |
| Oz environment | `warpoz-playgrounds` (`pnhqL0eT4VPpCfAr7BizuN`) |
| Repository / branch | `fireharp/warpOz` / `master` |
| Base image | `warpdotdev/dev-base:latest` |
| Setup commands | none |
| Cloud auth | Oz-managed team secrets named `claude` and `codex` |
| Cost defaults | Claude Haiku; low Codex tier |

Both managed harnesses have completed a real hosted task in that environment.
See [verification.md](verification.md) for run IDs and safe evidence.

## Where to check that it works

| Question | Check | What success looks like |
| --- | --- | --- |
| Is my workstation ready? | `make setup` | Python is available; local CLIs are reported if installed. |
| Is the catalog valid? | `make list` | Four task-named playgrounds are listed. |
| Do task contracts pass? | `make test` | Every offline scenario verifier passes. |
| Can Oz be reached? | `make api-check` | `PASS: Warp API reachable and authenticated`. |
| Did my local agent finish? | `./scripts/playground runs` | A `local` record with status `succeeded`. |
| Did Oz actually finish? | `make reconcile RUN_ID=<local-run-id>` | A terminal provider state, normally `succeeded`. |
| What did Oz report? | `./scripts/playground show <local-run-id>` | Redacted command, provider run ID, session link, and short result summary. |
| What is safe to share in Git? | `artifacts/evidence/` | Small, sanitized milestone records only. |

`artifacts/runs/` is deliberately local and gitignored. It can contain console
context and output copies, so use it for debugging but do not commit it.

## The normal developer loop

```text
       +--------------------------------+
       | 1. Edit task, prompt, verifier  |
       +---------------+----------------+
                       |
                       v
       +--------------------------------+
       | 2. make test; run locally       |
       +---------------+----------------+
                       |
                       v
       +--------------------------------+
       | 3. Commit and push master       |
       +---------------+----------------+
                       |
                       v
       +--------------------------------+
       | 4. Dispatch to Oz; reconcile    |
       +---------------+----------------+
                       |
                       v
             PASS -> record evidence
             FAIL -> fix and repeat step 2
```

### 1. Select or create a task-named playground

Start with the task, not the provider. A playground lives at
`playgrounds/<task>-<harness>/` and must contain:

- `playground.json`: task name, `harness`, local command, contract test,
  cloud prompt, expected runtime class, and output artifact paths;
- deterministic inputs/fixtures and an independent verifier;
- `oz-prompt.md`, which tells the already-running Oz harness what to do;
- a local runner that uses the developer's installed `codex` or `claude` CLI.

Choose `codex` or `claude` in the manifest's `harness` field. Do not call an
agent CLI from `oz-prompt.md`: Oz already starts the selected harness.

### 2. Prove it locally

```sh
make test
make local PLAYGROUND=inventory-report-codex
./scripts/playground runs
```

The local run must pass its independent verifier. If it does not, iterate only
on the task implementation, prompt, fixtures, or verifier until it does. A
green `make test` is necessary before using cloud credits, but the local live
run is the proof that the real local agent can perform the task.

### 3. Publish the task revision

Oz clones the repository's GitHub default branch at run time. For this
repository, that branch is `master`.

```sh
git add playgrounds/<task>-<harness> docs/
git commit -m "feat: add <task> playground"
git push origin master
```

There is no separate task-package upload or release command. The commit is the
published task revision.

### 4. Dispatch the same task to Oz

For the verified shared environment, set the ID once in your shell:

```sh
export OZ_ENVIRONMENT_ID=pnhqL0eT4VPpCfAr7BizuN
make oz-run PLAYGROUND=inventory-report-codex
```

The command immediately creates a local ledger record and returns. That means
the task is **submitted**, not necessarily finished. The default model is kept
economical. Override it only when justified:

```sh
OZ_MODEL=<supported-model-id> make oz-run PLAYGROUND=inventory-report-codex
```

List valid model IDs with `oz model list`.

### 5. Reconcile and iterate

Copy the local run ID printed as `run artifact: .../run.json`, or find it in
the ledger:

```sh
./scripts/playground runs
make reconcile RUN_ID=<local-run-id-or-prefix>
./scripts/playground show <local-run-id-or-prefix>
```

If the provider result is `succeeded`, save a small sanitized result in
`artifacts/evidence/` only when it marks a meaningful milestone. If it failed:

1. inspect `provider_status_message` and the session link from `show`;
2. reproduce task failures locally before retrying Oz;
3. correct the task, verifier, or environment configuration as appropriate;
4. commit and push `master`, then dispatch another named run.

## First-time cloud setup

This is normally a platform-maintainer action, not a task developer action.

1. Ensure the repository is on GitHub with `master` as its default branch.
2. Create the environment with `./scripts/playground oz-create --repo owner/repo`.
   Use the default `warpdotdev/dev-base:latest` image and no
   repository-relative setup commands.
3. Add typed Oz-managed provider secrets named `claude` and `codex`. Their
   values stay in Oz; task developers reference only the names.
4. Share the environment ID with developers and have them run `make api-check`
   before their first hosted dispatch.

The older `latest-agents` environment is retained only as historical evidence:
it failed while Warp installed a Codex plugin. Do not use it for new runs.

## Practical rules

- Keep task names outcome-oriented: `invoice-audit-codex`, not `codex-test-2`.
- Put every success condition in an independent verifier, not only in the
  agent's final prose.
- Keep each prompt scoped to its playground and declared output paths.
- Never commit provider keys, auth files, raw session transcripts, or generated
  `artifacts/runs/` directories.
- Use low-cost models for smoke tests. Raise the model only when task evidence
  justifies it.
- Keep self-hosted execution separate; this guide covers Warp-hosted Oz only.
