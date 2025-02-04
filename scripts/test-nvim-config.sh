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

# Install lazy.nvim
log_info "Installing lazy.nvim..."
LAZY_PATH="$XDG_DATA_HOME/nvim/lazy/lazy.nvim"
mkdir -p "$(dirname "$LAZY_PATH")"
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH" || {
    log_error "Failed to clone lazy.nvim"
    exit 1
}

# Function to run nvim with timeout
run_nvim_cmd() {
    local cmd="$1"
    local timeout=60
    local temp_log="$NVIM_TEST_DIR/nvim_log.txt"
    
    log_info "Running: nvim --headless $cmd"
    timeout "$timeout" nvim --headless "$cmd" > "$temp_log" 2>&1 || {
        log_error "Command failed: nvim --headless $cmd"
        log_error "Log output:"
        command cat "$temp_log"
        return 1
    }
}

# Test lazy.nvim installation and plugin sync
log_info "Testing lazy.nvim plugin installation..."
run_nvim_cmd "+Lazy! sync" "+qa" || {
    log_error "Failed to install plugins"
    exit 1
}

# Test loading each module
log_info "Testing module loading..."
MODULES=(
    options
    diagnostics
    keymaps
    plugins
    colorscheme
    cmp
    lsp
    telescope
    treesitter
    folding
    gitsigns
    nvim-tree
    lualine
    project
    indentline
    alpha
    autocommands
    gpt
    colorizer
    vim-gutentags
    hardtime
    neovide
)

failed_modules=()
for module in "${MODULES[@]}"; do
    log_info "Testing module: $module"
    if ! run_nvim_cmd "+lua require('user.$module')" "+qa"; then
        log_error "Failed to load module: $module"
        failed_modules+=("$module")
        continue
    fi
done

# Run health checks
log_info "Running health checks..."
run_nvim_cmd "+checkhealth" "+qa" || {
    log_warn "Health checks reported some issues"
}

# Test basic operations
log_info "Testing basic operations..."

# Test file operations
echo "print('hello')" > "$NVIM_TEST_DIR/test.lua"
run_nvim_cmd "$NVIM_TEST_DIR/test.lua +wq" || {
    log_error "Failed to open and save file"
    exit 1
}

# Test LSP functionality
log_info "Testing LSP functionality..."
run_nvim_cmd "+LspInfo" "+qa" || {
    log_warn "LSP info check failed"
}

# Test Telescope
log_info "Testing Telescope..."
run_nvim_cmd "+Telescope find_files" "+qa" || {
    log_warn "Telescope test failed"
}

# Test Tree-sitter
log_info "Testing Tree-sitter..."
run_nvim_cmd "+TSInstallInfo" "+qa" || {
    log_warn "Tree-sitter info check failed"
}

# Final status report
log_info "Test suite completed!"
if [ ${#failed_modules[@]} -eq 0 ]; then
    log_info "All modules loaded successfully! 🎉"
else
    log_error "The following modules failed to load:"
    printf '%s\n' "${failed_modules[@]/#/  - }"
    exit 1
fi
