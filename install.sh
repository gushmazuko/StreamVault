#!/usr/bin/env bash

# StreamVault Installer
# This script installs StreamVault and its dependencies

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# GitHub raw URL for the main script
SCRIPT_URL="https://raw.githubusercontent.com/gushmazuko/streamvault/refs/heads/main/streamvault.sh"
INSTALL_DIR="$HOME/.streamvault"

echo -e "${YELLOW}StreamVault Installer${NC}"
echo "================================"

# Create installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating installation directory..."
    mkdir -p "$INSTALL_DIR"
fi

# Function to install package based on package manager
install_deps() {
    if command -v brew >/dev/null; then
        echo "Installing dependencies with Homebrew..."
        brew install python ffmpeg
    elif command -v pkg >/dev/null; then
        echo "Installing dependencies with pkg (Termux)..."
        pkg install -y python python-pip ffmpeg
    elif command -v apt-get >/dev/null; then
        echo "Installing dependencies with apt..."
        apt install -y python python-pip ffmpeg
    elif command -v dnf >/dev/null; then
        echo "Installing dependencies with dnf..."
        dnf install -y python python-pip ffmpeg
    elif command -v pacman >/dev/null; then
        echo "Installing dependencies with pacman..."
        pacman -S --noconfirm python python-pip ffmpeg
    else
        echo -e "${YELLOW}Could not install dependencies automatically."
        echo "Please install python, pip, and ffmpeg manually.${NC}"
    fi
}

# Check and install dependencies if needed
echo "Checking dependencies..."
missing_deps=()
for dep in python ffmpeg; do
    if ! command -v "$dep" >/dev/null; then
        missing_deps+=("$dep")
    fi
done

if [ ${#missing_deps[@]} -ne 0 ]; then
    echo "Missing dependencies: ${missing_deps[*]}"
    install_deps
fi

# Install yt-dlp using pip
echo "Installing yt-dlp..."
if ! command -v yt-dlp >/dev/null; then
    python -m pip install --user --upgrade yt-dlp
fi

# Download StreamVault script using curl or python
echo "Downloading StreamVault..."
if command -v curl >/dev/null; then
    curl -sSL "$SCRIPT_URL" -o "$INSTALL_DIR/streamvault.sh"
else
    python -c "import urllib.request; urllib.request.urlretrieve('$SCRIPT_URL', '$INSTALL_DIR/streamvault.sh')"
fi

if [ -f "$INSTALL_DIR/streamvault.sh" ]; then
    chmod +x "$INSTALL_DIR/streamvault.sh"
    # Create symlink
    ln -sf "$INSTALL_DIR/streamvault.sh" "$HOME/streamvault"
    echo -e "${GREEN}StreamVault has been successfully installed!${NC}"
else
    echo -e "${RED}Failed to download StreamVault${NC}"
    exit 1
fi

# Final instructions
echo
echo -e "${YELLOW}Installation completed!${NC}"
echo "StreamVault is installed at: $INSTALL_DIR/streamvault.sh"
echo "A symlink has been created at: $HOME/streamvault"
echo
echo "You can run StreamVault in these ways:"
echo "1. ./streamvault (from your home directory)"
echo "2. \$HOME/streamvault (from anywhere)"
echo "3. \$INSTALL_DIR/streamvault.sh (direct script)"
echo
echo "Optional: To run 'streamvault' from anywhere, you can:"
echo "Add this line to your ~/.bashrc or ~/.zshrc:"
echo "export PATH=\"\$HOME/.streamvault:\$PATH\""
echo