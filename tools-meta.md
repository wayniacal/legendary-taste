# tools-meta

The toolset, why each piece, and what was rejected. Criteria: battle-tested
first, Rust where a robust Rust option exists, fewest total tools.

## Machine-level

| Tool | Language | Role | Why this one |
|---|---|---|---|
| **mise** | Rust | Toolchain pins + per-directory env vars | One binary replaces asdf *and* direnv. `[tools]` kills "works on my machine", `[env]` kills shell-profile sprawl. |
| **jujutsu (jj)** | Rust | Version control | Working copy is always a commit: nothing is ever lost and `jj undo` reverses any operation — ideal for non-coders and agents alike. Used colocated (`jj git init --colocate`) so `.git` stays fully functional: GitHub, CI, and the agent's deep git training keep working. Caveat: pre-1.0; the colocated git repo is the hedge. |
| **just** | Rust | Command runner — `check`/`fix`/`test`/`run` in every repo | ~10 years old, single static binary. Make without the footguns (no tab landmines, no `.PHONY`, `--list` built in). High training-data density: agents have read a lot of justfiles. |
| **uv** | Rust | All Python: venvs, deps, lockfile | Replaced pip/pipx/poetry/virtualenv with one fast binary. Now the default, not the gamble. |
| **ruff** | Rust | Python lint + format | Replaced flake8/isort/black. `--fix` is agent-friendly. |
| **ripgrep + fd** | Rust | Search | The agent navigates by grep; these are its eyes. |
| **pnpm** | TypeScript | Node packages | Not Rust, but no mature Rust alternative exists. Strict node_modules layout catches phantom dependencies. Implementation language matters least here — it's not in the edit-check loop. |
| **ShellCheck** | Haskell | Shell script oracle | Not Rust either; irreplaceable. Highest value-per-line static analyzer in the stack. |

## Per-language oracles

| Tool | Language | Role | Why |
|---|---|---|---|
| **cargo check / clippy** | Rust | Rust oracle + auto-fix | The reference standard for compiler feedback. |
| **cargo-nextest** | Rust | Test runner | Faster, better output, per-test isolation. |
| **insta / proptest** | Rust | Snapshots / properties | Minimized counterexamples beat assertions. |
| **sqlx** | Rust | Compile-time-checked SQL | Queries verified against the live schema at build time (`query!` macros + offline cache for CI). Closes the gap between schema constraints (runtime) and query strings (unchecked until executed). |
| **tsc (strict)** | TypeScript | TS type oracle | No Rust option. The one place correctness beats purity — the type checker IS the product. |
| **Biome** | Rust | TS/JS lint + format | Replaces eslint + prettier with one binary. tsc does types; Biome does style. |
| **pyright (strict)** | Node/TS | Python type oracle | Best gradual-typing checker available today. |

## Rejected

- **make** — more battle-tested than just, and that's its only win. Tab
  syntax, `.PHONY`, silent shell quirks: agents trip on all of them.
- **direnv** (Go) — subsumed by mise `[env]`.
- **asdf** — subsumed by mise, which reads the same plugin ecosystem.
- **eslint + prettier** — two Node tools and a config ecosystem replaced by
  one Rust binary (Biome).
- **poetry / pip / pipenv** — uv.
- **black / flake8 / isort** — ruff.
- **npm / yarn** — pnpm is stricter and faster; npm's loose hoisting hides
  phantom deps that surface as runtime failures.

## On watch (not yet — battle-tested wins over new)

- **ty** (Astral, Rust) — pyright's replacement. Same team as uv/ruff.
  Adopt at 1.0, drop the last Node tool in the Python lane.
- **tsgo** (Microsoft, Go) — the ~10x tsc port. Same checks, faster oracle.
  Adopt when it's the default tsc.
- **Deno** (Rust) — runtime + types + lint + fmt + test in one binary. For
  greenfield TS with no npm-ecosystem needs it would replace node + pnpm +
  Biome at a stroke; npm compat is why pnpm survives for now.

## Why any Node tools at all

The language recommendation is strict TypeScript; Node is the substrate it
ships on. tsc and pnpm are the cost of the TS lane, pyright is the cost of
the Python lane. Zero TS + zero Python = zero Node tools. Both are slated
for removal: ty kills pyright, tsgo kills tsc-on-Node, and Deno already
makes the whole Node toolchain optional for greenfield work.
