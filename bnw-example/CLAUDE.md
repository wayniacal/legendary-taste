# bnw — Brave New Word

In-browser novel-word generator (Markov over letter n-grams). Vanilla JS +
wasm, zero dependencies, all generation local. Live at https://b0y.eu/bnw/.

## Commands

- `just check` — typecheck app.js (JSDoc via tsc) + verify every `$('id')` exists in index.html
- `just build` — regenerate stale `.br`/`.gz` siblings — REQUIRED after any edit
- `just run` — serve on :8090 (wasm needs http, not file://)

## Invariants

- Caddy serves the precompressed `.br`/`.gz` files. An edited source file with
  stale siblings ships the OLD version silently. Never edit without `just build`.
- `bnw.wasm` is a build artifact — source is not on this server. Never hand-edit.
  The JS↔wasm boundary is `withStr`/`readResult` in app.js; the wasm side owns
  all generation, JS owns all DOM.
- Element ids are the app.js↔index.html contract; `just check` enforces it.
- Zero dependencies is a feature, not an accident. No package.json, no framework.

## Gotchas

- Corpora are one word per line; lists with `freq: true` in `CORPORA` must stay
  frequency-sorted or zipf weighting silently degrades.
- Share URLs encode settings — renaming a key in `DEFAULTS`/`settings()` breaks
  every link already shared.
- First `just check` run after adopting jsconfig will report existing findings
  (strict mode on untyped DOM code). That's the adoption cost — annotate, don't
  weaken the config.
