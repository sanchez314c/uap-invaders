# AGENTS.md

This file provides guidance for AI coding agents working with this repository. For the primary reference, see [CLAUDE.md](CLAUDE.md).

## Project Overview

UAP Invaders: Contact Protocol is a modern cross-platform desktop game that reimagines the classic Space Invaders with UAP/UFO-themed enemies. Built with Electron, HTML5 Canvas, and vanilla JavaScript, the game features mouse controls, multiple UAP types (including the famous Tic Tac), and a Neo-Noir Glass UI with callsign registration and persistent high scores.

## Development Commands

### Core Development
- `npm start` - Start the Electron application in production mode
- `npm run dev` - Start in development mode with DevTools enabled
- `npm test` - Placeholder test command (tests will be added in future version)

### Building and Distribution
- `npm run dist` - Build for current platform only
- `npm run dist:all` - Build for all platforms (macOS, Windows, Linux) without publishing
- `npm run dist:mac` - Build for macOS (DMG, ZIP, PKG with x64/arm64 support)
- `npm run dist:mac:all` - Build macOS with both Intel and Apple Silicon architectures
- `npm run dist:mac:store` - Build for Mac App Store distribution
- `npm run dist:win` - Build for Windows (NSIS, MSI, ZIP, Portable)
- `npm run dist:win:all` - Build Windows with x64, ia32, and arm64 architectures
- `npm run dist:win:msi` - Build Windows MSI installer specifically
- `npm run dist:win:portable` - Build portable Windows executable
- `npm run dist:linux` - Build for Linux (AppImage, DEB, RPM, SNAP, tar.xz, tar.gz)
- `npm run dist:linux:all` - Build Linux with x64, arm64, and armv7l architectures
- `npm run dist:linux:appimage` - Build Linux AppImage specifically
- `npm run dist:linux:deb` - Build Debian/Ubuntu package
- `npm run dist:linux:rpm` - Build RPM package
- `npm run dist:linux:snap` - Build Snap package
- `npm run dist:linux:tar` - Build tar.xz archive
- `npm run dist:maximum` - Build for all platforms and architectures (comprehensive build)
- `npm run pack` - Build without creating distributables (directory output)

### Build Management
- `npm run clean` - Remove build artifacts, cache, and temporary files
- `npm run build-clean` - Build without temporary cleanup or bloat checking
- `npm run temp-clean` - Remove temporary files using dedicated cleanup script
- `npm run bloat-check` - Check build size and identify potential bloat

### Platform-Specific Running
- `./run-source-mac.sh` - Run from source on macOS
- `./run-source-linux.sh` - Run from source on Linux

## Architecture Overview

UAP Invaders follows a simple but effective Electron architecture with clear separation between the main process and the renderer game logic.

### Main Process (`src/main.js`)
- **Window Management**: Creates and configures the BrowserWindow with security best practices
- **Application Menu**: Custom menu system with game-specific controls (New Game, Fullscreen, About)
- **Security Implementation**: Context isolation enabled, node integration disabled, secure external link handling
- **Cross-Platform Support**: Platform-specific menu adjustments and icon handling
- **Development Tools**: Automatic DevTools opening in development mode

### Renderer Process (`src/index.html`)
- **Single File Architecture**: All game logic, UI, and styling contained in one HTML file
- **Canvas-Based Game Engine**: HTML5 Canvas API for 2D game rendering
- **Game State Management**: JavaScript-based state management for score, health, energy, and game objects
- **Menu System**: Multiple screens (main menu, high scores, game over) with smooth transitions
- **Local Storage**: Persistent high score storage and callsign management
- **Responsive Design**: Automatic adaptation between windowed and fullscreen modes

### Key Game Systems

#### UAP Types and Behaviors
The game features 6 different UAP types, each with unique characteristics:
- **Classic Saucer** (🛸): Standard enemy, 10 points, speed 1
- **Probe** (🛰️): Fast reconnaissance craft, 15 points, speed 2
- **Tic Tac** (⚡): Fast-moving based on USS Nimitz encounter, 25 points, speed 3
- **Phoenix Light** (🔥): Large, medium speed based on Phoenix Lights, 30 points, speed 1.5
- **Orb** (💫): Medium-sized luminous phenomena, 20 points, speed 2.5
- **Vortex** (🌀): Large, slow advanced propulsion craft, 40 points, speed 1

#### Game Mechanics
- **Mouse Controls**: Smooth mouse-following player movement with left-click shooting
- **Energy System**: Regenerating energy resource for shooting (10 energy per shot)
- **Progressive Difficulty**: Dynamic spawn rates that increase with score
- **Collision Detection**: Circle-based collision system for bullets and player
- **Particle Effects**: Explosion animations and dynamic starfield background

## Code Style and Conventions

### JavaScript Patterns
- **ES6+ Features**: Modern JavaScript including const/let, arrow functions, and template literals
- **Functional Organization**: Functions organized by purpose (game state, rendering, input handling)
- **Event-Driven Architecture**: Event listeners for user input and game state changes
- **Canvas Rendering**: 2D context usage with requestAnimationFrame for smooth animation

### CSS Architecture
- **Inline Styles**: All CSS contained within the HTML file for simplicity
- **Dark Neo Glass Design Tokens**: Full `:root` CSS custom property system (50+ tokens) covering backgrounds, typography, accents, gradients, shadows, glass effects, border radius, spacing, and transitions
- **Primary Accent Color**: Teal (`#14b8a6`) for interactive elements, projectiles, and key UI highlights
- **Frameless Transparent Window**: Body has 16px padding creating a floating glass effect; `html, body` are transparent
- **Responsive Classes**: Conditional styling for windowed vs fullscreen modes
- **CSS Transitions**: fast (150ms), normal (250ms), slow (400ms) preset classes

### HTML Structure
- **Semantic HTML5**: Proper use of semantic elements for accessibility
- **Single File Design**: Self-contained HTML file with embedded CSS and JavaScript
- **Progressive Enhancement**: Fallbacks for different browser capabilities

## Development Workflow

### Before Making Changes
1. Ensure you understand the game mechanics and UAP behavior system
2. Test the current functionality to establish baseline
3. Consider impact on both windowed and fullscreen modes
4. Verify cross-platform compatibility of any changes

### Testing Strategy
- **Manual Testing**: Play the game to verify mechanics work correctly
- **Cross-Platform Testing**: Test on target platforms (macOS, Windows, Linux)
- **Browser Testing**: Verify web version compatibility if applicable
- **Build Testing**: Ensure the application builds and runs correctly after changes

### Performance Considerations
- **Frame Rate**: Maintain 60fps gameplay with requestAnimationFrame
- **Memory Management**: Clean up game objects and event listeners properly
- **Canvas Optimization**: Efficient rendering patterns for smooth gameplay
- **Resource Loading**: Optimize asset loading for quick startup

## Build Configuration

### Electron Builder Settings
- **App ID**: `com.uapinvaders.contactprotocol`
- **Product Name**: `UAP Invaders Contact Protocol`
- **Compression**: Maximum compression for smaller download sizes
- **Security**: Context isolation enabled, node integration disabled
- **Files**: Selective inclusion of source files, exclusion of development files

### Platform-Specific Configurations
- **macOS**:
  - Category: Games
  - Targets: DMG, ZIP, PKG
  - Architectures: x64, arm64 (Universal)
  - MAS (Mac App Store) configuration available
- **Windows**:
  - Targets: NSIS, MSI, ZIP, Portable
  - Architectures: x64, ia32
  - Custom installer with desktop shortcuts
- **Linux**:
  - Category: Game
  - Targets: AppImage, DEB, RPM, SNAP, tar.xz, tar.gz
  - Desktop integration with proper categories

## Game Development Guidelines

### Adding New UAP Types
1. Define the UAP type in the `uapTypes` array with emoji, name, points, speed, and size
2. Consider balance implications for gameplay
3. Test visual appearance and movement patterns
4. Verify point values match difficulty level

### Modifying Game Mechanics
1. Understand the current game loop structure in `gameLoop()`
2. Consider impact on difficulty progression
3. Test with various score levels to ensure balance
4. Verify UI elements update correctly

### UI and Visual Changes
1. Maintain the Neo-Noir Glass design system using CSS custom properties from `:root`
2. Use Inter for UI text and Courier Prime for monospace accents
3. Ensure responsive behavior in both windowed and fullscreen modes
4. Test visual effects on different screen sizes

## Security Considerations

### Electron Security Best Practices
- **Context Isolation**: Enabled to protect against prototype pollution
- **Node Integration**: Disabled in renderer to prevent system access
- **Web Security**: Enabled for secure content loading
- **External Links**: Handled securely through shell.openExternal()

### Input Validation
- **Callsign Input**: Sanitized and limited to 10 characters
- **Local Storage**: Basic validation of stored data
- **File Access**: No direct file system access from renderer process

## File Organization

### Core Files
- `src/main.js` - Electron main process and window management
- `src/index.html` - Complete game with embedded CSS and JavaScript
- `package.json` - Project configuration and build scripts

### Build Assets
- `resources/icons/` - Platform-specific application icons
- `scripts/` - Build automation and utility scripts
- `dist/` - Built applications (generated during build process)

### Documentation
- `README.md` - Comprehensive project documentation
- `docs/TECHSTACK.md` - Detailed technology information
- `CONTRIBUTING.md` - Contribution guidelines
- `CHANGELOG.md` - Version history and changes

## Platform-Specific Notes

### macOS Development
- Universal binary support for Intel and Apple Silicon
- DMG creation with custom background and layout
- Notarization and code signing ready configuration
- Special menu handling for macOS conventions

### Windows Development
- NSIS installer with custom branding
- MSI support for enterprise deployment
- Portable executable option
- Proper Windows icon integration

### Linux Development
- AppImage for portable distribution
- DEB package for Debian/Ubuntu systems
- RPM for Red Hat/Fedora systems
- SNAP for universal Linux distribution

## Debugging and Development

### Development Mode
- Use `npm run dev` to enable DevTools automatically
- Access browser console for debugging JavaScript
- Use Electron DevTools for renderer process inspection
- Monitor main process logs through terminal

### Common Issues
- **Canvas Not Rendering**: Check canvas context initialization and resize handling
- **Mouse Controls Not Working**: Verify event listeners and coordinate calculations
- **Build Failures**: Ensure all dependencies are installed and Node.js version is compatible
- **Cross-Platform Issues**: Test platform-specific code paths and configurations

This architecture provides a solid foundation for a cross-platform game while maintaining simplicity and performance. The single-file renderer approach makes development straightforward while the comprehensive build system ensures professional distribution across all major platforms.