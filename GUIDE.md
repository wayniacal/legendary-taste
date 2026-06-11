# Building things with an AI agent — the short guide

You don't need to know how to code to use this kit. The agent writes the
code. The kit catches its mistakes automatically. Your job is to say what
you want, try the result, and keep what works.

## Starting a project

Copy this folder (or use the template button on GitHub) and tell the agent:

> "Set this project up. Read CLAUDE.md and follow the first-run steps.
> I want to build ___."

That's it. The agent configures everything and will ask you what it needs
to know.

## The loop

1. **Say what you want**, in ordinary words. Small pieces beat big asks:
   "add a button that clears the list" works better than "build the whole app."
2. **The agent builds it.** Checks run automatically after every change it
   makes — you don't have to do anything.
3. **Try it.** Say "run it" (or type `just run`) and see for yourself.
4. **Keep it.** When it works, say "save". Every save is a snapshot you can
   return to forever.

## The five rules

1. **Never accept a skipped check.** If the agent says "the check fails
   but it should be fine" — it is not fine. Tell it to fix the check.
2. **Save every time it works.** Saves are free and they are your undo.
3. **If something breaks, don't debug — rewind.** Say: "undo back to the
   last save." Nothing is ever lost.
4. **Never put passwords or keys in the chat or the code.** Tell the agent
   you have a secret and it will set up the right place for it.
5. **If you don't understand, say so.** "Explain that in plain words" is
   always a fair request. You're the judge of what the thing should do —
   that part can't be delegated.

## What this kit does and doesn't do

It makes the agent's work *checkable*: broken code gets caught the moment
it's written instead of the moment you hit it. It makes every working state
*recoverable*. It does not make the result professional software — for
anything handling money, health, or other people's data, have a professional
look at it.
