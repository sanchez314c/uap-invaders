# Build & Compile Instructions

## Overview

UAP Invaders uses Electron Builder for cross-platform packaging. The build system creates native applications for macOS, Windows, and Linux from a single codebase.

## Prerequisites

### System Requirements
- **Node.js**: >= 16.0.0
- **npm**: >= 8.0.0
- **Git**: For version control

### Platform-Specific Requirements

#### macOS
- Xcode Command Line Tools
- macOS 10.14+ for building
- Notarization tools for distribution

#### Windows
- Visual Studio Build Tools
- Windows 10 SDK
- NSIS for installer creation

#### Linux
- Build essentials
- RPM tools (for RPM packages)
- dpkg-dev (for DEB packages)

## Quick Build

### One-Command Build & Run
```bash
# Clone repository
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders

# Install dependencies
npm install

# Build, release, and run with one command!
npm start
```

### Development Mode
```bash
# Run without building (for development)
npm run dev
```

## Build Commands

### NPM Scripts
```bash
# Core development
npm start              # Start Electron in production mode
npm run dev            # Start with DevTools enabled

# Building
npm run dist           # Build for current platform only
npm run dist:all       # Build for all platforms
npm run pack           # Build without creating distributables

# Platform-specific builds
npm run dist:mac       # macOS (DMG, ZIP, PKG)
npm run dist:mac:all   # macOS Universal (Intel + ARM)
npm run dist:mac:store # Mac App Store version
npm run dist:win       # Windows (NSIS, MSI, ZIP)
npm run dist:win:msi    # Windows MSI only
npm run dist:win:portable # Windows portable
npm run dist:linux     # Linux (AppImage, DEB, RPM)
npm run dist:linux:appimage # Linux AppImage only
npm run dist:linux:deb   # Debian package only
npm run dist:linux:rpm   # RPM package only

# Build management
npm run clean         # Remove build artifacts
npm run build-clean    # Build without cleanup
npm run temp-clean     # Remove temporary files
npm run bloat-check   # Check build size
```

### Build Script Options
```bash
npm start [options]

Options:
  --dev              Run in development mode (no build)
  --build-only        Build release but don't run
  --clean             Clean build artifacts before building
  --platform <spec>   Platform to build for:
                     mac, win, linux, all
  --help              Show help message
```

## Build Configuration

### package.json Configuration
```json
{
  "build": {
    "appId": "com.uapinvaders.contactprotocol",
    "productName": "UAP Invaders Contact Protocol",
    "directories": {
      "output": "dist"
    },
    "files": [
      "src/**/*",
      "node_modules/**/*",
      "package.json"
    ],
    "mac": {
      "category": "public.app-category.games",
      "target": [
        {
          "target": "dmg",
          "arch": ["x64", "arm64"]
        },
        {
          "target": "zip",
          "arch": ["x64", "arm64"]
        },
        "pkg"
      ]
    },
    "win": {
      "target": [
        "nsis",
        "msi",
        "zip"
      ]
    },
    "linux": {
      "category": "Game",
      "target": [
        "AppImage",
        "deb",
        "rpm",
        "snap",
        "tar.xz"
      ]
    }
  }
}
```

## Build Outputs

### Directory Structure
```
dist/
├── mac/                     # macOS app bundles
│   ├── UAP Invaders.app       # Intel x64
│   └── UAP Invaders-arm64.app # Apple Silicon
├── mac-arm64/               # ARM64 specific builds
├── win/                     # Windows builds
│   ├── UAP Invaders Setup.exe  # NSIS installer
│   └── UAP Invaders.msi      # MSI installer
├── win-unpacked/            # Windows portable
├── linux/                   # Linux builds
│   ├── UAP Invaders.AppImage
│   ├── uap-invaders.deb
│   └── uap-invaders.rpm
├── *.dmg                   # macOS disk images
├── *.zip                    # Archives
└── latest.yml               # Update metadata
```

### Platform-Specific Outputs

#### macOS
- **DMG**: Interactive installer with custom background
- **ZIP**: Portable app bundle
- **PKG**: Mac App Store ready package
- **Universal**: Combined Intel + ARM64

#### Windows
- **NSIS**: Interactive installer with desktop shortcut
- **MSI**: Enterprise installer for Group Policy
- **ZIP**: Portable version without installer

#### Linux
- **AppImage**: Portable, runs on any Linux distribution
- **DEB**: Debian/Ubuntu package with dependencies
- **RPM**: Red Hat/Fedora package
- **SNAP**: Universal Linux package with sandbox

## Build Process

### 1. Preparation
```bash
# Clean previous builds
rm -rf dist/

# Install dependencies
npm ci

# Run tests (if available)
npm test
```

### 2. Compilation
```bash
# Transpile source (if using TypeScript/Babel)
# Bundle application (if using bundler)
# Optimize assets
# Generate source maps
```

### 3. Packaging
```bash
# Create platform-specific directories
# Copy application files
# Generate icons and resources
# Create installers and packages
```

### 4. Post-Build
```bash
# Generate checksums
# Create release notes
# Upload to distribution platform
```

## Optimization

### Build Size Optimization
```bash
# Check current build size
npm run bloat-check

# Optimize assets
# - Compress images
# - Minify code
# - Remove unused dependencies

# Enable compression
npm run dist -- --compression maximum
```

### Performance Optimization
- Enable tree shaking
- Use production builds
- Minify JavaScript/CSS
- Optimize images and assets
- Remove development dependencies

## CI/CD Integration

### GitHub Actions Workflow
```yaml
name: Build and Release
on:
  push:
    tags: ['v*']

jobs:
  build:
    strategy:
      matrix:
        os: [macos-latest, windows-latest, ubuntu-latest]
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - run: npm ci
      - run: npm run dist
      
      - uses: actions/upload-artifact@v3
        with:
          name: ${{ matrix.os }}-build
          path: dist/
```

## Troubleshooting

### Common Build Issues

#### Permission Denied (Linux/macOS)
```bash
# Fix permissions
chmod +x scripts/*.sh
sudo npm install -g electron-builder
```

#### Code Signing Errors (macOS)
```bash
# Install certificates
security import-certificate -k ~/Library/Keychains/login.keychain-db cert.p12

# Configure build
export CSC_LINK="path/to/cert"
export CSC_KEY_PASSWORD="password"
```

#### Missing Dependencies (Windows)
```bash
# Install Visual Studio Build Tools
npm config set msvs_version 2019

# Install windows-build-tools
npm install -g windows-build-tools
```

#### Icon Generation Failures
```bash
# Install ImageMagick
brew install imagemagick  # macOS
sudo apt-get install imagemagick  # Ubuntu

# Verify icon formats
file resources/icons/*
```

### Debug Mode
```bash
# Enable verbose logging
DEBUG=electron-builder npm run dist

# Build with detailed output
npm run dist -- --x64 --ia32 --arm64 --publish=never
```

## Advanced Configuration

### Custom Build Scripts
```bash
#!/bin/bash
# custom-build.sh

set -e

echo "🚀 Starting custom build..."

# Environment setup
export NODE_ENV=production
export ELECTRON_BUILDER_ALLOW_UNRESOLVED_DEPENDENCIES=true

# Pre-build
npm run lint
npm run test

# Build
npm run dist:all

# Post-build
npm run create-checksums
npm run update-s3

echo "✅ Build complete!"
```

### Multi-Target Build
```json
{
  "build": {
    "win": {
      "target": [
        {
          "target": "nsis",
          "arch": ["x64", "ia32"]
        },
        {
          "target": "portable",
          "arch": ["x64"]
        }
      ]
    }
  }
}
```

## Release Process

### Automated Release
```bash
# Create release tag
git tag v1.0.0
git push origin v1.0.0

# Trigger GitHub Actions
# Builds will be created and uploaded automatically
```

### Manual Release
```bash
# Build all platforms
npm run dist:maximum

# Create GitHub release
gh release create v1.0.0 \
  --title "Version 1.0.0" \
  --notes "Release notes here" \
  dist/*
```

This build system ensures consistent, professional releases across all supported platforms with minimal configuration overhead.