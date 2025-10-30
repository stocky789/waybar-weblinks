# Waybar Web Shortcuts 🌐

A beautiful, customizable web shortcuts menu for Waybar with a macOS-inspired glass theme.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

## ✨ Features

- **🎨 Beautiful UI**: macOS-inspired glass theme with blur effects and smooth animations
- **⚡ Fast & Lightweight**: Minimal resource usage using rofi and bash
- **🔧 Easy Configuration**: Simple config file to manage your shortcuts
- **🎯 Customizable**: Add unlimited shortcuts with emoji icons
- **📦 Quick Install**: One-command installation script
- **🌓 Dark Theme**: Optimized for dark mode with excellent readability

## 📸 Preview

The menu features:
- Translucent dark background with glass effect
- Solid, readable menu items with rounded corners
- Apple blue selection highlight
- Searchable entries
- Emoji icons for visual identification

## 🚀 Quick Start

### Prerequisites

- Waybar (obviously!)
- Rofi (will be auto-installed if missing)
- A browser (xdg-open compatible)

### Installation

1. Clone this repository:
```bash
git clone https://github.com/stocky789/waybar-weblinks.git
cd waybar-weblinks
```

2. Run the installer:
```bash
./install.sh
```

The installer will automatically:
- Install rofi if needed
- Copy files to the correct locations
- **Automatically configure your waybar** (with backup)
- Set up the default configuration

3. Configure your links:
```bash
./configure.sh
```

Or manually edit `~/.config/waybar-weblinks/links.conf`

4. Reload waybar:
```bash
killall waybar; nohup waybar >/dev/null 2>&1 &
```

## ⚙️ Configuration

### Using the Configuration Script

Run the interactive configuration tool:
```bash
./configure.sh
```

This will guide you through setting up your shortcuts with prompts for labels and URLs.

### Manual Configuration

Edit `~/.config/waybar-weblinks/links.conf`:

```bash
# Labels (what appears in the menu with emoji icons)
LINK_LABELS=(
    "🌐 GitHub Repo"  # Default - points to this project
    "📞 My Service"    # Add your own links below
    "💼 Portal"
)

# URLs (corresponding links that will open)
LINK_URLS=(
    "https://github.com/stocky789/waybar-weblinks"
    "https://myservice.example.com"
    "https://portal.example.com"
)
```

**Important**: Make sure both arrays have the same number of entries!

### Adding More Shortcuts

Simply add new entries to both arrays in `~/.config/waybar-weblinks/links.conf`.

## 🎨 Customization

### Changing the Theme

Edit `~/.config/rofi/web-shortcuts.rasi` to customize colors and appearance:

```css
* {
    bg: rgba(30, 30, 35, 0.85);        /* Window background */
    bg-alt: rgba(50, 50, 55, 0.95);    /* Menu items background */
    fg: #e5e5e7;                       /* Text color */
    selected: rgba(10, 132, 255, 0.8); /* Selection highlight */
    active: #0a84ff;                   /* Active/accent color */
}
```

### Changing the Waybar Icon

Edit your waybar config to use a different icon:
```json
"custom/web-shortcuts": {
  "format": "🔗",  // Change this to any emoji or text
  "on-click": "~/.config/waybar/scripts/web-shortcuts.sh",
  "tooltip-format": "Quick Web Links"
}
```

## 📁 File Structure

```
waybar-weblinks/
├── install.sh                 # Installation script
├── configure.sh              # Interactive configuration tool
├── README.md                 # This file
├── LICENSE                   # MIT License
├── links.conf.example        # Example configuration
├── rofi/
│   └── web-shortcuts.rasi   # Rofi theme (macOS glass style)
└── scripts/
    └── web-shortcuts.sh     # Launcher script
```

### Installed Files

After installation, files will be placed at:
- `~/.config/waybar/scripts/web-shortcuts.sh` - Launcher script
- `~/.config/rofi/web-shortcuts.rasi` - Rofi theme
- `~/.config/waybar-weblinks/links.conf` - Your configuration

## 🗑️ Uninstallation

To remove waybar-weblinks:
```bash
./uninstall.sh
```

This will remove all installed files. You'll need to manually remove the module from your waybar config.

## 🐛 Troubleshooting

### Menu doesn't appear when clicking
- Check if rofi is installed: `which rofi`
- Make sure the script is executable: `chmod +x ~/.config/waybar/scripts/web-shortcuts.sh`
- Check for errors: Run the script manually to see output

### Links don't open
- Verify your URLs in `~/.config/waybar-weblinks/links.conf`
- Make sure URLs include `https://` or `http://`
- Check that xdg-open is working: `xdg-open https://google.com`

### Module not showing in waybar
- Verify the module is added to your waybar config
- Check that it's included in your `modules-right` array
- Restart waybar: `killall waybar; nohup waybar >/dev/null 2>&1 &`

### Config file not found error
- Run the installer: `./install.sh`
- Or manually copy: `cp links.conf.example ~/.config/waybar-weblinks/links.conf`

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Share your custom themes

## 📝 License

MIT License - feel free to use and modify as you wish!

## 🙏 Credits

Created for the Waybar and Hyprland community. Inspired by macOS design principles.

## 💡 Tips

- Use descriptive emoji icons for quick visual identification
- Keep your most-used links at the top
- Use keyboard shortcuts in rofi to quickly navigate (type to search!)
- Group similar services together (e.g., all PBX systems, all admin panels)

---

**Made with ❤️ for the Linux desktop customization community**
