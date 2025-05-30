#!/bin/bash

# Usage: ./deploy_expensify_user_batch.sh <ssh_user> <hosts_file> <path_to_public_key>

set -e

SSH_USER="$1"
HOSTS_FILE="$2"
PUBKEY_FILE="$3"
SETUP_SCRIPT="userSetup.sh"

# --- Validations ---
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <ssh_user> <hosts_file> <path_to_public_key>"
  exit 1
fi

if [[ ! -f "$HOSTS_FILE" ]]; then
  echo "Error: Hosts file '$HOSTS_FILE' not found."
  exit 1
fi

if [[ ! -f "$PUBKEY_FILE" ]]; then
  echo "Error: Public key file '$PUBKEY_FILE' not found."
  exit 1
fi

if [[ ! -f "$SETUP_SCRIPT" ]]; then
  echo "Error: Setup script '$SETUP_SCRIPT' not found in current directory."
  exit 1
fi

# --- Deployment Loop ---
while IFS= read -r REMOTE_IP || [[ -n "$REMOTE_IP" ]]; do
  [[ -z "$REMOTE_IP" || "$REMOTE_IP" =~ ^# ]] && continue  # skip empty lines and comments

  echo -e "\nDeploying to $REMOTE_IP..."

  # Copy files
  scp "$SETUP_SCRIPT" "$PUBKEY_FILE" "${SSH_USER}@${REMOTE_IP}:/tmp/" || {
    echo "Failed to copy files to $REMOTE_IP"
    continue
  }

  REMOTE_KEY_FILE="/tmp/$(basename "$PUBKEY_FILE")"

  # Run setup
  ssh "${SSH_USER}@${REMOTE_IP}" bash <<EOF
    set -e
    sudo mv "$REMOTE_KEY_FILE" /tmp/tempkey.pub
    sudo bash /tmp/$SETUP_SCRIPT
    sudo rm -f /tmp/$SETUP_SCRIPT /tmp/tempkey.pub
EOF

  echo "Setup complete on $REMOTE_IP"

done < "$HOSTS_FILE"
