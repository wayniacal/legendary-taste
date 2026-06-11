# Standard verbs — identical across all repos. Agents and humans run these
# without discovery. TODOs exit 1: a stub that lies with exit 0 poisons the loop.

default: check

# Fast oracle, <5s. Wire to: cargo check / tsc --noEmit / uv run pyright
check:
    @echo "TODO(agent): wire fast checker — see CLAUDE.md first-run steps" >&2; exit 1

# Auto-fixers. Wire to: cargo clippy --fix / biome check --write / ruff check --fix
fix:
    @echo "TODO(agent): wire auto-fixers" >&2; exit 1

# Full suite. Deterministic: no network, no real clocks, fixed seeds.
test:
    @echo "TODO(agent): wire test suite" >&2; exit 1

# Start the thing locally.
run:
    @echo "TODO(agent): wire local run" >&2; exit 1

# Checkpoint everything. jj snapshots the working copy automatically; this
# names the state and opens a new one. Any mistake: jj undo. Nothing is lost.
save msg="checkpoint":
    jj commit -m "{{msg}}"
