# Development

## Getting Started

### Prerequisites
- **Node.js**: >= 16.0.0
- **npm**: >= 8.0.0
- **Git**: For version control
- **Code Editor**: VS Code recommended

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders

# Install dependencies
npm install

# Run in development mode
npm run dev
```

## Development Environment

### Running the Application

#### Development Mode
```bash
# Start with DevTools enabled
npm run dev
```

#### Production Mode
```bash
# Start built application
npm start

# Or run from source
./run-source-mac.sh  # macOS
./run-source-linux.sh  # Linux
```

### File Structure
```
uap-invaders/
├── src/                    # Source code
│   ├── main.js            # Electron main process, IPC handlers
│   ├── preload.js         # contextBridge IPC bridge
│   ├── index.html         # Full game: CSS tokens, HTML, JS engine
│   └── icon-titlebar.png  # Titlebar icon
├── scripts/                # Build and utility scripts
│   ├── build-universal.sh
│   ├── compile-build-dist.sh
│   ├── bloat-check.sh
│   └── temp-cleanup.sh
├── resources/        # Build assets
│   └── icons/             # .icns, .ico, .png application icons
├── docs/                   # Full documentation (15 files)
├── .github/                # GitHub configuration
│   ├── workflows/ci.yml   # CI pipeline
│   ├── ISSUE_TEMPLATE/    # Bug report + feature request
│   └── PULL_REQUEST_TEMPLATE.md
├── package.json            # Project config + electron-builder
└── dist/                   # Build output (gitignored)
```

## Code Architecture

### Main Process (main.js)
```javascript
// Window configuration
const mainWindow = new BrowserWindow({
  width: 1060,
  height: 900,
  webPreferences: {
    nodeIntegration: false,
    contextIsolation: true
  }
});

// Security best practices
app.on('web-contents-created', (event, contents) => {
  contents.on('new-window', (event, navigationUrl) => {
    event.preventDefault();
    shell.openExternal(navigationUrl);
  });
});
```

### Renderer Process (index.html)
```javascript
// Game state management
const gameState = {
  screen: 'MENU_MAIN',
  score: 0,
  energy: 100,
  highScores: []
};

// Game loop
function gameLoop() {
  update();
  render();
  requestAnimationFrame(gameLoop);
}
```

## Development Workflow

### 1. Making Changes
```bash
# Create feature branch
git checkout -b feature/new-uap-type

# Make changes
# Test thoroughly

# Commit changes
git add .
git commit -m "feat(game): add Triangle UAP type"

# Push and create PR
git push origin feature/new-uap-type
```

### 2. Testing
```bash
# Manual testing checklist
npm run dev
# - [ ] Game starts without errors
# - [ ] Mouse controls work
# - [ ] All UAP types spawn
# - [ ] Score system works
# - [ ] High scores save

# Cross-platform testing
npm run dist:mac    # Build macOS
npm run dist:win    # Build Windows
npm run dist:linux  # Build Linux
```

### 3. Building
```bash
# Development build (fast)
npm run pack

# Production build
npm run dist

# All platforms
npm run dist:all
```

## Debugging

### DevTools
```bash
# Enable DevTools automatically
npm run dev

# Or open manually in production
# View > Toggle Developer Tools
```

### Console Debugging
```javascript
// Add debug logging
console.log('Game state:', gameState);
console.log('UAP count:', uaps.length);

// Debug collision detection
function checkCollision(obj1, obj2) {
  const dx = obj1.x - obj2.x;
  const dy = obj1.y - obj2.y;
  const distance = Math.sqrt(dx * dx + dy * dy);
  
  if (distance < obj1.radius + obj2.radius) {
    console.log('Collision detected!');
    return true;
  }
  return false;
}
```

### Common Issues and Solutions

#### Canvas Not Rendering
```javascript
// Ensure canvas is properly initialized
const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

// Handle resize
window.addEventListener('resize', () => {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
});
```

#### Mouse Controls Not Working
```javascript
// Check event listeners
canvas.addEventListener('mousemove', (e) => {
  const rect = canvas.getBoundingClientRect();
  mouseX = e.clientX - rect.left;
  mouseY = e.clientY - rect.top;
});

canvas.addEventListener('click', () => {
  if (gameState.energy >= 10) {
    shoot();
  }
});
```

#### Performance Issues
```javascript
// Optimize rendering
function render() {
  // Clear only dirty regions
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  // Use object pooling
  bullets.forEach(bullet => {
    if (bullet.active) {
      drawBullet(bullet);
    }
  });
  
  // Limit particles
  if (particles.length > MAX_PARTICLES) {
    particles.splice(0, particles.length - MAX_PARTICLES);
  }
}
```

## Code Style

### JavaScript Guidelines
- Use ES6+ features (const/let, arrow functions)
- Meaningful variable names
- Comment complex logic
- Keep functions focused

```javascript
// Good
const calculateUAPSpeed = (uapType, score) => {
  const baseSpeed = uapTypes[uapType].speed;
  const difficultyMultiplier = 1 + (score / 1000);
  return baseSpeed * difficultyMultiplier;
};

// Avoid
function s(t, sc) {
  return u[t].s * (1 + sc/1000);
}
```

### CSS Guidelines
- Use CSS variables for theming
- Mobile-first responsive design
- Consistent naming conventions

```css
/* Good */
:root {
  --primary-color: #00ff00;
  --bg-color: #000000;
  --font-family: 'Courier Prime', monospace;
}

.game-ui {
  color: var(--primary-color);
  background: var(--bg-color);
  font-family: var(--font-family);
}
```

## Adding Features

### New UAP Type
```javascript
// 1. Define in uapTypes array
const uapTypes = [
  // ... existing types
  {
    emoji: '🔺',
    name: 'Triangle',
    points: 35,
    speed: 2.2,
    size: 32,
    wobble: 0.15
  }
];

// 2. Add to spawn logic
function spawnUAP() {
  const type = Math.floor(Math.random() * uapTypes.length);
  const uap = {
    x: Math.random() * canvas.width,
    y: -50,
    type: type,
    ...uapTypes[type]
  };
  uaps.push(uap);
}
```

### New Game Feature
```javascript
// 1. Add to game state
const gameState = {
  // ... existing
  powerUps: [],
  activePowerUp: null
};

// 2. Implement logic
function spawnPowerUp() {
  if (Math.random() < 0.001) {
    powerUps.push({
      x: Math.random() * canvas.width,
      y: -30,
      type: 'rapidFire'
    });
  }
}

// 3. Add to game loop
function update() {
  // ... existing updates
  updatePowerUps();
  checkPowerUpCollisions();
}
```

## Performance Optimization

### Profiling
```javascript
// Use performance API
function gameLoop(timestamp) {
  performance.mark('loop-start');
  
  update();
  render();
  
  performance.mark('loop-end');
  performance.measure('loop', 'loop-start', 'loop-end');
  
  requestAnimationFrame(gameLoop);
}
```

### Optimization Techniques
1. **Object Pooling**: Reuse objects instead of creating new ones
2. **Dirty Rectangle Rendering**: Only update changed areas
3. **Image Spritesheets**: Reduce draw calls
4. **Web Workers**: Offload heavy calculations

## Testing

### Manual Testing
```bash
# Create test script
npm run test:manual

# Test matrix
- [ ] All platforms start
- [ ] Controls responsive
- [ ] Score tracking
- [ ] High score persistence
- [ ] Fullscreen mode
- [ ] Window resizing
```

### Automated Testing (Future)
```javascript
// Unit tests with Jest
describe('Game Logic', () => {
  test('should calculate score correctly', () => {
    const score = calculateScore([{ type: 0 }, { type: 1 }]);
    expect(score).toBe(25); // 10 + 15
  });
});

// Integration tests with Spectron
describe('Application', () => {
  test('should launch without errors', async () => {
    const app = new Application({ path: electronPath });
    await app.start();
    const windowCount = await app.client.getWindowCount();
    expect(windowCount).toBe(1);
  });
});
```

## Tools and Extensions

### VS Code Extensions
- ES6 String HTML
- Prettier - Code formatter
- ESLint - Linting
- GitLens - Git history
- Thunder Client - API testing

### Chrome Extensions
- React Developer Tools
- Redux DevTools (if using Redux)
- Performance Monitor
- Canvas Inspector

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed contribution guidelines.

### Quick Start for Contributors
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Ensure code follows style guidelines
5. Submit pull request with description

That covers the full development setup. If something's missing, open an issue.