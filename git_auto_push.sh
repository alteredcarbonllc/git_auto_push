#!/bin/bash

# Reading the configuration file
CONFIG_FILE="/etc/git_auto_push.conf"

# Checking if the configuration file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "The configuration file $CONFIG_FILE was not found."
  exit 1
fi

# Reading the configuration file and iterating through each directory
while IFS= read -r repo_dir; do
  # Skipping empty lines and comments
  if [[ -z "$repo_dir" || "$repo_dir" == \#* ]]; then
    continue
  fi

  # Changing to the directory with the repository
  if [[ -d "$repo_dir" ]]; then
    cd "$repo_dir" || continue

    # Checking for changes
    if [[ -n $(git status --porcelain) ]]; then
      # Adding all changes to the index
      git add .

      # Creating a commit without a message
      git commit --amend --no-edit --date "$(date)"

      # Pushing changes to the remote repository
      git push origin HEAD
    else
      echo "No changes in $repo_dir to commit"
    fi
  else
    echo "The directory $repo_dir does not exist or is not a Git repository."
  fi
done < "$CONFIG_FILE"
