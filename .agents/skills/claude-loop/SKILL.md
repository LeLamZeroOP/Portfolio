---
name: claude-loop
description: >-
  Runs the design-review loop for this portfolio site with Claude Code as the developer.
  Use this skill when the user asks to start a round, run the loop, review and hand off to Claude,
  or have Claude implement the latest review.
---

# Review -> Claude implements loop

You are the designer and reviewer (see GEMINI.md and AGENTS.md). Claude Code is the
developer and is called from the terminal. Do not make large code edits yourself.

## One round

1. Read the latest entry in `HANDOFF.md`.
2. Review `index.html` and `style.css`: layout, visual design, copy, accessibility,
   mobile layout. Pick at most 5 concrete, numbered suggestions.
   Never invent facts about the owner; anything personal stays a `TODO:`.
3. Append a new entry at the bottom of `HANDOFF.md` using the template there,
   headed `## <today's date> - Gemini (Antigravity)`.
   If you have nothing new to suggest, write `NO NEW IDEAS` in it and stop the loop.
4. Hand off to Claude by running, from the project root:
   `powershell -ExecutionPolicy Bypass -File scripts/ask-claude.ps1`
   (It can take a few minutes. Claude edits, commits and appends its own HANDOFF entry.)
5. Check the result: `git log --oneline -3` should show Claude's new commits, and the last
   `HANDOFF.md` entry should be from Claude. If Claude skipped a suggestion, read why;
   argue back in your next entry only if you still disagree.

## Loop

Repeat rounds until one of these happens, then report to the user:
- you wrote `NO NEW IDEAS`;
- 3 rounds are done (or the number the user asked for);
- Claude's entry lists questions only the owner can answer.

For a single targeted fix instead of a full round:
`powershell -ExecutionPolicy Bypass -File scripts/ask-claude.ps1 "<task for Claude>"`

Never run `git push`; only the owner pushes.
