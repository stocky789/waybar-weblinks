# Waybar Web Shortcuts 🌐

A powerful, customizable web shortcuts menu for Waybar with beautiful themes and advanced features.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)
![Version](https://img.shields.io/badge/version-2.0.0-green.svg)

## ✨ Features

### Core Features
- **⚡ Fast & Lightweight**: Minimal resource usage using rofi and bash
- **🎨 Beautiful Themes**: Dark and light themes with glass morphism design
- **🔍 Smart Search**: Filter shortcuts with fuzzy search
- **📁 Categories**: Organize shortcuts into folders (optional)
- **🛠️ Individual Management**: Add, edit, remove, enable/disable shortcuts individually
- **📝 Descriptions**: Add tooltips to explain each shortcut

### Advanced Features
- **🌐 Browser Control**: Choose specific browser (Firefox, Chrome, Brave, etc.)
- **🔒 Private Mode**: Open links in incognito/private browsing mode
- **💾 Backup & Restore**: Automatic backups with easy restoration
- **✅ Validation**: Built-in config validator with helpful error messages
- **🔧 Environment Variables**: Use `${HOME}`, `${USER}` in URLs
- **📦 One-Command Install**: Automatic waybar integration with safety backups
- **--help Everywhere**: All scripts have detailed help documentation

## 📸 Preview

### Dark Theme (Default)
- Translucent dark background with glass effect
- Solid, readable menu items with rounded corners
- Apple blue selection highlight
- Searchable entries with fuzzy matching
- Emoji icons for visual identification

### Light Theme
- Clean, bright appearance for daytime use
- Subtle shadows and borders
- Blue accent highlighting
- Perfect for light desktop themes

## 🚀 Quick Start

### Prerequisites

- **Waybar** - The status bar (obviously!)
- **Rofi** - Menu renderer (auto-installed if missing)
- **Browser** - Any xdg-open compatible browser

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/stocky789/waybar-weblinks.git
cd waybar-weblinks
```

2. **Run the installer:**
```bash
./install.sh
```

The installer will automatically:
- ✅ Install rofi if needed (asks for sudo)
- ✅ Copy all files to correct locations
- ✅ **Automatically configure waybar** (with timestamped backup)
- ✅ Set up default configuration
- ✅ Install both dark and light themes

For more options:
```bash
./install.sh --help              # Show all options
./install.sh --skip-waybar       # Skip waybar config
./install.sh --unattended        # Auto-install with defaults
```

3. **Configure your shortcuts:**
```bash
./configure.sh
```

This launches an interactive setup. See [Configuration](#️-configuration) for more options.

4. **Reload waybar:**
```bash
killall -SIGUSR2 waybar    # Graceful reload
# OR
killall waybar && waybar &  # Full restart
```

That's it! Click the 🌐 icon in your waybar to see the menu.

## ⚙️ Configuration

### Quick Commands

The `configure.sh` tool now supports many commands:

```bash
# Interactive full configuration
./configure.sh

# List all shortcuts
./configure.sh list

# Add a new shortcut
./configure.sh add

# Edit a shortcut (index starts at 0)
./configure.sh edit 2

# Remove a shortcut
./configure.sh remove 1

# Disable/enable shortcuts (keeps them but hides from menu)
./configure.sh disable 3
./configure.sh enable 3

# Backup and restore
./configure.sh backup
./configure.sh restore

# Validate configuration
./configure.sh validate

# Configure global settings (browser, theme, etc.)
./configure.sh settings

# Get help
./configure.sh --help
```

### Interactive Configuration

Run without arguments for the full interactive setup:
```bash
./configure.sh
```

This will:
1. Show your current shortcuts
2. Ask how many you want
3. Prompt for label, URL, and description for each
4. Automatically create a backup of your previous config
5. Save and validate the new configuration

### Manual Configuration

Edit `~/.config/waybar-weblinks/links.conf`:

```bash
# Labels (what appears in the menu)
LINK_LABELS=(
    "🌐 GitHub"
    "📧 Gmail"
    "📺 YouTube"
)

# URLs (must match labels array length)
LINK_URLS=(
    "https://github.com"
    "https://mail.google.com"
    "https://youtube.com"
)

# Descriptions (optional tooltips)
LINK_DESCRIPTIONS=(
    "Code hosting"
    "Email client"
    "Video platform"
)

# Disable specific shortcuts (by index, 0-based)
LINK_DISABLED=(1)  # This would disable Gmail

# Browser settings
LINK_BROWSER="firefox"        # Or: chromium, brave, xdg-open
LINK_PRIVATE_MODE="true"      # Open in private/incognito mode
LINK_THEME="dark"             # Or: light
```

**Important**: `LINK_LABELS` and `LINK_URLS` must have the same length!

### Environment Variables in URLs

You can use shell variables in your URLs:

```bash
LINK_URLS=(
    "https://github.com/${USER}"        # Your GitHub profile
    "file://${HOME}/Documents/index.html"  # Local file
)
```

Variables are expanded when the link is opened.

### Category Organization

For many shortcuts, enable categories:

```bash
# Enable categories
LINK_USE_CATEGORIES="true"

# Define categories
LINK_CATEGORIES=("Work" "Personal" "Dev")

# Map shortcuts to categories
CATEGORY_Work=("Gmail" "Calendar")
CATEGORY_Personal=("YouTube" "Twitter")
CATEGORY_Dev=("GitHub" "GitLab")
```

Categories appear as headers in the menu with indented items below.

## 🎨 Customization

### Switching Themes

**Method 1: Using configure.sh**
```bash
./configure.sh settings
# Then select theme: dark or light
```

**Method 2: Edit config file**
```bash
# In ~/.config/waybar-weblinks/links.conf
LINK_THEME="light"  # or "dark"
```

### Custom Theme Colors

Edit the theme files to customize colors:

**Dark theme:** `~/.config/rofi/web-shortcuts.rasi`
**Light theme:** `~/.config/rofi/web-shortcuts-light.rasi`

```css
* {
    bg: rgba(30, 30, 35, 0.85);        /* Window background */
    bg-alt: rgba(50, 50, 55, 0.95);    /* Menu items */
    fg: #e5e5e7;                       /* Text color */
    selected: rgba(10, 132, 255, 0.8); /* Selection highlight */
    active: #0a84ff;                   /* Accent color */
    border-color: rgba(255, 255, 255, 0.15);  /* Borders */
}
```

### Custom Theme File

You can use a completely custom theme:

```bash
~/.config/waybar/scripts/web-shortcuts.sh --theme /path/to/custom.rasi
```

Or set it permanently in your waybar config:
```json
"custom/web-shortcuts": {
  "format": "🌐",
  "on-click": "~/.config/waybar/scripts/web-shortcuts.sh --theme ~/.config/rofi/my-custom.rasi"
}
```

### Changing the Waybar Icon

Edit your waybar config (`~/.config/waybar/config.jsonc`):

```json
"custom/web-shortcuts": {
  "format": "🔗",  // Any emoji or text
  "on-click": "~/.config/waybar/scripts/web-shortcuts.sh",
  "tooltip-format": "Quick Web Links"
}
```

Popular icon choices: 🌐 🔗 🌍 🗂️ ⚡ 🚀 📎

### Browser-Specific Settings

Configure different browsers per shortcut or globally:

**Global setting:**
```bash
./configure.sh settings
# Select browser: firefox, chromium, brave, etc.
```

**Per-launch override:**
```bash
LINK_BROWSER=firefox LINK_PRIVATE_MODE=true ~/.config/waybar/scripts/web-shortcuts.sh
```

### Debug Mode

To troubleshoot issues:

```bash
~/.config/waybar/scripts/web-shortcuts.sh --debug
```

This shows detailed information about what the script is doing.

## 📁 File Structure

### Repository Structure
```
waybar-weblinks/
├── install.sh                      # Installation script (v2.0.0)
├── uninstall.sh                    # Removal script
├── configure.sh                    # Configuration tool (multi-command)
├── README.md                       # This comprehensive guide
├── LICENSE                         # MIT License
├── links.conf.example             # Example config with all features
├── rofi/
│   ├── web-shortcuts.rasi         # Dark theme (default)
│   └── web-shortcuts-light.rasi   # Light theme
└── scripts/
    └── web-shortcuts.sh           # Main launcher (v2.0.0)
```

### Installed Files

After installation:
```
~/.config/
├── waybar/
│   ├── config.jsonc               # Auto-configured with backup
│   └── scripts/
│       └── web-shortcuts.sh      # Main launcher
├── rofi/
│   ├── web-shortcuts.rasi         # Dark theme
│   └── web-shortcuts-light.rasi   # Light theme
└── waybar-weblinks/
    ├── links.conf                 # Your configuration
    └── backups/                   # Automatic backups directory
        ├── links.conf.backup-*    # Timestamped backups
        └── links.conf.manual-*    # Manual backups
```

## 🗑️ Uninstallation

### Complete Removal
```bash
./uninstall.sh
```

This interactively removes all installed files.

### Options
```bash
./uninstall.sh --help        # Show all options
./uninstall.sh --force       # Skip confirmation
./uninstall.sh --keep-config # Remove app but keep your shortcuts
```

### What Gets Removed
- ✅ Launcher script
- ✅ Both theme files
- ✅ Configuration directory (unless --keep-config)
- ✅ All backups

### Manual Cleanup Required
You'll need to manually remove the module from your waybar config:

1. Edit `~/.config/waybar/config.jsonc`
2. Remove `"custom/web-shortcuts"` from `modules-right` array
3. Delete the `"custom/web-shortcuts"` module definition block
4. Reload waybar

## 🐛 Troubleshooting & FAQ

### Installation Issues

**Q: Rofi won't install automatically**
```bash
# Try installing manually based on your distro:
# Arch/Manjaro:
sudo pacman -S rofi

# Debian/Ubuntu:
sudo apt install rofi

# Fedora:
sudo dnf install rofi

# Then re-run install.sh
```

**Q: Waybar configuration failed**
```bash
# Install without waybar config, configure manually:
./install.sh --skip-waybar

# Then manually add to ~/.config/waybar/config.jsonc:
{
  "custom/web-shortcuts": {
    "format": "🌐",
    "on-click": "~/.config/waybar/scripts/web-shortcuts.sh",
    "tooltip-format": "Quick Web Links"
  }
}
```

### Menu Issues

**Q: Menu doesn't appear when clicking**

1. Check if rofi is installed:
```bash
which rofi  # Should show /usr/bin/rofi or similar
```

2. Test the script manually:
```bash
~/.config/waybar/scripts/web-shortcuts.sh --debug
```

3. Check script permissions:
```bash
chmod +x ~/.config/waybar/scripts/web-shortcuts.sh
```

4. Look for errors in waybar output:
```bash
killall waybar && waybar  # Run in terminal to see errors
```

**Q: Menu appears but is empty**

- Check your configuration is valid:
```bash
./configure.sh validate
```

- Make sure you have enabled shortcuts:
```bash
./configure.sh list  # Shows which are disabled
```

- Verify config file exists:
```bash
cat ~/.config/waybar-weblinks/links.conf
```

**Q: Wrong theme is displayed**

The theme is loaded from the config file setting:
```bash
# Check current theme:
grep LINK_THEME ~/.config/waybar-weblinks/links.conf

# Change theme:
./configure.sh settings  # Interactive
# OR edit manually:
# LINK_THEME="light"  # or "dark"
```

### Link Opening Issues

**Q: Links don't open**

1. Test if xdg-open works:
```bash
xdg-open https://google.com
```

2. Check URL format in config:
```bash
./configure.sh validate  # Checks URL formats
```

3. Enable debug mode to see what's happening:
```bash
~/.config/waybar/scripts/web-shortcuts.sh --debug
```

**Q: Wrong browser opens**

Set your preferred browser:
```bash
./configure.sh settings
# Select LINK_BROWSER: firefox, chromium, brave, etc.
```

Or set system default:
```bash
xdg-settings set default-web-browser firefox.desktop
```

**Q: Private mode doesn't work**

Private mode requires specific browser commands. Supported browsers:
- Firefox: `--private-window`
- Chrome/Chromium: `--incognito`
- Brave: `--incognito`

If using another browser, it may not support this feature.

### Configuration Issues

**Q: Configuration validation fails**

Common issues:
1. **Array length mismatch**: LINK_LABELS and LINK_URLS must be same length
2. **Invalid URL**: Must start with `https://`, `http://`, or `file://`
3. **Syntax error**: Check for missing quotes or parentheses

Fix:
```bash
./configure.sh validate  # Shows specific errors
./configure.sh           # Reconfigure interactively
```

**Q: Environment variables don't expand**

Make sure they're in the correct format:
```bash
# Correct:
"https://github.com/${USER}/repos"
"file://${HOME}/Documents/page.html"

# Incorrect:
"https://github.com/$USER/repos"     # Missing braces
"https://github.com/\${USER}/repos"  # Escaped dollar sign
```

**Q: Can't restore from backup**

List available backups:
```bash
ls ~/.config/waybar-weblinks/backups/

# Restore using configure.sh:
./configure.sh restore

# Or manually:
cp ~/.config/waybar-weblinks/backups/links.conf.backup-TIMESTAMP \
   ~/.config/waybar-weblinks/links.conf
```

### Waybar Integration Issues

**Q: Module not showing in waybar**

1. Check waybar config includes the module:
```bash
grep "custom/web-shortcuts" ~/.config/waybar/config.jsonc
```

2. Verify it's in modules array:
```bash
grep -A 10 "modules-right" ~/.config/waybar/config.jsonc
```

3. Restart waybar:
```bash
killall -SIGUSR2 waybar  # Graceful reload
# OR
killall waybar && waybar &  # Full restart
```

**Q: Waybar shows error "Config file not found"**

The config wasn't created during install:
```bash
# Copy example config:
cp links.conf.example ~/.config/waybar-weblinks/links.conf

# Or run configuration tool:
./configure.sh
```

### Category Issues

**Q: Categories don't show up**

Make sure categories are enabled:
```bash
# In ~/.config/waybar-weblinks/links.conf:
LINK_USE_CATEGORIES="true"  # Must be "true" not "1" or "yes"
```

And define categories:
```bash
LINK_CATEGORIES=("Work" "Personal")
CATEGORY_Work=("Gmail" "Calendar")
CATEGORY_Personal=("YouTube")
```

**Q: Items appear in wrong category**

Categories match by label keywords. Check your category definitions match parts of your labels:
```bash
# If label is "📧 Work Gmail"
# This will match:
CATEGORY_Work=("Gmail")  # Matches "Gmail" in the label
```

### Performance & Misc

**Q: Menu is slow to appear**

Try:
1. Reduce number of shortcuts
2. Disable categories if not needed
3. Check rofi config for performance issues

**Q: How do I update to latest version?**

```bash
cd waybar-weblinks
git pull
./install.sh  # Preserves your configuration
```

**Q: Can I use this on multiple machines?**

Yes! Your config is at `~/.config/waybar-weblinks/links.conf`.

To sync:
```bash
# On machine 1:
./configure.sh backup
# Copy backup file to machine 2

# On machine 2:
./configure.sh restore
```

Or use a dotfiles manager/git repo.

### Getting More Help

If you're still having issues:

1. **Check verbose output:**
```bash
~/.config/waybar/scripts/web-shortcuts.sh --debug 2>&1 | less
```

2. **Validate your config:**
```bash
./configure.sh validate
bash -n ~/.config/waybar-weblinks/links.conf  # Check syntax
```

3. **Check versions:**
```bash
./configure.sh --version
./install.sh --version
~/.config/waybar/scripts/web-shortcuts.sh --version
```

4. **Review all help docs:**
```bash
./install.sh --help
./configure.sh --help
./uninstall.sh --help
~/.config/waybar/scripts/web-shortcuts.sh --help
```

5. **Open an issue on GitHub** with:
   - Your distro and versions
   - Output of --debug mode
   - Your config file (sanitize URLs if needed)

## 🆕 What's New in v2.0.0

### Major Features
- ✨ Light theme variant
- 🛠️ Individual shortcut management (add/edit/remove/disable)
- 📁 Category support for organizing shortcuts
- 🔒 Private/incognito mode support
- 🌐 Browser selection (Firefox, Chrome, Brave, etc.)
- 📝 Description/tooltip support
- 💾 Automatic backups with restore functionality
- ✅ Configuration validation with helpful errors
- 🔧 Environment variable expansion in URLs

### Improvements
- Better error handling and validation
- --help and --version flags on all scripts
- Improved font fallbacks (no more SF Pro dependency)
- Better waybar config modification with validation
- Debug mode for troubleshooting
- Comprehensive configuration examples

### Bug Fixes
- Fixed font compatibility issues
- Better handling of edge cases
- Improved array validation
- Safer waybar config modification

## 📝 License

MIT License - feel free to use and modify as you wish!

## 🤝 Contributing

Contributions welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## ⭐ Show Your Support

If you find this project useful, please consider:
- Giving it a star on GitHub
- Sharing it with others
- Contributing improvements
- Reporting bugs

---

Made with ❤️ for the Linux/Wayland community
