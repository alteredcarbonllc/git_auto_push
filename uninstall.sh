#!/bin/bash

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be executed with root privileges."
  exit 1
fi

# Paths to files
GIT_AUTO_PUSH_SCRIPT="/usr/local/bin/git_auto_push.sh"
CONFIG_FILE="/etc/git_auto_push.conf"
SERVICE_FILE="/etc/systemd/system/git_auto_push.service"
TIMER_FILE="/etc/systemd/system/git_auto_push.timer"

# Stop and disable the timer and service
echo "Stop and disable the timer and service..."
systemctl stop git_auto_push.timer git_auto_push.service
systemctl disable git_auto_push.timer git_auto_push.service

# Check if the configuration file is empty
if [[ -s "$CONFIG_FILE" ]]; then
  echo "The configuration file $CONFIG_FILE is not empty."
else
  echo "Deleting the configuration file..."
  rm -f "$CONFIG_FILE"
fi

# Deleting script, service, and timer files
echo "Deleting files..."
rm -f "$GIT_AUTO_PUSH_SCRIPT" "$SERVICE_FILE" "$TIMER_FILE"

# Reloading systemd
echo "Reloading systemd..."
systemctl daemon-reload

echo "Removal completed!"
