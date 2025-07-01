# UAP Invaders: Contact Protocol - Technology Stack

## Overview

UAP Invaders is a modern cross-platform desktop game built with web technologies, featuring UAP/UFO-themed enemies and mouse-based controls. The game is packaged as a native desktop application using Electron.

## Core Technologies

### **Runtime & Framework**
- **Electron** `^27.3.11`
  - Cross-platform desktop application framework
  - Enables web technologies to run as native desktop apps
  - Provides native OS integration (menus, file system, etc.)

### **Programming Language**
- **JavaScript (ES6+)**
  - Primary programming language
  - Used for game logic, Electron main process, and renderer process
  - Modern JavaScript features including modules, async/await, and classes

### **Frontend Technologies**
- **HTML5**
  - Game interface structure
  - Canvas element for game rendering
  - Semantic HTML for accessibility

- **CSS3**
  - Game styling and theming
  - Responsive design for different screen sizes
  - Custom properties and modern CSS features

- **HTML5 Canvas API**
  - 2D game rendering engine
  - Real-time graphics rendering
  - Sprite animation and collision detection

## Development Tools

### **Package Management**
- **npm** `>=8.0.0`
  - Dependency management
  - Script execution
  - Package publishing

### **Build & Packaging**
- **electron-builder** `^24.9.1`
  - Cross-platform application packaging
  - Auto-update functionality
  - Code signing support

### **Version Control**
- **Git**
  - Source code version control
  - Branching and merging workflows
  - GitHub integration

### **CI/CD**
- **GitHub Actions**
  - Automated testing and building
  - Multi-platform CI pipeline
  - Release automation

## Assets & Resources

### **Fonts**
- **Google Fonts - Courier Prime**
  - Monospace font for terminal/military aesthetic
  - Multiple weights (400, 700) for UI hierarchy

### **Icons**
- **Multiple Formats**
  - `.icns` - macOS application icons
  - `.ico` - Windows application icons
  - `.png` - Linux and web fallback icons

### **Data Storage**
- **Local Storage API**
  - High score persistence
  - Player callsign storage
  - Game settings and preferences

## Build System

### **Shell Scripts**
- **Bash Scripts**
  - `compile-build-dist.sh` - Complete build pipeline
  - `run-source-mac.sh` - macOS development runner
  - `run-source-linux.sh` - Linux development runner

### **Build Configuration**
- **package.json**
  - Project metadata and dependencies
  - Build scripts and commands
  - Electron-builder configuration

## Platform Support

### **Target Platforms**
- **macOS** (Intel x64 + Apple Silicon ARM64)
  - `.dmg` disk images
  - `.app` bundles
  - Universal binaries

- **Windows** (x64)
  - `.exe` installers
  - Portable `.zip` packages
  - NSIS installer support

- **Linux** (x64)
  - `.AppImage` portable packages
  - `.deb` Debian packages
  - System integration

### **Web Version**
- **Browser Compatibility**
  - Modern browsers with HTML5 Canvas support
  - Chrome 80+, Firefox 75+, Safari 13+, Edge 80+
  - Progressive enhancement for different capabilities

## Development Environment

### **Code Quality**
- **EditorConfig**
  - Consistent coding style across editors
  - 2-space indentation for JavaScript/HTML/CSS
  - UTF-8 encoding and LF line endings

### **Project Structure**
```
uap-invaders/
├── src/                    # Source code
│   ├── index.html         # Game interface
│   └── main.js            # Electron main process
├── scripts/               # Build automation
├── resources/             # Assets and icons
├── dist/                  # Built applications (generated)
└── package.json           # Project configuration
```

## System Requirements

### **Development**
- **Node.js** `>=16.0.0`
- **npm** `>=8.0.0`
- **Git** (recommended)
- **Platform-specific build tools**

### **Runtime (End Users)**
- **Operating System**: macOS 10.14+, Windows 10+, Linux (Ubuntu/Debian)
- **Memory**: 512 MB RAM minimum, 1 GB recommended
- **Storage**: 200-300 MB available space
- **Display**: 800x600 resolution minimum

## Deployment

### **Distribution Methods**
- **GitHub Releases**
  - Pre-built binaries for all platforms
  - Release notes and changelogs
  - Download statistics

- **Auto-Updates**
  - Electron-builder auto-update system
  - Platform-specific update mechanisms
  - Background update downloads

## Security Considerations

### **Electron Security**
- **Context Isolation**: Enabled for renderer process
- **Node Integration**: Disabled in renderer
- **Remote Module**: Disabled
- **Web Security**: Enabled

### **Content Security**
- **External Links**: Handled through shell.openExternal()
- **Local Resources**: Restricted to application bundle
- **Data Validation**: Input sanitization for callsigns

## Performance Optimizations

### **Rendering**
- **RequestAnimationFrame**: Smooth 60fps gameplay
- **Canvas Optimization**: Efficient 2D rendering
- **Memory Management**: Object pooling for game entities

### **Build Optimizations**
- **Tree Shaking**: Unused code elimination
- **Minification**: Production bundle size reduction
- **Platform-Specific Builds**: Targeted optimizations

## Future Technology Roadmap

### **Potential Additions**
- **TypeScript**: Type safety and better IDE support
- **WebGL**: Enhanced 3D graphics capabilities
- **Web Audio API**: Sound effects and background music
- **Service Workers**: Offline functionality
- **Progressive Web App (PWA)**: Enhanced web version

### **Build Enhancements**
- **Webpack**: Advanced bundling and optimization
- **ESLint/Prettier**: Code quality and formatting
- **Testing Framework**: Unit and integration tests

---

## Support & Resources

- **Documentation**: Comprehensive README and inline comments
- **Community**: GitHub Issues and Discussions
- **Build Scripts**: Automated cross-platform building
- **CI/CD**: GitHub Actions for continuous integration

---

This stack gives UAP Invaders native desktop performance across macOS, Windows, and Linux while keeping the codebase small and easy to maintain.