# Troubleshooting

## Installation Issues

### macOS

#### "App can't be opened because Apple cannot check it for malicious software"
**Problem**: macOS Gatekeeper blocking unsigned application

**Solutions**:
1. **Right-click Method**:
   - Right-click UAP Invaders.app
   - Select "Open" from context menu
   - Click "Open" in security dialog

2. **System Preferences Method**:
   - Open System Preferences → Security & Privacy
   - Click "Allow Anyway" for UAP Invaders

3. **Command Line Method**:
   ```bash
   xattr -d com.apple.quarantine "/Applications/UAP Invaders.app"
   ```

4. **Permanent Fix**:
   - Obtain Apple Developer certificate
   - Code sign the application
   - Notarize with Apple

#### Application crashes on startup on macOS 15.0.1
**Problem**: Electron 28.x compatibility issue with macOS 15

**Solutions**:
1. **Use Web Version**:
   - Navigate to https://sanchez314c.github.io/uap-invaders/
   - No installation required

2. **Run from Source**:
   ```bash
   git clone https://github.com/sanchez314c/uap-invaders.git
   cd uap-invaders
   npm install
   npm run dev
   ```

3. **Downgrade Electron** (temporary):
   ```bash
   npm install electron@27.3.11
   npm run dist
   ```

### Windows

#### "Windows protected your PC"
**Problem**: Smart Screen blocking unknown application

**Solutions**:
1. **Click "More info"**
2. **Select "Run anyway"**
3. **Permanent Fix**:
   - Windows Security → App & browser control
   - Turn off "SmartScreen for Microsoft Edge"
   - Add exclusion for UAP Invaders

#### Installer fails with "Access denied"
**Problem**: Insufficient permissions

**Solutions**:
1. **Run as Administrator**:
   - Right-click installer
   - Select "Run as administrator"

2. **Check Folder Permissions**:
   - Ensure installation directory is writable
   - Try different location (e.g., Desktop)

3. **Disable Antivirus Temporarily**:
   - Some AV software blocks installers
   - Re-enable after installation

### Linux

#### "Permission denied" when running AppImage
**Problem**: Execute bit not set

**Solutions**:
```bash
# Make executable
chmod +x UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Run directly
./UAP.Invaders.Contact.Protocol-1.0.0.AppImage

# Or with explicit interpreter
./UAP.Invaders.Contact.Protocol-1.0.0.AppImage --appimage-extract-and-run
```

#### Missing dependencies error
**Problem**: Required system libraries not installed

**Solutions**:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install libgtk-3-0 libx11-xcb1 libxss1 libasound2

# Fedora
sudo dnf install gtk3 libX11 xcb libXss alsa-lib

# Arch
sudo pacman -S gtk3 libx11 libxss alsa-lib
```

## Runtime Issues

### Game Performance

#### Low FPS or stuttering
**Problem**: Frame rate below 60fps

**Solutions**:
1. **Check System Resources**:
   - Close other applications
   - Check CPU usage in Task Manager/Activity Monitor

2. **Graphics Settings**:
   - Update graphics drivers
   - Disable hardware acceleration:
     ```bash
     # Linux
     ./UAP.Invaders.AppImage --disable-gpu
     
     # Windows
     "UAP Invaders.exe" --disable-gpu
     ```

3. **In-Game Settings** (future):
   - Lower graphics quality
   - Reduce particle effects
   - Disable background animations

#### Black screen on launch
**Problem**: Canvas not rendering

**Solutions**:
1. **Check Browser Compatibility** (web version):
   - Ensure browser supports HTML5 Canvas
   - Enable JavaScript
   - Disable ad blockers

2. **Verify Hardware Acceleration**:
   - Try disabling GPU acceleration
   - Update graphics drivers

3. **Clear Cache**:
   ```bash
   # Electron
   rm -rf ~/Library/Application\ Support/UAP\ Invaders/
   
   # Windows
   rmdir /s "%APPDATA%\UAP Invaders"
   
   # Linux
   rm -rf ~/.config/UAP-Invaders/
   ```

### Control Issues

#### Mouse not working
**Problem**: Mouse input not detected

**Solutions**:
1. **Check Focus**:
   - Click on game window to ensure focus
   - Check if another app is capturing input

2. **Verify Event Listeners**:
   - Open browser console (F12)
   - Look for JavaScript errors
   - Check for mouse event errors

3. **Test in Different Browser** (web version):
   - Try Chrome, Firefox, Safari
   - Check if browser-specific issue

#### Clicks not registering
**Problem**: Shooting not working

**Solutions**:
1. **Check Energy Level**:
   - Must have at least 10 energy to shoot
   - Wait for energy to regenerate

2. **Verify Click Detection**:
   - Ensure clicking in game area, not UI
   - Check if other elements capturing clicks

3. **Disable Browser Extensions**:
   - Some extensions interfere with clicks
   - Try incognito/private mode

### Audio Issues

#### No sound in game
**Status**: Not implemented yet

**Solution**: Audio system planned for v1.1
- Follow development on GitHub
- Vote for audio feature in issues

## Build Issues

### npm install fails

#### "EACCES: permission denied"
**Problem**: npm permissions issue

**Solutions**:
```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) node_modules

# Or use npx
npx electron .

# Or use Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

#### "node-gyp rebuild failed"
**Problem**: Native module compilation error

**Solutions**:
```bash
# Install build tools
# macOS
xcode-select --install

# Windows
npm install -g windows-build-tools

# Linux
sudo apt-get install build-essential

# Clean rebuild
rm -rf node_modules
npm install
```

### Build fails on specific platform

#### macOS build fails
**Problem**: Code signing or notarization issues

**Solutions**:
```bash
# Skip code signing for development
export CSC_LINK=""

# Use development certificate
export CSC_LINK="path/to/dev/cert.p12"

# Check notarization status
xcrun altool --notarization-history --username "developer@apple.com"
```

#### Windows build fails
**Problem**: Missing Windows SDK

**Solutions**:
```bash
# Install with Chocolatey
choco install visualstudio2019buildtools

# Or manually download
# https://visualstudio.microsoft.com/downloads/
```

## Data Issues

### High scores not saving

#### LocalStorage not working
**Problem**: Browser settings blocking storage

**Solutions**:
1. **Check Browser Settings**:
   - Ensure "Block third-party cookies" is off
   - Check site-specific settings
   - Try different browser

2. **Verify Storage Available**:
   ```javascript
   // In browser console
   localStorage.setItem('test', 'value');
   console.log(localStorage.getItem('test'));
   ```

3. **Check for Errors**:
   - Open browser console (F12)
   - Look for storage errors
   - Check quota exceeded

#### High scores disappeared
**Problem**: Data corruption or clearing

**Solutions**:
1. **Check Browser Settings**:
   - Clearing browser data removes high scores
   - Check "Clear on exit" settings

2. **Export/Import** (future feature):
   - Manual backup of high scores
   - Screenshot of high scores

3. **Recovery**:
   - Check browser cache/backup
   - Use file recovery tools

## Network Issues

### Auto-update not working
**Problem**: Update check failing

**Solutions**:
1. **Check Internet Connection**:
   - Verify network connectivity
   - Check firewall settings

2. **Update Server Status**:
   - Check GitHub for new releases
   - Verify update URLs are accessible

3. **Manual Update**:
   - Download latest version from GitHub
   - Install over current version

### Can't download updates
**Problem**: Download failing

**Solutions**:
1. **Check Disk Space**:
   - Ensure space for download
   - Clear temporary files

2. **Download Manually**:
   - Use direct download links
   - Bypass auto-updater

3. **Check SSL Certificates**:
   - System date must be correct
   - Update root certificates

## Getting Help

### Debug Information Collection
When reporting issues, please provide:

1. **System Information**:
   - Operating system and version
   - Hardware specifications
   - Browser version (web version)

2. **Error Details**:
   - Exact error message
   - Steps to reproduce
   - Frequency of occurrence

3. **Console Output**:
   - Browser console errors (F12)
   - Electron debug logs
   - Terminal output from build

### Contact Methods
1. **GitHub Issues**:
   - Search existing issues first
   - Create new issue with details
   - Use appropriate labels

2. **Community Forums**:
   - GitHub Discussions
   - Stack Overflow with `uap-invaders` tag

3. **Direct Support**:
   - Email: support@uapinvaders.com
   - Include debug information

---

For additional help, see the [documentation index](README.md) or check [FAQ.md](FAQ.md) for common questions.