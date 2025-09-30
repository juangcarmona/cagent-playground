#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <agent-name> [--no-tty]"
  exit 1
fi

AGENT_NAME="$1"
shift

NO_TTY=false
if [ "${1:-}" = "--no-tty" ]; then
  NO_TTY=true
  shift
fi

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
AGENT_FILE="$REPO_ROOT/agents/$AGENT_NAME/agent.yaml"
ENV_FILE="$REPO_ROOT/.env"

if [ ! -f "$AGENT_FILE" ]; then
  echo "Agent not found: $AGENT_FILE"
  exit 1
fi

echo "Running agent: $AGENT_NAME"

# build args
cagent_args=( run "$AGENT_FILE" )

if [ -f "$ENV_FILE" ]; then
  cagent_args+=( --env-from-file "$ENV_FILE" )
else
  export OPENAI_API_KEY=dummy
fi

if [ "$NO_TTY" = true ]; then
  cagent_args+=( --no-tty )
fi

exec cagent "${cagent_args[@]}"
