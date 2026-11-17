#!/usr/bin/env bash
# Re-seed a single Floci track to the bad state.
set -euo pipefail
TRACK="${1:-}"
if [[ -z "$TRACK" ]]; then
  echo "Usage: $0 s3|sg|ec2" >&2
  exit 1
fi
if [[ -z "${FLOCI_ENDPOINT:-}" ]]; then
  if [[ -z "${GUID:-}" || -z "${DOMAIN:-}" ]]; then
    echo "Set FLOCI_ENDPOINT, or set GUID and DOMAIN, so the script can reach the Floci route" >&2
    exit 1
  fi
  FLOCI_ENDPOINT="https://floci-${GUID}.${DOMAIN}"
fi
PLAYBOOK="${HOME}/eda-lab/materials/playbooks/reset_track.yml"
if [[ ! -f "$PLAYBOOK" ]]; then
  PLAYBOOK="/usr/local/share/eda-lab/playbooks/reset_track.yml"
fi
ansible-playbook "$PLAYBOOK" -e "track=${TRACK}" -e "floci_endpoint=${FLOCI_ENDPOINT}"
