# eda_floci_lab collection

Playbooks and roles for the Zero-Touch EDA lab:

- `playbooks/seed_floci.yml` — seed S3 / SG / instance demo resources in Floci
- `playbooks/remediate_*.yml` / `verify_*.yml` — Job Template bodies per track
- `playbooks/reset_track.yml` — restore a single track to the bad state
- `roles/floci_seed` — shared seed tasks

Point AWS modules at Floci with `endpoint_url`. The default is `https://floci-$GUID.$DOMAIN`. Set `FLOCI_ENDPOINT` to override it.
