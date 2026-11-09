# Module 03 — Guardrails: when not to act

### Brief Overview

Learners harden the same rulebook so not every alert causes remediation. They add environment and severity conditions, inject noisy or out-of-scope events for their chosen track, and use Rule Audit to show that the platform correctly skipped those events.

### Audience and Time

- **Audience:** Learners who completed Event Streams setup
- **Prerequisites:** Modules 01–02 complete
- **Duration:** ~25 minutes

### Learning Objectives

- Implement environment and severity conditions that skip noisy or out-of-scope alerts
- Demonstrate a non-matching (skip) path for the chosen track in Rule Audit
- Keep the happy-path match working after guardrails are added

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Shared: why guardrails matter in production | 5 min |
| 2 | Add env and severity conditions to the rulebook | 8 min |
| 3 | Track procedures: inject noise / wrong env | 7 min |
| 4 | Re-test happy path; read skip vs match in Rule Audit | 5 min |

### Detailed Steps

1. Discuss false positives and blast radius without deep throttle (throttle is stretch only).
2. Edit the evolving rulebook: require `env=prod` (or equivalent) and appropriate `severity` for action.
3. **Track A/B/C:** Inject low-severity and/or staging payloads for the track `alertname`; confirm no remediate job.
4. **Track A/B/C:** Re-inject prod/critical happy path; confirm match still fires.
5. In Rule Audit, contrast skip/no-action vs successful match.
6. Checkpoint: noise skipped; happy path still remediates for the chosen track.

### Key Takeaways

- Conditions encode when *not* to automate
- Guardrails belong in the rulebook, not only in human process
- Rule Audit explains both action and inaction

### Infrastructure Notes

- Injector supports env/severity variants per track
- No additional VMs beyond AAP + Floci
