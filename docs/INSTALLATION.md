# Installation

## System Requirements

### Minimum Requirements
- **Operating System**: 
  - macOS 10.14 (Mojave) or later
  - Windows 10 (Version 1903) or later
  - Linux (Ubuntu 18.04, Debian 10, Fedora 30 or equivalent)
- **Processor**: Intel Core i3 or equivalent
- **Memory**: 512 MB RAM
- **Storage**: 200 MB available space
- **Graphics**: OpenGL 2.0 compatible graphics card
- **Display**: 800x600 resolution minimum

### Recommended Requirements
- **Operating System**: 
  - macOS 11.0 (Big Sur) or later
  - Windows 11
  - Latest Ubuntu/Fedora release
- **Processor**: Intel Core i5 or equivalent
- **Memory**: 1 GB RAM
- **Storage**: 500 MB available space
- **Graphics**: Dedicated graphics card
- **Display**: 1024x768 resolution or higher

### Web Version Requirements
- Modern web browser with HTML5 Canvas support:
  - Chrome 80+
  - Firefox 75+
  - Safari 13+
  - Edge 80+
- JavaScript enabled
- 2 GB available memory

## Installation Methods

### Method 1: Pre-built Binaries (Recommended)

#### macOS Installation
1. **Download**:
   - Intel Mac: [UAP.Invaders.Contact.Protocol-1.0.0.dmg](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0.dmg)
   - Apple Silicon: [UAP.Invaders.Contact.Protocol-1.0.0-arm64.dmg](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0-arm64.dmg)

2. **Install**:
   ```bash
   # Mount the DMG
   hdiutil attach UAP.Invaders.Contact.Protocol-1.0.0.dmg
   
   # Drag to Applications folder
   # Or use command line
   cp -R "/Volumes/UAP Invaders/UAP Invaders.app" /Applications/
   
   # Unmount
   hdiutil detach "/Volumes/UAP Invaders"
   ```

3. **First Run**:
   - Right-click app and select "Open" (macOS Gatekeeper)
   - Click "Open" in security dialog
   - Subsequent launches won't show this dialog

#### Windows Installation
1. **Download**:
   - [UAP.Invaders.Contact.Protocol.Setup.1.0.0.exe](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol.Setup.1.0.0.exe)

2. **Install**:
   - Double-click the installer
   - Follow the installation wizard
   - Choose installation directory (default: `C:\Program Files\UAP Invaders\`)
   - Select "Create desktop shortcut"
   - Click "Install"

3. **Launch**:
   - From Start Menu
   - Or desktop shortcut
   - Or directly: `C:\Program Files\UAP Invaders\UAP Invaders.exe`

#### Linux Installation

**Option A: AppImage (Portable)**
```bash
# Download
wget https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Make executable
chmod +x UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Run
./UAP.Invaders.Contact.Protocol-1.0.0.AppImage
```

**Option B: DEB Package (Debian/Ubuntu)**
```bash
# Download
wget https://github.com/sanchez314c/uap-invaders/releases/latest/download/uap-invaders_1.0.0_amd64.deb

# Install
sudo dpkg -i uap-invaders_1.0.0_amd64.deb

# Fix dependencies if needed
sudo apt-get install -f

# Launch
uap-invaders
```

**Option C: RPM Package (Red Hat/Fedora)**
```bash
# Download
wget https://github.com/sanchez314c/uap-invaders/releases/latest/download/uap-invaders-1.0.0.x86_64.rpm

# Install
sudo rpm -i uap-invaders-1.0.0.x86_64.rpm

# Launch
uap-invaders
```

### Method 2: Web Version (No Installation)

1. **Open Browser**: Navigate to https://sanchez314c.github.io/uap-invaders/
2. **Allow Canvas**: The game will request permission to use the Canvas API
3. **Play Instantly**: No download or installation required

### Method 3: Build from Source

#### Prerequisites
```bash
# Check Node.js version (must be >= 16.0.0)
node --version

# Check npm version (must be >= 8.0.0)
npm --version

# Install Git if not present
# Ubuntu/Debian:
sudo apt-get install git

# macOS (with Homebrew):
brew install git

# Windows (with Chocolatey):
choco install git
```

#### Installation Steps
```bash
# 1. Clone repository
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders

# 2. Install dependencies
npm install

# 3. Run in development mode
npm run dev

# Or build and run
npm run dist
npm start
```

## Verification

### Verify Installation

#### Desktop Version
1. Launch the application
2. You should see:
   - Main menu with "UAP INVADERS" title
   - Callsign input prompt
   - Green military-themed interface
3. Test basic functionality:
   - Enter a callsign
   - Start a game
   - Move mouse to control ship
   - Click to shoot

#### Web Version
1. Open browser to game URL
2. Check console for errors (F12)
3. Verify game loads and is playable

### Command Line Verification
```bash
# Check if Electron app is properly packaged
# macOS:
ls "/Applications/UAP Invaders.app/Contents/MacOS/UAP Invaders"

# Windows:
dir "C:\Program Files\UAP Invaders\UAP Invaders.exe"

# Linux:
which uap-invaders
```

## Configuration

### Default Settings
- **Window Size**: 1024x768
- **Fullscreen**: F11 toggle
- **Controls**: Mouse movement, left-click to shoot
- **High Scores**: Saved locally (top 10)

### Configuration Files
```bash
# macOS
~/Library/Application Support/UAP Invaders/settings.json

# Windows
%APPDATA%/UAP Invaders/settings.json

# Linux
~/.config/UAP Invaders/settings.json
```

### Reset Configuration
```bash
# Delete settings to reset defaults
# macOS:
rm -rf ~/Library/Application\ Support/UAP\ Invaders/

# Windows:
rmdir /s "%APPDATA%\UAP Invaders"

# Linux:
rm -rf ~/.config/UAP-Invaders/
```

## Troubleshooting

### Common Installation Issues

#### macOS: "App can't be opened because Apple cannot check it for malicious software"
```bash
# Solution 1: Right-click and Open
# Right-click app → Open → Click Open

# Solution 2: System Preferences
# System Preferences → Security & Privacy → General → Allow Anyway

# Solution 3: Remove quarantine attribute
xattr -d com.apple.quarantine "/Applications/UAP Invaders.app"
```

#### Windows: "Windows protected your PC"
1. Click "More info"
2. Click "Run anyway"
3. Or: Windows Security → App & browser control → Reputation-based protection → Turn off (temporary)

#### Linux: "Permission denied"
```bash
# Fix permissions
chmod +x UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Or run with explicit interpreter
./UAP.Invaders.Contact.Protocol-1.0.0.AppImage --appimage-extract-and-run
```

#### Build from Source: "npm command not found"
```bash
# Install Node.js
# Ubuntu/Debian:
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# macOS:
brew install node

# Windows:
# Download from https://nodejs.org
```

### Runtime Issues

#### Game Won't Start
1. Check system requirements
2. Update graphics drivers
3. Run as administrator (Windows)
4. Check console for errors

#### Black Screen
1. Verify WebGL/Canvas support
2. Disable hardware acceleration:
   ```bash
   # Linux
   ./UAP.Invaders.AppImage --disable-gpu

   # Windows
   "UAP Invaders.exe" --disable-gpu
   ```

#### No Sound
Sound is not yet implemented. Coming in version 1.1!

#### Poor Performance
1. Close other applications
2. Lower screen resolution
3. Update graphics drivers
4. Try web version if desktop is slow

## Uninstallation

### macOS
```bash
# Drag to Trash from Applications folder
# Or use command line
rm -rf "/Applications/UAP Invaders.app"

# Remove preferences
rm -rf ~/Library/Application\ Support/UAP\ Invaders/
```

### Windows
1. Use "Add or Remove Programs"
2. Find "UAP Invaders"
3. Click "Uninstall"
4. Or run uninstaller from installation directory

### Linux
```bash
# DEB package
sudo dpkg -r uap-invaders

# RPM package
sudo rpm -e uap-invaders

# AppImage
rm UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Remove config
rm -rf ~/.config/UAP-Invaders/
```

## Getting Help

If you encounter issues not covered here:

1. Check the [troubleshooting guide](TROUBLESHOOTING.md)
2. Search [GitHub issues](https://github.com/sanchez314c/uap-invaders/issues)
3. Create a new issue with:
   - Your operating system and version
   - Installation method used
   - Exact error message
   - Steps you've tried

---

For additional help, see the [documentation index](README.md).