# Portfolio site: shared rules for Claude and Gemini

This repo is a personal "about me" website hosted on GitHub Pages
(`https://<github-username>.github.io`). Two AI agents work on it together.
Both agents read this file first.

## The goal
A fast, simple, good-looking single-page site that describes the owner:
who they are, what they do, projects, skills and how to contact them.

## Tech rules (keep it simple so GitHub Pages serves it with no build step)
- Plain HTML + CSS (+ a little vanilla JS if really needed). No frameworks, no build tools.
- Entry point is `index.html` in the repo root. Styles in `style.css`. Images in `assets/`.
- Mobile-first, responsive, accessible (semantic tags, alt text, good contrast).
- Never invent facts about the owner. If info is missing, leave a clear `TODO:` placeholder
  and list the question in HANDOFF.md.

## Roles
| Agent  | Main job |
|--------|----------|
| Claude | Lead developer: writes and edits the code, keeps the structure clean, commits. |
| Gemini | Designer and reviewer: proposes layout/visual ideas, reviews code and copy, checks accessibility and mobile layout. |

Either agent may disagree with the other. Say why, briefly, in HANDOFF.md.

## How the two agents talk to each other
1. **Directly (one-shot questions):**
   - Claude asks Gemini:  `gemini -p "Review index.html and style.css for design and accessibility issues. Reply with a numbered list."`
   - Gemini asks Claude:  `claude -p "Implement item 2 from the latest Gemini review in HANDOFF.md."`
   - Helper scripts: `scripts/ask-gemini.ps1 "<question>" -Log` (one question, answer logged to HANDOFF.md)
     and `scripts/round.ps1 -Rounds N` (runs the Gemini review -> Claude implement loop N times).
2. **Through HANDOFF.md (longer work):** after each turn, append an entry at the
   bottom of HANDOFF.md using the template there. The next agent reads the latest entry first.

## Workflow loop
1. Gemini proposes or reviews -> writes a HANDOFF entry.
2. Claude implements -> runs a quick check (open index.html) -> commits -> writes a HANDOFF entry.
3. Repeat. Stop after 3 rounds without new ideas, and ask the owner.

## Git rules
- Small commits with clear messages, e.g. `feat: add projects section`.
- Commit before any large change so it can be rolled back.
- Only the owner pushes to GitHub unless they say otherwise.
