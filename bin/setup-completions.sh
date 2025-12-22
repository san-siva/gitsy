#!/usr/bin/env bash

# Gitsy Auto-Completion Setup Script
# Automatically configures shell completions during npm install

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine the installation directory
if [ -n "$npm_config_global" ] && [ "$npm_config_global" = "true" ]; then
    # Global install
    INSTALL_DIR="$(npm root -g)/@san-siva/gitsy"
else
    # Local install
    INSTALL_DIR="$(pwd)"
fi

COMPLETIONS_DIR="$INSTALL_DIR/completions"

# Function to check if completion is already configured
is_completion_configured() {
    local config_file=$1
    local completion_file=$2

    if [ -f "$config_file" ]; then
        grep -q "gitsy.*$completion_file" "$config_file" 2>/dev/null
        return $?
    fi
    return 1
}

# Function to add completion to config file
add_completion() {
    local config_file=$1
    local completion_file=$2
    local shell_name=$3

    if [ ! -f "$config_file" ]; then
        touch "$config_file"
    fi

    if ! is_completion_configured "$config_file" "$completion_file"; then
        echo "" >> "$config_file"
        echo "# Gitsy auto-completion (added by gitsy npm package)" >> "$config_file"
        echo "[ -f \"$COMPLETIONS_DIR/$completion_file\" ] && source \"$COMPLETIONS_DIR/$completion_file\"" >> "$config_file"
        echo -e "${GREEN}✓${NC} Added gitsy completion to $config_file"
        return 0
    else
        echo -e "${BLUE}ℹ${NC} Gitsy completion already configured in $config_file"
        return 1
    fi
}

# Detect shell and configure completions
setup_completions() {
    local configured=false

    # Detect user's shell
    local user_shell="$SHELL"

    # Setup for Bash
    if [[ "$user_shell" == *"bash"* ]] || [ -f "$HOME/.bashrc" ] || [ -f "$HOME/.bash_profile" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            add_completion "$HOME/.bashrc" "g-wr-completion.bash" "bash" && configured=true
        elif [ -f "$HOME/.bash_profile" ]; then
            add_completion "$HOME/.bash_profile" "g-wr-completion.bash" "bash" && configured=true
        fi
    fi

    # Setup for Zsh
    if [[ "$user_shell" == *"zsh"* ]] || [ -f "$HOME/.zshrc" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            add_completion "$HOME/.zshrc" "g-wr-completion.zsh" "zsh" && configured=true
        fi
    fi

    if [ "$configured" = true ]; then
        echo ""
        echo -e "${YELLOW}⚠${NC}  Please restart your shell or run:"
        if [[ "$user_shell" == *"bash"* ]]; then
            echo "   source ~/.bashrc"
        elif [[ "$user_shell" == *"zsh"* ]]; then
            echo "   source ~/.zshrc"
        fi
        echo "   to enable auto-completion for g-wr"
    fi
}

# Only run setup if completions directory exists
if [ -d "$COMPLETIONS_DIR" ]; then
    echo ""
    echo -e "${BLUE}Setting up gitsy shell completions...${NC}"
    setup_completions
    echo ""
else
    # Silently skip if completions directory doesn't exist
    exit 0
fi
