# style.md

Style for all agent-written code, comments, docs, commit messages, and
published prose in this project. Derived from Fabrice Bellard's published
code and pages (bellard.org: quickjs, tcc, libbf, ffmpeg). Where the target
language's enforced idiom conflicts (rustfmt, gofmt, PEP 8, biome), the
language wins; everything else here still applies.

## Before writing code

The best code is the code never written. Lazy means efficient, not careless.
Stop at the first rung that holds:

- Does this need to exist at all? (YAGNI)
- Does the standard library already do it? Use it.
- Does a native platform feature cover it? Use it.
- Does an already-installed dependency solve it? Use it.
- Can it be one line? Make it one line.
- Only then write the minimum that works.

Question complex requests before building: do you need X, or does Y cover it?
None of this licenses cutting corners on the things that bite: input
validation at trust boundaries, error handling that prevents data loss,
security, accessibility, calibration for real hardware (the platform is
never the spec ideal: a clock drifts, a sensor reads off), and anything
explicitly asked for. Those get full effort regardless. Non-trivial logic
ships with one runnable check: the smallest thing that fails if the logic
breaks, an assert-based self-check or one small test file, no frameworks,
no fixtures. Trivial one-liners need none.

## Principles

- Simplest correct solution. No abstraction until repetition forces one;
  no boilerplate nobody asked for. Boring over clever.
- Between two equal-size approaches, take the edge-case-correct one. Lazy
  means less code, not the flimsier algorithm.
- Few substantial files over many small ones. One self-contained file with
  clear sections beats thirty files of ceremony (quickjs.c: one file, 61k
  lines, the whole engine).
- Small interfaces, hard to misuse: fewer parameters, fewer modes, fewer flags.
- A high-quality dependency over reimplementing a solved problem; no
  dependency over a marginal one.
- Every allocation, I/O call, and conversion can fail. Check it.
- Delete dead code; version control remembers. (C lane excepted: `#if 0`
  where the disabled branch documents a considered alternative.)
- Measure before optimizing. Keep optimizations local and put the
  measurement in the comment: "11% faster on bench-v8", not "faster".

## Prose

- Terse, declarative, ego-free. No first person, no marketing, nothing
  qualitative that could be a number instead.
- Project descriptions are noun phrases: "QuickJS: a small but complete
  Javascript engine." Never "X is a powerful tool for...".
- Exact figures over adjectives: "42% faster on bench-v8", "~210 KiB".
- A README is a pointer, not a document. The quickjs readme is one line:
  "The main documentation is in doc/quickjs.pdf or doc/quickjs.html."
- Changelog entries: hyphen bullets under a YYYY-MM-DD heading, 5-15 words,
  verb first: added, fixed, removed, improved, reworked.
- Dates YYYY-MM-DD. License stated explicitly. Hyphens for list bullets.
  No bold for emphasis in running text. Minimal links, cited by name.
- Assume domain literacy. Never define standard terms or expand well-known
  acronyms.

## Naming

Language convention wins; these fill the gaps.

- Public API: PascalCase with a short module prefix (JS_NewContext, Buf_Init).
- Internal: snake_case with a subsystem prefix (js_call_c_function, gc_decref).
- Prefixes exist because C has no namespaces. In languages with modules the
  module is the prefix: buf::init, not Buf_Init.
- Types PascalCase. Constants and enum variants ALL_CAPS with prefix.
- Locals short: p (the pointer being worked), s (string), ctx, i/j/n.
  Output parameters get a p prefix (plen, pres). Bool fields: is_ prefix.
- Bit flags as shift expressions, (1 << 3), never 0x08.

## Comments

- Low density (quickjs.c: about 4 per 100 lines). Comment why and caveats,
  never what the next line does.
- Known limitations and open questions: `/* XXX: ... */`, phrased as a
  question when unsure. Real examples: `/* XXX: optimize */`,
  `/* XXX: should generate an exception ? */`. No FIXME.
- An intentional simplification with a known ceiling (a global lock, an
  O(n^2) scan, a naive heuristic) gets the same `XXX:` marker, naming the
  ceiling and the upgrade path: `/* XXX: O(n^2) rescan, fine under ~1k
  rows; index by id when it grows */`.
- Preconditions: `/* WARNING: 'p' must be a typed array */`.
- Pre-function comments only for return semantics, ownership transfer, or
  non-obvious contracts.
- Struct fields get short trailing comments, aligned.

## Errors

- Check each fallible operation at the call site; bail immediately.
- Clean up in reverse acquisition order. C: `goto fail` / `goto exception`
  labels at function bottom. Elsewhere: early return, `?`, try; same shape.
- Free or close a resource the moment it is no longer needed, not at
  function end.
- Error values per language: Result in Rust, exceptions in Python, the
  C convention of -1 error / 0 success only where ints are the idiom.
  Predicates return bool everywhere.

## Performance

- Helpers 5-20 lines; hot dispatch loops as long as they need to be. Never
  split a hot loop to satisfy a length lint.
- Inline functions over macros. Dispatch and opcode tables generated, not
  hand-maintained. Cold paths marked noinline; tiny hot functions
  force-inlined. Bit fields and intrusive lists where layout matters.

## Machine tells

None of the following appear in any committed file, commit message, or
published page. Each reads as generated text. Sources: Wikipedia's "Signs of
AI writing" (WikiProject AI Cleanup), the blader/humanizer skill's 25
patterns, and the getspike.ai note on why the patterns arise (safe
continuations, reward for agreeable hedged prose, low-surprise decoding).
Consulted 2026-09-30; nothing installed.

Punctuation and formatting

- Em dashes. Use a colon, a comma, parens, or two sentences.
- Bold sprinkled through prose for emphasis; bold lead-ins on bullets or
  paragraphs ("Strengths:", "The catch:"); labelled lists where the label
  adds nothing. Emoji. Exclamation marks. Horizontal rules between sections.
  Title Case headings. A heading restated in the first sentence under it.
  Curly quotes where the format wants straight ones.
- Colons used as a reveal ("There are three benefits: ...") or to stage a
  point ("Here is what it means:"). State the point.
- Hyphenated pairs after nouns ("results of high-quality"): drop the hyphen
  unless the compound precedes the noun.

Sentence shapes

- Negative parallelism in every form: "not just X, but Y", "not X, but Y",
  "it's not about X, it's about Y", "Y rather than X" used for weight. Keep a
  contrast only when it corrects a belief the reader actually holds.
- The triple cadence: "fast, simple, and reliable". Three reworded synonyms
  are filler; say the one true thing. Three items only when there are three.
- One-line closers that restate the paragraph ("That matters." "Either way,
  we win."), and rows of dramatic fragments. Cut them.
- Staged run-ups: "Let's dive in", "Here's the thing", "Stated plainly",
  "The short answer is", "Put simply". Start with the point.
- Faux-insight setups: "What most people miss is", "The real question is".
- Arguing with no one: "I'm not saying...", "To be clear, this does not
  mean...", when nobody raised the objection.
- Repeated sentence openings across consecutive sentences.
- Stacked hedges: "could potentially possibly". One qualifier, only when the
  uncertainty is real and its source is named.
- Passive voice that hides the actor ("results are preserved"). Name the
  subject.
- Uniform sentence and paragraph length. Vary them; let a fact stand alone
  in a short sentence when it is the fact, not for effect.
- Register held at one mid-formal pitch throughout.

Words and phrases

- Filler connectives: "Note that", "It's worth noting", "Importantly",
  "In essence", "Overall", "In conclusion", "Additionally", "Net:",
  "Net-net".
- Marketing and inflation vocabulary: robust, comprehensive, seamless,
  powerful, elegant, blazing, vibrant, rich, profound, groundbreaking,
  renowned, meticulous, intricate, nuanced, pivotal, crucial, key (as an
  adjective), testament, tapestry, landscape, interplay, delve, leverage
  (verb), utilize, showcase, boasts, garner, bolster, foster, cultivate,
  enhance, empower, underscore, "stands as", "serves as", "marks a".
- Copulative avoidance: "serves as", "functions as", "represents",
  "features", "offers" where "is", "are", "has" would do.
- Shallow participial riders bolted onto facts: "highlighting",
  "underscoring", "reflecting", "emphasizing", "ensuring", "symbolizing".
  Keep only when the source says so.
- Vague attribution: "experts argue", "observers note", "industry reports",
  "some critics". Name the person or cut.
- Vague connection: "associated with", "in connection with". Say what the
  relation is.
- Sycophantic framing: "the good news is", "this is entirely fixable".
- Aphorisms dressed as insight: "at its core", "the language of", "X is the
  new Y".
- Chatbot residue: "I hope this helps", "let me know", closing offers,
  "as of my last update", any knowledge-cutoff disclaimer.
- Writing about the document instead of the subject: "this section
  covers", "as discussed above", "the write-up says so". Say the thing.
- Comments that narrate the obvious or talk to a reviewer ("now we
  correctly handle...").
- Summary paragraphs restating what was just said.
- Praise of the code, the author, or the question.
- AI attribution: no Co-Authored-By model trailers, no "Generated with"
  footers, anywhere in the repo or its history.

Cleaning a draft

1. Read the whole thing once and mark tells, strongest first. One instance
   of a negative parallelism, a closer, a staged run-up, or an aphorism is
   enough to mark.
2. Redraft without treating the original structure as fixed. Merge or split
   paragraphs, drop labels, reorder. Add no fact, name, date, number or
   citation that is not in the source.
3. Check the draft against the original for dropped or added claims.
4. Read it aloud. Search for the survivors: contrasts, closers, triads,
   colons as reveals, bold lead-ins, "which is what X is for".
5. The test: would the sentence survive in a Bellard changelog? "added
   resizable array buffers" survives. "Significantly enhanced the array
   buffer functionality to support seamless resizing" does not.

Grep for the fast ones before committing:

    grep -nE "not (just|only|merely) |, but (also )?|rather than|Net:|Stated plainly|Here is what|The catch|In essence|Importantly|It's worth|worth noting|serves as|stands as|underscor|highlight|robust|comprehensive|leverage|delve|nuanced|pivotal|testament" FILE
