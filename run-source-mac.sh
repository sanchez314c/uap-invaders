#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════
# UAP Invaders - macOS Source Launcher
# ═══════════════════════════════════════════════════════════════════════

set -eo pipefail

# ── Port Configuration ──
DEV_SERVER_PORT=55377
ELECTRON_DEBUG_PORT=60205
ELECTRON_INSPECT_PORT=63365

# ── Color Codes ──
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"; }
print_success() { echo -e "${GREEN}[$(date +'%H:%M:%S')] ✔${NC} $1"; }
print_error() { echo -e "${RED}[$(date +'%H:%M:%S')] ✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}[$(date +'%H:%M:%S')] ⚠${NC} $1"; }

# ── Platform Check ──
if [ "$(uname)" != "Darwin" ]; then
    print_error "This script is for macOS only"
    exit 1
fi

print_status "🚀 Starting UAP Invaders from source (macOS)..."

# ── Zombie Process Cleanup (scoped to this project only) ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_status "Checking for zombie processes from this project..."
pgrep -f "Electron.*${SCRIPT_DIR}" | xargs kill -9 2>/dev/null || true
sleep 1

# ── Port Cleanup ──
print_status "Checking ports: ${DEV_SERVER_PORT}, ${ELECTRON_DEBUG_PORT}, ${ELECTRON_INSPECT_PORT}..."
for port in $DEV_SERVER_PORT $ELECTRON_DEBUG_PORT $ELECTRON_INSPECT_PORT; do
    pid=$(lsof -ti:$port 2>/dev/null || true)
    if [ -n "$pid" ]; then
        print_warning "Port $port in use by PID $pid, killing..."
        kill -9 $pid 2>/dev/null || true
    fi
done

# ── Dependency Check ──
if ! command -v node &>/dev/null; then
    print_error "Node.js not installed. Install with: brew install node"
    exit 1
fi

if ! command -v npm &>/dev/null; then
    print_error "npm not installed. Install with: brew install node"
    exit 1
fi

# ── Install Dependencies ──
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
fi

# ── Environment Setup ──
export NODE_ENV=development

# ── Launch Application ──
print_success "Launching UAP Invaders..."
npm run dev || npm start

print_success "Application session ended"
