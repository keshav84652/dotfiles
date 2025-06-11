#!/bin/bash

# Windows-Style Keyboard Shortcuts for Ubuntu
# Configures familiar shortcuts for Windows laptop users

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⌨️  Configuring Windows-Style Keyboard Shortcuts...${NC}"
echo ""

# File Manager - Windows Explorer equivalent
echo -e "${YELLOW}File Manager Shortcuts:${NC}"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
echo "✓ Super+E opens file manager (like Windows Explorer)"

# Lock Screen - Windows equivalent
echo ""
echo -e "${YELLOW}System Shortcuts:${NC}"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
echo "✓ Super+L locks screen (like Windows)"

# Show Desktop - Windows equivalent
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
echo "✓ Super+D shows desktop (like Windows)"

# Close Window - Windows standard
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4']"
echo "✓ Alt+F4 closes windows (Windows standard)"

# Task Manager equivalent - System Monitor
echo ""
echo -e "${YELLOW}Development Shortcuts:${NC}"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# System Monitor (Task Manager equivalent)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "System Monitor"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Primary><Shift>Escape"
echo "✓ Ctrl+Shift+Esc opens System Monitor (like Task Manager)"

# VS Code quick launch
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "VS Code"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "code"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Primary><Alt>v"
echo "✓ Ctrl+Alt+V opens VS Code"

# Window management shortcuts
echo ""
echo -e "${YELLOW}Window Management:${NC}"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
echo "✓ Super+Up maximizes window"

gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
echo "✓ Super+Down restores window"

gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
echo "✓ Super+Left tiles window to left half"

gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"
echo "✓ Super+Right tiles window to right half"

# Application switching (better Alt+Tab)
echo ""
echo -e "${YELLOW}Application Switching:${NC}"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
echo "✓ Alt+Tab switches between windows (not applications)"

gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
echo "✓ Shift+Alt+Tab switches windows backward"

gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
echo "✓ Super+Tab switches between applications"

echo ""
echo -e "${GREEN}✓ Windows-style keyboard shortcuts configured!${NC}"
echo ""
echo -e "${BLUE}Configured shortcuts:${NC}"
echo "• Super+E         - File Manager (Windows Explorer)"
echo "• Super+L         - Lock Screen"
echo "• Super+D         - Show Desktop"
echo "• Alt+F4          - Close Window"
echo "• Ctrl+Shift+Esc  - System Monitor (Task Manager)"
echo "• Ctrl+Alt+V      - VS Code"
echo "• Super+Arrow     - Window tiling/maximize"
echo "• Alt+Tab         - Switch windows"
echo "• Super+Tab       - Switch applications"
echo ""
echo -e "${YELLOW}Note: Some shortcuts may require logout/login to take full effect.${NC}"