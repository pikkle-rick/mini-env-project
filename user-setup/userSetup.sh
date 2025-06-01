#!/bin/bash

# create_expensify_user.sh
# Run this on the remote host as root or with sudo

set -e

KEY_FILE="/tmp/tempkey.pub"

# Validate the key file
if [[ ! -f "$KEY_FILE" ]]; then
  echo "ERROR: Public key file $KEY_FILE not found."
  exit 1
fi

# Create the user if it doesn't exist
if ! id "expensify" &>/dev/null; then
  echo "Creating user 'expensify'..."
  useradd -m -s /bin/bash expensify
fi

# Add user to sudo group
echo "Adding 'expensify' to sudoers..."
usermod -aG sudo expensify

# Set up SSH authorized_keys
echo "Setting up SSH keys..."
mkdir -p /home/expensify/.ssh
cp "$KEY_FILE" /home/expensify/.ssh/authorized_keys
chown -R expensify:expensify /home/expensify/.ssh
chmod 700 /home/expensify/.ssh
chmod 600 /home/expensify/.ssh/authorized_keys

# Optional: Remove the key file
rm -f "$KEY_FILE"

echo "User 'expensify' created and SSH key installed."
