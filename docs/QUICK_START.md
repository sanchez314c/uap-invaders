# Quick Start Guide

## One-Command Setup

### Fastest Way to Play
```bash
# Clone and run immediately
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders
npm start
```

This single command will:
1. Install all dependencies
2. Build the application for your platform
3. Launch the game immediately

## Development Mode

### Quick Development Setup
```bash
# For development with hot reload
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders
npm install
npm run dev
```

### Run from Source
```bash
# macOS
./run-source-mac.sh

# Linux
./run-source-linux.sh

# Windows
npm start
```

## Pre-built Downloads

### Download and Play (No Build Required)

| Platform | Download Link | Size |
|----------|---------------|-------|
| 🍎 **macOS Intel** | [Download DMG](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0.dmg) | ~96 MB |
| 🍎 **macOS ARM** | [Download DMG](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0-arm64.dmg) | ~90 MB |
| 🪟 **Windows** | [Download EXE](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol.Setup.1.0.0.exe) | ~146 MB |
| 🐧 **Linux** | [Download AppImage](https://github.com/sanchez314c/uap-invaders/releases/latest/download/UAP.Invaders.Contact.Protocol-1.0.0.AppImage) | ~99 MB |

### Web Version (Instant Play)
No download required! Play in your browser:
👉 https://sanchez314c.github.io/uap-invaders/

## First Time Playing

### 1. Launch the Game
- **Desktop**: Double-click the application
- **Web**: Navigate to the game URL
- **Development**: Already running from `npm run dev`

### 2. Enter Your Callsign
- Type your pilot identifier (max 10 characters)
- Press Enter to continue
- Your callsign will appear on high scores

### 3. Basic Controls
| Action | Control |
|---------|----------|
| Move Ship | Move mouse |
| Fire Weapon | Left mouse button |
| Fullscreen | F11 key |
| Pause | ESC key (planned) |

### 4. Game Objective
- Prevent UAPs from reaching the bottom
- Each UAP type has different point values
- Manage your energy for strategic shooting
- Beat the high score!

## Build Options

### Quick Build Commands
```bash
# Build for current platform only
npm run dist

# Build for all platforms
npm run dist:all

# Build specific platform
npm run dist:mac      # macOS
npm run dist:win      # Windows
npm run dist:linux    # Linux
```

### Development Commands
```bash
# Start with DevTools
npm run dev

# Run tests (when available)
npm test

# Clean build artifacts
npm run clean
```

## Common Tasks

### Update Game
```bash
# Pull latest changes
git pull origin main

# Rebuild
npm run dist

# Run updated version
npm start
```

### Add New UAP Type
1. Open `src/index.html`
2. Find the `uapTypes` array
3. Add new UAP definition:
```javascript
{
  emoji: '🔺',
  name: 'Triangle',
  points: 35,
  speed: 2.2,
  size: 32
}
```
4. Save and restart game

### Change Theme Colors
1. Open `src/index.html`
2. Find CSS variables:
```css
:root {
  --primary-color: #00ff00;
  --bg-color: #000000;
}
```
3. Modify colors as desired

## Troubleshooting

### Game Won't Start
```bash
# Check Node.js version
node --version  # Must be >= 16.0.0

# Reinstall dependencies
rm -rf node_modules
npm install
```

### Build Fails
```bash
# Clean and rebuild
npm run clean
npm run dist

# For specific platform issues
npm run dist:mac -- --mac.cscLink="path/to/cert"
```

### Performance Issues
- Close other applications
- Try windowed mode instead of fullscreen
- Check graphics drivers are up to date

## Next Steps

### For Players
- Read the full [README.md](../README.md) for detailed features
- Check [FAQ.md](FAQ.md) for common questions
- Report issues on GitHub

### For Developers
- Follow [DEVELOPMENT.md](DEVELOPMENT.md) for detailed setup
- Review [ARCHITECTURE.md](ARCHITECTURE.md) for code structure
- Read [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

### For Advanced Users
- Configure build settings in `package.json`
- Customize icons in `resources/icons/`
- Modify build scripts in `scripts/`

## Minimum Requirements

- **OS**: macOS 10.14+, Windows 10+, Linux (Ubuntu 18.04+)
- **Memory**: 512 MB RAM minimum
- **Storage**: 200 MB free space
- **Graphics**: OpenGL 2.0 compatible

---

Ready to defend Earth from the UAP invasion? 🛸

**Enter your callsign and engage!**

For more detailed information, see the [documentation index](README.md).