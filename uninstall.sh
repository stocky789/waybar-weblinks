#!/bin/bash

VERSION="2.0.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Show help
show_help() {
    cat << EOF
Waybar Web Shortcuts Uninstaller v${VERSION}

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help       Show this help message
  -v, --version    Show version information
  -f, --force      Skip confirmation prompt
  --keep-config    Keep configuration files

Description:
  Removes waybar-weblinks installation including:
    - Launcher script
    - Rofi themes
    - Configuration files (unless --keep-config is used)

  Note: Waybar config must be manually edited to remove the module.

Examples:
  $(basename "$0")              # Interactive uninstallation
  $(basename "$0") --force      # Skip confirmation
  $(basename "$0") --keep-config  # Keep your shortcuts config

EOF
    exit 0
}

# Show version
show_version() {
    echo "Waybar Web Shortcuts Uninstaller v${VERSION}"
    exit 0
}

# Parse command line arguments
FORCE=0
KEEP_CONFIG=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -f|--force)
            FORCE=1
            shift
            ;;
        --keep-config)
            KEEP_CONFIG=1
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  Waybar Web Shortcuts Uninstaller v${VERSION}${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Set up directories
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
WEBLINKS_DIR="$CONFIG_DIR/waybar-weblinks"

echo -e "${YELLOW}This will remove:${NC}"
echo -e "  - $WAYBAR_DIR/scripts/web-shortcuts.sh"
echo -e "  - $ROFI_DIR/web-shortcuts.rasi (dark theme)"
echo -e "  - $ROFI_DIR/web-shortcuts-light.rasi (light theme)"
if [[ $KEEP_CONFIG -eq 1 ]]; then
    echo -e "  - ${GREEN}Keeping${NC} $WEBLINKS_DIR/ (your config)"
else
    echo -e "  - $WEBLINKS_DIR/ (your config)"
fi
echo
echo -e "${YELLOW}Note: You'll need to manually remove the module from your waybar config.${NC}"
echo

if [[ $FORCE -eq 0 ]]; then
    read -p "Continue with uninstallation? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Uninstallation cancelled.${NC}"
        exit 0
    fi
else
    echo -e "${BLUE}Running in force mode, skipping confirmation...${NC}"
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

# Remove rofi themes
echo -e "${BLUE}[2/3]${NC} Removing rofi themes..."
REMOVED=0
if [[ -f "$ROFI_DIR/web-shortcuts.rasi" ]]; then
    rm "$ROFI_DIR/web-shortcuts.rasi"
    echo -e "${GREEN}✓ Dark theme removed${NC}"
    REMOVED=1
fi
if [[ -f "$ROFI_DIR/web-shortcuts-light.rasi" ]]; then
    rm "$ROFI_DIR/web-shortcuts-light.rasi"
    echo -e "${GREEN}✓ Light theme removed${NC}"
    REMOVED=1
fi
if [[ $REMOVED -eq 0 ]]; then
    echo -e "${YELLOW}⚠ Rofi themes not found (already removed?)${NC}"
fi

# Remove configuration directory
echo -e "${BLUE}[3/3]${NC} Removing configuration..."
if [[ $KEEP_CONFIG -eq 1 ]]; then
    echo -e "${GREEN}✓ Configuration kept (--keep-config flag)${NC}"
else
    if [[ -d "$WEBLINKS_DIR" ]]; then
        rm -rf "$WEBLINKS_DIR"
        echo -e "${GREEN}✓ Configuration removed${NC}"
    else
        echo -e "${YELLOW}⚠ Configuration directory not found (already removed?)${NC}"
    fi
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
echo -e "  4. Reload waybar: ${BLUE}killall waybar; nohup waybar >/dev/null 2>&1 &${NC}"
echo
