# tutor.md: introducing the PRODUCER

This one is for you, the person setting the kit up for someone else. The
PRODUCER is anyone with deep, proven taste in some other field and no
programming. GUIDE.md is their manual. This is yours: how to hand the thing
over so it takes.

The premise you're working from: taste is a discrimination engine. It works
by seeing the thing and knowing better from worse. Your whole job is to
shorten the path between the PRODUCER saying something and the PRODUCER
seeing the result, then get out of the way. Every choice below follows from
that.

## Before the first session, alone

- Set up their machine completely: mise, Claude Code, GitHub auth, billing.
  Run one small project end to end on their hardware yourself. The first
  session has no budget for environment problems; spend that frustration
  in private.
- The permissions file in `.claude/settings.json` exists so the agent
  doesn't interrupt with approval prompts. Verify it works. Interruptions
  read as the machine asking them questions they can't answer, which is
  the exact feeling this kit exists to prevent.
- Ask them, before the session, to bring some of their material: a list
  they keep, notes, an archive, a collection. Pick the first project from
  that. Not an exercise, not a tutorial app. Their material means their
  judgment fires instantly, and instant judgment is the engine you're
  trying to start.
- Decide where shipped projects live (GitHub Pages is fine) so "ship it"
  works on day one.

## The first session

Sit together. They talk to the agent, not you. The order matters:

1. **The loop.** They describe a small first piece in their own words, the
   agent builds it, they look at it, they react, it changes. Let this run
   until they've felt the rhythm: say, see, react.
2. **The rewind.** Break something on purpose, visibly. Then have them say
   "undo back to the last save" and watch it come back. Do not skip this
   or save it for when it's needed. A person who hasn't seen disaster
   reversed in one sentence works carefully, and careful is the enemy of
   everything this kit is for.
3. **The ship.** Before the session ends, the thing goes to a real URL and
   they send it to someone. Shipped work is real in a way local work
   never becomes.

End at a working, shipped state, however small. A quarter of an idea that
exists beats a whole idea that doesn't.

## The framing to hand them

Give them the producer contract straight, it's the first section of
GUIDE.md: the agent has craft and no taste, they have taste and no craft,
they are directing, not learning to code.

Add the durability point in whatever terms fit the person: everything they
make here is plain text and boring, widely-used technology. It will open
and read in thirty years. It doesn't depend on any company's server staying
alive. People who keep first editions or master tapes understand this
instantly, and it buys real trust in the stack.

## What not to do

- Don't explain the tools. jj, hooks, lanes, toolchains: plumbing. If you
  find yourself explaining version control, you've lost the thread. The
  vocabulary they need is six words: run it, save, ship it, undo.
- Don't polish their prompts. Their phrasing reaches the agent better than
  your translation of it, and correcting how they ask teaches them their
  instincts are wrong here. The instincts are the asset.
- Don't touch the keyboard to fix something. Say what you'd ask the agent
  for, and let them ask it.
- Don't let the first project need accounts, payments, or other people's
  data. Those need a professional, and the first weeks should be free of
  anything that does.

## Your ongoing role

- You own the infrastructure: accounts, costs, kit updates, and a weekly
  glance at GitHub to confirm saves are arriving. They own everything
  visible.
- If they and the agent go in circles for more than fifteen minutes, the
  cause is usually the environment, not their asking. Step in for
  environment problems only, and step back out.
- If a check fights them, the agent fixes the code or the agent is wrong.
  Never resolve a fight by teaching them to weaken a config; that trades
  the kit's honesty for one afternoon's peace.

The measure of success: a few weeks in, they're shipping things you've
never seen, and your name doesn't come up.
