#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   📦 INSTALLER SCRIPT 📦                    ║"
echo "║              Setting up your project generator               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Get the current directory (where the script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREATE_PROJECT_SCRIPT="$SCRIPT_DIR/create-project.sh"

# Check if create-project.sh exists
if [[ ! -f "$CREATE_PROJECT_SCRIPT" ]]; then
    echo -e "${RED}❌ Error: create-project.sh not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Make sure the script is executable
chmod +x "$CREATE_PROJECT_SCRIPT"

# Detect shell
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    "bash")
        SHELL_CONFIG="$HOME/.bashrc"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        fi
        ;;
    "zsh")
        SHELL_CONFIG="$HOME/.zshrc"
        ;;
    "fish")
        SHELL_CONFIG="$HOME/.config/fish/config.fish"
        ;;
    *)
        echo -e "${YELLOW}⚠️  Unknown shell: $SHELL_NAME${NC}"
        echo -e "${YELLOW}Please manually add this alias to your shell config:${NC}"
        echo -e "${BLUE}alias create-project='$CREATE_PROJECT_SCRIPT'${NC}"
        exit 0
        ;;
esac

# Create alias
ALIAS_COMMAND="alias create-project='$CREATE_PROJECT_SCRIPT'"

# Check if alias already exists
if grep -q "alias create-project=" "$SHELL_CONFIG" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Alias 'create-project' already exists in $SHELL_CONFIG${NC}"
    echo -e "${YELLOW}Do you want to update it? (y/N): ${NC}"
    read -r update_alias
    
    if [[ "$update_alias" =~ ^[Yy]$ ]]; then
        # Remove existing alias and add new one
        sed -i.bak '/alias create-project=/d' "$SHELL_CONFIG"
        echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
        echo -e "${GREEN}✅ Alias updated in $SHELL_CONFIG${NC}"
    else
        echo -e "${YELLOW}⚠️  Keeping existing alias${NC}"
    fi
else
    # Add new alias
    echo "" >> "$SHELL_CONFIG"
    echo "# Project Generator Alias" >> "$SHELL_CONFIG"
    echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
    echo -e "${GREEN}✅ Alias added to $SHELL_CONFIG${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo ""
echo -e "${YELLOW}To use the project generator:${NC}"
echo -e "${BLUE}  1. Restart your terminal (or run: source $SHELL_CONFIG)${NC}"
echo -e "${BLUE}  2. Run: create-project${NC}"
echo ""
echo -e "${YELLOW}Or you can run it directly:${NC}"
echo -e "${BLUE}  $CREATE_PROJECT_SCRIPT${NC}"
echo ""
echo -e "${GREEN}✨ Happy coding! ✨${NC}"