#!/bin/bash

# Windows-Style Keyboard Shortcuts for Ubuntu
# Configures familiar shortcuts for Windows laptop users

set -e  # Exit on any error

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/common-functions.sh" ]; then
    source "$SCRIPT_DIR/common-functions.sh"
else
    echo "Error: common-functions.sh not found"
    exit 1
fi

# Initialize logging
init_log

print_header "⌨️ Windows-Style Keyboard Shortcuts Configuration"

# Validate dependencies
if ! validate_dependencies "keyboard-shortcuts.sh" "gsettings"; then
    print_error "Missing required dependencies"
    add_manual_task "Install missing dependencies: gsettings (part of GNOME)"
    finalize_log "Keyboard Shortcuts"
    exit 1
fi

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

# Add summary to log
print_header "Keyboard Shortcuts Configured"
print_success "Windows-style keyboard shortcuts configured successfully!"

add_manual_task "Test Super+E to open file manager"
add_manual_task "Test Super+L to lock screen"
add_manual_task "Test Alt+F4 to close windows"
add_manual_task "Test Ctrl+Shift+Esc for system monitor"
add_manual_task "Test Super+Arrow keys for window tiling"

add_next_step "Log out and back in if some shortcuts don't work immediately"
add_next_step "Customize additional shortcuts in Settings > Keyboard if needed"

print_info "Configured shortcuts:"
print_info "• Super+E         - File Manager (Windows Explorer)"
print_info "• Super+L         - Lock Screen"
print_info "• Super+D         - Show Desktop"
print_info "• Alt+F4          - Close Window"
print_info "• Ctrl+Shift+Esc  - System Monitor (Task Manager)"
print_info "• Ctrl+Alt+V      - VS Code"
print_info "• Super+Arrow     - Window tiling/maximize"
print_info "• Alt+Tab         - Switch windows"
print_info "• Super+Tab       - Switch applications"

finalize_log "Keyboard Shortcuts"