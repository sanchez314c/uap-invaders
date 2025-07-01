# API Reference

UAP Invaders uses Electron's contextBridge IPC pattern. There is no HTTP API. All inter-process communication flows through `src/preload.js` via the `window.electronAPI` object exposed to the renderer.

## IPC Channels (Main Process Handlers)

Defined in `src/main.js` via `ipcMain.handle()`.

| Channel | Direction | Description |
|---------|-----------|-------------|
| `minimize-window` | Renderer → Main | Minimizes the main window |
| `maximize-window` | Renderer → Main | Toggles maximize/restore on the main window |
| `close-window` | Renderer → Main | Closes the main window |
| `show-about` | Renderer → Main | Opens the About modal dialog |

All handlers are async and return `undefined`. They do not throw on invalid state (e.g., calling minimize when `mainWindow` is null is a no-op).

## Renderer API (`window.electronAPI`)

Exposed via `src/preload.js` using `contextBridge.exposeInMainWorld`.

```javascript
window.electronAPI = {
  minimizeWindow: () => Promise<void>,
  maximizeWindow: () => Promise<void>,
  closeWindow:    () => Promise<void>,
  showAbout:      () => Promise<void>,
}
```

### `minimizeWindow()`
Minimizes the application window. Invokes `minimize-window` IPC channel.

### `maximizeWindow()`
Toggles between maximized and restored window state. Invokes `maximize-window` IPC channel.

### `closeWindow()`
Closes the application window. On macOS this does not quit the app (standard macOS behavior). Invokes `close-window` IPC channel.

### `showAbout()`
Opens a modal About dialog showing version, description, GitHub link, and contact email. The modal is a frameless transparent child window rendered from an inline HTML string. Invokes `show-about` IPC channel.

## Game State API (Renderer-Internal)

The game state is managed entirely within `src/index.html`. It is not exposed to the main process. Key state variables:

| Variable | Type | Description |
|----------|------|-------------|
| `gameState.screen` | string | Current screen: `MENU_MAIN`, `MENU_HIGH_SCORES`, `MENU_GAME_OVER`, `GAME_PLAYING` |
| `gameState.score` | number | Current session score |
| `gameState.energy` | number | Player energy (0-100, costs 10 per shot, regenerates 1/frame) |
| `uaps` | Array | Active UAP enemy objects |
| `bullets` | Array | Active projectile objects |
| `particles` | Array | Active explosion particle objects |
| `stars` | Array | Background starfield objects |

## Local Storage Keys

High scores and callsigns are persisted via `localStorage` in the renderer. No keys are accessed from the main process.

| Key | Type | Description |
|-----|------|-------------|
| `uapHighScores` | JSON array | Top 10 scores: `[{ callsign: string, score: number, date: string }]` |
| `uapCallsign` | string | Last used pilot callsign (max 10 characters) |

### High Score Schema
```javascript
{
  callsign: string,  // max 10 chars, sanitized
  score: number,     // integer, >= 0
  date: string       // ISO 8601 datetime
}
```

## Application Menu Actions

Defined in `src/main.js` via `Menu.buildFromTemplate`. These are OS-level menu items, not programmatic API.

| Menu | Item | Accelerator | Action |
|------|------|-------------|--------|
| Game | New Game | CmdOrCtrl+N | Reloads the renderer window |
| Game | Toggle Fullscreen | F11 | Toggles fullscreen state |
| Game | Quit | Cmd/Ctrl+Q | Quits the app |
| View | Reload | (default) | Reloads renderer |
| View | Toggle DevTools | (default) | Opens DevTools |
| Help | About UAP Invaders | — | Calls `showAboutWindow()` |

## Security Boundaries

- `nodeIntegration: false` -- renderer has no Node.js access
- `contextIsolation: true` -- renderer cannot access main world globals
- `enableRemoteModule: false` -- remote module disabled
- `webSecurity: true` -- same-origin policy enforced
- All external URL opens are validated for `https:`, `http:`, or `mailto:` protocol before passing to `shell.openExternal()`
- New window creation is denied via `setWindowOpenHandler` returning `{ action: 'deny' }`
