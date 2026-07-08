# legendary-taste

Scaffolding for agent-built projects. The agent does the setup and the
coding; the kit catches mistakes automatically; the human judges results.

Non-coders: read **GUIDE.md**. It's the whole manual, one page, no jargon.
Setting this up for someone else: read **tutor.md**.

Principle: convert runtime failures into static failures, keep the check
fast. Agent leverage = oracle quality x iteration speed.

## What goes where

| File | Purpose |
|---|---|
| `GUIDE.md` | The PRODUCER's manual: lay language, the producer contract, five rules, the loop |
| `tutor.md` | The introducer's manual: machine prep, the first session, what not to do |
| `CLAUDE.md` | The agent's manual: self-bootstrapping first-run steps + standing rules |
| `justfile` | Standard verbs (`check`/`fix`/`test`/`run`/`audit`/`ship`/`save`), same in every repo |
| `style.md` | Code/prose style (Bellard-derived) plus the machine-tells blacklist |
| `.mise.toml` | Pinned toolchains + per-directory env vars |
| `.claude/settings.json` | Hook: `just check` after every agent edit, failures feed back automatically |
| `.github/workflows/ci.yml` | CI is `just check && just test`, same contract as local |
| `configs/` | Per-language locked defaults; the agent copies the one in use, deletes the rest |
| `tools-meta.md` | The toolset: what, why, what was rejected, what's on watch |
| `bnw-example/` | The schema applied to a real project (vanilla JS + wasm static app) |

## Version control: jujutsu

`jj git init --colocate`, so jj and git share the repo. jj's working copy
is always a commit: nothing is ever lost, `jj undo` reverses anything, and
`just save` checkpoints and backs up to the remote in one verb. The
colocated `.git` keeps
GitHub, CI, and agents' deep git knowledge fully functional.

## Rules that aren't files

- Commit lockfiles, always, every ecosystem. Installs run from the lockfile,
  never re-resolve: CI uses `pnpm install --frozen-lockfile`, `uv sync --locked`,
  `cargo fetch --locked`; do the same locally. A swapped or drifted dependency
  fails the install instead of shipping.
- Everything `check`/`test` invokes is pinned. Bare `npx -y tool` re-resolves
  latest every run; the ruleset drifts until the gate fails on untouched code.
  Run tools as pinned devDependencies via `pnpm exec`, never `npx -y`.
- `just audit` scans the committed lockfiles for known-vulnerable deps (one
  cross-ecosystem scanner, osv-scanner) and the repo history for leaked
  secrets (gitleaks, always `--redact`), and runs in CI. A freshly-disclosed
  CVE failing the gate on untouched code is a true positive, not drift.
- `ship` ends by fetching the live URL and grepping a sentinel, not by
  printing the URL and hoping.
- Assets over a few MB: copy with `cp -u`/rsync so ship skips them when
  unchanged, raise jj's `snapshot.max-new-file-size` deliberately, and note
  both in CLAUDE.md.
- No network in tests, no real clocks, fixed seeds. A test that flakes twice
  gets quarantined same day.
- `just check` stays under 5 seconds or it gets split.
- Oracle recipes use the tool's own concise, no-color mode: drop ANSI and
  progress noise, report only failures, but never a lossy summary format that
  hides a diagnostic (`ruff --output-format=concise`, `tsc --pretty false`,
  `nextest --status-level=fail` — not `cargo --message-format=short`). Fidelity
  outranks brevity; the gate's job is to show the agent exactly what to fix.
- Postgres for persistence, JSON-lines on stderr for logs, monorepo per project.
