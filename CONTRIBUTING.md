# Contributing to UAP Invaders

Thank you for your interest in contributing to UAP Invaders: Contact Protocol! This document provides guidelines for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)

## Code of Conduct

This project adheres to a code of conduct promoting a welcoming environment. By participating, you agree to:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- Node.js 16+ and npm
- Git
- Basic knowledge of JavaScript, HTML5, and Electron

### Setting Up Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/uap-invaders.git
   cd uap-invaders
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/sanchez314c/uap-invaders.git
   ```
4. Install dependencies:
   ```bash
   npm install
   ```
5. Start development mode:
   ```bash
   npm run dev
   ```

## Development Workflow

### Branching Strategy

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Urgent production fixes

### Creating a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### Keeping Your Fork Updated

```bash
git fetch upstream
git checkout main
git merge upstream/main
```

## Coding Standards

### JavaScript Style Guide

- Use ES6+ features (const/let, arrow functions, template literals)
- Use 2-space indentation
- Use semicolons
- Maximum line length: 100 characters
- Use camelCase for variables and functions
- Use PascalCase for classes
- Add JSDoc comments for functions

Example:
```javascript
/**
 * Spawns a new UAP enemy
 * @param {string} type - The UAP type to spawn
 * @returns {Object} The spawned UAP object
 */
function spawnUAP(type) {
  const uapType = uapTypes.find(u => u.name === type);
  return {
    x: Math.random() * canvas.width,
    y: 0,
    type: uapType,
    health: 100
  };
}
```

### HTML/CSS Guidelines

- Use semantic HTML5 elements
- Maintain the Neo-Noir Glass design system (dark theme with teal accents)
- Use CSS custom properties for colors
- Keep inline styles minimal
- Ensure responsive design works

### Electron Security

- Never enable `nodeIntegration` in renderer without `contextIsolation`
- Always validate external URLs before opening
- Use `preload` scripts for IPC communication
- Follow Electron security checklist

## Commit Guidelines

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

### Examples

```bash
feat(game): add new Triangular UAP type

fix(collision): correct bullet collision detection
Fixes #123

docs(readme): update installation instructions

chore(deps): update electron to 28.0.0
```

## Pull Request Process

### Before Submitting

1. Ensure code follows the style guide
2. Test your changes thoroughly
3. Update documentation if needed
4. Add/update tests if applicable
5. Ensure the app builds successfully:
   ```bash
   npm run dist:current
   ```

### Submitting a Pull Request

1. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
2. Open a pull request on GitHub
3. Fill out the PR template completely
4. Link any related issues
5. Wait for review and address feedback

### PR Review Criteria

- Code quality and style compliance
- Functionality and bug-free operation
- Performance impact
- Security considerations
- Documentation completeness
- Test coverage

## Reporting Bugs

### Before Reporting

- Check existing issues to avoid duplicates
- Test on the latest version
- Gather system information

### Bug Report Template

```markdown
**Description**
Clear description of the bug

**To Reproduce**
1. Step 1
2. Step 2
3. See error

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., macOS 13.0, Windows 11, Ubuntu 22.04]
- Node.js version: [e.g., 18.15.0]
- Electron version: [e.g., 27.3.11]
- Game version: [e.g., 1.0.0]

**Screenshots**
If applicable

**Additional Context**
Any other relevant information
```

## Feature Requests

### Suggesting Features

1. Check if the feature already exists or is planned
2. Clearly describe the feature and its benefits
3. Provide use cases and examples
4. Consider implementation complexity

### Feature Request Template

```markdown
**Feature Description**
Clear description of the proposed feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should this be implemented?

**Alternatives Considered**
What other approaches could work?

**Additional Context**
Screenshots, mockups, or examples
```

## Development Guidelines

### Adding New UAP Types

1. Define in `uapTypes` array with:
   - Emoji icon
   - Name
   - Point value
   - Speed
   - Size
2. Balance point values with difficulty
3. Test movement patterns
4. Update documentation

### Modifying Game Mechanics

1. Preserve core gameplay loop
2. Maintain 60fps performance
3. Test difficulty progression
4. Ensure UI updates correctly
5. Document changes

### Testing Changes

- Manual testing required for all changes
- Test on multiple platforms if possible
- Verify both windowed and fullscreen modes
- Check high score persistence
- Test edge cases

## Build and Release

### Building for Distribution

```bash
# Build for current platform
npm run dist:current

# Build for all platforms
npm run dist:all

# Build for specific platform
npm run dist:mac
npm run dist:win
npm run dist:linux
```

### Release Process

1. Update version in `package.json`
2. Update `CHANGELOG.md`
3. Create git tag: `git tag v1.x.x`
4. Push tag: `git push --tags`
5. Build distributables
6. Create GitHub release
7. Upload distributables

## Documentation

### Updating Documentation

- Keep README.md current
- Update CHANGELOG.md for all changes
- Update inline code comments
- Update technical docs as needed

## Community

### Getting Help

- GitHub Discussions for questions
- GitHub Issues for bugs
- Pull requests for contributions

### Recognition

Contributors will be acknowledged in:
- CHANGELOG.md
- Release notes
- Project README

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to UAP Invaders: Contact Protocol!
