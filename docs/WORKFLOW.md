# Workflow

## Development Workflow

This document outlines the complete development workflow for UAP Invaders: Contact Protocol, from initial setup to release.

## Git Workflow

### Branch Strategy
```
main                    ← Production-ready code
├── develop              ← Integration branch
├── feature/*            ← New features
├── bugfix/*             ← Bug fixes
├── hotfix/*              ← Critical fixes
└── release/*             ← Release preparation
```

### Branch Naming Conventions
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical production fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test additions

### Commit Message Format
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes
- refactor: Code refactoring
- test: Adding or updating tests
- chore: Maintenance tasks
- perf: Performance improvements

Examples:
feat(game): add Triangle UAP type
fix(controls): mouse movement lag on Linux
docs(readme): update installation instructions
refactor(renderer): optimize collision detection
```

## Development Process

### 1. Setup
```bash
# Clone repository
git clone https://github.com/sanchez314c/uap-invaders.git
cd uap-invaders

# Install dependencies
npm install

# Create feature branch
git checkout -b feature/new-feature

# Start development
npm run dev
```

### 2. Development Cycle
```bash
# Make changes
# Test locally
git add .
git commit -m "feat(game): add new feature"

# Push to feature branch
git push origin feature/new-feature

# Create pull request
# Via GitHub UI or gh cli
gh pr create --title "Add new feature"
```

### 3. Code Review Process
- **Self-Review**:
  - Code follows style guidelines
  - No console errors or warnings
  - Tests pass (when available)
  - Documentation updated

- **Peer Review**:
  - At least one approval required
  - Reviewer checks for:
    - Code quality
    - Performance implications
    - Security considerations
    - Cross-platform compatibility

### 4. Integration
```bash
# Merge to develop
git checkout develop
git merge feature/new-feature

# Resolve conflicts if any
# Run full test suite
npm test

# Push to develop
git push origin develop
```

## Testing Workflow

### Manual Testing Checklist
```markdown
- [ ] Game starts without errors
- [ ] Main menu loads correctly
- [ ] Callsign input works
- [ ] Game starts from menu
- [ ] Mouse controls responsive
- [ ] Shooting mechanism works
- [ ] All UAP types spawn
- [ ] Collision detection accurate
- [ ] Score updates correctly
- [ ] Energy system functions
- [ ] High scores save/load
- [ ] Game over screen works
- [ ] Return to menu works
- [ ] Fullscreen toggle works
- [ ] Window resize handled
```

### Cross-Platform Testing
```bash
# Build for all platforms
npm run dist:all

# Test matrix
┌─────────────┬─────────────┬─────────────┐
│   macOS    │   Windows   │    Linux    │
│  (Intel/ARM) │  (x64/ia32) │ (AppImage/DEB)│
├─────────────┼─────────────┼─────────────┤
│ Start app  │ Start app   │ Start app   │
│ Check UI   │ Check UI   │ Check UI   │
│ Test game  │ Test game  │ Test game  │
│ Verify save│ Verify save│ Verify save│
└─────────────┴─────────────┴─────────────┘
```

### Performance Testing
```javascript
// Performance monitoring
const performanceMonitor = {
  frameCount: 0,
  startTime: performance.now(),
  
  measure() {
    this.frameCount++;
    const elapsed = performance.now() - this.startTime;
    const fps = (this.frameCount / elapsed) * 1000;
    
    if (fps < 55) {
      console.warn(`Low FPS: ${fps}`);
    }
    
    return fps;
  },
  
  reset() {
    this.frameCount = 0;
    this.startTime = performance.now();
  }
};

// In game loop
function gameLoop() {
  update();
  render();
  
  const fps = performanceMonitor.measure();
  // Display FPS in debug mode if needed
}
```

## Release Workflow

### 1. Preparation
```bash
# Update version
npm version patch  # or minor/major

# Update CHANGELOG.md
# Add release notes for new version

# Run full test suite
npm test

# Build all platforms
npm run dist:maximum
```

### 2. Release Process
```bash
# Create release tag
git tag v1.0.1
git push origin v1.0.1

# Create GitHub release
gh release create v1.0.1 \
  --title "UAP Invaders v1.0.1" \
  --notes "$(cat CHANGELOG.md | sed -n '5,/^##/p')" \
  dist/*
```

### 3. Post-Release
```bash
# Merge to main
git checkout main
git merge develop

# Push main
git push origin main

# Update develop for next iteration
git checkout develop
git merge main
git push origin develop
```

## CI/CD Workflow

### GitHub Actions Pipeline
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    strategy:
      matrix:
        os: [macos-latest, windows-latest, ubuntu-latest]
    
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Build
        run: npm ci && npm run dist
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ${{ matrix.os }}-build
          path: dist/

  release:
    if: github.event_name == 'push' && 
          github.ref == 'refs/heads/main'
    needs: [test, build]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      
      - name: Download artifacts
        uses: actions/download-artifact@v3
        with:
          path: dist/
      
      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: UAP Invaders ${{ github.ref }}
          draft: false
          files: dist/*
```

## Code Review Guidelines

### Review Checklist
```markdown
### Code Quality
- [ ] Code follows project style guide
- [ ] No hardcoded values or magic numbers
- [ ] Proper error handling
- [ ] No console.log statements in production
- [ ] Functions are small and focused

### Performance
- [ ] No performance regressions
- [ ] Efficient algorithms used
- [ ] Memory leaks checked
- [ ] Canvas rendering optimized

### Security
- [ ] No XSS vulnerabilities
- [ ] Input validation present
- [ ] No sensitive data exposed
- [ ] Secure coding practices followed

### Testing
- [ ] Tests cover new functionality
- [ ] Edge cases considered
- [ ] Cross-platform compatibility verified
- [ ] Manual testing completed

### Documentation
- [ ] README updated if needed
- [ ] Inline comments added
- [ ] API documentation updated
- [ ] CHANGELOG.md updated
```

### Review Process
1. **Automated Checks**:
   - ESLint passes
   - Tests pass
   - Build succeeds

2. **Human Review**:
   - Code quality assessment
   - Architecture implications
   - Performance impact
   - Security review

3. **Approval Requirements**:
   - At least one maintainer approval
   - All automated checks pass
   - No outstanding review comments

## Quality Assurance

### Pre-Release QA
```bash
# Smoke testing
./scripts/smoke-test.sh

# Regression testing
./scripts/regression-test.sh

# Performance benchmarking
./scripts/performance-test.sh

# Security scanning
npm audit
```

### Release Criteria
- [ ] All tests passing
- [ ] No critical bugs
- [ ] Performance meets targets
- [ ] Documentation complete
- [ ] Security scan clean
- [ ] All platforms build successfully

## Maintenance Workflow

### Regular Tasks
```bash
# Weekly
npm audit                    # Check for vulnerabilities
npm outdated                  # Check for updates

# Monthly
npm update                    # Update dependencies
./scripts/cleanup-branches.sh   # Remove old branches

# Quarterly
./scripts/security-audit.sh     # Full security review
./scripts/performance-review.sh  # Performance analysis
```

### Issue Triage
1. **Immediate Response**:
   - Acknowledge within 24 hours
   - Assign priority level
   - Add appropriate labels

2. **Investigation**:
   - Reproduce issue
   - Identify root cause
   - Determine impact

3. **Resolution**:
   - Fix or document workaround
   - Test thoroughly
   - Close with explanation

## Emergency Procedures

### Hotfix Process
```bash
# 1. Create hotfix branch from main
git checkout -b hotfix/critical-bug

# 2. Fix issue
# Make minimal changes

# 3. Test and release
npm run dist
git commit -m "hotfix: critical security fix"
git tag v1.0.1-hotfix

# 4. Deploy
# Push hotfix directly to main
git push origin main --tags

# 5. Merge back
git checkout develop
git merge main
git push origin develop
```

### Rollback Procedure
```bash
# 1. Identify problematic version
git log --oneline --decorate

# 2. Revert to previous tag
git checkout v1.0.0

# 3. Force push
git push origin main --force

# 4. Communicate
# Update GitHub release
# Notify users
# Document issue
```

## Tools and Automation

### Development Tools
```bash
# Pre-commit hooks
npm install husky
npx husky add .husky/pre-commit "npm run lint && npm test"

# Commitizen for conventional commits
npm install -g commitizen
git cz  # Instead of git commit
```

### Build Tools
```bash
# Automated versioning
npm install -g standard-version
standard-version

# Changelog generation
npm install -g conventional-changelog-cli
conventional-changelog -p angular -i CHANGELOG.md
```

### Release Tools
```bash
# GitHub CLI for releases
npm install -g gh
gh release create
gh release list
gh release view v1.0.0
```

This workflow ensures consistent, high-quality releases while maintaining developer productivity and code quality.