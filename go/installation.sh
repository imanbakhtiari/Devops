#!/bin/bash

# Set variables
GO_VERSION="1.23.4"  # Change to the latest version if needed
GO_TAR="go$GO_VERSION.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/$GO_TAR"
INSTALL_DIR="/usr/local"
PROFILE_FILE="$HOME/.bashrc"  # Change to ~/.zshrc if using Zsh

# Check if Go is already installed
if command -v go &>/dev/null; then
    echo "Go is already installed: $(go version)"
    exit 0
fi

echo "Downloading Go $GO_VERSION..."
wget -q --show-progress "$GO_URL" -O "$GO_TAR"

if [ $? -ne 0 ]; then
    echo "Download failed! Please check the URL or network connection."
    exit 1
fi

echo "Removing any previous Go installation..."
sudo rm -rf "$INSTALL_DIR/go"

echo "Extracting Go..."
sudo tar -C "$INSTALL_DIR" -xzf "$GO_TAR"

# Add Go to PATH
echo "Configuring Go environment..."
echo "export PATH=$INSTALL_DIR/go/bin:\$PATH" >> "$PROFILE_FILE"
echo "export GOPATH=\$HOME/go" >> "$PROFILE_FILE"
echo "export PATH=\$GOPATH/bin:\$PATH" >> "$PROFILE_FILE"

# Apply changes
source "$PROFILE_FILE"

# Verify installation
if command -v go &>/dev/null; then
    echo "Go $(go version) installed successfully!"
    rm -f "$GO_TAR"
else
    echo "Go installation failed. Please check the steps manually."
    exit 1
fi

