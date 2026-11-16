#!/bin/bash
# Start the Floci API on 4566 and the console on 4500.
# The console image serves the UI directly. Port 4500 is not published
# until this container is running.
set -euo pipefail

if ! command -v podman >/dev/null 2>&1; then
  dnf install -y podman
fi

if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-port=4566/tcp
  firewall-cmd --permanent --add-port=4500/tcp
  firewall-cmd --reload
fi

podman network exists floci-net || podman network create floci-net

if podman container exists floci; then
  podman start floci
else
  podman run -d --name floci --network floci-net -p 4566:4566 docker.io/floci/floci:latest
fi

if podman container exists floci-ui; then
  podman start floci-ui
else
  podman run -d --name floci-ui --network floci-net -p 4500:4500 \
    -e FLOCI_ENDPOINT=http://floci:4566 \
    -e AWS_ACCESS_KEY_ID=test \
    -e AWS_SECRET_ACCESS_KEY=test \
    -e AWS_DEFAULT_REGION=us-east-1 \
    -e PORT=4500 \
    docker.io/floci/floci-ui:0.7.0
fi

ready=0
for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do
  if curl -fsS -o /dev/null http://127.0.0.1:4500/; then
    ready=1
    break
  fi
  sleep 2
done

if [ "${ready}" -ne 1 ]; then
  echo "Floci UI did not respond on http://127.0.0.1:4500/" >&2
  if podman container exists floci-ui; then
    podman logs floci-ui >&2
  fi
  exit 1
fi
