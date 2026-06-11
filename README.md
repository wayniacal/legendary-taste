# taste

Scaffolding for agent-built projects. The agent does the setup and the
coding; the kit catches mistakes automatically; the human judges results.

Non-coders: read **GUIDE.md** — it's the whole manual, one page, no jargon.

Principle: convert runtime failures into static failures, keep the check fast.
Agent leverage = oracle quality × iteration speed.

## What goes where

| File | Purpose |
|---|---|
| `GUIDE.md` | The human's manual — lay language, five rules, the loop |
| `CLAUDE.md` | The agent's manual — self-bootstrapping first-run steps + standing rules |
| `justfile` | Standard verbs (`check`/`fix`/`test`/`run`/`save`) — same in every repo |
| `.mise.toml` | Pinned toolchains + per-directory env vars |
| `.claude/settings.json` | PostToolUse hook: `just check` after every agent edit, failures feed back automatically |
| `.github/workflows/ci.yml` | CI is `just check && just test` — same contract as local |
| `configs/` | Per-language locked defaults; the agent copies the one in use, deletes the rest |
| `tools-meta.md` | The toolset: what, why, what was rejected, what's on watch |
| `bnw-example/` | The schema applied to a real project (vanilla JS + wasm static app) |

## Version control: jujutsu

`jj git init --colocate` — jj and git share the repo. jj's working copy is
always a commit: nothing is ever lost, `jj undo` reverses anything, and
`just save` is the only verb a non-coder needs. The colocated `.git` keeps
GitHub, CI, and agents' deep git knowledge fully functional.

## Rules that aren't files

- Commit lockfiles, always, every ecosystem.
- No network in tests, no real clocks, fixed seeds. A test that flakes twice
  gets quarantined same day.
- `just check` stays under 5 seconds or it gets split.
- Postgres for persistence, JSON-lines on stderr for logs, monorepo per project.
