#!/usr/bin/env bash
# Re-seed a single Floci track to the bad state (calls ansible on floci host materials).
set -euo pipefail
TRACK="${1:-}"
if [[ -z "$TRACK" ]]; then
  echo "Usage: $0 s3|sg|ec2" >&2
  exit 1
fi
PLAYBOOK="${HOME}/eda-lab/materials/playbooks/reset_track.yml"
if [[ ! -f "$PLAYBOOK" ]]; then
  PLAYBOOK="/usr/local/share/eda-lab/playbooks/reset_track.yml"
fi
ansible-playbook "$PLAYBOOK" -e "track=${TRACK}" -e "floci_endpoint=${FLOCI_ENDPOINT:-http://127.0.0.1:4566}"
