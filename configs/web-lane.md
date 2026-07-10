# Web lane wiring

Three sub-lanes. Route by what the project actually is, not by habit.

| Project | Stack | Oracle |
|---|---|---|
| Web app | Vite + React + strict TS + Biome | `tsc --noEmit` typechecks the markup itself (TSX); Biome lints TS and CSS |
| Content site with components | Astro | `astro check` |
| Pure markdown site | Zola | `zola check` (validates internal links and anchors) |
| Tiny vanilla page | hand HTML/CSS/JS | html-validate (a pinned devDependency in the lockfile, run as `pnpm exec html-validate`, with a committed .htmlvalidate.json) plus an id-contract grep (see bnw-example) |

The reason TSX over hand-written HTML: browsers never fail loudly. Broken
HTML renders anyway, error-corrected into something almost right. Putting
markup inside the type system turns misspelled attributes, wrong props, and
bad handler signatures into compile errors. Hand-written HTML is for pages
too small to have contracts.

React is chosen for training density, not runtime speed. Its one silent
failure mode (wrong useEffect dependency arrays: stale data, no error) is
turned into a static error by Biome's useExhaustiveDependencies rule, set
to error in configs/biome.json. Do not downgrade that rule.

## justfile wiring (app sub-lane)

Every tool below is a pinned devDependency resolved from the lockfile via
`pnpm exec`, never `npx -y <tool>`, which re-resolves latest every run and
defeats the lockfile (CI installs with `--frozen-lockfile`; honor it locally too).

```just
check:
    pnpm exec tsc --noEmit --pretty false && biome check .

fix:
    biome check --write .

test:
    pnpm exec playwright test --reporter=line

run:
    pnpm dev

# Runtime oracle: drives a real browser, screenshots land in e2e/shots/
# where the agent can look at them and the human can judge them.
verify:
    pnpm exec playwright test --reporter=line

# Publish, then prove it landed: fetch the URL and grep a sentinel.
# (Pages deploys lag by up to a minute; if the curl races a fresh deploy,
# rerun it rather than weakening the check.)
ship:
    pnpm build
    pnpm exec gh-pages -d dist --nojekyll
    curl -sf "https://<user>.github.io/<repo>/" | grep -q "<sentinel>"
    @echo "live: https://<user>.github.io/<repo>/"
```

For the ship recipe, enable Pages once during first-run wiring
(`gh api repos/<user>/<repo>/pages -f 'source[branch]=gh-pages'` or the
repo settings page). Zola and Astro ship the same way with their own
output dirs (`public/`, `dist/`). A server path behind a reverse proxy
works too; the contract is only that `just ship` ends with a URL the
PRODUCER can send to someone.

## Playwright + axe

One spec gives you load-check, screenshot, and accessibility in a single run:

```ts
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test('home loads, looks right, passes axe', async ({ page }) => {
  await page.goto('/');
  await page.screenshot({ path: 'e2e/shots/home.png', fullPage: true });
  const a11y = await new AxeBuilder({ page }).analyze();
  expect(a11y.violations).toEqual([]);
});
```

Screenshots are the one oracle for "renders wrong": agents can read images,
and the human judging the page is the final check no static tool replaces.

## Links

lychee (Rust) in CI and before deploys:

```
lychee --no-progress 'dist/**/*.html'
```

## wasm

Not a lane. When a project needs in-browser compute, that is the Rust lane
with a different build target (trunk or wasm-pack); cargo check stays the
oracle. See bnw-example for what the deployed result looks like.
