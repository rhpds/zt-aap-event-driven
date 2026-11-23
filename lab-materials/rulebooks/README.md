# Rulebook materials

- `alert-response.starter.yml` — Module 1 starting point (webhook + single match)
- `alert-response.final.example.yml` — reference end state with env/severity guardrails

Setup installs this tree to `/usr/local/share/eda-lab/` and `~/eda-lab/materials/`.
Sibling paths under those roots: `bin/` (inject/reset scripts) and `playbooks/reset_track.yml`.

In the live lab, Event Streams usually replace the webhook source via the activation /
credential binding in AAP rather than a different YAML file name. Follow Module 2 UI steps.
