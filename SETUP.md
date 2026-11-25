# Setup on Windows (one time, about 15 minutes)

## 1. Install the tools
Open **PowerShell** and run each line (skip anything you already have):

```powershell
winget install Git.Git
winget install OpenJS.NodeJS.LTS
# Claude Code
irm https://claude.ai/install.ps1 | iex
# Gemini CLI
npm install -g @google/gemini-cli
```
Close and reopen PowerShell, then check:
```powershell
git --version; claude --version; gemini --version
```
Run `claude` once and `gemini` once to sign in to each.

## 2. Put this project in place
Your project lives in `C:\Users\Admin\OneDrive\Documents\Portfolio`. Open PowerShell there:
```powershell
cd $HOME\OneDrive\Documents\Portfolio
```
Git is already initialized here with a first commit on branch `main`.

## 3. Create the GitHub repo
1. On github.com create a **public** repo named exactly `<your-username>.github.io`
   (no README, so it stays empty).
2. Connect and push:
```powershell
git remote add origin https://github.com/<your-username>/<your-username>.github.io.git
git push -u origin main
```
3. Repo **Settings -> Pages**: Source = "Deploy from a branch", branch `main`, folder `/ (root)`.
   After a minute the site is live at `https://<your-username>.github.io`.

## 4. Start the two agents working together
Open two PowerShell windows in the project folder.

**Window 1 - Gemini (designer):**
```powershell
gemini
```
> Read GEMINI.md and HANDOFF.md, then do the next step for Gemini.

**Window 2 - Claude (developer):**
```powershell
claude
```
> Read HANDOFF.md and implement Gemini's latest suggestions. Ask Gemini with `gemini -p` if anything is unclear.

Claude can also call Gemini by itself (`gemini -p "..."`) with no second window, so for
quick work you only need Window 2.

### Or let them run the loop by themselves
Allow local scripts once (current user only):
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```
Then run up to 3 rounds:
```powershell
.\scripts\round.ps1 -Rounds 3
```
Each round, Gemini reviews and writes a HANDOFF entry, then Claude implements it, commits and
writes its own entry. The loop stops early when Gemini writes "NO NEW IDEAS".
For one quick question: `.\scripts\ask-gemini.ps1 "Review @index.html for contrast issues" -Log`

### Or use Antigravity as the Gemini side (no API billing needed)
Antigravity's agent reads `GEMINI.md` and `AGENTS.md` by itself, and this repo ships an
Antigravity skill in `.agents/skills/claude-loop/`.
1. Open this folder in Antigravity IDE.
2. In the agent panel, type:
   > Run the claude-loop skill for 3 rounds.
3. The agent reviews the site, writes a HANDOFF entry, then runs
   `scripts/ask-claude.ps1` so Claude Code implements and commits. Approve the terminal
   command when Antigravity asks.

Tip: this folder is inside OneDrive. If OneDrive ever fights with the `.git` folder,
pause syncing while you work, or move the project outside OneDrive.

## 5. Publish updates
```powershell
git push
```
GitHub Pages redeploys automatically in about a minute.
