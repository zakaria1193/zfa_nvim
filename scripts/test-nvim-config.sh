#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if nvim is installed
if ! command -v nvim >/dev/null 2>&1; then
    log_error "Neovim is not installed!"
    exit 1
fi

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    log_error "Git is not installed!"
    exit 1
fi

# Check if cat is available
if ! command -v cat >/dev/null 2>&1; then
    log_error "cat is not installed!"
    exit 1
fi

# Check if running in CI
IN_CI="${CI:-false}"

# Set up temporary Neovim config directory
NVIM_TEST_DIR=$(mktemp -d)
log_info "Using temporary directory: $NVIM_TEST_DIR"

cleanup() {
    log_info "Cleaning up..."
    rm -rf "$NVIM_TEST_DIR"
}
trap cleanup EXIT
trap cleanup SIGINT  # Add this line to handle Ctrl+C

# Get script directory and config root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Copy config to temporary directory
log_info "Copying Neovim config to temporary directory..."
mkdir -p "$NVIM_TEST_DIR/.config/nvim"

# List files before copying for debugging
log_info "Contents of config directory:"
ls -la "$CONFIG_ROOT"

# Copy all files except .git and scripts
cp -r "$CONFIG_ROOT"/[!.git]* "$CONFIG_ROOT"/.* "$NVIM_TEST_DIR/.config/nvim/" 2>/dev/null || true
if [ ! -f "$NVIM_TEST_DIR/.config/nvim/init.lua" ]; then
    log_error "Failed to copy Neovim config files"
    log_error "Contents of target directory:"
    ls -la "$NVIM_TEST_DIR/.config/nvim"
    exit 1
fi

# Set XDG directories
export XDG_CONFIG_HOME="$NVIM_TEST_DIR/.config"
export XDG_DATA_HOME="$NVIM_TEST_DIR/.local/share"
export XDG_STATE_HOME="$NVIM_TEST_DIR/.local/state"
export XDG_CACHE_HOME="$NVIM_TEST_DIR/.cache"

# Create necessary directories
mkdir -p "$XDG_DATA_HOME/nvim" "$XDG_STATE_HOME/nvim" "$XDG_CACHE_HOME/nvim"

# Function to run nvim with timeout
run_nvim_cmd() {
    local cmd="$1"
    local timeout=10
    
    log_info "Running: nvim cmd: $cmd"

    timeout $timeout nvim -u "$NVIM_TEST_DIR/.config/nvim/init.lua" -c "$cmd" -c "qa" || {
        log_error "Failed to run nvim command: $cmd"
        exit 1
    }
}

# Test lazy.nvim installation and plugin sync
log_info "Testing lazy.nvim plugin installation..."
run_nvim_cmd "+q"
