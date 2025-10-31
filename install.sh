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
Waybar Web Shortcuts Installer v${VERSION}

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help       Show this help message
  -v, --version    Show version information
  --skip-waybar    Skip waybar configuration
  --unattended     Run in unattended mode (auto-accept defaults)

Description:
  Installs waybar-weblinks, a customizable web shortcuts menu for Waybar.
  This script will:
    1. Check and install dependencies (rofi)
    2. Copy files to appropriate directories
    3. Set up initial configuration
    4. Configure waybar module (optional)

Examples:
  $(basename "$0")              # Interactive installation
  $(basename "$0") --unattended # Auto-install with defaults
  $(basename "$0") --skip-waybar  # Install without waybar config

EOF
    exit 0
}

# Show version
show_version() {
    echo "Waybar Web Shortcuts Installer v${VERSION}"
    exit 0
}

# Parse command line arguments
SKIP_WAYBAR=0
UNATTENDED=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        --skip-waybar)
            SKIP_WAYBAR=1
            shift
            ;;
        --unattended)
            UNATTENDED=1
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Error handler
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Waybar Web Shortcuts Installer v${VERSION}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo -e "${YELLOW}⚠ Rofi is not installed.${NC}"
    if [[ $UNATTENDED -eq 1 ]]; then
        REPLY="Y"
    else
        echo -e "Would you like to install it? (requires sudo)"
        read -p "Install rofi? [Y/n] " -n 1 -r
        echo
    fi
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]] || [[ $UNATTENDED -eq 1 ]]; then
        # Detect package manager and install rofi
        if command -v pacman &> /dev/null; then
            echo -e "${BLUE}Installing rofi via pacman...${NC}"
            sudo pacman -S --noconfirm rofi
        elif command -v apt-get &> /dev/null; then
            echo -e "${BLUE}Installing rofi via apt...${NC}"
            sudo apt-get update && sudo apt-get install -y rofi
        elif command -v dnf &> /dev/null; then
            echo -e "${BLUE}Installing rofi via dnf...${NC}"
            sudo dnf install -y rofi
        elif command -v zypper &> /dev/null; then
            echo -e "${BLUE}Installing rofi via zypper...${NC}"
            sudo zypper install -y rofi
        else
            echo -e "${RED}✗ Could not detect package manager.${NC}"
            echo -e "${YELLOW}Please install rofi manually for your distribution:${NC}"
            echo -e "  Arch/Manjaro:  sudo pacman -S rofi"
            echo -e "  Debian/Ubuntu: sudo apt install rofi"
            echo -e "  Fedora:        sudo dnf install rofi"
            echo -e "  openSUSE:      sudo zypper install rofi"
            exit 1
        fi
        echo -e "${GREEN}✓ Rofi installed${NC}"
    else
        echo -e "${RED}✗ Rofi is required. Exiting.${NC}"
        exit 1
    fi
fi

# Set up directories
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
WAYBAR_DIR="$CONFIG_DIR/waybar"
ROFI_DIR="$CONFIG_DIR/rofi"
WEBLINKS_DIR="$CONFIG_DIR/waybar-weblinks"

echo -e "${BLUE}[1/5]${NC} Creating directories..."
mkdir -p "$WAYBAR_DIR/scripts"
mkdir -p "$ROFI_DIR"
mkdir -p "$WEBLINKS_DIR"
echo -e "${GREEN}✓ Directories created${NC}"

# Copy rofi themes
echo -e "${BLUE}[2/5]${NC} Installing rofi themes..."
if [[ ! -f "rofi/web-shortcuts.rasi" ]]; then
    error_exit "Theme file not found: rofi/web-shortcuts.rasi"
fi
cp rofi/web-shortcuts.rasi "$ROFI_DIR/" || error_exit "Failed to copy dark theme"
chmod 644 "$ROFI_DIR/web-shortcuts.rasi"

if [[ -f "rofi/web-shortcuts-light.rasi" ]]; then
    cp rofi/web-shortcuts-light.rasi "$ROFI_DIR/" || error_exit "Failed to copy light theme"
    chmod 644 "$ROFI_DIR/web-shortcuts-light.rasi"
    echo -e "${GREEN}✓ Rofi themes installed (dark & light)${NC}"
else
    echo -e "${GREEN}✓ Rofi theme installed (dark)${NC}"
fi

# Copy launcher script
echo -e "${BLUE}[3/5]${NC} Installing launcher script..."
cp scripts/web-shortcuts.sh "$WAYBAR_DIR/scripts/"
chmod +x "$WAYBAR_DIR/scripts/web-shortcuts.sh"
echo -e "${GREEN}✓ Launcher script installed${NC}"

# Set up configuration file
echo -e "${BLUE}[4/5]${NC} Setting up configuration..."
if [[ -f "$WEBLINKS_DIR/links.conf" ]]; then
    echo -e "${YELLOW}⚠ Configuration file already exists. Skipping.${NC}"
else
    cp links.conf.example "$WEBLINKS_DIR/links.conf"
    chmod 644 "$WEBLINKS_DIR/links.conf"
    echo -e "${GREEN}✓ Configuration file created${NC}"
fi

# Configure waybar module
if [[ $SKIP_WAYBAR -eq 1 ]]; then
    echo -e "${BLUE}[5/5]${NC} Skipping waybar configuration (--skip-waybar flag)"
else
    echo -e "${BLUE}[5/5]${NC} Configuring waybar..."
    WAYBAR_CONFIG="$WAYBAR_DIR/config.jsonc"
    if [[ ! -f "$WAYBAR_CONFIG" ]]; then
        WAYBAR_CONFIG="$WAYBAR_DIR/config"
    fi

    if [[ -f "$WAYBAR_CONFIG" ]]; then
        if grep -q "custom/web-shortcuts" "$WAYBAR_CONFIG"; then
            echo -e "${YELLOW}⚠ Waybar module already configured${NC}"
        else
            echo -e "${BLUE}Automatically configuring waybar...${NC}"

            # Backup the config
            BACKUP_FILE="${WAYBAR_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
            cp "$WAYBAR_CONFIG" "$BACKUP_FILE" || error_exit "Failed to backup waybar config"
            echo -e "${YELLOW}  Backup created: $BACKUP_FILE${NC}"

            # Try to validate if it's valid JSON before modifying
            if command -v jq &> /dev/null; then
                # Remove comments for validation (jsonc support)
                if ! grep -v '^\s*//' "$WAYBAR_CONFIG" | jq empty 2>/dev/null; then
                    echo -e "${YELLOW}⚠ Warning: Waybar config may not be valid JSON${NC}"
                    echo -e "${YELLOW}  Manual configuration may be required${NC}"
                fi
            fi

            # Add the module definition before the last closing brace
            # Find the last } and insert before it
            sed -i '$ {s/^}/,\n  "custom\/web-shortcuts": {\n    "format": "🌐",\n    "on-click": "~\/.config\/waybar\/scripts\/web-shortcuts.sh",\n    "tooltip-format": "Quick Web Links"\n  }\n}/}' "$WAYBAR_CONFIG"

            # Verify the modification worked
            if ! grep -q "custom/web-shortcuts" "$WAYBAR_CONFIG"; then
                echo -e "${RED}✗ Failed to add module definition${NC}"
                echo -e "${YELLOW}  Restoring backup...${NC}"
                cp "$BACKUP_FILE" "$WAYBAR_CONFIG"
                echo -e "${YELLOW}  Please add the module manually to your waybar config${NC}"
            else
                # Add to modules-right array at the beginning
                # Find "modules-right": [ and add our module as first entry
                sed -i '/"modules-right".*\[/{
                    n
                    s/^\(\s*\)/\1"custom\/web-shortcuts",\n\1/
                }' "$WAYBAR_CONFIG"

                # Verify full configuration
                if grep -q "custom/web-shortcuts" "$WAYBAR_CONFIG" && grep -q '"modules-right"' "$WAYBAR_CONFIG"; then
                    echo -e "${GREEN}✓ Waybar config updated successfully${NC}"
                else
                    echo -e "${YELLOW}⚠ Partial configuration - manual adjustment may be needed${NC}"
                fi
            fi
        fi
    else
        echo -e "${YELLOW}⚠ Waybar config not found at $WAYBAR_CONFIG${NC}"
        echo -e "${YELLOW}  You can manually add the module later or run with --skip-waybar${NC}"
    fi
fi

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "Next steps:"
echo -e "  1. Run ${BLUE}./configure.sh${NC} to add your own links"
echo -e "  2. Reload waybar: ${BLUE}killall waybar; nohup waybar >/dev/null 2>&1 &${NC}"
echo
