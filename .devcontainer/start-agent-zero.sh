#!/usr/bin/env bash
# Owner-initiated GitHub Codespace starts a single isolated Agent Zero Docker container.
# This file makes NO API model calls, deployments, cloud changes, or billable subscriptions.
set -euo pipefail

NAME="agent-zero-cloud-test"
PORT="5080"
IMAGE="agent0ai/agent-zero"

if ! command -v docker >/dev/null 2>&1; then
  echo "BLOCKED: Docker CLI unavailable. Rebuild the Codespace dev container."
  exit 1
fi

ready=false
for i in $(seq 1 40); do
  if docker info >/dev/null 2>&1; then
    ready=true
    break
  fi
  sleep 2
done
if [ "$ready" != "true" ]; then
  echo "BLOCKED: Docker daemon unavailable. Check the devcontainer Docker-in-Docker feature."
  exit 1
fi

if docker inspect "$NAME" >/dev/null 2>&1; then
  if [ "$(docker inspect -f '{{.State.Running}}' "$NAME")" != "true" ]; then
    docker start "$NAME"
  fi
else
  docker run -d \
    --name "$NAME" \
    --restart unless-stopped \
    -p "127.0.0.1:${PORT}:80" \
    -v agent_zero_usr:/a0/usr \
    "$IMAGE"
fi

if [ "$(docker inspect -f '{{.State.Running}}' "$NAME")" != "true" ]; then
  echo "BLOCKED: Agent Zero container did not start."
  docker logs --tail 70 "$NAME"
  exit 1
fi

echo "Agent Zero container started. This is NOT yet a confirmed working model/browser session."
echo "Open the GitHub Codespaces PORTS panel and the forwarded PRIVATE port 5080."
echo "Finish Agent Zero onboarding, then configure your Cloudflare Workers AI Free model."
echo "Run 'docker logs --tail 80 $NAME' to diagnose initialization."
echo "Do not change forwarded port visibility to Public."
