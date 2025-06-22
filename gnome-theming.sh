#!/bin/bash

# GNOME Theming Enhancement Script
# Sets up themes, icons, and extensions safely using package manager

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/common-functions.sh" ]; then
    source "$SCRIPT_DIR/common-functions.sh"
    init_log
else
    # Fallback color definitions
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    RED='\033[0;31m'
    NC='\033[0m'
    
    print_success() { echo -e "${GREEN}✓${NC} $1"; }
    print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
    print_error() { echo -e "${RED}✗${NC} $1"; }
    print_header() { echo -e "\n${BLUE}=== $1 ===${NC}"; }
fi

print_header "🎨 GNOME Theming Enhancement"

# Check if running GNOME
if [ "$XDG_CURRENT_DESKTOP" != "ubuntu:GNOME" ] && [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
    print_error "This script is designed for GNOME desktop environment"
    print_warning "Detected: $XDG_CURRENT_DESKTOP"
    exit 1
fi

print_success "GNOME desktop environment detected"

print_header "Installing Theming Tools"

# Install essential theming packages
THEMING_PACKAGES=(
    "gnome-tweaks"
    "gnome-shell-extensions"
    "gnome-shell-extension-manager"
    "chrome-gnome-shell"
    "papirus-icon-theme"
    "fonts-firacode"
)

print_success "Installing theming packages..."
for package in "${THEMING_PACKAGES[@]}"; do
    if dpkg -l "$package" >/dev/null 2>&1; then
        print_success "$package already installed"
    else
        print_success "Installing $package..."
        if sudo apt install -y "$package" >/dev/null 2>&1; then
            print_success "✓ $package installed"
        else
            print_warning "Failed to install $package"
            echo "$(date): Failed to install package: $package" >> /tmp/dotfiles-errors.log
        fi
    fi
done

print_header "Applying GNOME Theme Settings"

# Apply dark theme
print_success "Setting up dark theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Yaru-blue-dark'

# Apply Papirus icons
print_success "Setting Papirus icon theme..."
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# Font settings
print_success "Configuring fonts..."
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Ubuntu Bold 11'

print_header "Configuring GNOME Shell"

# Window controls
print_success "Configuring window controls..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Hot corners
print_success "Enabling hot corners..."
gsettings set org.gnome.desktop.interface enable-hot-corners true

# Animation speed
print_success "Optimizing animation speed..."
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface gtk-enable-animations true

print_header "Dock Configuration"

# Check if dash-to-dock is available and configure it
if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
    print_success "Configuring Dash to Dock..."
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.7
else
    print_warning "Dash to Dock extension not found - skipping dock configuration"
fi

# Clean up dock favorites
print_success "Setting up dock favorites..."
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'org.gnome.TextEditor.desktop']"

print_header "File Manager Configuration"

# Nautilus preferences
print_success "Configuring file manager..."
gsettings set org.gtk.Settings.FileChooser show-hidden true
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view use-tree-view true

print_header "Privacy & Security Settings"

# Privacy settings
print_success "Configuring privacy settings..."
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy recent-files-max-age 1
gsettings set org.gnome.desktop.privacy remove-old-temp-files true
gsettings set org.gnome.desktop.privacy remove-old-trash-files true

print_header "Extensions Information"

print_success "Theming base configuration complete!"
echo ""
print_warning "📦 For additional extensions, use the Extension Manager:"
echo "  • Open 'Extension Manager' from applications"
echo "  • Or visit: https://extensions.gnome.org"
echo ""
echo "🔗 Recommended extensions:"
echo "  • Blur my Shell - For window transparency effects"
echo "  • Burn My Windows - For window animations"
echo "  • User Themes - For custom shell themes"
echo "  • AppIndicator Support - For system tray icons"
echo "  • Vitals - For system monitoring"
echo ""
echo "⚠️  Install extensions through Extension Manager for security"

print_header "Manual Customization Options"

echo "🎨 Additional customization (optional):"
echo ""
echo "1. Open GNOME Tweaks for advanced options:"
echo "   • Appearance → Applications: Yaru-blue-dark"
echo "   • Appearance → Icons: Papirus-Dark"
echo "   • Appearance → Shell: User-themes (if installed)"
echo ""
echo "2. Window Animations:"
echo "   • Install 'Burn My Windows' extension"
echo "   • Configure animation presets in extension settings"
echo ""
echo "3. Blur Effects:"
echo "   • Install 'Blur my Shell' extension" 
echo "   • Enable panel blur and overview blur"
echo ""
echo "4. Custom Wallpapers:"
echo "   • Right-click desktop → Change Background"
echo "   • Or: Settings → Appearance → Background"
echo ""

print_header "✅ GNOME Theming Setup Complete"

print_success "Base theming configuration applied successfully!"
echo ""
print_warning "🔄 Changes that take effect immediately:"
echo "  • Dark theme and Papirus icons"
echo "  • Window controls and dock settings"
echo "  • File manager preferences"
echo ""
print_warning "🔄 Changes requiring logout/restart:"
echo "  • Font changes"
echo "  • Some extension settings"
echo ""
print_success "💡 Next steps:"
echo "  1. Open Extension Manager to install additional extensions"
echo "  2. Use GNOME Tweaks for fine-tuning"
echo "  3. Restart GNOME Shell: Alt+F2, type 'r', press Enter"
echo "  4. Or log out and back in for all changes to take effect"

if command_exists finalize_log; then
    finalize_log "GNOME Theming Setup"
fi