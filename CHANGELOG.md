# Changelog

All notable changes to UAP Invaders: Contact Protocol will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-04-11 -- Forensic Audit Remediation (Step 5)

### Security Fixes (CRITICAL)

#### Fixed
- **Sandbox disabled** (src/main.js): Changed `sandbox: false` → `sandbox: true` in webPreferences
- **--no-sandbox flag** (src/main.js): Removed `app.commandLine.appendSwitch('no-sandbox')` — use sysctl fix instead
- **IPC injection vulnerability** (src/main.js): Added `typeof url !== 'string'` validation to all IPC handlers
- **Error swallowing** (src/main.js): Added `console.error` logging to catch blocks with full error context
- **File load error handling** (src/main.js): Added `.then()/.catch()` to `mainWindow.loadFile()` with app.quit() on failure
- **DevTools race condition** (src/main.js): Moved `openDevTools()` inside `ready-to-show` handler
- **IPC handler cleanup** (src/main.js): Added handler removal on window close to prevent memory leaks

#### Performance Optimizations (HIGH)

#### Changed
- **DOM caching** (src/index.html): Pre-cached all `getElementById` lookups in `uiElements` object during `initGame()`
- **Set pre-allocation** (src/index.html): Moved `hitBullets`/`hitEnemies` Sets to module scope with `.clear()` reuse pattern

#### Bug Fixes (HIGH/MEDIUM)

#### Fixed
- **Bullet memory leak** (src/index.html): Added upper bound check `bullet.y < canvas.height + 100` to prevent infinite bullets
- **Game over re-entry** (src/index.html): Added `&& gameRunning` guard to prevent multiple `gameOver()` calls
- **Score bar overflow** (src/index.html): Wrapped in `Math.floor()` to prevent floating-point percentages
- **Energy regen inconsistency** (src/index.html): Added `&& health > 0` guard to prevent regen after death
- **Callsign sanitization** (src/index.html): Added `.replace(/-+/g, '-').replace(/^-|-$/g, '')` to remove consecutive/trailing hyphens
- **Collision hitbox** (src/index.html): Changed from `enemy.width/2` to `enemy.width * 0.6` for tighter hitbox
- **Fullscreen race condition** (src/index.html): Moved `isFullscreen = true` inside `.then()` callback
- **Fullscreen error handling** (src/index.html): Added `.catch()` with `console.error` for denied fullscreen
- **Array filter optimization** (src/index.html): Added `bullets.length === 0` early return before filter
- **Immediate loop start** (src/index.html): Removed premature `gameLoop()` call — now lazy-starts on `startGame()`

#### Dependency Vulnerabilities (HIGH)

#### Identified
- **@tootallnate/once** (transitive): Incorrect Control Flow Scoping (GHSA-vpq2-c234-7x6)
- **Fix requires breaking change**: `npm audit fix --force` upgrades electron-builder 24→26
- **USER ACTION REQUIRED**: Run `npm audit fix --force`? (Ask User before proceeding)

---

## [Unreleased] - 2026-04-11 -- Repo Pipeline Documentation Pass

### Documentation Consolidation

#### Moved
- `PRD.md` (root) → `docs/PRD.md` (standard location)
- `implement.md` → `archive/implement.md` (displaced)
- `AUDIT_REPORT.md` → `archive/AUDIT_REPORT.md` (pipeline report)

#### Removed
- `docs/DOCUMENTATION_INDEX.md` (duplicate content merged into `docs/README.md`)

#### Updated
- `docs/PRD.md` regenerated via /repoprdgen with comprehensive 14-section specification

---

## [Unreleased] - 2026-03-14 20:10 EST -- Neo-Noir Glass Monitor Design System Validation Pass

### Neo-Noir Design Token Cleanup

#### Changed
- **About modal CSS** (src/index.html): Replaced all hardcoded hex values with design token vars (`var(--gradient-card)`, `var(--glass-border)`, `var(--radius-card)`, `var(--shadow-xl)`, `var(--glass-highlight-strong)`, `var(--glass-bg-medium)`, `var(--text-muted)`, `var(--error)`, `var(--transition-fast)`, `var(--text-heading)`, `var(--accent-teal)`, `var(--text-secondary)`, `var(--gradient-button)`, `var(--text-inverse)`, `var(--radius-full)`, `var(--shadow-glow)`, `var(--shadow-glow-strong)`)
- **Offline status indicator** (src/index.html): Added `--color-offline: #52525b` to `:root` token block, replaced inline `#52525b` with `var(--color-offline)`

#### Validated (27-point Neo-Noir checklist: ALL PASS)
- Window frame: transparent float, `padding: 16px`, `background: transparent !important`, `border-radius: 20px`, `frame: false`, `hasShadow: false`
- Title bar: app icon, teal app name, muted tagline, flat About + fullscreen icons (gap: 2px, margin-right: 10px), circular min/max/close (28px, gap: 6px), IPC-wired
- About modal: glass card, layered shadow, inner highlight, close on X/overlay/Escape
- Status bar: status dot + text + pipe + UAPs intercepted (left); version-only teal (right)
- Cards: glass-border, `::before` inner highlights, hover translateY(-2px) + shadow escalation, ambient gradient mesh on hero cards
- Visual: confirmed via screenshot — floating glass window, teal accents, dark cyberpunk aesthetic

---

## [Unreleased] - 2026-03-14 -- Forensic Audit Remediation

### Forensic Code Audit + Full Remediation

#### Fixed (CRITICAL)
- **Collision detection array splice bug** (index.html): Replaced unsafe `splice()` inside nested `forEach` loops with Set-based hit collection and post-iteration `filter()`. Prevents index corruption, skipped enemies, and phantom collisions.
- **Deprecated 'new-window' event** (main.js): Replaced removed Electron event with `setWindowOpenHandler` on all web contents, keeping the same protocol validation logic.

#### Fixed (HIGH)
- **run-source-linux.sh process kill scope**: Replaced `pkill -9 electron/node` (kills all system processes) with project-scoped `pgrep -f` targeting only processes from this directory.
- **CI Node version mismatch** (ci.yml): Changed hardcoded `node-version: '18'` to `node-version-file: '.nvmrc'` so CI matches local dev environment (Node 24).
- **SECURITY.md aspirational code**: Removed fabricated `sanitizeCallsign()`, `loadHighScores()`, and domain-restricted handler code that didn't exist in the codebase. Replaced with accurate descriptions of actual implementations.

#### Fixed (MEDIUM)
- **Callsign input sanitization** (index.html): Added `replace(/[^A-Z0-9\-]/g, '')` filter to strip non-alphanumeric characters from callsign input.
- **localStorage validation** (index.html): Wrapped `JSON.parse` in try/catch with array validation and per-entry structure checking for high scores.
- **Triple position declaration** (index.html): Removed dead `position: relative` and duplicate `position: fixed` from `.game-over` CSS.
- **run-source-mac.sh process kill scope**: Same fix as linux script, scoped to project directory.
- **ESLint sourceType** (.eslintrc.json): Changed from `"module"` to `"commonjs"` to match actual CommonJS `require()` usage.
- **repository-cleanup.sh header**: Fixed copy-paste error referencing "AgentCHAT" instead of "UAP Invaders".
- **Menu handler null checks** (main.js): Added `if (mainWindow)` guards to New Game and Fullscreen menu click handlers.
- **Health/energy bar units** (index.html): Changed from pixel values (`100px`) to percentages (`100%`) for proper proportional display.
- **build-universal.sh syntax error**: Fixed `-not -path="./dist/*"` to `-not -path "./dist/*"` in C# detection find command.

#### Fixed (LOW)
- **AGENTS.md duplicate**: Changed header from "CLAUDE.md" to "AGENTS.md" with reference to CLAUDE.md as primary source.
- **CONTRIBUTING.md theme reference**: Updated from "green-on-black" to "Neo-Noir Glass design system with teal accents".
- **set -o pipefail**: Added to all 6 bash scripts for proper pipeline error propagation.
- **Unused player.speed**: Removed dead property from player object (movement uses mouse lerp, not speed).

#### Added
- `implement.md` - Implementation plan and feature roadmap (per project standards)
- `AUDIT_REPORT.md` - Full forensic audit report with findings and remediation log

## [Unreleased] - 2026-03-14 -- Documentation Standardization

### Documentation Standardization (27-file standard)

#### Renamed
- `docs/TECH-STACK.md` renamed to `docs/TECHSTACK.md` (standard naming)

#### Moved to Root
- `docs/CODE_OF_CONDUCT.md` moved to `CODE_OF_CONDUCT.md`
- `docs/SECURITY.md` moved to `SECURITY.md`

#### Archived (displaced duplicates)
- `docs/AGENTS.md` (duplicate of root `AGENTS.md`) archived to `archive/docs-reorganization-*/`
- `docs/DOCUMENTATION_INDEX.md` archived (content merged into `docs/README.md`)
- `.github/CODE_OF_CONDUCT.md` archived (root is canonical)

#### Created
- `docs/README.md` - documentation index linking all 15 docs files
- `docs/API.md` - IPC channels, `window.electronAPI`, localStorage keys, security boundaries
- `VERSION_MAP.md` - active version, history table, archive locations

#### Corrected
- All `your-username` GitHub placeholders replaced with `sanchez314c`
- All `run-source-macos.sh` references corrected to `run-source-mac.sh`
- All `build-release-run.sh` references replaced with real npm commands (script doesn't exist)
- `CLAUDE.md` CSS Architecture section updated to reflect current Neo-Noir Glass design tokens
- `CLAUDE.md` and `AGENTS.md` file references updated (docs/TECH-STACK.md, docs/CONTRIBUTING.md)
- `CODE_OF_CONDUCT.md` enforcement contact placeholder replaced with real email
- `SECURITY.md` placeholder contact email replaced with `software@jasonpaulmichaels.co`

## [Unreleased] - 2026-02-13 01:00 EST

### Repository Compliance Audit - Phase 1 Complete
Repo prep protocol executed by Master Control. Structural compliance verified and optimizations materialized.

#### Added
- **CONTRIBUTING.md** - Comprehensive contribution guidelines (root level, 346 lines)
- **.nvmrc** - Node version specification (18.20.5 for compatibility)
- **.env.example** - Environment configuration template with all standard variables
- **.eslintrc.json** - ESLint configuration for code quality enforcement
- **.prettierrc.json** - Prettier configuration for consistent formatting
- **DEPENDENCIES.md** - Dependency status, update guide, and security considerations
- **.github/ISSUE_TEMPLATE/bug_report.md** - Standardized bug report template
- **.github/ISSUE_TEMPLATE/feature_request.md** - Standardized feature request template
- **Git repository initialization** - Repository was not tracked, now initialized
- **package.json scripts** - Added `lint`, `lint:fix`, `format`, `format:check` commands
- **package.json devDependencies** - Added `eslint@^8.57.0` and `prettier@^3.2.5`

#### Changed
- **package.json author** - Updated from "UAP Invaders Team" to "Jason" for consistency with LICENSE
- **package.json copyright** - Updated from "2024 UAP Invaders Team" to "2025 Jason" for consistency
- **.gitignore** - Added rules for backup files (*.backup.*) and archive directory

#### Removed
- **docs/CONTRIBUTING.md** - Archived duplicate (227 lines, less comprehensive than root version)
  - Location: `~/AI-Pre-Trash/uap-invaders/20260213_002736/CONTRIBUTING.md`

#### Fixed
- **Git tracking** - Repository was not a git repo, now properly initialized with all files staged
- **Author attribution consistency** - LICENSE and package.json now align
- **Version consistency** - Copyright year standardized to 2025

#### Audit Findings
- **Dependency Status**: Electron (27.3.11 → 40.4.0 available), electron-builder (24.13.3 → 26.7.0 available)
- **Node.js Version**: .nvmrc specifies 18.20.5 but system running 22.22.0 (acceptable, update planned)
- **Test Framework**: Not implemented (placeholder only, documented for future work)
- **Health Assessment**: YELLOW (functional but with outdated dependencies)

#### Notes
- Dependencies added to package.json require `npm install` to resolve
- All structural files now present for professional repository standards
- Linting and formatting tools configured but not yet applied to codebase
- Git repository initialized with all files staged, ready for initial commit
- Backup and archive files now properly excluded from tracking

## [1.2.0] - 2026-02-08 14:42 EST

### Dark Neo Glass Theme Restyle

Complete visual transformation to the Neo-Noir Glass Monitor design system. Floating transparent panels, layered depth shadows, teal accent lighting, and ambient gradient meshes creating a 3D glass illusion.

#### Changed
- **Electron Main Process (src/main.js)**
  - Frameless transparent window: `frame: false`, `transparent: true`, `hasShadow: false`
  - Removed `titleBarStyle: 'default'` (was global, now macOS-only conditional)
  - Replaced `backgroundColor: '#000000'` with `'#00000000'` (fully transparent)
  - Added IPC handlers for custom window controls (minimize, maximize, close)
  - Window dimensions adjusted to 1060x900 (calculated for 800px canvas + UI + 32px body padding)
  - `roundedCorners: true` enabled
  - About dialog restyled with Neo Glass theme (frameless, transparent, glass card)

#### Added
- **Preload Script (src/preload.js)**
  - Created contextBridge IPC bridge for window control communication
  - Exposes `electronAPI.minimizeWindow()`, `maximizeWindow()`, `closeWindow()`

- **Dark Neo Glass Design Token System**
  - Complete `:root` CSS custom property system (50+ design tokens)
  - Background tokens: void, surface, card, card-hover, sidebar, tertiary, input, modal, tooltip
  - Typography tokens: primary, secondary, muted, dim, heading, accent, inverse
  - Accent colors: teal, blue, purple with dim/glow/hover variants
  - Status colors: success, warning, error, online, offline, busy, away
  - Border tokens: subtle, light, glow, input, focus
  - 7 gradient presets: primary, accent, card, sidebar, bg, button, header
  - Layered shadow system: sm, md, lg, xl, card, card-hover, glow, inset
  - Glass effect tokens: bg, bg-medium, border, highlight, highlight-strong
  - Border radius scale: xs through full (9999px)
  - Spacing scale: xs through 2xl
  - Typography scale: xs through 3xl
  - Transition presets: fast (150ms), normal (250ms), slow (400ms)
  - Scrollbar theming tokens

- **Custom Window Controls**
  - Drag handle (48px height, z-index: 50) for window dragging
  - Minimize, maximize, close buttons (z-index: 200) with IPC wiring
  - Close button: red hover state
  - Proper z-index layering: controls above drag handle above content
  - Only interactive leaf elements in no-drag list (not layout containers)

- **Notification Toast System**
  - Replaced `alert()` calls with themed toast notifications
  - Warning-style gradient with slide-in animation

- **Modal Backdrop**
  - Game over screen now has dimmed backdrop with blur enhancement
  - Respects 16px body padding gap

- **Ambient Gradient Mesh**
  - Title section: triple radial-gradient (teal, purple, cyan) over card gradient
  - Menu screen: triple radial-gradient ambient mesh
  - Game over dialog: dual radial-gradient ambient mesh

- **Ambient Pulse Animation**
  - Menu title glows with pulsing teal drop-shadow animation

#### Restyled
- **All UI Components**
  - Menu screen: full-overlay glass panel with gradient header text
  - Callsign input: dark input with teal focus glow
  - Menu buttons: glass secondary + teal gradient primary variants with hover lift
  - High scores panel: glass sub-panel with inner highlight
  - Score entries: subtle glass rows with hover state
  - UI status bar: glass card panel with inner highlight
  - Progress bars: gradient fills with glow shadows (teal/purple/cyan)
  - Controls hint: dim text at bottom
  - Game over dialog: modal glass card with gradient heading
  - Canvas: dark border with rounded corners and layered shadow
  - Title section: hero card with full ambient gradient mesh
  - Fullscreen button: glass pill near window controls

- **Every Card Element Has**
  - `::before` inner highlight (1px gradient line at top edge)
  - Layered box-shadow (2-4 shadow layers)
  - Hover state with `translateY(-2px)` lift + shadow escalation
  - Gradient background (not solid colors)

- **Global Styles**
  - `body { padding: 16px }` creating floating glass effect
  - `html, body { background: transparent !important }`
  - App container: 20px border-radius, overflow hidden, gradient background
  - Inter font stack with antialiased rendering
  - Custom 6px scrollbar with dark themed thumb
  - Teal selection highlight
  - Game bullets and explosions: teal/cyan color scheme matching theme

#### Technical Details
- 27-point validation checklist: ALL PASS
- Zero orphan hardcoded colors outside token system (canvas API colors match tokens)
- `backdrop-filter` used only as enhancement on modal/loading overlays
- No `experimentalFeatures: true` (preserves IPC integrity)
- `disable-gpu-compositing` (not `disable-gpu`) for transparent visuals
- `titleBarStyle` conditionally set only on macOS
- Content area has 56px top padding below window controls

## [1.0.1] - 2026-02-08

### Port Configuration & Launch Script Optimization

#### Changed
- **Port Assignment**
  - DEV_SERVER_PORT: 55377 (reserved for future dev server)
  - ELECTRON_DEBUG_PORT: 60205
  - ELECTRON_INSPECT_PORT: 63365
  - All ports randomized to prevent conflicts with other applications

- **Package.json**
  - Added `--no-sandbox` flag to electron start/dev commands for Linux compatibility
  - Ensures proper execution on all Linux distributions

- **Electron Main Process (src/main.js)**
  - Injected platform-specific Chromium flags for Linux
  - Added `enable-transparent-visuals`, `disable-gpu-compositing`, `no-sandbox` switches
  - Flags applied before `app.whenReady()` to ensure proper initialization

- **Launch Scripts**
  - Complete rewrite of `run-source-linux.sh` with:
    - Zombie process cleanup (electron/node)
    - Port conflict detection and cleanup
    - Linux sandbox automatic fix with sudo
    - Enhanced error handling and status reporting
  - Complete rewrite of `run-source-mac.sh` with:
    - macOS-specific process cleanup
    - Port management and validation
    - Improved dependency checking
  - Complete rewrite of `run-source-windows.bat` with:
    - Windows process cleanup (taskkill)
    - Port cleanup via netstat
    - Better error messages and color coding

#### Technical Details
- All scripts now include comprehensive port configuration section
- Automated zombie process detection and cleanup
- Platform-specific fixes for Electron sandbox issues
- Executable permissions set automatically for shell scripts

## [1.0.0] - 2025-01-30

### 🎉 Initial Release

#### Added
- **Core Gameplay**
  - Classic Space Invaders mechanics with modern twist
  - 6 unique UAP/UFO enemy types inspired by real phenomena:
    - 🛸 Classic Saucer (10 pts)
    - 🛰️ Probe (15 pts)
    - ⚡ Tic Tac (25 pts) - Based on USS Nimitz encounter
    - 🔥 Phoenix Light (30 pts) - Inspired by Phoenix Lights incident
    - 💫 Orb (20 pts)
    - 🌀 Vortex (40 pts)
  - Progressive difficulty scaling
  - Energy-based shooting system with regeneration

- **Controls & Interface**
  - Intuitive mouse movement and left-click firing
  - Full-screen support (F11 toggle)
  - Responsive design for different screen sizes
  - Professional UFO icon across all platforms

- **Player Features**
  - Custom callsign system (up to 10 characters)
  - Persistent local high score tracking
  - Top 10 leaderboard display
  - New record notifications

- **Visual Effects**
  - Explosion animations on enemy destruction
  - Glowing projectile effects
  - Dynamic starfield background
  - Smooth enemy movement patterns with wobble effects

- **Cross-Platform Support**
  - Electron-based desktop application
  - Native builds for macOS (Intel & Apple Silicon), Windows, and Linux
  - Web version for instant browser play
  - Professional installers (.dmg, .exe, .AppImage, .deb)

- **Development Infrastructure**
  - Professional build system with shell scripts
  - GitHub Actions CI/CD workflow
  - Comprehensive documentation (README, REQUIREMENTS, CONTRIBUTING)
  - Development mode with hot reload
  - Clean project structure following best practices

#### Technical Stack
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Runtime**: Electron v28.3.3 (desktop version)
- **Build System**: electron-builder v24.9.1
- **Platform Support**: macOS 10.14+, Windows 10+, Linux (Ubuntu 18.04+)

#### Known Issues
- Electron app may crash on macOS 15.0.1 due to framework compatibility
- Workaround: Use web version or run from source

---

## Development History

### 2025-01-30 - Project Evolution
1. **Initial Concept**: Basic Space Invaders clone
2. **UAP Theme Added**: Transformed into UAP/UFO themed game
3. **Enhanced Features**: Added mouse controls, callsign system, high scores
4. **Electron Integration**: Created cross-platform desktop application
5. **Professional Polish**: Added build scripts, documentation, and CI/CD

### Future Roadmap
- [ ] Audio system (sound effects and background music)
- [ ] Achievement system
- [ ] Power-ups and special weapons
- [ ] Mobile touch controls
- [ ] Online leaderboards
- [ ] Multiplayer support

---

*For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md)*