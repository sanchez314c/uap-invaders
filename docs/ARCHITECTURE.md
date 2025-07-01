# Architecture

## System Overview

UAP Invaders: Contact Protocol follows a clean Electron architecture with clear separation between the main process (system integration) and renderer process (game logic).

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    UAP Invaders                        │
├─────────────────────────────────────────────────────────────┤
│  Main Process (src/main.js)                           │
│  ┌─────────────────┐  ┌─────────────────┐           │
│  │ Window Manager  │  │ App Menu      │           │
│  │ Security Config │  │ Platform Logic │           │
│  └─────────────────┘  └─────────────────┘           │
├─────────────────────────────────────────────────────────────┤
│  Renderer Process (src/index.html)                     │
│  ┌─────────────────┐  ┌─────────────────┐           │
│  │ Game Engine     │  │ UI System      │           │
│  │ Canvas API      │  │ Local Storage  │           │
│  └─────────────────┘  └─────────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## Main Process Architecture

### Window Management
- Creates BrowserWindow with security best practices
- Configures window properties (size, icon, web preferences)
- Handles window events (close, resize, focus)
- Manages fullscreen transitions

### Application Menu System
- Custom menu bar with game-specific options
- Platform-specific menu adjustments
- Keyboard shortcuts integration
- External link handling security

### Security Implementation
- Context isolation enabled
- Node integration disabled in renderer
- Web security enabled
- Secure external link handling via shell.openExternal()

## Renderer Process Architecture

### Single-File Design
All game logic, styling, and UI contained within `index.html`:
- HTML structure for game interface
- CSS styling for military theme
- JavaScript for game engine and state management

### Game Engine Components

#### State Management
```javascript
Game States:
- MENU_MAIN
- MENU_HIGH_SCORES
- MENU_GAME_OVER
- GAME_PLAYING
- GAME_PAUSED
```

#### Game Objects
- **Player**: Position, energy, score tracking
- **UAPs**: Array of enemy objects with type-specific properties
- **Bullets**: Active projectiles array
- **Particles**: Explosion effects
- **Stars**: Background starfield

#### Game Loop
1. Input Processing
2. State Updates
3. Collision Detection
4. Rendering
5. UI Updates

### Canvas Rendering System

#### 2D Context Usage
- `requestAnimationFrame` for 60fps gameplay
- Layered rendering approach:
  1. Background (stars)
  2. Game objects (UAPs, player, bullets)
  3. Effects (explosions, UI overlays)

#### Visual Effects
- Particle system for explosions
- Glowing projectile effects
- Dynamic starfield with parallax
- Smooth interpolation for movement

## Data Flow

### Input Flow
```
Mouse Movement → Position Update → Player X Coordinate
Mouse Click    → Energy Check   → Bullet Creation
```

### Game State Flow
```
Menu → Callsign Input → Game Start → Playing → Game Over → High Scores → Menu
```

### Persistence Flow
```
Score → Local Storage → High Score Array → Leaderboard Display
```

## Component Relationships

### UAP System
```javascript
UAP Types {
  Classic Saucer: { emoji: '🛸', points: 10, speed: 1, size: 30 }
  Probe:         { emoji: '🛰️', points: 15, speed: 2, size: 25 }
  Tic Tac:       { emoji: '⚡', points: 25, speed: 3, size: 20 }
  Phoenix Light: { emoji: '🔥', points: 30, speed: 1.5, size: 40 }
  Orb:           { emoji: '💫', points: 20, speed: 2.5, size: 28 }
  Vortex:        { emoji: '🌀', points: 40, speed: 1, size: 45 }
}
```

### Energy System
- Max energy: 100
- Shot cost: 10 energy
- Regeneration rate: 1 energy per frame
- Minimum energy for shot: 10

### Difficulty Progression
- Spawn rate increases every 100 points
- UAP speed increases slightly with score
- Mixed UAP types at higher scores

## Security Architecture

### Electron Security Model
```
┌─────────────────────────────────┐
│ Main Process                  │ ← Full system access
│ (Node.js Environment)         │
├─────────────────────────────────┤
│ IPC Bridge                    │ ← Secure communication
│ (Context Isolation Boundary)   │
├─────────────────────────────────┤
│ Renderer Process              │ ← Sandboxed environment
│ (Browser Context)            │
│ - No Node.js                │
│ - Web Security Enabled        │
│ - Context Isolated          │
└─────────────────────────────────┘
```

### Input Validation
- Callsign input: Sanitized, max 10 characters
- Local storage: Basic validation on load
- External links: Validated and opened via main process

## Performance Considerations

### Rendering Optimizations
- Single canvas for all game objects
- Efficient collision detection (circle-based)
- Object pooling for bullets and particles
- Throttled rendering with requestAnimationFrame

### Memory Management
- Clean up event listeners on state changes
- Remove off-screen objects
- Limit particle count
- Efficient array operations

## Platform-Specific Architecture

### macOS
- Universal binary support (x64 + ARM64)
- Native menu integration
- Touch Bar support (potential)
- Retina display handling

### Windows
- Taskbar integration
- Desktop shortcut creation
- Registry entries for installation
- Windows-specific file paths

### Linux
- Desktop file integration
- MIME type registration
- Package manager integration
- X11/Wayland compatibility

## Future Architecture Considerations

### Potential Enhancements
1. **Modular Architecture**: Split single HTML file into modules
2. **State Management**: Implement Redux-like pattern for complex state
3. **WebGL Rendering**: 3D effects and enhanced visuals
4. **Web Workers**: Offload heavy calculations
5. **Service Workers**: Offline functionality and caching

### Scalability Considerations
- Plugin system for custom UAP types
- Theme system for visual customization
- Mod support for community content
- API integration for online features

This architecture provides a solid foundation that balances simplicity with maintainability, enabling rapid development while ensuring cross-platform compatibility and security.