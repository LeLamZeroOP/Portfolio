# Hand a task to Claude Code (headless) from the project root.
# Used by Gemini / the Antigravity agent. Claude may edit files and run git add/commit/status/diff/log only.
# The full prompt and Claude's reply are saved to logs/<date>.md.
# Usage:  .\scripts\ask-claude.ps1                      (implement the latest Gemini HANDOFF entry)
#         .\scripts\ask-claude.ps1 "Fix the nav contrast in style.css"
param(
  [string]$Task,
  [string]$From = 'Gemini'
)

if (-not $Task) {
  $Task = @'
Read CLAUDE.md, AGENTS.md and the latest Gemini entry in HANDOFF.md.
Implement the suggestions you agree with (say briefly why you skip any).
Never invent facts about the owner; keep TODO placeholders.
Then commit with a clear message, append a Claude entry to HANDOFF.md, and commit that too.
'@
}

. "$PSScriptRoot\log.ps1"
$root = Split-Path $PSScriptRoot -Parent
Push-Location $root
try {
  if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    throw "Claude Code CLI not found. See SETUP.md step 1."
  }
  # Tee: the reply streams to the terminal and is also kept for the log.
  claude -p $Task --permission-mode acceptEdits `
    --allowedTools "Bash(git add:*)" "Bash(git commit:*)" "Bash(git status:*)" "Bash(git diff:*)" "Bash(git log:*)" `
    2>&1 | ForEach-Object { "$_" } | Tee-Object -Variable captured
  $code = $LASTEXITCODE
  Write-AgentLog -From $From -To 'Claude' -Prompt $Task -Response ($captured -join "`n") -ExitCode $code
  exit $code
}
finally { Pop-Location }
