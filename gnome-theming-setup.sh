#!/bin/bash

# GNOME Theming Enhancement Script
# Adds macOS-like animations, Papirus icons, and modern extensions
# Run with: bash gnome-theming-setup.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }
print_command() { echo -e "${CYAN}$ ${NC}$1"; }

print_section "GNOME Theming Enhancement Setup"
print_status "Configuring macOS-like theming with modern extensions..."

# Check current desktop environment
if [ -n "$XDG_CURRENT_DESKTOP" ]; then
    print_status "Detected desktop: $XDG_CURRENT_DESKTOP"
fi

# Apply immediate settings that don't require sudo
print_section "Applying GNOME Settings (no sudo required)"

# Configure macOS-like animations and effects
print_status "Configuring macOS-like animations..."

# Enable animations and set faster speeds
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface gtk-enable-animations true

# Set up window controls like macOS (close, minimize, maximize on left)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
print_status "✓ Window controls moved to left side (macOS style)"

# Configure window behavior
gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'

# Configure Alt+Tab to be more macOS-like
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"

# Set up macOS-like workspace behavior
gsettings set org.gnome.mutter dynamic-workspaces true
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.shell.overrides workspaces-only-on-primary false

# Set accent color to blue for macOS-like feel
gsettings set org.gnome.desktop.interface accent-color 'blue'
print_status "✓ Set blue accent color"

# Configure font rendering for crisp text like macOS
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'

# Configure window focus behavior
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
gsettings set org.gnome.desktop.wm.preferences raise-on-click true

# Set up hot corners
gsettings set org.gnome.desktop.interface enable-hot-corners true

# Configure file manager
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'

# Set up keyboard shortcuts more like macOS
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>space']"
print_status "✓ Applied macOS-style keyboard shortcuts"

# Configure dock behavior (if using Ubuntu dock)
if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
    print_status "Configuring dock for macOS-like behavior..."
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
    gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.2
    gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.2
    gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.0
    print_status "✓ Configured dock for macOS-like behavior"
fi

# Configure touchpad for macOS-like gestures (if laptop)
if [ -d /proc/acpi/battery ] || [ -d /sys/class/power_supply ] && ls /sys/class/power_supply/ 2>/dev/null | grep -q BAT; then
    print_status "Configuring macOS-like touchpad gestures..."
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true  # macOS style
    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'  # macOS style clicking
    print_status "✓ Applied macOS-style touchpad gestures"
fi

# Check what needs to be installed
print_section "Packages and Extensions Needed"

print_status "Run these commands to install required packages:"
echo ""
print_command "sudo apt update"
print_command "sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager chrome-gnome-shell curl unzip"
echo ""

print_status "Install Papirus icon theme:"
print_command "sudo add-apt-repository ppa:papirus/papirus -y"
print_command "sudo apt update"
print_command "sudo apt install -y papirus-icon-theme papirus-folders numix-icon-theme numix-icon-theme-circle"
echo ""

print_status "After installing packages, run this to apply Papirus icons:"
print_command "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"
echo ""

# Create extension installation script
cat > /tmp/install-extensions.sh << 'EOF'
#!/bin/bash

# Install Bibata cursor theme
echo "Installing Bibata modern cursor theme..."
CURSOR_DIR="$HOME/.local/share/icons"
mkdir -p "$CURSOR_DIR"

if [ ! -d "$CURSOR_DIR/Bibata-Modern-Classic" ]; then
    curl -L "https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.gz" -o /tmp/bibata-cursor.tar.gz
    tar -xzf /tmp/bibata-cursor.tar.gz -C "$CURSOR_DIR"
    rm -f /tmp/bibata-cursor.tar.gz
    echo "✓ Bibata cursor theme installed"
fi

# Apply cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
echo "✓ Applied Bibata cursor theme"

# Apply Papirus icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
echo "✓ Applied Papirus-Dark icon theme"
EOF

chmod +x /tmp/install-extensions.sh

print_status "Extension installation script created. Run this after installing packages:"
print_command "bash /tmp/install-extensions.sh"
echo ""

print_section "Manual Extension Installation"
print_status "Install these GNOME extensions manually via Extensions Manager or browser:"
echo ""
echo "🔗 Visit: https://extensions.gnome.org"
echo ""
echo "Required Extensions:"
echo "• Blur my Shell - https://extensions.gnome.org/extension/3193/"
echo "• Burn My Windows - https://extensions.gnome.org/extension/4679/"
echo "• Compiz alike magic lamp effect - https://extensions.gnome.org/extension/3740/"
echo "• Animation Tweaks - https://extensions.gnome.org/extension/1680/"
echo "• User Themes - https://extensions.gnome.org/extension/19/"
echo ""

print_section "Quick Installation Summary"
print_status "Complete setup in this order:"
echo ""
echo "1. Install packages:"
echo "   sudo apt update && sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager chrome-gnome-shell"
echo ""
echo "2. Install Papirus icons:"
echo "   sudo add-apt-repository ppa:papirus/papirus -y && sudo apt update && sudo apt install -y papirus-icon-theme"
echo ""
echo "3. Install cursor and apply themes:"
echo "   bash /tmp/install-extensions.sh"
echo ""
echo "4. Install GNOME extensions via browser or Extensions Manager"
echo ""
echo "5. Log out and back in to see all changes"

print_section "Current Settings Applied"
print_status "These macOS-like settings are now active:"
echo "• ✓ Window controls moved to left (close, minimize, maximize)"
echo "• ✓ macOS-style keyboard shortcuts (⌘Q to close, ⌘M to minimize)"
echo "• ✓ Blue accent color theme"
echo "• ✓ Enhanced font rendering"
echo "• ✓ macOS-like touchpad gestures (if laptop)"
echo "• ✓ Dynamic workspaces"
echo "• ✓ Hot corners enabled"
echo "• ✓ Dock configured for macOS-like behavior"

print_warning "Next steps:"
echo "1. Run the package installation commands above"
echo "2. Install the browser extensions"
echo "3. Log out and back in for full effect"
echo "4. Use 'Extensions' app to fine-tune settings"

print_status "Setup script completed! 🎉"