# Ask Gemini a one-shot question from the project root.
# Usage:  .\scripts\ask-gemini.ps1 "Review @index.html and @style.css for accessibility. Numbered list."
#         add -Log to append the answer to HANDOFF.md
param(
  [Parameter(Mandatory = $true)][string]$Question,
  [switch]$Log
)

$root = Split-Path $PSScriptRoot -Parent
Push-Location $root
try {
  if (-not (Get-Command gemini -ErrorAction SilentlyContinue)) {
    throw "Gemini CLI not found. Install it (see SETUP.md step 1) and run 'gemini' once to sign in."
  }
  $answer = (gemini -p $Question) -join "`n"
  Write-Output $answer
  if ($Log) {
    $entry = "`n## $(Get-Date -Format 'yyyy-MM-dd') - Gemini (asked via ask-gemini)`nQuestion: $Question`n`n$answer`n"
    Add-Content -Path HANDOFF.md -Value $entry -Encoding utf8
  }
}
finally { Pop-Location }
