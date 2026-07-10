# tools-meta

The toolset, why each piece, and what was rejected. Criteria: battle-tested
first, Rust where a robust Rust option exists, fewest total tools.

## Machine-level

| Tool | Language | Role | Why this one |
|---|---|---|---|
| **mise** | Rust | Toolchain pins + per-directory env vars | One binary replaces asdf and direnv. `[tools]` kills "works on my machine", `[env]` kills shell-profile sprawl. |
| **jujutsu (jj)** | Rust | Version control | The working copy is always a commit: nothing is ever lost, and `jj undo` reverses any operation. Ideal for non-coders and agents alike. Used colocated (`jj git init --colocate`) so `.git` stays fully functional: GitHub, CI, and the agent's deep git training keep working. Caveat: pre-1.0; the colocated git repo is the hedge. |
| **just** | Rust | Command runner: `check`/`fix`/`test`/`run`/`save` in every repo | About ten years old, single static binary. Make without the footguns (no tab landmines, no `.PHONY`, `--list` built in). High training-data density: agents have read a lot of justfiles. |
| **uv** | Rust | All Python: venvs, deps, lockfile | Replaced pip/pipx/poetry/virtualenv with one fast binary. Now the default, not the gamble. |
| **ruff** | Rust | Python lint + format | Replaced flake8/isort/black. `--fix` is agent-friendly. |
| **ripgrep + fd** | Rust | Search | The agent navigates by grep; these are its eyes. |
| **pnpm** | TypeScript | Node packages | Not Rust, but no mature Rust alternative exists. Strict node_modules layout catches phantom dependencies. Implementation language matters least here; it is not in the edit-check loop. |
| **ShellCheck** | Haskell | Shell script oracle | Not Rust either; irreplaceable. Highest value-per-line static analyzer in the stack. |
| **osv-scanner** | Go | Supply-chain oracle (`just audit`) | One binary reads Cargo.lock, pnpm-lock.yaml, and uv.lock against the OSV database, so the whole stack shares a single auditor instead of cargo-audit + pnpm audit + pip-audit. Not Rust, but the "fewest total tools" win is decisive. Scans the lockfile the build already pins; building managers from source would not catch a poisoned dependency, this does. |
| **ast-grep** | Rust | Structural search + custom lint rules | tree-sitter search/rewrite by AST: ripgrep for syntax. `ast-grep scan` with a rule file is a *writable* oracle: ban a pattern and a violation becomes a static failure. Beats Comby (syntactic, quieter project) and GritQL (newer). The youngest tool in the stack; the rule files are version-controlled, so drift is visible. |
| **gitleaks** | Go | Secret-leak oracle (`just audit` / CI gate) | Fast offline regex+entropy scan; turns "no secrets in code" from a convention into a gate. Runs inside `just audit` with `--redact` so a found secret never lands in logs or agent context. Go, not Rust: same irreplaceable-function exception as ShellCheck/osv-scanner. trufflehog verifies harder but needs the network (see On watch). |
| **actionlint** | Go | GitHub Actions workflow oracle | Validates workflow syntax, `${{ }}` expressions, and embedded `run:` shell (via ShellCheck). A broken workflow is silent until push; this makes it loud. Earns its slot only where the repo ships workflows. |
| **typos** | Rust | Source spell-check (optional) | Catches typo'd identifiers, config keys, and doc links, a silent failure class. Source-aware (handles camelCase), fast, single binary. Optional and lowest-priority; codespell is more proven but Python and heavier. |

## Per-language oracles

| Tool | Language | Role | Why |
|---|---|---|---|
| **cargo check / clippy** | Rust | Rust oracle + auto-fix | The reference standard for compiler feedback. |
| **cargo-nextest** | Rust | Test runner | Faster, better output, per-test isolation. |
| **insta / proptest** | Rust | Snapshots / properties | Minimized counterexamples beat assertions. |
| **sqlx** | Rust | Compile-time-checked SQL | Queries verified against the live schema at build time (`query!` macros + offline cache for CI). Closes the gap between schema constraints (runtime) and query strings (unchecked until executed). |
| **tsc (strict)** | TypeScript | TS type oracle | No Rust option. The one place correctness beats purity: the type checker is the product. |
| **Biome** | Rust | TS/JS/CSS lint + format | Replaces eslint + prettier with one binary. tsc does types; Biome does style. Its CSS coverage is narrower than stylelint's, an accepted trade: CSS errors are visible, and the human looking at the page is the CSS oracle. |
| **pyright (strict)** | Node/TS | Python type oracle | Best gradual-typing checker available today. |

## Web

| Tool | Language | Role | Why |
|---|---|---|---|
| **Vite** | TS (Rust internals landing via Rolldown) | Build + dev server | The ecosystem default; no serious rival for this audience. |
| **React + TSX** | TS | Web app UI | Chosen for training density, not runtime speed: agents have read more React than anything else. TSX puts markup inside the type system, so misspelled attributes and wrong props are compile errors. Its one silent footgun (wrong useEffect dependency arrays) is made static by Biome's useExhaustiveDependencies rule, set to error. |
| **Astro** | TS | Content sites with components | `astro check` typechecks components; ships near-zero JS by default. |
| **Zola** | Rust | Pure markdown sites | Single binary, `zola check` validates links. Simpler than Astro when there are no components. |
| **Playwright** | TS | Runtime oracle | Drives a real browser: e2e assertions, screenshots agents can read, auto-waiting that kills the flakiness which poisons agent loops. Cypress and Selenium are not close. |
| **axe-core** | JS | Accessibility | The industry standard; everything else wraps it. Runs inside the Playwright pass. |
| **lychee** | Rust | Link checker | Fast, battle-tested in CI. Link rot is a silent failure; this makes it loud. |
| **html-validate** | TS | Vanilla-lane HTML oracle | Only for hand-written pages too small for a framework. Browsers error-correct broken HTML silently; this is the missing loud failure. |

Lane routing: web app to Vite + React; content site with components to
Astro; pure markdown to Zola; tiny vanilla page to html-validate plus an
id-contract grep (see bnw-example). Wiring details in configs/web-lane.md.

wasm is not a lane. In-browser compute is the Rust lane with a different
build target (trunk or wasm-pack); cargo check stays the oracle.

## Rejected

- **make**: more battle-tested than just, and that is its only win. Tab
  syntax, `.PHONY`, silent shell quirks: agents trip on all of them.
- **direnv** (Go): subsumed by mise `[env]`.
- **asdf**: subsumed by mise, which reads the same plugin ecosystem.
- **eslint + prettier**: two Node tools and a config ecosystem replaced by
  one Rust binary (Biome).
- **stylelint**: deeper CSS linting than Biome, but one more Node tool for
  a failure class the human catches by looking at the page.
- **Cypress / Selenium**: flakier model / legacy. Playwright won.
- **poetry / pip / pipenv**: uv.
- **black / flake8 / isort**: ruff.
- **npm / yarn**: pnpm is stricter and faster; npm's loose hoisting hides
  phantom deps that surface as runtime failures.
- **cargo-audit / `pnpm audit` / pip-audit**: three per-ecosystem scanners
  with three output formats; osv-scanner covers all their lockfiles from one
  binary against the same OSV database.
- **Comby / GritQL**: structural-search rivals to ast-grep. Comby matches
  syntactically (no real AST); GritQL is newer with less density. ast-grep
  wins on tree-sitter accuracy, Rust, and adoption.
- **Semgrep**: heavier (Python/OCaml) and registry/cloud-shaped. It is the
  specialist for security rule-scanning, but that overlaps gitleaks (secrets)
  and osv-scanner (deps), so it earns no slot here.
- **codespell**: the proven-by-tenure spell checker, but Python and heavier;
  typos covers the same failure class as one Rust binary.
- **pre-commit**: the git-hook manager the rest of the world uses. Here the
  gate manager is the harness hook (`just check` after every edit) plus CI
  running the same verbs: it fires on edit, not on commit, which is earlier
  and stricter, and adds no Python dependency.
- **trivy / dive**: container and image scanners. Real tools, wrong layer:
  osv-scanner already covers the lockfiles and no lane ships containers.
  They earn slots the day one does.

## On watch (not yet; battle-tested wins over new)

- **ty** (Astral, Rust): pyright's replacement. Same team as uv/ruff.
  Adopt at 1.0, drop the last Node tool in the Python lane.
- **tsgo** (Microsoft, Go): the roughly 10x tsc port. Same checks, faster
  oracle. Adopt when it is the default tsc.
- **Deno** (Rust): runtime + types + lint + fmt + test in one binary. For
  greenfield TS with no npm-ecosystem needs it would replace node + pnpm +
  Biome at a stroke; npm compat is why pnpm survives for now.
- **Svelte 5 / Solid**: faster than React and arguably cleaner, but each
  carries its own silent reactivity trap and a tier less training data.
  Revisit as their density grows.
- **trufflehog**: a secret scanner that *verifies* candidates against provider
  APIs, so far fewer false positives than gitleaks. Adopt if verification is
  worth the network dependency and slower run; gitleaks stays the offline default.
- **hurl** (Rust): HTTP requests as declarative files with asserts, an
  oracle-shaped API test runner. No API-only lane exists yet; Playwright owns
  the web lane and nextest/pytest cover backends. The day a project is a
  headless API, hurl is the answer.

## Why any Node tools at all

The language recommendation is strict TypeScript; Node is the substrate it
ships on. tsc and pnpm are the cost of the TS lane, pyright is the cost of
the Python lane. Zero TS + zero Python = zero Node tools. The Node
footprint is slated to shrink: ty kills pyright, tsgo kills tsc-on-Node,
and Deno already makes the whole Node toolchain optional for greenfield
work.
