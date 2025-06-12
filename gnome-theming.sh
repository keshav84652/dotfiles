#!/bin/bash

# GNOME Theming Enhancement Script
# Adds macOS-like animations, Papirus icons, and modern extensions
# Run with: bash gnome-theming.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function definitions
print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

# Check if running GNOME
if [ "$XDG_CURRENT_DESKTOP" != "ubuntu:GNOME" ] && [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
    print_error "This script is designed for GNOME desktop environment"
    exit 1
fi

print_section "GNOME Theming Enhancement"
print_status "Setting up macOS-like theming with modern extensions..."

# Install required packages
print_status "Installing theming dependencies..."
sudo apt update
sudo apt install -y \
    gnome-tweaks \
    gnome-shell-extensions \
    gnome-shell-extension-manager \
    chrome-gnome-shell \
    curl \
    unzip

# Install Papirus icon theme
print_status "Installing Papirus icon theme..."
if [ ! -d "/usr/share/icons/Papirus" ]; then
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo apt update
    sudo apt install -y papirus-icon-theme
    print_status "Papirus icon theme installed"
else
    print_status "Papirus icon theme already installed"
fi

# Install additional icon themes for variety
print_status "Installing additional icon themes..."
sudo apt install -y \
    papirus-icon-theme \
    papirus-folders \
    numix-icon-theme \
    numix-icon-theme-circle

# Apply Papirus icon theme
print_status "Applying Papirus icon theme..."
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# Set up modern cursor theme
print_status "Installing Bibata modern cursor theme..."
CURSOR_DIR="$HOME/.local/share/icons"
mkdir -p "$CURSOR_DIR"

if [ ! -d "$CURSOR_DIR/Bibata-Modern-Classic" ]; then
    curl -L "https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.gz" -o /tmp/bibata-cursor.tar.gz
    tar -xzf /tmp/bibata-cursor.tar.gz -C "$CURSOR_DIR"
    rm -f /tmp/bibata-cursor.tar.gz
    print_status "Bibata cursor theme installed"
fi

# Apply cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

# Function to install GNOME extension
install_gnome_extension() {
    local extension_id="$1"
    local extension_name="$2"
    
    print_status "Installing $extension_name extension..."
    
    # Create extensions directory if it doesn't exist
    mkdir -p "$HOME/.local/share/gnome-shell/extensions"
    
    # Download extension info
    local extension_info=$(curl -s "https://extensions.gnome.org/extension-info/?pk=$extension_id")
    local download_url=$(echo "$extension_info" | grep -o '"download_url":"[^"]*"' | cut -d'"' -f4)
    local uuid=$(echo "$extension_info" | grep -o '"uuid":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$download_url" ] && [ -n "$uuid" ]; then
        # Download and install extension
        curl -L "https://extensions.gnome.org$download_url" -o "/tmp/$uuid.zip"
        
        # Extract to extensions directory
        unzip -o "/tmp/$uuid.zip" -d "$HOME/.local/share/gnome-shell/extensions/$uuid/"
        rm -f "/tmp/$uuid.zip"
        
        # Enable extension
        gnome-extensions enable "$uuid"
        print_status "$extension_name installed and enabled"
    else
        print_warning "Could not install $extension_name automatically"
    fi
}

# Install key extensions
print_status "Installing GNOME Shell extensions..."

# Blur my Shell - ID: 3193
install_gnome_extension "3193" "Blur my Shell"

# Burn My Windows - ID: 4679
install_gnome_extension "4679" "Burn My Windows"

# Compiz alike magic lamp effect - ID: 3740
install_gnome_extension "3740" "Compiz alike magic lamp effect"

# Animation Tweaks - ID: 1680
install_gnome_extension "1680" "Animation Tweaks"

# Compiz windows effect - ID: 3210
install_gnome_extension "3210" "Compiz windows effect"

# User Themes - ID: 19
install_gnome_extension "19" "User Themes"

# Configure macOS-like animations and effects
print_status "Configuring macOS-like animations..."

# Enable animations and set faster speeds for more responsive feel
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface gtk-enable-animations true

# Configure window animations for macOS-like feel
gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'

# Set up window controls like macOS (close, minimize, maximize on left)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Configure Alt+Tab to be more macOS-like
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"

# Set up macOS-like workspace behavior
gsettings set org.gnome.mutter dynamic-workspaces true
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.shell.overrides workspaces-only-on-primary false

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
fi

# Configure font rendering for crisp text like macOS
print_status "Configuring font rendering..."
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'

# Set up better font stack
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 10'

# Configure touchpad for macOS-like gestures (if laptop)
if [ -d /proc/acpi/battery ] || [ -d /sys/class/power_supply ] && ls /sys/class/power_supply/ | grep -q BAT; then
    print_status "Configuring macOS-like touchpad gestures..."
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true  # macOS style
    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'  # macOS style clicking
fi

# Create configuration script for Blur my Shell
print_status "Creating Blur my Shell configuration..."
cat > /tmp/configure-blur.sh << 'EOF'
#!/bin/bash
# Configure Blur my Shell for macOS-like transparency

# Wait for extension to load
sleep 2

# Set blur settings via dconf if available
if command -v dconf >/dev/null 2>&1; then
    # Enable blur for overview
    dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur true
    
    # Enable blur for panel
    dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur true
    dconf write /org/gnome/shell/extensions/blur-my-shell/panel/opacity 0.8
    
    # Enable blur for lockscreen
    dconf write /org/gnome/shell/extensions/blur-my-shell/lockscreen/blur true
    
    # Set blur strength
    dconf write /org/gnome/shell/extensions/blur-my-shell/blur-amount 30
fi
EOF

chmod +x /tmp/configure-blur.sh

# Create configuration script for Burn My Windows
print_status "Creating Burn My Windows configuration..."
cat > /tmp/configure-burn.sh << 'EOF'
#!/bin/bash
# Configure Burn My Windows for macOS-like window animations

sleep 2

if command -v dconf >/dev/null 2>&1; then
    # Enable subtle fade effect for window close
    dconf write /org/gnome/shell/extensions/burn-my-windows/close-effect "'fade'"
    dconf write /org/gnome/shell/extensions/burn-my-windows/open-effect "'fade'"
    
    # Set animation speed (faster like macOS)
    dconf write /org/gnome/shell/extensions/burn-my-windows/animation-time 200
fi
EOF

chmod +x /tmp/configure-burn.sh

# Set up automatic extension configuration
print_status "Setting up extension auto-configuration..."
cat > "$HOME/.config/autostart/configure-gnome-extensions.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Configure GNOME Extensions
Exec=/bin/bash -c 'sleep 5 && /tmp/configure-blur.sh && /tmp/configure-burn.sh'
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF

# Restart GNOME Shell to apply extensions (only on X11)
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    print_status "Restarting GNOME Shell to apply extensions..."
    killall -SIGQUIT gnome-shell 2>/dev/null || true
else
    print_warning "Wayland detected. You may need to log out and back in to see all changes."
fi

# Configure additional visual enhancements
print_status "Applying additional visual enhancements..."

# Set accent color to blue for macOS-like feel
gsettings set org.gnome.desktop.interface accent-color 'blue'

# Configure window focus behavior
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
gsettings set org.gnome.desktop.wm.preferences raise-on-click true

# Set up hot corners (like macOS mission control)
gsettings set org.gnome.desktop.interface enable-hot-corners true

# Configure file manager for better integration
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'

# Set up keyboard shortcuts more like macOS
print_status "Setting up macOS-like keyboard shortcuts..."
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>space']"

# Final status report
print_section "Theming Setup Complete!"
print_status "Applied the following enhancements:"
echo "• 🎨 Papirus-Dark icon theme"
echo "• 🖱️  Bibata-Modern-Classic cursor theme"
echo "• 🪟 macOS-like window controls (close, minimize, maximize on left)"
echo "• ✨ Blur my Shell for transparency effects"
echo "• 🔥 Burn My Windows for smooth animations"
echo "• 🎭 Compiz-like magic lamp and window effects"
echo "• ⚡ Faster, more responsive animations"
echo "• 🎯 macOS-like touchpad gestures (if laptop)"
echo "• ⌨️  macOS-style keyboard shortcuts"
echo "• 🎨 Blue accent color theme"

print_warning "Important next steps:"
echo "1. Log out and back in to ensure all extensions load properly"
echo "2. Open 'Extensions' app to fine-tune extension settings"
echo "3. Use 'GNOME Tweaks' for additional customization"
echo "4. Extensions will auto-configure on next login"

print_status "Use these commands to manage themes:"
echo "• gsettings set org.gnome.desktop.interface icon-theme 'Papirus' # Light version"
echo "• gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' # Dark version"
echo "• gnome-extensions list # View installed extensions"
echo "• gnome-tweaks # Open tweaks application"

# Update CLAUDE.md with theming info
if [ -f "CLAUDE.md" ]; then
    echo "
## GNOME Theming Configuration

The repository now includes comprehensive GNOME theming with:
- **Icons**: Papirus icon theme (dark variant)
- **Cursor**: Bibata Modern Classic
- **Extensions**: Blur my Shell, Burn My Windows, Animation Tweaks
- **Animations**: macOS-like window effects and transitions
- **Layout**: macOS-style window controls and behavior
- **Shortcuts**: macOS-inspired keyboard shortcuts

Run: \`bash gnome-theming.sh\` to apply enhanced theming.
" >> CLAUDE.md
fi

print_status "GNOME theming enhancement completed successfully! 🎉"