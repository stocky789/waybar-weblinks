#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  Waybar Web Shortcuts Uninstaller${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Set up directories
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
WEBLINKS_DIR="$CONFIG_DIR/waybar-weblinks"

echo -e "${YELLOW}This will remove:${NC}"
echo -e "  - $WAYBAR_DIR/scripts/web-shortcuts.sh"
echo -e "  - $ROFI_DIR/web-shortcuts.rasi"
echo -e "  - $WEBLINKS_DIR/ (your config)"
echo
echo -e "${YELLOW}Note: You'll need to manually remove the module from your waybar config.${NC}"
echo

read -p "Continue with uninstallation? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstallation cancelled.${NC}"
    exit 0
fi

echo

# Remove launcher script
echo -e "${BLUE}[1/3]${NC} Removing launcher script..."
if [[ -f "$WAYBAR_DIR/scripts/web-shortcuts.sh" ]]; then
    rm "$WAYBAR_DIR/scripts/web-shortcuts.sh"
    echo -e "${GREEN}✓ Launcher script removed${NC}"
else
    echo -e "${YELLOW}⚠ Launcher script not found (already removed?)${NC}"
fi

# Remove rofi theme
echo -e "${BLUE}[2/3]${NC} Removing rofi theme..."
if [[ -f "$ROFI_DIR/web-shortcuts.rasi" ]]; then
    rm "$ROFI_DIR/web-shortcuts.rasi"
    echo -e "${GREEN}✓ Rofi theme removed${NC}"
else
    echo -e "${YELLOW}⚠ Rofi theme not found (already removed?)${NC}"
fi

# Remove configuration directory
echo -e "${BLUE}[3/3]${NC} Removing configuration..."
if [[ -d "$WEBLINKS_DIR" ]]; then
    rm -rf "$WEBLINKS_DIR"
    echo -e "${GREEN}✓ Configuration removed${NC}"
else
    echo -e "${YELLOW}⚠ Configuration directory not found (already removed?)${NC}"
fi

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Uninstallation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Manual cleanup required:${NC}"
echo -e "  1. Remove the module from your waybar config:"
echo -e "     ${BLUE}~/.config/waybar/config.jsonc${NC}"
echo -e "  2. Remove ${BLUE}\"custom/web-shortcuts\"${NC} from your modules-right array"
echo -e "  3. Remove the module definition block"
echo -e "  4. Reload waybar: ${BLUE}killall waybar && waybar &${NC}"
echo
