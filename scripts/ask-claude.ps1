# Hand a task to Claude Code (headless) from the project root.
# Used by Gemini / the Antigravity agent. Claude may edit files and run git add/commit/status/diff only.
# Usage:  .\scripts\ask-claude.ps1                      (implement the latest Gemini HANDOFF entry)
#         .\scripts\ask-claude.ps1 "Fix the nav contrast in style.css"
param([string]$Task)

if (-not $Task) {
  $Task = @'
Read CLAUDE.md, AGENTS.md and the latest Gemini entry in HANDOFF.md.
Implement the suggestions you agree with (say briefly why you skip any).
Never invent facts about the owner; keep TODO placeholders.
Then commit with a clear message, append a Claude entry to HANDOFF.md, and commit that too.
'@
}

$root = Split-Path $PSScriptRoot -Parent
Push-Location $root
try {
  if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    throw "Claude Code CLI not found. See SETUP.md step 1."
  }
  claude -p $Task --permission-mode acceptEdits `
    --allowedTools "Bash(git add:*)" "Bash(git commit:*)" "Bash(git status:*)" "Bash(git diff:*)" "Bash(git log:*)"
  exit $LASTEXITCODE
}
finally { Pop-Location }
