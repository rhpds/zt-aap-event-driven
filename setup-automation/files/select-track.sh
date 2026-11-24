#!/usr/bin/env bash
# Interactive track picker for the EDA Zero-Touch lab.
# Writes ~/eda-lab/track, clones the lab repo from Gitea, and prepares
# rulebooks/alert-response.yml for terminal editing before push + AAP sync.
set -euo pipefail

EDA_LAB="${HOME}/eda-lab"
TRACK_FILE="${EDA_LAB}/track"
CLONE_DIR="${EDA_LAB}/workshop"
RULEBOOK_LINK="${EDA_LAB}/rulebooks/alert-response.yml"
LAB_ENV="${EDA_LAB}/lab.env"
SYSTEM_LAB_ENV="/usr/local/share/eda-lab/lab.env"

GITEA_USER="${GITEA_USER:-gitea}"
GITEA_PASS="${GITEA_PASS:-ansible123!}"
GITEA_REPO_URL="${GITEA_URL:-}"

# Lab URLs are written at provision time — students never need GUID/DOMAIN.
load_lab_env() {
  local env_file=""
  if [[ -f "${LAB_ENV}" ]]; then
    env_file="${LAB_ENV}"
  elif [[ -f "${SYSTEM_LAB_ENV}" ]]; then
    env_file="${SYSTEM_LAB_ENV}"
  else
    return 1
  fi
  # shellcheck disable=SC1090
  set -a
  # shellcheck disable=SC1090
  source "${env_file}"
  set +a
  return 0
}

load_lab_env || true

GITEA_USER="${GITEA_USER:-gitea}"
GITEA_PASS="${GITEA_PASS:-ansible123!}"
GITEA_REPO_URL="${GITEA_URL:-${GITEA_REPO_URL:-}}"

if [[ -z "${GITEA_REPO_URL}" ]]; then
  echo "Gitea repo URL was not provisioned into ${LAB_ENV}." >&2
  echo "Open the Gitea tab, copy the repo HTTPS URL, and paste it below" >&2
  echo "(example: https://gitea-….apps.…/gitea/event-driven-aap-workshop.git)" >&2
  read -r -p "Gitea repo URL: " GITEA_REPO_URL
  GITEA_REPO_URL="${GITEA_REPO_URL%.git}.git"
fi

# Build an authenticated clone URL from the public HTTPS URL (lab password only).
gitea_host_path="${GITEA_REPO_URL#https://}"
gitea_host_path="${gitea_host_path#http://}"
GITEA_CLONE_URL="https://${GITEA_USER}:${GITEA_PASS}@${gitea_host_path}"
GITEA_PUSH_URL="https://${GITEA_USER}@${gitea_host_path}"

mkdir -p "${EDA_LAB}/rulebooks" "${EDA_LAB}/bin"

cat <<'EOF'

╔══════════════════════════════════════════════════════════════╗
║  Event-Driven Ansible lab — choose your Floci track          ║
╚══════════════════════════════════════════════════════════════╝

Each track is the same EDA pattern (source → condition → action).
Only the alert name, Job Templates, and Floci resource change.

  1) S3 public exposure
     A storage bucket is world-readable. You match S3PublicExposure,
     enable Block Public Access, and verify BPA on Floci.

  2) Open security group
     A security group allows wide 0.0.0.0/0 ingress. You match
     OpenSecurityGroup, quarantine/revoke the open rules, and verify.

  3) Runaway instance
     An EC2-like instance is running out of policy. You match
     RunawayInstance, stop it (with quarantine tags), and verify state.

  4) All three examples
     Build one rulebook with rules for S3, SG, and runaway instance.
     You will exercise each alert path (longer than a single track).

  Tip: If unsure, pick 1 (S3) — it is the simplest Floci path.

EOF

TRACK=""
while [[ -z "${TRACK}" ]]; do
  read -r -p "Select track [1-4]: " choice
  case "${choice}" in
    1|s3|S3) TRACK="s3" ;;
    2|sg|SG) TRACK="sg" ;;
    3|ec2|EC2) TRACK="ec2" ;;
    4|all|ALL) TRACK="all" ;;
    *) echo "Enter 1, 2, 3, or 4." ;;
  esac
done

printf '%s\n' "${TRACK}" > "${TRACK_FILE}"
echo "Wrote track marker: ${TRACK_FILE} → ${TRACK}"

if [[ -d "${CLONE_DIR}/.git" ]]; then
  echo "Workshop clone already exists at ${CLONE_DIR} — pulling latest..."
  git -C "${CLONE_DIR}" pull --ff-only || true
else
  echo "Cloning ${GITEA_REPO_URL} → ${CLONE_DIR}"
  rm -rf "${CLONE_DIR}"
  git clone "${GITEA_CLONE_URL}" "${CLONE_DIR}"
  # Drop embedded credentials from the stored remote URL.
  git -C "${CLONE_DIR}" remote set-url origin "${GITEA_REPO_URL}"
fi

STARTER="${CLONE_DIR}/rulebooks/alert-response.starter.yml"
TARGET="${CLONE_DIR}/rulebooks/alert-response.yml"

if [[ ! -f "${STARTER}" ]]; then
  echo "Missing starter rulebook at ${STARTER}" >&2
  exit 1
fi

if [[ ! -f "${TARGET}" ]]; then
  cp "${STARTER}" "${TARGET}"
  echo "Created ${TARGET} from starter"
else
  echo "Keeping existing ${TARGET} (delete it and re-run to reset from starter)"
fi

ln -sfn "${TARGET}" "${RULEBOOK_LINK}"
echo "Linked ${RULEBOOK_LINK} → ${TARGET}"

cat <<EOF

Next steps:
  1. Edit the rulebook for your track:
       nano ${TARGET}
       # or: vim ${TARGET}

  2. Commit and push to Gitea (so AAP can sync the project):
       cd ${CLONE_DIR}
       git add rulebooks/alert-response.yml
       git config user.email "student@example.com"
       git config user.name "Lab Student"
       git commit -m "Configure alert-response for track ${TRACK}"
       git push ${GITEA_PUSH_URL} HEAD:main
       # password when prompted: ${GITEA_PASS}

  3. Follow the lab instructions to create Automation Controller and
     Event-Driven Ansible projects pointing at:
       ${GITEA_REPO_URL}

Track selected: ${TRACK}
EOF
