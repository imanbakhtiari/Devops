#!/bin/bash

# Exit on any error
set -e

# Update package list
echo "Updating package list..."
sudo apt update

# Add the GitLab Runner repository
echo "Adding GitLab Runner repository..."
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

# Install GitLab Runner
echo "Installing GitLab Runner..."
sudo apt install -y gitlab-runner

# Verify the installation
echo "Verifying GitLab Runner installation..."
gitlab-runner --version

echo "GitLab Runner installation completed successfully."

