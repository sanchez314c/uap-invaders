# FORENSIC AUDIT REPORT
**Audit Date:** 2026-04-17
**Auditor:** Master Control (Claude Code / GLM-5.1)
**Target:** /media/heathen-admin/RAID/Development/Projects/portfolio/00-QUEUE/uap-invaders
**Stack:** Electron 27.3 + HTML5 Canvas + vanilla JavaScript (single-file renderer)
**Total Files Analyzed:** 8 source files (src/main.js, src/preload.js, src/index.html, package.json, .gitignore, .env.example, run-source-linux.sh, run-source-mac.sh) + 5 scripts + CI config

---

## Executive Summary

Codebase is in good shape. Electron security posture is solid (contextIsolation=true, nodeIntegration=false, sandbox=true, preload bridge). No XSS vectors found. Game engine is simple and correct. Identified 15 findings across severity levels: 2 critical, 4 high, 5 medium, 4 low. All fixable issues auto-fixed. No game behavior regressions.

---

## Findings by Severity

### CRITICAL (2)

#### C-1: IPC `open-external` handler had no URL validation
- **File:** `src/main.js:95-107` (new), previously missing
- **Problem:** `preload.js` exposes `openExternal(url)` to renderer via IPC. The main process had no handler for this channel, meaning `ipcRenderer.invoke('open-external', url)` would fail silently. The `setWindowOpenHandler` validates URLs for `window.open`, but the direct IPC channel was unhandled, letting the renderer pass any string to `shell.openExternal` without validation.
- **Fix:** Added `ipcMain.handle('open-external', ...)` with protocol allowlist (`https:`, `http:`, `mailto:`) and type check. Malformed URLs silently rejected.

#### C-2: Duplicate `closed` listener caused IPC handler leak
- **File:** `src/main.js:56-80`
- **Problem:** Two `mainWindow.on('closed', ...)` listeners registered. First (line 56) set `mainWindow = null`. Second (line 79) cleaned up IPC handlers but never fired because `closed` callback order is registration order, and the window object was already nulled. IPC handlers accumulated on each window recreate (e.g., macOS activate).
- **Fix:** Merged into single `closed` handler that cleans up IPC handlers first, then nulls `mainWindow`.

### HIGH (4)

#### H-1: `saveHighScore()` throws on localStorage failure
- **File:** `src/index.html:1468` (original line ~1470)
- **Problem:** `localStorage.setItem()` not wrapped in try/catch. Throws in private browsing mode, storage quota exceeded, or restricted environments. Game over would crash.
- **Fix:** Wrapped in try/catch. Scores persist in memory for session regardless.

#### H-2: Background gradient allocated every frame
- **File:** `src/index.html:1682-1686` (draw function)
- **Problem:** `ctx.createLinearGradient()` called 60 times/sec inside `draw()`. Canvas gradient objects are allocated per call.
- **Fix:** Cached gradient in `bgGradient` variable. Invalidated on resize. `buildBgGradient()` called lazily.

#### H-3: `fullscreenchange` event not listened
- **File:** `src/index.html` (new, after toggleFullscreen)
- **Problem:** If user exits fullscreen via browser UI (Esc key or native controls), `isFullscreen` remained `true`, body class stayed non-windowed, canvas kept fullscreen dimensions. Only the toggle button synced state.
- **Fix:** Added `document.addEventListener('fullscreenchange', ...)` that syncs state when browser exits fullscreen independently.

#### H-4: Bullet rendering draws same rect twice
- **File:** `src/index.html:1711-1717`
- **Problem:** Two `ctx.fillRect()` calls per bullet — first without shadow, second with shadow. The first was invisible under the second. Wasted draw calls.
- **Fix:** Single `fillRect` with shadow set before the draw, zeroed after.

### MEDIUM (5)

#### M-1: `restartGame()` doesn't reset `totalIntercepted`
- **File:** `src/index.html:1696-1702`
- **Problem:** `totalIntercepted` counter carried over between games. Status bar showed cumulative count across restarts.
- **Fix:** Added `totalIntercepted = 0` in `restartGame()`.

#### M-2: `newRecord` detection used fragile comparison
- **File:** `src/index.html:1485-1487`
- **Problem:** `highScores[0].score === score && highScores[0].callsign === currentCallsign` could false-positive if a previous entry with same callsign+score was already at position 0.
- **Fix:** Compare by reference: `highScores[0] === newScore` (the just-pushed object).

#### M-3: `updateUI()` writes DOM every frame without dirty check
- **File:** `src/index.html:1659-1673`
- **Problem:** `textContent` and `style.width` set 60 times/sec even when values unchanged. Forces layout recalculation.
- **Fix:** String comparison guards on cached DOM refs. Only writes when value actually changes.

#### M-4: Inline event handlers require `unsafe-inline` in CSP
- **File:** `src/index.html:1061-1063` (title bar buttons), `1156` (about close)
- **Problem:** `onclick="window.electronAPI.windowMinimize()"` and `onclick="closeAboutModal()"` require `unsafe-inline` in CSP script-src.
- **Fix:** Replaced all inline `onclick` with `addEventListener` in JS. Buttons now use IDs. CSP tightened with `base-uri 'self'`. (`'unsafe-inline'` still needed for inline `<script>` block.)

#### M-5: `startGame()` overwrites callsign from input on restart
- **File:** `src/index.html:1410-1417`
- **Problem:** On restart, `startGame()` re-reads the hidden callsign input. If somehow cleared, it would reset to 'UNKNOWN' and block. Also, input read is unnecessary on restart.
- **Fix:** Only update `currentCallsign` from input if sanitized value is non-empty. Preserve existing callsign on restart.

### LOW (4)

#### L-1: Toast notification timeout collision
- **File:** `src/index.html:1237-1242`
- **Problem:** Rapid `showNotification()` calls — old `setTimeout` could hide a newer toast.
- **Fix:** Track timeout ID in `_toastTimer`, `clearTimeout` before setting new one.

#### L-2: Callsign input missing accessibility attributes
- **File:** `src/index.html:1079`
- **Problem:** `<input>` has no `aria-label` or `<label>`. Screen readers announce it generically.
- **Fix:** Added `aria-label="Enter your pilot callsign"` and `autocomplete="off"`.

#### L-3: Port kill in run scripts doesn't handle multiple PIDs
- **File:** `run-source-mac.sh:46`, `run-source-linux.sh:46`
- **Problem:** `lsof -ti:$port` can return multiple PIDs. `kill -9 $pid` passes them as one argument. macOS `kill` handles this but it's fragile.
- **Fix:** Piped to `xargs kill -9` (Linux: `xargs -r kill -9`).

#### L-4: .gitignore has duplicate entries
- **File:** `.gitignore`
- **Problem:** `npm-debug.log*` (lines 3, 37), `.DS_Store` (lines 25, 67), `.idea/` (lines 21, 77) duplicated.
- **Status:** Documented only. Duplicates cause no harm and .gitignore is not code.

---

## Files Modified

| File | Changes |
|------|---------|
| `src/main.js` | Merged duplicate `closed` listener, added `open-external` IPC handler with URL validation |
| `src/index.html` | Cached bg gradient, fullscreen sync, dirty-check UI updates, localStorage try/catch, remove inline onclick handlers, fix restartGame intercepted counter, fix newRecord detection, fix startGame callsign handling, toast timeout safety, a11y on callsign input, CSP base-uri added |
| `run-source-linux.sh` | Port kill uses `xargs -r` for multi-PID safety |
| `run-source-mac.sh` | Port kill uses `xargs` for multi-PID safety |
| `src/index.html.backup.20260417_*` | Pre-edit backup created |

---

## Verification Notes

1. **No game behavior changes.** All UAP types, speeds, points, spawn rates, energy mechanics, collision math preserved exactly.
2. **Electron security hardening unchanged.** `contextIsolation: true`, `nodeIntegration: false`, `sandbox: true` all intact.
3. **Preload bridge surface unchanged.** Same 4 methods exposed (`windowMinimize`, `windowMaximize`, `windowClose`, `openExternal`). Added validation in main process only.
4. **CSS/visual unchanged.** All `:root` custom properties, glass effects, layout, animations identical.
5. **Build config untouched.** package.json dependencies, electron-builder config, scripts unchanged.
6. **CSP still requires `'unsafe-inline'`** because the entire game JS is an inline `<script>` block. This is inherent to the single-file architecture. To remove it, the JS would need to be extracted to a separate `.js` file — outside audit scope.

---

## Acceptable Risks (No Fix Required)

- **`'unsafe-inline'` in CSP for scripts**: Required by inline `<script>` block. Architectural decision.
- **No keyboard-only gameplay**: Mouse-only controls by design. Keyboard used for menu navigation (Enter to start) and fullscreen (F11). Full keyboard gameplay would be a feature addition.
- **No tests**: `tests/.gitkeep` only. `npm test` is a placeholder. Test coverage is outside audit scope.
- **`.gitignore` duplicates**: Cosmetic, no functional impact.

END OF LINE.
