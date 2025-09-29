param(
  [Parameter(Mandatory=$true)][string]$AgentName,
  [string]$NoTty
)

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$agentFile = Join-Path $repoRoot "agents\$AgentName\agent.yaml"
$envFile   = Join-Path $repoRoot ".env"

if (-not (Test-Path $agentFile)) {
  Write-Host "Agent not found: $agentFile"
  exit 1
}

Write-Host "Running agent: $AgentName"

if (Test-Path $envFile) {
  & cagent run $agentFile "--env-from-file=$envFile" $NoTty
} else {
  # fallback to dummy key so it always runs
  [System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY','dummy','Process')
  & cagent run $agentFile $NoTty
}
