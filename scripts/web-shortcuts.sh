#!/bin/bash

# Web shortcuts menu for waybar
# Configure your links in ~/.config/waybar-weblinks/links.conf

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar-weblinks/links.conf"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Build menu from config
MENU=""
FIRST=1
for i in "${!LINK_LABELS[@]}"; do
    if [[ $FIRST -eq 1 ]]; then
        MENU="${LINK_LABELS[$i]}"
        FIRST=0
    else
        MENU="${MENU}\n${LINK_LABELS[$i]}"
    fi
done

choice=$(echo -e "$MENU" | \
  rofi -dmenu -i -p "Quick Links" \
  -theme ~/.config/rofi/web-shortcuts.rasi)

# Open the selected link
for i in "${!LINK_LABELS[@]}"; do
    if [[ "${LINK_LABELS[$i]}" == "$choice" ]]; then
        xdg-open "${LINK_URLS[$i]}"
        break
    fi
done
