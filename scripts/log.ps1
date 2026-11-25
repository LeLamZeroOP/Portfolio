# Shared helper: append one agent exchange to logs/<date>.md
# Dot-source it:  . "$PSScriptRoot\log.ps1"
function Write-AgentLog {
  param(
    [Parameter(Mandatory = $true)][string]$From,   # who asked, e.g. "Gemini (Antigravity)"
    [Parameter(Mandatory = $true)][string]$To,     # who answered, e.g. "Claude"
    [Parameter(Mandatory = $true)][string]$Prompt,
    [string]$Response,
    [int]$ExitCode = 0
  )
  $dir = Join-Path (Split-Path $PSScriptRoot -Parent) 'logs'
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  $file = Join-Path $dir ("{0}.md" -f (Get-Date -Format 'yyyy-MM-dd'))
  $fence = '````'
  $entry = @"

## $(Get-Date -Format 'HH:mm:ss') - $From -> $To (exit $ExitCode)

**Prompt**
$fence
$Prompt
$fence

**Response**
$fence
$Response
$fence
"@
  Add-Content -Path $file -Value $entry -Encoding utf8
}
