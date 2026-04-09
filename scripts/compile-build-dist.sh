#!/bin/bash
# Comprehensive Build Script for UAP Invaders
# Handles cleaning, dependency installation, and building distributables

set -eo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Parse arguments
SKIP_TEMP_CLEAN=false
SKIP_BLOAT_CHECK=false
BUILD_TARGET="current"

while [[ $# -gt 0 ]]; do
  case $1 in
    --no-temp-clean)
      SKIP_TEMP_CLEAN=true
      shift
      ;;
    --no-bloat-check)
      SKIP_BLOAT_CHECK=true
      shift
      ;;
    --target)
      BUILD_TARGET="$2"
      shift 2
      ;;
    --all)
      BUILD_TARGET="all"
      shift
      ;;
    --mac|--win|--linux)
      BUILD_TARGET="${1#--}"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--no-temp-clean] [--no-bloat-check] [--target current|all|mac|win|linux]"
      exit 1
      ;;
  esac
done

echo "========================================="
echo "UAP Invaders - Build & Distribution"
echo "========================================="
echo ""
echo "Build target: $BUILD_TARGET"
echo "Skip temp clean: $SKIP_TEMP_CLEAN"
echo "Skip bloat check: $SKIP_BLOAT_CHECK"
echo ""

# Step 1: Temporary file cleanup
if [ "$SKIP_TEMP_CLEAN" = false ]; then
  echo "🧹 Cleaning temporary files..."
  if [ -f "scripts/temp-cleanup.sh" ]; then
    bash scripts/temp-cleanup.sh
  else
    echo "⚠️  temp-cleanup.sh not found, skipping"
  fi
  echo ""
fi

# Step 2: Clean previous build artifacts
echo "🗑️  Removing previous build artifacts..."
rm -rf dist/ build/ node_modules/.cache/
echo "✅ Build directories cleaned"
echo ""

# Step 3: Install/update dependencies
echo "📦 Installing dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

# Step 4: Run electron-builder post-install
echo "🔧 Running electron-builder post-install..."
npm run postinstall
echo "✅ Post-install complete"
echo ""

# Step 5: Build distributables
echo "🏗️  Building distributables..."
case $BUILD_TARGET in
  all)
    echo "Building for all platforms..."
    npm run dist:all
    ;;
  mac)
    echo "Building for macOS..."
    npm run dist:mac
    ;;
  win)
    echo "Building for Windows..."
    npm run dist:win
    ;;
  linux)
    echo "Building for Linux..."
    npm run dist:linux
    ;;
  current|*)
    echo "Building for current platform..."
    npm run dist:current
    ;;
esac
echo "✅ Build complete"
echo ""

# Step 6: Bloat check
if [ "$SKIP_BLOAT_CHECK" = false ]; then
  echo "🔍 Running bloat check..."
  if [ -f "scripts/bloat-check.sh" ]; then
    bash scripts/bloat-check.sh
  else
    echo "⚠️  bloat-check.sh not found, skipping"
  fi
  echo ""
fi

# Step 7: Summary
echo "========================================="
echo "✅ Build process complete!"
echo "========================================="
echo ""
echo "📦 Build artifacts location: dist/"
echo ""
echo "Next steps:"
echo "  - Test the application: open dist/[platform]/"
echo "  - Verify distributables work correctly"
echo "  - Check release notes and documentation"
echo ""
