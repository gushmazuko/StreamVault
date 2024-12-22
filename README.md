# StreamVault 🎥

A powerful and user-friendly Bash script for downloading videos and audio from various platforms using yt-dlp.

## Features ✨

- Download videos in best quality
- Choose specific video quality (480p, 720p, 1080p, etc.)
- Extract audio in MP3 format
- Automatic platform detection (Termux/Desktop)
- Download from multiple platforms:
  - YouTube
  - Vimeo
  - TikTok
  - Instagram
  - Twitter
  - And many more!

## Requirements 📋

- python
- python-pip
- ffmpeg
- yt-dlp

## Installation 🚀

### Quick Install (Recommended)

```bash
source <(curl -fsSL https://raw.githubusercontent.com/gushmazuko/streamvault/refs/heads/main/install.sh)
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/gushmazuko/streamvault.git
```

2. Make the script executable:
```bash
chmod +x streamvault/streamvault.sh
```

3. Install dependencies:
```bash
# Termux
pkg install python python-pip ffmpeg

# Debian/Ubuntu
apt install python python-pip ffmpeg

# Fedora
dnf install python python-pip ffmpeg

# Arch Linux
pacman -S python python-pip ffmpeg

# macOS
brew install python python-pip ffmpeg
```

4. Install yt-dlp:
```bash
python -m pip install --user --upgrade yt-dlp
```

## Usage 💻

1. Run the script:
```bash
./streamvault.sh
```

2. Select download type:
   - Best Quality Video
   - Choose Specific Quality
   - Best Audio Only (MP3)

3. Enter the URL when prompted

## Output Location 📂

- Termux: `/storage/emulated/0/Download/`
- Other systems: `/tmp/`

## Contributing 🤝

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/gushmazuko/streamvault/issues).

## Project Description 📌

StreamVault is a versatile media downloader that simplifies the process of downloading videos and audio from various online platforms. Built with Bash and powered by yt-dlp, it provides an intuitive interface for both mobile (Termux) and desktop users. The script automatically detects the environment and adjusts its behavior accordingly, ensuring a seamless experience across different platforms.

### Key Features:

- Multiple quality options
- Progress tracking
- Metadata embedding
- Thumbnail embedding
- Error handling
- Cross-platform support

### Use Cases:

- Download videos for offline viewing
- Extract audio from videos
- Archive media content
- Educational content download
- Content creation

## Acknowledgments 📚

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) project
- All contributors and users
