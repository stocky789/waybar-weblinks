#!/bin/bash

# Web shortcuts menu for waybar
# Configure your links in ~/.config/waybar-weblinks/links.conf

VERSION="2.0.0"

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar-weblinks/links.conf"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar-weblinks"
THEME_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/web-shortcuts.rasi"

# Color codes for error messages
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Show help message
show_help() {
    cat << EOF
Waybar Web Shortcuts - Quick web link launcher for Waybar

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help       Show this help message
  -v, --version    Show version information
  -t, --theme      Specify custom rofi theme file
  -d, --debug      Enable debug output

Configuration:
  Edit your shortcuts in: $CONFIG_FILE
  Run 'configure.sh' for interactive setup

Examples:
  $(basename "$0")                    # Launch shortcut menu
  $(basename "$0") -t my-theme.rasi   # Use custom theme
  $(basename "$0") --debug            # Show debug info

EOF
    exit 0
}

# Show version
show_version() {
    echo "Waybar Web Shortcuts v${VERSION}"
    exit 0
}

# Debug mode flag
DEBUG=0

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -t|--theme)
            THEME_FILE="$2"
            shift 2
            ;;
        -d|--debug)
            DEBUG=1
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Debug output function
debug() {
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Error handler
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Validate URL format
validate_url() {
    local url="$1"
    # Allow http://, https://, file://, or environment variable references
    if [[ "$url" =~ ^(https?|file)://.*$ ]] || [[ "$url" =~ \$\{.*\} ]]; then
        return 0
    else
        return 1
    fi
}

# Check dependencies
debug "Checking dependencies..."
command -v rofi &> /dev/null || error_exit "rofi is not installed. Please install it first."
command -v xdg-open &> /dev/null || error_exit "xdg-open is not installed."

# Load configuration
debug "Loading configuration from: $CONFIG_FILE"
if [[ ! -f "$CONFIG_FILE" ]]; then
    error_exit "Configuration file not found: $CONFIG_FILE\nRun 'configure.sh' to create your configuration."
fi

source "$CONFIG_FILE" || error_exit "Failed to load configuration file. Check syntax."

# Validate configuration
debug "Validating configuration..."

# Check if arrays exist
if [[ -z "${LINK_LABELS+x}" ]] || [[ -z "${LINK_URLS+x}" ]]; then
    error_exit "Configuration missing LINK_LABELS or LINK_URLS arrays."
fi

# Check if arrays have same length
if [[ ${#LINK_LABELS[@]} -ne ${#LINK_URLS[@]} ]]; then
    error_exit "Configuration error: LINK_LABELS (${#LINK_LABELS[@]} items) and LINK_URLS (${#LINK_URLS[@]} items) must have the same length."
fi

# Check if arrays are empty
if [[ ${#LINK_LABELS[@]} -eq 0 ]]; then
    error_exit "No shortcuts configured. Run 'configure.sh' to add shortcuts."
fi

# Validate URLs and expand environment variables
debug "Validating URLs..."
for i in "${!LINK_URLS[@]}"; do
    # Expand environment variables in URLs
    LINK_URLS[$i]=$(eval echo "${LINK_URLS[$i]}")

    # Validate URL format
    if ! validate_url "${LINK_URLS[$i]}"; then
        echo -e "${YELLOW}Warning: Invalid URL format for '${LINK_LABELS[$i]}': ${LINK_URLS[$i]}${NC}" >&2
    fi
done

# Load optional settings with defaults
BROWSER="${LINK_BROWSER:-xdg-open}"
PRIVATE_MODE="${LINK_PRIVATE_MODE:-false}"
USE_CATEGORIES="${LINK_USE_CATEGORIES:-false}"

# Handle category support
if [[ "$USE_CATEGORIES" == "true" ]] && [[ -n "${LINK_CATEGORIES+x}" ]]; then
    debug "Categories enabled, building categorized menu..."
    MENU=""
    FIRST=1

    # Build menu with categories
    for cat in "${LINK_CATEGORIES[@]}"; do
        # Add category header
        if [[ $FIRST -eq 1 ]]; then
            MENU="📁 ${cat}"
            FIRST=0
        else
            MENU="${MENU}\n📁 ${cat}"
        fi

        # Add items in this category
        category_var="CATEGORY_${cat// /_}"
        if [[ -n "${!category_var+x}" ]]; then
            eval "category_items=(\"\${${category_var}[@]}\")"
            for item in "${category_items[@]}"; do
                # Find this item in LINK_LABELS
                for i in "${!LINK_LABELS[@]}"; do
                    if [[ "${LINK_LABELS[$i]}" == *"$item"* ]]; then
                        # Check if disabled
                        if [[ -n "${LINK_DISABLED+x}" ]] && [[ " ${LINK_DISABLED[*]} " =~ " $i " ]]; then
                            continue
                        fi
                        MENU="${MENU}\n  ${LINK_LABELS[$i]}"
                        break
                    fi
                done
            done
        fi
    done
else
    # Build regular menu from config (no categories)
    debug "Building menu with ${#LINK_LABELS[@]} items..."
    MENU=""
    FIRST=1
    for i in "${!LINK_LABELS[@]}"; do
        # Skip disabled items
        if [[ -n "${LINK_DISABLED+x}" ]] && [[ " ${LINK_DISABLED[*]} " =~ " $i " ]]; then
            debug "Skipping disabled item: ${LINK_LABELS[$i]}"
            continue
        fi

        # Add description/tooltip if available
        label="${LINK_LABELS[$i]}"
        if [[ -n "${LINK_DESCRIPTIONS+x}" ]] && [[ -n "${LINK_DESCRIPTIONS[$i]}" ]]; then
            label="${label} (${LINK_DESCRIPTIONS[$i]})"
        fi

        if [[ $FIRST -eq 1 ]]; then
            MENU="$label"
            FIRST=0
        else
            MENU="${MENU}\n${label}"
        fi
    done
fi

# Check if menu is empty (all items disabled)
if [[ -z "$MENU" ]]; then
    error_exit "No enabled shortcuts found. Check your configuration."
fi

# Check if theme file exists
if [[ ! -f "$THEME_FILE" ]]; then
    echo -e "${YELLOW}Warning: Theme file not found: $THEME_FILE${NC}" >&2
    echo -e "${YELLOW}Using rofi default theme.${NC}" >&2
    THEME_ARG=""
else
    THEME_ARG="-theme $THEME_FILE"
fi

# Launch rofi menu
debug "Launching rofi menu..."
choice=$(echo -e "$MENU" | rofi -dmenu -i -p "Quick Links" $THEME_ARG)

# Check if user made a selection
if [[ -z "$choice" ]]; then
    debug "No selection made, exiting."
    exit 0
fi

debug "User selected: $choice"

# Handle category selection (if user clicked a category header)
if [[ "$choice" == 📁* ]]; then
    debug "Category header selected, exiting."
    exit 0
fi

# Remove description from choice if present
choice=$(echo "$choice" | sed 's/ (.*)$//')

# Open the selected link
debug "Searching for matching link..."
FOUND=0
for i in "${!LINK_LABELS[@]}"; do
    # Skip disabled items
    if [[ -n "${LINK_DISABLED+x}" ]] && [[ " ${LINK_DISABLED[*]} " =~ " $i " ]]; then
        continue
    fi

    if [[ "${LINK_LABELS[$i]}" == "$choice" ]] || [[ "  ${LINK_LABELS[$i]}" == "$choice" ]]; then
        debug "Match found: ${LINK_URLS[$i]}"
        FOUND=1

        # Determine which browser to use
        if [[ "$BROWSER" != "xdg-open" ]]; then
            if command -v "$BROWSER" &> /dev/null; then
                if [[ "$PRIVATE_MODE" == "true" ]]; then
                    case "$BROWSER" in
                        firefox)
                            "$BROWSER" --private-window "${LINK_URLS[$i]}" &
                            ;;
                        chromium|google-chrome|chrome)
                            "$BROWSER" --incognito "${LINK_URLS[$i]}" &
                            ;;
                        brave)
                            "$BROWSER" --incognito "${LINK_URLS[$i]}" &
                            ;;
                        *)
                            "$BROWSER" "${LINK_URLS[$i]}" &
                            ;;
                    esac
                else
                    "$BROWSER" "${LINK_URLS[$i]}" &
                fi
            else
                echo -e "${YELLOW}Warning: Browser '$BROWSER' not found, using xdg-open${NC}" >&2
                xdg-open "${LINK_URLS[$i]}" &
            fi
        else
            xdg-open "${LINK_URLS[$i]}" &
        fi

        # Check if URL opening succeeded
        if [[ $? -ne 0 ]]; then
            error_exit "Failed to open URL: ${LINK_URLS[$i]}"
        fi

        debug "Successfully opened link"
        break
    fi
done

if [[ $FOUND -eq 0 ]]; then
    error_exit "No matching link found for selection: $choice"
fi

exit 0
