#!/bin/bash

# Checking for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with root privileges."
  exit 1
fi

# Path to the script git_auto_push.sh
GIT_AUTO_PUSH_SCRIPT="/usr/local/bin/git_auto_push.sh"

# Path to the configuration file
CONFIG_FILE="/etc/git_auto_push.conf"

# Checking if the configuration file already exists, if not – creating an empty one
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "The configuration file $CONFIG_FILE not found. Creating a new one..."
  touch "$CONFIG_FILE"
  echo "# Specify directories with Git repositories for auto-commit and auto-push." > "$CONFIG_FILE"
fi

# Copying the git_auto_push.sh script to /usr/local/bin
echo "Copying to /usr/local/bin..."
cp git_auto_push.sh "$GIT_AUTO_PUSH_SCRIPT"
chmod +x "$GIT_AUTO_PUSH_SCRIPT"

# Copying the service and timer files to the appropriate directories
echo "Copying the systemd service and timer files..."
cp git_auto_push.service /etc/systemd/system/
cp git_auto_push.timer /etc/systemd/system/

# Reloading the systemd configuration
echo "Reloading systemd..."
systemctl daemon-reload

# Enabling and starting the timer
echo "Enabling and starting the timer and service..."
systemctl enable git_auto_push.timer
systemctl start git_auto_push.timer

echo "Installation completed successfully!"
