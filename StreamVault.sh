#!/usr/bin/env bash

# StreamVault - Multi-platform Video/Audio Downloader
# Version: 1.0.0
# Author: gushmazuko
# License: MIT
# Repository: https://github.com/gushmazuko/streamvault
#
# Supports: YouTube, Vimeo, TikTok, Instagram, Twitter, and many more platforms

# Cleanup function
cleanup() {
    rm -f /tmp/yt-dlp-*
    exit "${1:-0}"
}

trap cleanup SIGINT SIGTERM

# Function to detect Termux environment
detect_termux() {
    # Check method 1: Directory existence
    if [ -d "/data/data/com.termux" ]; then
        return 0
    fi
    
    # Check method 2: Environment variable
    if [ ! -z "$TERMUX_VERSION" ]; then
        return 0
    fi
    
    # Check method 3: Operating system
    if [ "$(uname -o)" = "Android" ]; then
        return 0
    fi
    
    return 1
}

# Function to validate URL
validate_url() {
    local url=$1
    if [[ ! $url =~ ^https?:// ]]; then
        echo "Error: Invalid URL format. Must start with http:// or https://"
        exit 1
    fi
}

# Check if output directory exists and is writable
check_output_dir() {
    local dir=$(dirname "${output_path}")
    if [ ! -d "$dir" ]; then
        echo "Out put directory does not exist"
    fi
    if [ ! -w "$dir" ]; then
        echo "Error: Output directory not writable"
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    local deps=("yt-dlp" "ffmpeg")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            echo "Error: Required dependency '$dep' not found"
            echo "Please install it using your package manager"
            exit 1
        fi
    done
}

# Set output path based on environment
if detect_termux; then
    echo "Termux environment detected"
    output_path="/storage/emulated/0/Download/%(title)s.%(ext)s"
else
    echo "Standard environment detected"
    output_path="/tmp/%(title)s.%(ext)s"
fi

# Function to download video in best quality
download_best_video() {
    echo "Downloading video in best quality..."
    if ! yt-dlp \
        --progress-template "[%(progress.downloaded_bytes)s/%(progress.total_bytes)s] %(progress._percent_str)s" \
        -f 'bestvideo[ext=mp4]+bestaudio/best' \
        --merge-output-format mp4 \
        --embed-thumbnail \
        --add-metadata \
        --output "$output_path" \
        "$1"; then
        echo "Error: Download failed!"
        exit 1
    fi
}

# Function to list available qualities and download selected quality
choose_and_download_quality() {
    local url=$1
    echo "Fetching available qualities..."
    yt-dlp -F "$url"

    read -p "Enter desired video height to download (e.g., 480, 720, 1080): " height
    echo "Downloading video in ${height}p quality..."
    if ! yt-dlp \
        --progress-template "[%(progress.downloaded_bytes)s/%(progress.total_bytes)s] %(progress._percent_str)s" \
        -f "bestvideo[height<=${height}][ext=mp4]+bestaudio/best" \
        --merge-output-format mp4 \
        --embed-thumbnail \
        --add-metadata \
        --output "$output_path" \
        "$url"; then
        echo "Error: Download failed!"
        exit 1
    fi
}

# Function to download only the best audio
download_best_audio() {
    echo "Downloading only the best audio..."
    if ! yt-dlp \
        --progress-template "[%(progress.downloaded_bytes)s/%(progress.total_bytes)s] %(progress._percent_str)s" \
        -f 'bestaudio' \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        --output "$output_path" \
        "$1"; then
        echo "Error: Download failed!"
        exit 1
    fi
}

show_banner() {
    echo "╔═══════════════════════════════════════╗"
    echo "║           StreamVault v1.0.0          ║"
    echo "║ Universal Media Downloader via yt-dlp ║"
    echo "╚═══════════════════════════════════════╝"
}

# Main script starts here
show_banner
check_dependencies
check_output_dir

echo "Downloads will be saved to: $(dirname "${output_path}")"
echo
echo "Select download type:"
echo "1. Download Best Quality Video"
echo "2. List Qualities and Choose for Download"
echo "3. Download Best Audio Only (MP3)"
echo "q. Quit"
echo

while true; do
    read -p "Enter your choice (1-4 or q): " choice
    case $choice in
        q|Q) exit 0 ;;
        1|2|3) break ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done

if [ "$choice" = "4" ]; then
    yt-dlp --list-extractors
    exit 0
fi

# Get URL
while true; do
    read -p "Enter media URL: " url
    validate_url "$url"
    break
done

case $choice in
    1) download_best_video "$url" ;;
    2) choose_and_download_quality "$url" ;;
    3) download_best_audio "$url" ;;
esac

echo "Download completed successfully!"
