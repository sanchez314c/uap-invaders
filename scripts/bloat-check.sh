#!/bin/bash
# Bloat Check Script for UAP Invaders
# Analyzes build output size and identifies potential bloat sources

set -eo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "========================================="
echo "UAP Invaders - Bloat Check"
echo "========================================="
echo ""

# Check if dist directory exists
if [ ! -d "dist" ]; then
  echo "⚠️  No dist/ directory found. Run a build first."
  echo "   npm run dist:current"
  exit 0
fi

echo "📊 Build Output Analysis"
echo "----------------------------------------"

# Overall dist size
DIST_SIZE=$(du -sh dist 2>/dev/null | cut -f1)
echo "Total dist/ size: $DIST_SIZE"
echo ""

# Breakdown by platform
echo "📦 Platform Builds:"
if [ -d "dist/mac" ] || [ -d "dist/mac-arm64" ] || [ -d "dist/mac-universal" ]; then
  MAC_SIZE=$(du -sh dist/mac* 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
  echo "  macOS builds: $MAC_SIZE"
fi

if [ -d "dist/win-unpacked" ] || [ -d "dist/win-ia32-unpacked" ]; then
  WIN_SIZE=$(du -sh dist/win* 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
  echo "  Windows builds: $WIN_SIZE"
fi

if [ -d "dist/linux-unpacked" ]; then
  LINUX_SIZE=$(du -sh dist/linux* 2>/dev/null | awk '{sum+=$1} END {print sum}' || echo "0")
  echo "  Linux builds: $LINUX_SIZE"
fi

echo ""
echo "📄 Distributables:"
ls -lh dist/*.{dmg,exe,AppImage,deb,rpm,snap,zip,tar.xz,tar.gz} 2>/dev/null | \
  awk '{printf "  %-40s %8s\n", $9, $5}' || echo "  (No distributables found)"

echo ""
echo "🔍 Potential Bloat Sources:"
echo "----------------------------------------"

# Check node_modules in dist (shouldn't be there)
if find dist -name "node_modules" -type d 2>/dev/null | grep -q .; then
  echo "⚠️  WARNING: node_modules found in dist/"
  find dist -name "node_modules" -type d -exec du -sh {} \; 2>/dev/null
else
  echo "✅ No node_modules in dist/"
fi

# Check for source maps
SOURCEMAP_COUNT=$(find dist -name "*.map" -type f 2>/dev/null | wc -l)
if [ "$SOURCEMAP_COUNT" -gt 0 ]; then
  echo "⚠️  WARNING: $SOURCEMAP_COUNT source map files found (should be excluded)"
  find dist -name "*.map" -type f -exec ls -lh {} \; 2>/dev/null | head -10
else
  echo "✅ No source maps in dist/"
fi

# Check for .ts files (should be compiled)
TS_COUNT=$(find dist -name "*.ts" -type f 2>/dev/null | wc -l)
if [ "$TS_COUNT" -gt 0 ]; then
  echo "⚠️  WARNING: $TS_COUNT TypeScript files found (should be compiled)"
else
  echo "✅ No .ts files in dist/"
fi

# Check for test files
TEST_COUNT=$(find dist -path "*/test/*" -o -path "*/tests/*" -o -path "*/__tests__/*" 2>/dev/null | wc -l)
if [ "$TEST_COUNT" -gt 0 ]; then
  echo "⚠️  WARNING: $TEST_COUNT test files found (should be excluded)"
else
  echo "✅ No test files in dist/"
fi

# Check for documentation
DOC_COUNT=$(find dist -name "*.md" -type f 2>/dev/null | wc -l)
if [ "$DOC_COUNT" -gt 0 ]; then
  echo "ℹ️  INFO: $DOC_COUNT markdown files found"
else
  echo "✅ No markdown docs in dist/"
fi

echo ""
echo "✅ Bloat check complete"
echo ""
