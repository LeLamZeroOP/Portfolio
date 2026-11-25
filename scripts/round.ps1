# Run the Gemini -> Claude workflow loop automatically.
# Each round: Gemini reviews the site and writes a HANDOFF entry,
# then Claude implements it, commits, and writes its own HANDOFF entry.
# Usage:  .\scripts\round.ps1            (one round)
#         .\scripts\round.ps1 -Rounds 3  (three rounds; stop early if Gemini has no new ideas)
param([int]$Rounds = 1)

. "$PSScriptRoot\log.ps1"
$root = Split-Path $PSScriptRoot -Parent
Push-Location $root
try {
  foreach ($tool in 'gemini', 'claude', 'git') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
      throw "'$tool' not found. See SETUP.md step 1."
    }
  }

  $geminiTask = @'
Read GEMINI.md, AGENTS.md and the latest entry in HANDOFF.md.
Then do your next step as designer/reviewer: review index.html and style.css and give
at most 5 numbered, concrete suggestions. Append them as a new HANDOFF.md entry using the
template (Gemini). Do not edit any other file. If you have no new ideas, write
"NO NEW IDEAS" in the entry.
'@

  for ($i = 1; $i -le $Rounds; $i++) {
    Write-Host "=== Round $i / $Rounds : Gemini reviewing ===" -ForegroundColor Cyan
    gemini -p $geminiTask --approval-mode auto_edit 2>&1 | ForEach-Object { "$_" } | Tee-Object -Variable gemOut
    Write-AgentLog -From 'round.ps1' -To 'Gemini' -Prompt $geminiTask -Response ($gemOut -join "`n") -ExitCode $LASTEXITCODE
    if ((Get-Content HANDOFF.md -Raw) -match 'NO NEW IDEAS\s*$') {
      Write-Host "Gemini has no new ideas. Stopping - time for the owner to review." -ForegroundColor Yellow
      break
    }

    Write-Host "=== Round $i / $Rounds : Claude implementing ===" -ForegroundColor Green
    # Run in a child PowerShell: ask-claude.ps1 ends with 'exit', which would stop this loop.
    powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\ask-claude.ps1" -From 'Gemini (round.ps1)'
  }

  Write-Host "`nDone. Open index.html to check, then 'git push' when you are happy." -ForegroundColor Cyan
}
finally { Pop-Location }
