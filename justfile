# Standard verbs, identical across all repos. Agents and humans run these
# without discovery. TODOs exit 1: a stub that lies with exit 0 poisons the loop.

default: check

# Fast oracle, <5s. Wire the lane's checker in its terse, no-color mode: drop
# ANSI and progress noise, NEVER drop a diagnostic (no lossy summary formats like
# cargo --message-format=short). Wire to: cargo check -q / tsc --noEmit
# --pretty false / uv run ruff check --output-format=concise / uv run pyright
check:
    @echo "TODO(agent): wire fast checker, see CLAUDE.md first-run steps" >&2; exit 1

# Auto-fixers. Wire to: cargo clippy --fix / biome check --write / ruff check --fix
fix:
    @echo "TODO(agent): wire auto-fixers" >&2; exit 1

# Full suite. Deterministic: no network, no real clocks, fixed seeds. Report only
# failures (passing tests are noise): cargo nextest run --status-level=fail /
# pytest -q / playwright --reporter=line.
test:
    @echo "TODO(agent): wire test suite" >&2; exit 1

# Start the thing locally.
run:
    @echo "TODO(agent): wire local run" >&2; exit 1

# Supply-chain + secrets audit: scan every committed lockfile (Cargo.lock,
# pnpm-lock.yaml, uv.lock) for known-vulnerable deps, and the repo history for
# leaked secrets. One scanner per failure class:
#   osv-scanner scan source -r .
#   gitleaks git --no-banner --redact .
# (uncomment both in .mise.toml). --redact is not optional: a found secret must
# not land in logs or agent context. A freshly-disclosed CVE can fail this on
# untouched code — that is the point: disclosure is news, not drift. Runs in CI.
audit:
    @echo "TODO(agent): wire dependency audit, see CLAUDE.md first-run steps" >&2; exit 1

# Put it on a real URL the user can send to someone, then prove it landed:
# end with `curl -sf <url> | grep -q "<sentinel>"`, not a printed URL and hope.
# Wire per lane: GitHub Pages for static output, a server path, wherever.
# See configs/web-lane.md.
ship:
    @echo "TODO(agent): wire deploy, see CLAUDE.md first-run steps" >&2; exit 1

# Checkpoint everything, then back it up. jj snapshots the working copy
# automatically; any mistake is reversible with jj undo. The push is allowed
# to fail (offline is fine, backup happens on the next save).
save msg="checkpoint":
    jj commit -m "{{msg}}"
    jj bookmark set main -r @-
    -jj git push --remote origin -b main
