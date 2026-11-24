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

1. Present track scenarios (S3 / SG / runaway / all three); learner runs `~/eda-lab/bin/select-track.sh` to write `~/eda-lab/track` and clone the workshop from Gitea.
2. Explain source, condition, and action; edit `rulebooks/alert-response.yml` in the terminal for the chosen track (or all three rules), then commit and push to Gitea.
3. Create an Automation Controller project pointing at the Gitea repo (playbooks / Job Templates).
4. Create an Event-Driven Ansible project pointing at the same Gitea repo (rulebooks); sync and confirm `alert-response.yml`.
5. Create a rulebook activation for that rulebook; ensure it reaches running state.
6. Run the track-specific injector happy-path payload (loop s3/sg/ec2 if track is `all`).
7. In Rule Audit, locate the matching event(s) and confirm the Job Template launched.
8. Checkpoint: track marker set, rulebook on disk, activation path ready for later modules.

### Key Takeaways

- EDA reacts to events; it does not replace the Job Template itself
- One rulebook activation listens continuously
- Rule Audit is the evidence trail for matches
- Track choice only changes the alert and target JT—not the EDA model

### Infrastructure Notes

- AAP 2.6 with Controller + EDA; pre-created remediate JTs per track
- Floci API route reachable from AAP execution nodes on TCP 443; bucket and security group are seeded by the container
- Alert injector available in the student terminal
