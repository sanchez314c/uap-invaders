# Frequently Asked Questions

## General Questions

### Q: What is UAP Invaders?
A: UAP Invaders: Contact Protocol is a modern reimagining of the classic Space Invaders game featuring UAP/UFO-themed enemies, mouse controls, and a military-themed interface. It's built with Electron for cross-platform desktop play.

### Q: What platforms are supported?
A: UAP Invaders supports:
- macOS (Intel and Apple Silicon)
- Windows (10+)
- Linux (Ubuntu, Debian, Fedora, etc.)
- Web browsers (Chrome, Firefox, Safari, Edge)

### Q: Is the game free?
A: Yes! UAP Invaders is open source and free to play. The source code is available on GitHub under the MIT license.

### Q: Can I play with a controller?
A: Currently, the game is designed for mouse controls only. Controller support is planned for a future release.

## Gameplay

### Q: How do I play?
A: 
1. Enter your pilot callsign (max 10 characters)
2. Move your mouse to control the interceptor
3. Left-click to fire at UAPs
4. Prevent UAPs from reaching the bottom
5. Climb the high score leaderboard

### Q: What do the different UAP types mean?
A: Each UAP type is based on real phenomena:
- **Classic Saucer** (🛸): Traditional UFO sightings
- **Probe** (🛰️): Reconnaissance craft
- **Tic Tac** (⚡): USS Nimitz encounter
- **Phoenix Light** (🔥): Phoenix Lights incident
- **Orb** (💫): Luminous spherical objects
- **Vortex** (🌀): Advanced propulsion craft

### Q: How does scoring work?
A: Each UAP type has different point values:
- Classic Saucer: 10 points
- Probe: 15 points
- Tic Tac: 25 points
- Phoenix Light: 30 points
- Orb: 20 points
- Vortex: 40 points

### Q: What is the energy system?
A: Shooting consumes 10 energy points. Energy regenerates automatically over time. This adds a strategic element to the gameplay.

### Q: How do I get on the high score list?
A: The game tracks the top 10 scores locally. Achieve a high score, enter your callsign, and it will be saved to the leaderboard.

## Technical

### Q: Why Electron?
A: Electron allows us to use web technologies (HTML5, Canvas, JavaScript) while providing a native desktop experience with cross-platform compatibility from a single codebase.

### Q: What are the system requirements?
A: 
- **Minimum**: 512 MB RAM, 800x600 resolution
- **Recommended**: 1 GB RAM, 1024x768 resolution
- **OS**: macOS 10.14+, Windows 10+, Linux (Ubuntu 18.04+)

### Q: Why does the macOS app crash on startup?
A: This is a known issue with Electron 28.x on macOS 15.0.1. Workarounds:
- Use the web version
- Run from source with `npm run dev`
- Wait for the next update with the fix

### Q: Can I modify the game?
A: Absolutely! The game is open source under the MIT license. Feel free to modify, add features, or even create your own UAP types.

## Installation

### Q: How do I install on macOS?
A: 
1. Download the DMG file
2. Double-click to open
3. Drag UAP Invaders to Applications
4. Launch from Applications folder

### Q: How do I install on Windows?
A: 
1. Download the Setup.exe file
2. Run the installer
3. Follow the installation wizard
4. Launch from Start Menu or desktop

### Q: How do I install on Linux?
A: 
**AppImage (Recommended)**:
1. Download the .AppImage file
2. Make it executable: `chmod +x UAP.Invaders.AppImage`
3. Run directly: `./UAP.Invaders.AppImage`

**DEB Package**:
1. Download the .deb file
2. Install: `sudo dpkg -i uap-invaders.deb`
3. Launch from applications menu

### Q: Can I play without installing?
A: Yes! The web version works directly in your browser at: https://sanchez314c.github.io/uap-invaders/

## Development

### Q: How can I contribute?
A: 
1. Fork the repository on GitHub
2. Create a feature branch
3. Make your changes
4. Submit a pull request
5. Follow the contribution guidelines in CONTRIBUTING.md

### Q: What skills are needed to contribute?
A: 
- JavaScript/HTML5/CSS3 for game features
- Node.js/Electron for desktop features
- Shell scripting for build automation
- Design skills for visual improvements

### Q: How do I report bugs?
A: Please use the GitHub issue tracker:
1. Search existing issues first
2. Create a new issue with:
   - OS and version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

## Troubleshooting

### Q: The game is running slowly
A: Try these solutions:
- Close other applications
- Update your graphics drivers
- Try the web version if desktop is slow
- Check if your system meets minimum requirements

### Q: Mouse controls aren't working
A: 
- Ensure the game window is focused
- Try clicking in the game area
- Check if another application is capturing mouse input
- Restart the application

### Q: High scores aren't saving
A: 
- Check browser settings if using web version
- Ensure local storage is enabled
- Try clearing browser cache
- Check permissions on desktop version

### Q: Build fails on Linux
A: Common solutions:
```bash
# Install missing dependencies
sudo apt-get install build-essential

# Install Node.js dependencies
npm ci --production=false

# Fix permissions
chmod +x scripts/*.sh
```

## Future Features

### Q: Will there be sound?
A: Yes! An audio system with sound effects and background music is planned for version 1.1.

### Q: Will there be multiplayer?
A: Online multiplayer and local co-op modes are planned for future versions (1.2+).

### Q: Will there be mobile versions?
A: Mobile support is on the roadmap for version 2.0, which will include iOS and Android apps.

### Q: Can I suggest features?
A: Absolutely! Please open an issue on GitHub with the "enhancement" label. We welcome all suggestions.

## Community

### Q: Where can I discuss the game?
A: 
- GitHub Issues: For bugs and feature requests
- GitHub Discussions: For general discussion
- Discord: [Link when available]

### Q: How can I support the project?
A: 
- Star the repository on GitHub
- Report bugs and suggest features
- Contribute code or documentation
- Share with friends
- Create content (videos, streams)

### Q: Can I use assets from the game?
A: Game assets are not currently licensed separately. Please ask before using game-specific assets in your projects.

---

Still have questions? Check the [documentation index](README.md) or open an issue on GitHub.