#!/usr/bin/env bash
# Inject Alertmanager-shaped JSON for the chosen lab track.
set -euo pipefail

TRACK=""
ENV_NAME="prod"
SEVERITY="critical"
URL="${EVENT_STREAM_URL:-${WEBHOOK_URL:-http://127.0.0.1:5000/endpoint}}"
TOKEN="${EVENT_STREAM_TOKEN:-}"

usage() {
  echo "Usage: $0 --track s3|sg|ec2 [--env prod|staging] [--severity critical|warning|info] [--url URL] [--token TOKEN]" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --track) TRACK="${2:-}"; shift 2 ;;
    --env) ENV_NAME="${2:-}"; shift 2 ;;
    --severity) SEVERITY="${2:-}"; shift 2 ;;
    --url) URL="${2:-}"; shift 2 ;;
    --token) TOKEN="${2:-}"; shift 2 ;;
    *) usage ;;
  esac
done

[[ -n "$TRACK" ]] || usage

case "$TRACK" in
  s3) ALERT="S3PublicExposure"; RESOURCE="eda-lab-public" ;;
  sg) ALERT="OpenSecurityGroup"; RESOURCE="eda-lab-open" ;;
  ec2) ALERT="RunawayInstance"; RESOURCE="eda-lab-runaway" ;;
  *) echo "Unknown track: $TRACK" >&2; exit 1 ;;
esac

PAYLOAD=$(cat <<EOF
{
  "alertname": "${ALERT}",
  "status": "firing",
  "severity": "${SEVERITY}",
  "env": "${ENV_NAME}",
  "resource_id": "${RESOURCE}",
  "labels": {
    "alertname": "${ALERT}",
    "severity": "${SEVERITY}",
    "env": "${ENV_NAME}",
    "instance": "${RESOURCE}"
  }
}
EOF
)

HDR=(-H "Content-Type: application/json")
if [[ -n "$TOKEN" ]]; then
  HDR+=(-H "Authorization: Bearer ${TOKEN}")
fi

echo "POST ${URL} track=${TRACK} alert=${ALERT} env=${ENV_NAME} severity=${SEVERITY}"
curl -sS -w "\nHTTP %{http_code}\n" "${HDR[@]}" -d "${PAYLOAD}" "${URL}"
