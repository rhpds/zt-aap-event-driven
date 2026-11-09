# Module 01 — Pick your track + first match and activation

### Brief Overview

Learners choose one cloud misconfiguration track (S3, security group, or runaway instance) and keep that choice for the rest of the lab. They create a first Event-Driven Ansible rulebook with a source, condition, and action aimed at their track’s alert, then run it as a rulebook activation on Ansible Automation Platform 2.6 and find the match in Rule Audit.

### Audience and Time

- **Audience:** Beginners to EDA who already know basic Ansible and Job Templates
- **Prerequisites:** Lab environment up; AAP reachable; Floci seeded (all three resources present)
- **Duration:** ~35 minutes

### Learning Objectives

- Select one Floci cloud track and record it for the lab path
- Create a rulebook that matches the chosen track’s alert-shaped event and runs the matching Job Template
- Configure a rulebook activation so the rulebook listens continuously
- Monitor the first match in Rule Audit

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Lab map and choose your track (A/B/C) | 5 min |
| 2 | Shared: EDA source → condition → action | 8 min |
| 3 | Track procedures: first rulebook match | 12 min |
| 4 | Create activation and confirm in Rule Audit | 10 min |

### Detailed Steps

1. Present the three tracks and have the learner pick one (S3 / SG / runaway instance); set track marker for validate.
2. Explain source, condition, and action using a short shared diagram (not track-specific).
3. **Track A/B/C:** Open the starter rulebook; set condition on the track `alertname`; point action at the track remediate Job Template.
4. Create a rulebook activation for that rulebook; ensure it reaches running state.
5. **Track A/B/C:** Run the track-specific injector happy-path payload.
6. In Rule Audit, locate the matching event and confirm the Job Template launched.
7. Checkpoint: activation running + one successful match for the chosen track.

### Key Takeaways

- EDA reacts to events; it does not replace the Job Template itself
- One rulebook activation listens continuously
- Rule Audit is the evidence trail for matches
- Track choice only changes the alert and target JT—not the EDA model

### Infrastructure Notes

- AAP 2.6 with Controller + EDA; pre-created remediate JTs per track
- Floci host reachable from AAP execution nodes; all three seeds present
- Alert injector available on Floci host (or documented from AAP)
