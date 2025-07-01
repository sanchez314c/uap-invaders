# Deployment

## Overview

UAP Invaders supports multiple deployment methods including GitHub Releases, automatic updates, and direct distribution. This document covers all deployment scenarios and best practices.

## Distribution Channels

### GitHub Releases (Primary)
- **URL**: https://github.com/sanchez314c/uap-invaders/releases
- **Automatic**: Created via GitHub Actions CI/CD
- **Artifacts**: All platform binaries and packages
- **Metadata**: Release notes, checksums, and version info

### Direct Distribution
- **Website**: https://uapinvaders.com (if available)
- **Steam**: Planned for future release
- **Mac App Store**: Configured and ready
- **Microsoft Store**: Potential future channel

## Release Process

### Automated Release (Recommended)
```bash
# 1. Update version in package.json
npm version patch  # or minor/major

# 2. Push version tag
git push origin v1.0.1

# 3. GitHub Actions automatically:
#    - Builds all platforms
#    - Creates release
#    - Uploads artifacts
#    - Generates checksums
```

### Manual Release
```bash
# 1. Build all platforms
npm run dist:maximum

# 2. Generate checksums
sha256sum dist/* > checksums.txt

# 3. Create GitHub release
gh release create v1.0.1 \
  --title "UAP Invaders v1.0.1" \
  --notes "Bug fixes and improvements" \
  dist/* checksums.txt
```

## Platform-Specific Deployment

### macOS Deployment

#### App Store Distribution
```bash
# Build for Mac App Store
npm run dist:mac:store

# Upload to App Store Connect
xcrun altool --upload-app \
  --type osx \
  --file "UAP Invaders.pkg" \
  --asc-provider "ProviderID"
```

#### Direct Distribution
```bash
# Notarize for macOS 10.15+
xcrun altool --notarize-app \
  --primary-bundle-id "com.uapinvaders.contactprotocol" \
  --username "developer@apple.com" \
  --password "@keychain:AC_PASSWORD" \
  --file "UAP Invaders.dmg"

# Staple notarization
xcrun stapler staple "UAP Invaders.dmg"
```

#### Distribution Formats
- **DMG**: Interactive installer with EULA
- **ZIP**: Portable app bundle
- **PKG**: Silent installation option

### Windows Deployment

#### Code Signing
```bash
# Set environment variables
export CSC_LINK="path/to/cert.p12"
export CSC_KEY_PASSWORD="password"

# Build with signature
npm run dist:win
```

#### Installer Options
- **NSIS**: Interactive installer with:
  - Custom directory selection
  - Desktop shortcut creation
  - Start menu integration
  - Uninstaller

- **MSI**: Enterprise installer with:
  - Silent installation support
  - Group Policy deployment
  - Upgrade management

- **Portable**: ZIP archive for:
  - USB drive deployment
  - No installation required
  - Portable settings

### Linux Deployment

#### Package Formats
```bash
# AppImage (Portable)
npm run dist:linux:appimage
# Runs on any Linux distribution
# Self-contained with dependencies

# DEB (Debian/Ubuntu)
npm run dist:linux:deb
# Installs via apt
# Dependency management
# System integration

# RPM (Red Hat/Fedora)
npm run dist:linux:rpm
# Installs via yum/dnf
# Enterprise support

# SNAP (Universal)
npm run dist:linux:snap
# Sandboxed application
# Auto-updates
# Cross-distro
```

#### Repository Setup
```bash
# APT Repository (Debian/Ubuntu)
# Add PPA for automatic updates
echo "deb https://ppa.uapinvaders.com/ubuntu stable main" > /etc/apt/sources.list.d/uap-invaders.list

# YUM Repository (Red Hat/Fedora)
echo "[uap-invaders]
name=UAP Invaders
baseurl=https://yum.uapinvaders.com/rpm
enabled=1" > /etc/yum.repos.d/uap-invaders.repo
```

## Auto-Update System

### Electron-Updater Configuration
```javascript
// main.js
const { autoUpdater } = require('electron-updater');

// Check for updates
autoUpdater.checkForUpdatesAndNotify();

// Update events
autoUpdater.on('update-available', () => {
  // Notify user
});

autoUpdater.on('update-downloaded', () => {
  // Install and restart
});
```

### Update Server Setup
```yaml
# GitHub Releases as update server
updater:
  url: https://api.github.com/repos/sanchez314c/uap-invaders/releases/latest
  channel: latest
  platform:
    mac: darwin
    win: win32
    linux: linux
```

## Continuous Deployment

### GitHub Actions Workflow
```yaml
name: Build and Release
on:
  push:
    tags: ['v*']

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build all platforms
        run: npm run dist:maximum
        
      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: UAP Invaders ${{ github.ref }}
          draft: false
          prerelease: false
          
      - name: Upload Assets
        uses: actions/upload-release-asset@v1
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: dist/
          asset_name: uap-invaders-${{ github.ref }}-${{ matrix.os }}.${{ matrix.ext }}
          asset_content_type: application/octet-stream
```

## Deployment Checklist

### Pre-Release
- [ ] Version number updated
- [ ] CHANGELOG.md updated
- [ ] All tests passing
- [ ] Build size optimized
- [ ] Checksums generated
- [ ] Release notes prepared

### Release
- [ ] All platforms built successfully
- [ ] Code signatures valid
- [ ] Installers tested on clean systems
- [ ] Virus scans clean
- [ ] Release created on GitHub
- [ ] Artifacts uploaded

### Post-Release
- [ ] Website updated
- [ ] Documentation updated
- [ ] Community notified
- [ ] Download metrics monitored
- [ ] User feedback collected

## Security Considerations

### Code Signing
- macOS: Apple Developer certificate required
- Windows: Code signing certificate recommended
- Linux: GPG signing for packages

### Checksums
```bash
# Generate SHA256 checksums
sha256sum dist/* > checksums.txt

# Verify checksums
sha256sum -c checksums.txt
```

### Secure Distribution
- Use HTTPS for all downloads
- Verify SSL certificates
- Mirror downloads to CDN
- Rate limiting for abuse prevention

## Monitoring and Analytics

### Download Tracking
```javascript
// GitHub API for release stats
const releases = await fetch('https://api.github.com/repos/sanchez314c/uap-invaders/releases');
const downloads = releases.reduce((sum, release) => {
  return sum + release.assets.reduce((assetSum, asset) => {
    return assetSum + asset.download_count;
  }, 0);
}, 0);
```

### Error Reporting
```javascript
// Sentry integration for crash reports
const Sentry = require('@sentry/electron');
Sentry.init({ dsn: 'YOUR_DSN' });

// Capture errors
Sentry.captureException(error);
```

### Usage Analytics
- Anonymous usage statistics
- Platform distribution
- Version adoption rates
- Feature usage tracking

## Rollback Strategy

### Emergency Rollback
```bash
# 1. Pull previous release
git checkout v1.0.0

# 2. Build and sign
npm run dist:maximum

# 3. Update release
gh release edit v1.0.1 --draft
gh release create v1.0.1-rollback \
  --title "Rollback to v1.0.0" \
  --notes "Emergency rollback due to critical issues"
```

### Auto-Update Rollback
```javascript
// Disable auto-updates
autoUpdater.setFeedURL({
  url: 'https://releases.uapinvaders.com/stable',
  channel: 'stable'
});

// Force specific version
autoUpdater.checkForUpdatesAndNotify({
  version: '1.0.0'
});
```

## Best Practices

1. **Test Before Release**: Always test installers on clean systems
2. **Staged Rollout**: Release to small group first
3. **Monitor Closely**: Watch for issues after release
4. **Quick Response**: Have rollback plan ready
5. **Document Everything**: Keep detailed release notes

This deployment strategy ensures reliable, secure distribution across all supported platforms with minimal user friction.