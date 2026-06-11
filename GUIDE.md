# Building things with an AI agent: the short guide

You don't need to know how to code to use this kit. The agent writes the
code. The kit catches its mistakes automatically. Your job is to say what
you want, try the result, and keep what works.

## You are the producer

The agent has craft and no taste. You have taste and no craft. That makes
you the PRODUCER: you decide what gets made, you judge what comes back, and
you say what's wrong with it until nothing is. You are not the apprentice
here and you are not learning to code. You are directing something that
codes.

Two things follow from this:

**Brief it the way you'd brief a person whose work you trust.** Describe
the experience you want, not the construction. "It should feel like a
Sunday paper, unhurried, nothing competing for attention" is a better
instruction than any technical vocabulary you could guess at. Your own
words work. Don't translate them into what you imagine computer language
sounds like; the translation is the agent's job, and it's good at it.

**Your no is the most valuable thing you bring.** The agent will produce
competent versions of whatever you ask, forever, without fatigue and
without ego. It cannot tell which version is good. That judgment is yours,
it's the one part that can't be delegated, and the whole kit exists to put
results in front of you fast enough for it to operate.

## Starting a project

Copy this folder (or use the template button on GitHub) and tell the agent:

> "Set this project up. Read CLAUDE.md and follow the first-run steps.
> I want to build ___."

That's it. The agent configures everything and will ask you what it needs
to know.

## The loop

1. **Say what you want**, in ordinary words. Small pieces beat big asks:
   "add a button that clears the list" works better than "build the whole
   thing." You can hold the large vision; feed it to the agent a piece at
   a time.
2. **The agent builds it.** Checks run automatically after every change it
   makes. You don't have to do anything.
3. **Try it.** Say "run it" (or type `just run`) and see for yourself.
4. **Keep it.** When it works, say "save". Every save is a snapshot you can
   return to forever, and it backs itself up automatically.
5. **Show it.** Say "ship it" and the result goes to a real address you can
   send to anyone. Work nobody can see has a way of stalling; ship early.

## The five rules

1. **Never accept a skipped check.** If the agent says the check fails but
   it should be fine anyway, it is not fine. Tell it to fix the check.
2. **Save every time it works.** Saves are free and they are your undo.
3. **If something breaks, don't debug. Rewind.** Say: "undo back to the
   last save." Nothing is ever lost.
4. **Never put passwords or keys in the chat or the code.** Tell the agent
   you have a secret and it will set up the right place for it.
5. **If you don't understand, say so.** "Explain that in plain words" is
   always a fair request.

## What this kit does and doesn't do

It makes the agent's work checkable: broken code gets caught the moment
it's written instead of the moment you hit it. It makes every working state
recoverable and every save backed up. It does not make the result
professional software. For anything handling money, health, or other
people's data, have a professional look at it.
