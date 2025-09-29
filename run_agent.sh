#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <agent-name> [--no-tty]"
  exit 1
fi

AGENT_NAME="$1"
NO_TTY_FLAG="${2:-}"

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
AGENT_FILE="$REPO_ROOT/agents/$AGENT_NAME/agent.yaml"
ENV_FILE="$REPO_ROOT/.env"

if [ ! -f "$AGENT_FILE" ]; then
  echo "Agent not found: $AGENT_FILE"
  exit 1
fi

echo "Running agent: $AGENT_NAME"

if [ -f "$ENV_FILE" ]; then
  exec cagent run "$AGENT_FILE" --env-from-file "$ENV_FILE" $NO_TTY_FLAG
else
  OPENAI_API_KEY=dummy exec cagent run "$AGENT_FILE" $NO_TTY_FLAG
fi
