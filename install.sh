#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Waybar Web Shortcuts Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if rofi is installed
if ! command -v rofi &> /dev/null; then
    echo -e "${YELLOW}⚠ Rofi is not installed.${NC}"
    echo -e "Would you like to install it? (requires sudo)"
    read -p "Install rofi? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        if command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm rofi
        elif command -v apt &> /dev/null; then
            sudo apt install -y rofi
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y rofi
        else
            echo -e "${RED}✗ Could not detect package manager. Please install rofi manually.${NC}"
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

# Copy rofi theme
echo -e "${BLUE}[2/5]${NC} Installing rofi theme..."
cp rofi/web-shortcuts.rasi "$ROFI_DIR/"
chmod 644 "$ROFI_DIR/web-shortcuts.rasi"
echo -e "${GREEN}✓ Rofi theme installed${NC}"

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

# Check waybar config
echo -e "${BLUE}[5/5]${NC} Checking waybar configuration..."
WAYBAR_CONFIG="$WAYBAR_DIR/config.jsonc"
if [[ ! -f "$WAYBAR_CONFIG" ]]; then
    WAYBAR_CONFIG="$WAYBAR_DIR/config"
fi

if [[ -f "$WAYBAR_CONFIG" ]]; then
    if grep -q "custom/web-shortcuts" "$WAYBAR_CONFIG"; then
        echo -e "${YELLOW}⚠ Waybar module already configured${NC}"
    else
        echo -e "${YELLOW}⚠ You need to manually add the module to your waybar config${NC}"
        echo -e "Add this to your waybar config:"
        echo -e "${BLUE}"
        cat << 'EOF'

  "custom/web-shortcuts": {
    "format": "🌐",
    "on-click": "~/.config/waybar/scripts/web-shortcuts.sh",
    "tooltip-format": "Quick Web Links"
  }
EOF
        echo -e "${NC}"
        echo -e "And add ${BLUE}\"custom/web-shortcuts\"${NC} to your modules-right array."
    fi
else
    echo -e "${RED}✗ Waybar config not found at $WAYBAR_CONFIG${NC}"
fi

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "Next steps:"
echo -e "  1. Edit your links: ${BLUE}$WEBLINKS_DIR/links.conf${NC}"
echo -e "  2. Add the module to your waybar config (if not done)"
echo -e "  3. Reload waybar: ${BLUE}killall waybar && waybar &${NC}"
echo
