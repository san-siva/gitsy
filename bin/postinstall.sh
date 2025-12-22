#!/usr/bin/env bash

# Gitsy Post-Install Script
# Displays installation success message and sets up completions

echo ""
echo "✓ gitsy installed successfully!"
echo ""
echo "Dependencies required: git, figlet, lolcat"
echo ""
echo "Run any command with --help to get started:"
echo "  g-s --help"
echo ""
echo "Quick example:"
echo "  g-s      # Show git status"
echo ""
echo "Documentation: https://gitsy-56895.web.app"

# Run completion setup script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/setup-completions.sh" ]; then
    bash "$SCRIPT_DIR/setup-completions.sh"
fi

echo ""
