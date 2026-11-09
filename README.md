# zt-aap-event-driven

Automation answers "what should happen?" but something still has to say when. In this hands-on workshop, you'll learn how Event-Driven Ansible turns that question into code. Using rulebooks, you'll codify your response to real-world events so your infrastructure responds in seconds, without waiting for a human to notice.

You'll start at the command line, building your first rulebook around a webhook source, the simplest way to understand how sources, conditions, and actions work together. From there, you'll bring that rulebook into Ansible Automation Platform 2.6, where rulebook activations run continuously, restart on failure, and record every matching event in the Rule Audit. You'll secure inbound events with Event Streams, then put the platform to work against sources your enterprise already uses: Splunk alerts driving automated response, Kafka event streams fanning out to multiple listeners, and Prometheus metrics triggering targeted remediation.

**Owner:** nmartins0611

---

## What was set up

1. Repository created
2. `catalog-info.yaml` added to repository
3. Registered in Developer Hub catalog
4. Orchestrator workflow started — your AI-guided content pipeline is running!

## What happens next

Claude will walk you through the entire content lifecycle — from intake and spec creation, through Jira tracking and reviews, all the way to a published lab on RHDP. Just follow the prompts!

## Getting started

### DevSpaces (recommended)

1. Open in DevSpaces: `https://devspaces.apps.ocpv-infra02.wdc07.infra.demo.redhat.com#https://github.com/rhpds/zt-aap-event-driven`
2. Use Claude via the **extension** or the **CLI**:
   - **Extension:** Click the **Claude** icon in the sidebar, click **New Session**. If the Claude icon is not visible, open **Extensions** (`Ctrl/Cmd+Shift+X`), find **Claude Code for VS Code** under the DevSpaces section, click it, then click **Enable (Workspace)**.
   - **CLI:** Open a terminal and run `claude`
3. Run `/rhdp-publishing-house` — and you're off!

### Local machine

1. Install the skills:
   ```
   git clone -b prod https://github.com/rhpds/rhdp-publishing-house-skills.git ~/.claude/skills/publishing-house
   ```
2. Clone the repo:
   ```
   git clone https://github.com/rhpds/zt-aap-event-driven
   ```
3. `cd zt-aap-event-driven`
4. Start Claude CLI: `claude`
5. Run `/rhdp-publishing-house` — and you're off!
