# Start a real Agent Zero cloud computer in GitHub Codespaces

**Status: prepared, NOT live-tested in the owner's Codespaces account.** This is a quick, interactive free-quota trial, not a 24/7 production service. The repository's Cloudflare app remains unchanged.

## ONE-CLICK START (from THIS branch)

https://codespaces.new/marwalfarsi2000/free-agent-manager/tree/trial/agent-zero-codespace

1. Sign in as your personal GitHub account.
2. Select the **2-core** machine (GitHub Free includes 120 core-hours/month, equivalent to ~60 hours on 2 cores, plus 15 GB-month storage).
3. Check your Codespaces billing has a **$0 paid-usage budget with Stop usage enabled**. No payment method is needed to use personal included quota.
4. Click **Create codespace**. GitHub builds the official Docker-in-Docker devcontainer and the postStart script pulls `agent0ai/agent-zero`, starts **one** private Web UI on port **5080**, and mounts persistent Docker volume `agent_zero_usr`.
5. When the Codespaces browser editor opens, open **PORTS**, find port **5080**, ensure Visibility = **Private**, and click the forwarded URL. It uses your GitHub authentication.
6. Complete Agent Zero onboarding in the browser, then configure a free model.

## FREE MODEL — Cloudflare Workers AI (no Modal)

- Visit https://dash.cloudflare.com/ > Workers AI, use the REST API controls to obtain your Account ID and a limited-scope token.
- In Agent Zero's settings select **OpenAI Compatible**. Enter the token under External Services > Other OpenAI-compatible API keys, the API base URL `https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/ai/v1`, and the exact model ID `@cf/zai-org/glm-4.7-flash`. Save and send a simple test prompt.
- Cloudflare's Free plan currently includes 10,000 Neurons/day. This model is among the models available to Workers Free; requests stop when the free quota ends. **Agent Zero ↔ Cloudflare specific tool-call compatibility has not been tested yet.**
- Do not add paid provider API keys or enable paid model fallback.

## FIRST REAL TEST

Ask Agent Zero:

```text
Inside your own isolated cloud Linux workspace:
1. Open a browser to https://example.com and save a screenshot.
2. Build a Python FastAPI POST /webhook/orders endpoint with SQLite duplicate order prevention.
3. Create tests for valid, invalid and duplicate orders using pytest.
4. Install dependencies and actually execute tests; repair failures.
5. Report test commands, output, file paths, screenshot evidence, and remaining blockers.
No customer accounts, production deployment, payments or external commits.
```

Verify actual browser screenshot, files, commands and passing tests; prose alone is not proof.

## Troubleshooting

From the Codespaces terminal:

```bash
docker ps -a --filter name=agent-zero-cloud-test
docker logs --tail 80 agent-zero-cloud-test
docker inspect -f '{{.State.Running}}' agent-zero-cloud-test
```

To restart the trial container manually:

```bash
docker start agent-zero-cloud-test
```

If Codespaces rebuild is needed, run "Codespaces: Rebuild Container" from the Command Palette. The Docker volume is intended to persist across ordinary restarts and rebuilds, but **deleting the Codespace can remove project data**. Export important deliverables or commit safe files to a separate branch. Do NOT grant the agent write credentials before testing and approving operations.

## Limitations and costs

- **No Modal, no Oracle, no paid cloud VPS.**
- Codespaces is a **cloud developer environment**, not a production agent hosting service; it is intended for development/side projects and will automatically stop after idle time (default 30 min; user-adjustable). Maximum Codespace active session length 12h. Running processes stop when Codespace stops. A background task can be interrupted. It is NOT durable autonomous 24/7 operation.
- 120 *core*-hours are not 120 actual hours for a 2-core machine; GitHub quota may already be shared with other Codespaces.
- Cloudflare inference daily allowance is shared with all projects on the same account, so existing Workers AI usage reduces capacity here.
- Docker-in-Docker may exceed quota or memory with multiple browser/desktop agents. The 2-core machine is a trial, not proof of multi-agent scale.
- Keep forwarded port 5080 PRIVATE; use only public test data and a narrowly scoped Cloudflare model token. Never provide personal/client credentials to an autonomous shell/browser agent during trial.
- Check current limits and terms before commercial production usage. For unattended 24/7 work, we will need a separate, durable executor with an appropriate service plan.
- This configuration does not merge Agent Zero into the Cloudflare frontend or create an end-to-end enterprise system; it runs the **official finished agent UI and cloud computer right away**, subject to test.

## References
- https://github.com/agent0ai/agent-zero
- https://github.com/devcontainers/features/tree/main/src/docker-in-docker
- https://docs.github.com/en/codespaces/about-codespaces/what-are-codespaces
- https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle
- https://developers.cloudflare.com/workers-ai/platform/pricing/
- https://developers.cloudflare.com/workers-ai/configuration/open-ai-compatibility/
