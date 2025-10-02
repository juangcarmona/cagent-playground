param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Query
)

$repoRoot   = Split-Path -Parent $MyInvocation.MyCommand.Path
$agentFile  = Join-Path $repoRoot "agent.yaml"
$envFile    = Join-Path $repoRoot ".env"

if (-not (Test-Path $agentFile)) {
  Write-Host "Agent not found: $agentFile"
  exit 1
}

# Build arguments for cagent
$cagentArgs = @("run", $agentFile, $Query, "--tui=false", "--yolo")

if (Test-Path $envFile) {
  $cagentArgs += @("--env-from-file", $envFile)
}

Write-Host "Running search agent for query: '$Query'"
& cagent @cagentArgs

