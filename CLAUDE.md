# <project>, built on the legendary-taste template

<!-- AGENT FIRST RUN. Do these once, in order, then delete this comment block.
1. Ask the user, in plain words, what they want to build. Pick the lane:
   - Rust: default for anything long-lived (services, CLIs, libraries)
   - Web app: Vite + React + strict TS (see configs/web-lane.md)
   - Content site: Astro if it needs components, Zola if pure markdown
   - Python: only if ML or data libraries require it
   - bash: glue under 50 lines
2. Wire the justfile. The stubs exit 1 on purpose. Replace check (fast oracle,
   under 5s), fix, test, run, and ship for the chosen lane. Copy the matching
   file from configs/ to the repo root; delete the configs/ entries you didn't use.
   ship must end by printing the URL where the result is now live.
3. Pin the toolchain in .mise.toml [tools]; run `mise install`.
4. If .jj is missing: `jj git init --colocate`. Create a private GitHub repo
   (ask the user what to call it) and add it as the origin remote, so every
   save backs itself up. Then `just save "project start"`.
5. Verify the hook: make a trivial edit and confirm `just check` fires.
6. Rewrite this file: one-line description, Commands, Invariants, Gotchas.
   Keep the Working rules section verbatim. Delete this block.
-->

## Working rules

- After every edit, `just check` must pass; the hook enforces this. Never
  bypass it and never weaken a config to make it pass. Fix the code.
- Whenever the check is green and `just run` behaves: `just save "<plain words>"`.
- The user may not read code. Explain what changed in ordinary language;
  never paste raw error output at them.
- Recovery is `jj undo` (and `jj op log` to see history). Nothing is ever
  lost. Prefer rewinding to a good state over patching a broken one.
- Secrets never go in code, chat, or saves. They live in `.env.local`
  (untracked), loaded via the `[env]` section of .mise.toml.
- Small steps: one working feature per save, not one big bang.

## Commands

- `just check`: fast oracle; runs automatically after every edit
- `just fix`: auto-fixers
- `just test`: full suite, deterministic
- `just run`: start the thing locally
- `just ship`: publish to the live URL
- `just save "msg"`: checkpoint everything and back it up (jj + push)

## Invariants

<!-- rules the code can't express; the agent must not violate these -->

## Gotchas

<!-- things that cost an hour once; write them down the same day -->
