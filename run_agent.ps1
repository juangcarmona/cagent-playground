param(
  [Parameter(Mandatory = $true)][string]$AgentName,
  [switch]$NoTty
)

$repoRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$agentFile  = Join-Path $repoRoot "agents\$AgentName\agent.yaml"
$envFile    = Join-Path $repoRoot ".env"

if (-not (Test-Path $agentFile)) {
  Write-Host "Agent not found: $agentFile"
  exit 1
}

Write-Host "Running agent: $AgentName"

# build arguments for cagent
$cagentArgs = @("run", $agentFile)

if (Test-Path $envFile) {
  $cagentArgs += @("--env-from-file", $envFile)
} else {
  [System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY','dummy','Process')
}

if ($NoTty) {
  $cagentArgs += "--no-tty"
}

& cagent @cagentArgs
