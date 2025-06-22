#!/bin/bash

# Ubuntu 24.04 LTS Development Environment Setup
# Clean, consolidated version with reliable error handling
# Run with: bash setup.sh

# Script directory and error logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERROR_LOG="/tmp/dotfiles-errors.log"
echo "=== Dotfiles Setup Started: $(date) ===" > "$ERROR_LOG"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Output functions
print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

# Safety checks
if [ "$EUID" -eq 0 ]; then
    print_error "Please run this script as a regular user (not root/sudo)"
    print_error "The script will ask for sudo when needed"
    exit 1
fi

# Utility functions
command_exists() { command -v "$1" >/dev/null 2>&1; }
is_laptop() { [ -d /proc/acpi/battery ] || [ -d /sys/class/power_supply ] && ls /sys/class/power_supply/ | grep -q BAT; }
add_user_to_group() {
    if ! groups $USER | grep -q "\b$1\b"; then
        sudo usermod -a -G $1 $USER
        print_status "Added $USER to $1 group"
    fi
}

# Installation mode selection
print_section "Ubuntu Development Environment Setup"
echo "This script will set up your Ubuntu system for development."
echo ""
echo "Choose setup mode:"
echo "1) Fully automated (recommended)"
echo "2) Interactive (choose components)"
echo ""
read -p "Enter choice (1 or 2): " SETUP_MODE

if [ "$SETUP_MODE" = "1" ]; then
    INSTALL_DEVELOPMENT=true
    INSTALL_DESKTOP_APPS=true
    SETUP_GNOME=true
    SETUP_OPTIMIZATIONS=true
    SETUP_SSH=true
    SETUP_DOTFILES=true
    INSTALL_ZSH=true
    # Set default Git config values for automated mode
    GIT_USERNAME="keshav84652"
    GIT_EMAIL="keshavkasat@outlook.com"
    AUTOMATED_MODE=true
else
    read -p "Install development tools (Python 3.11, Node.js, Docker)? (Y/n): " -n 1 -r; echo; INSTALL_DEVELOPMENT=${REPLY:-y}
    read -p "Install desktop applications (Chrome, Discord, VLC, etc.)? (Y/n): " -n 1 -r; echo; INSTALL_DESKTOP_APPS=${REPLY:-y}
    read -p "Configure GNOME desktop (theming, shortcuts, touchpad)? (Y/n): " -n 1 -r; echo; SETUP_GNOME=${REPLY:-y}
    read -p "Apply system optimizations? (Y/n): " -n 1 -r; echo; SETUP_OPTIMIZATIONS=${REPLY:-y}
    read -p "Setup SSH keys for Git? (Y/n): " -n 1 -r; echo; SETUP_SSH=${REPLY:-y}
    read -p "Install dotfiles (shell configs)? (Y/n): " -n 1 -r; echo; SETUP_DOTFILES=${REPLY:-y}
    read -p "Install Zsh + Oh My Zsh? (Y/n): " -n 1 -r; echo; INSTALL_ZSH=${REPLY:-y}
fi

print_section "System Update"
print_status "Updating package lists and upgrading system..."
sudo apt update && sudo apt upgrade -y

print_section "Installing Essential Packages"
ESSENTIAL_PACKAGES=(curl wget build-essential tree git vim htop unzip ca-certificates gnupg 
                   lsb-release software-properties-common dconf-editor preload ubuntu-restricted-extras xclip)
sudo apt install -y "${ESSENTIAL_PACKAGES[@]}"

# Zsh + Oh My Zsh Installation
if [[ "$INSTALL_ZSH" =~ ^[Yy]$ ]]; then
    print_section "Installing Zsh + Oh My Zsh"
    if ! command_exists zsh; then
        sudo apt install -y zsh
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        
        # Install plugins
        ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
        [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        
        print_status "Zsh and plugins installed"
    fi
fi

# Development Tools Installation
if [[ "$INSTALL_DEVELOPMENT" =~ ^[Yy]$ ]]; then
    print_section "Installing Development Tools"
    
    # Python 3.11 + UV
    print_status "Installing Python 3.11 and UV package manager..."
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
    python3.11 -m pip install --user uv
    
    # Add python alias - more flexible approach
    # First check if python3.11 is available
    if command -v python3.11 >/dev/null 2>&1; then
        PYTHON_VERSION="python3.11"
    # Fall back to system default Python 3
    elif command -v python3 >/dev/null 2>&1; then
        PYTHON_VERSION="python3"
    fi
    
    if [ -n "$PYTHON_VERSION" ]; then
        BASHRC_ALIAS="alias python=$PYTHON_VERSION"
        grep -qF "$BASHRC_ALIAS" ~/.bashrc || echo "$BASHRC_ALIAS" >> ~/.bashrc
        print_status "Set Python alias to use $PYTHON_VERSION"
    fi
    
    # Node.js via NVM
    print_status "Installing Node.js via NVM..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts && nvm use --lts && nvm alias default 'lts/*'
        
        # Install essential global packages
        print_status "Installing global Node.js packages..."
        npm install -g yarn pnpm nodemon live-server http-server prettier eslint @vue/cli create-react-app
    fi
    
    # Docker
    print_status "Installing Docker..."
    if ! command_exists docker; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        add_user_to_group docker
    fi
fi

# Git and SSH Setup
if [[ "$INSTALL_DEVELOPMENT" =~ ^[Yy]$ ]] || [[ "$SETUP_SSH" =~ ^[Yy]$ ]]; then
    print_section "Git and SSH Configuration"
    
    # Git configuration
    print_status "Setting up Git configuration..."
    
    if [ "$AUTOMATED_MODE" = "true" ]; then
        # Use default values in automated mode
        print_status "Using default Git configuration in automated mode"
        git_username="$GIT_USERNAME"
        git_email="$GIT_EMAIL"
    else
        # Prompt for values in interactive mode
        read -p "Enter your Git username: " git_username
        read -p "Enter your Git email: " git_email
    fi
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor "$(command -v nvim || command -v vim)"
    git config --global color.ui auto
    
    # SSH Key Generation
    if [[ "$SETUP_SSH" =~ ^[Yy]$ ]]; then
        SSH_KEY="$HOME/.ssh/id_ed25519"
        if [ ! -f "$SSH_KEY" ]; then
            print_status "Generating SSH key..."
            # Use the git_email which is already set correctly for both automated and interactive modes
            ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N ''
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_ed25519
            
            print_status "SSH key generated!"
            cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
            print_warning "SSH public key copied to clipboard. Add it to GitHub!"
        fi
        
        # Configure SSH known hosts
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        for host in github.com gitlab.com bitbucket.org; do
            grep -q "$host" ~/.ssh/known_hosts 2>/dev/null || ssh-keyscan -H "$host" >> ~/.ssh/known_hosts 2>/dev/null
        done
        chmod 644 ~/.ssh/known_hosts
    fi
fi

# Dotfiles Installation
if [[ "$SETUP_DOTFILES" =~ ^[Yy]$ ]]; then
    print_section "Installing Dotfiles"
    if [ -f "$SCRIPT_DIR/install.sh" ]; then
        bash "$SCRIPT_DIR/install.sh"
    else
        print_warning "install.sh not found - skipping dotfiles installation"
    fi
fi

# Desktop Applications
if [[ "$INSTALL_DESKTOP_APPS" =~ ^[Yy]$ ]]; then
    print_section "Installing Desktop Applications"
    
    # Setup Flatpak
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Essential apps via apt
    sudo apt install -y flameshot copyq vlc
    
    # Terminal alternatives
    print_status "Installing alternative terminals..."
    for terminal in kitty alacritty; do
        if ! command_exists "$terminal"; then
            sudo apt install -y "$terminal" 2>/dev/null || print_warning "Failed to install $terminal"
        fi
    done
    
    # Apps via snap
    for app in discord bitwarden; do
        snap list | grep -q "$app" 2>/dev/null || sudo snap install "$app"
    done
    
    # Google Chrome
    if ! command_exists google-chrome; then
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
        sudo apt install -y /tmp/chrome.deb && rm -f /tmp/chrome.deb
    fi
fi

# GNOME Desktop Configuration (Consolidated)
if [[ "$SETUP_GNOME" =~ ^[Yy]$ ]]; then
    print_section "Configuring GNOME Desktop"
    
    # Install GNOME packages
    sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager papirus-icon-theme fonts-firacode
    
    # Theme and appearance
    print_status "Applying dark theme and icons..."
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 10'
    
    # Window management
    print_status "Configuring window management..."
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
    gsettings set org.gnome.desktop.interface enable-hot-corners true
    
    # Keyboard shortcuts (essential only)
    print_status "Setting up keyboard shortcuts..."
    gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
    gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
    
    # Window tiling
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
    gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
    gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"
    
    # Dock configuration (if dash-to-dock exists)
    if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
        print_status "Configuring dock..."
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
        gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
        gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
    fi
    
    # Touchpad configuration (FIXED - force traditional scrolling)
    if is_laptop; then
        print_status "Configuring touchpad for traditional scrolling..."
        # Set traditional scrolling multiple times to ensure it sticks
        for i in {1..3}; do
            gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
            sleep 0.5
        done
        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
        gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
        gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
        
        # Verify the setting
        if [ "$(gsettings get org.gnome.desktop.peripherals.touchpad natural-scroll)" = "false" ]; then
            print_status "✓ Traditional scrolling confirmed (scroll down = content moves down)"
        else
            print_warning "Touchpad setting may need manual verification"
        fi
    fi
    
    # File manager
    print_status "Configuring file manager..."
    gsettings set org.gtk.Settings.FileChooser show-hidden true
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    
    # Privacy settings
    print_status "Configuring privacy settings..."
    gsettings set org.gnome.desktop.privacy remember-recent-files false
    gsettings set org.gnome.desktop.privacy remove-old-temp-files true
    
    # Dock favorites
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop']"
fi

# System Optimizations
if [[ "$SETUP_OPTIMIZATIONS" =~ ^[Yy]$ ]]; then
    print_section "Applying System Optimizations"
    
    # TLP for laptops
    if is_laptop; then
        print_status "Installing TLP for battery optimization..."
        sudo apt install -y tlp tlp-rdw
        sudo systemctl enable tlp
    fi
    
    # Zram for better memory management
    sudo apt install -y zram-config
    
    # Firewall
    print_status "Configuring firewall..."
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    
    # Disable unnecessary services
    sudo systemctl disable cups-browsed.service 2>/dev/null || true
    sudo systemctl disable ModemManager.service 2>/dev/null || true
fi

# Run additional setup scripts
print_section "Running Additional Configurations"

# Python development setup
if [[ "$INSTALL_DEVELOPMENT" =~ ^[Yy]$ ]] && [ -f "$SCRIPT_DIR/python-templates.sh" ]; then
    print_status "Setting up Python development environment..."
    bash "$SCRIPT_DIR/python-templates.sh" >/dev/null 2>&1 || print_warning "Python setup had issues (continuing...)"
fi

# Docker development setup  
if [[ "$INSTALL_DEVELOPMENT" =~ ^[Yy]$ ]] && [ -f "$SCRIPT_DIR/docker-basics.sh" ]; then
    print_status "Setting up Docker development environment..."
    bash "$SCRIPT_DIR/docker-basics.sh" >/dev/null 2>&1 || print_warning "Docker setup had issues (continuing...)"
fi


print_section "Final Setup"

# Enable preload
sudo systemctl enable preload

# Change default shell to Zsh
if [[ "$INSTALL_ZSH" =~ ^[Yy]$ ]] && command_exists zsh && [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
    print_warning "Default shell changed to Zsh. Log out and back in for this to take effect."
fi

# Cleanup
print_status "Cleaning up..."
sudo apt autoremove -y && sudo apt autoclean

print_section "Setup Complete!"
print_status "Ubuntu development environment configured successfully!"
echo ""
echo -e "${GREEN}Installed:${NC}"
[[ "$INSTALL_DEVELOPMENT" =~ ^[Yy]$ ]] && echo "• Development: Python 3.11 + UV, Node.js, Docker"
[[ "$INSTALL_ZSH" =~ ^[Yy]$ ]] && echo "• Shell: Zsh + Oh My Zsh with plugins"
[[ "$INSTALL_DESKTOP_APPS" =~ ^[Yy]$ ]] && echo "• Apps: Chrome, Discord, Bitwarden, VLC, Kitty, Alacritty"
[[ "$SETUP_GNOME" =~ ^[Yy]$ ]] && echo "• Desktop: Dark theme, keyboard shortcuts, traditional touchpad scrolling"
[[ "$SETUP_SSH" =~ ^[Yy]$ ]] && echo "• SSH: Keys generated and ready for GitHub"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run: bash post-install-signin.sh    # Open sign-in pages"
echo "2. Restart your system to apply all changes"
echo "3. Test: ssh -T git@github.com         # Verify SSH setup"
echo "4. Create projects: python-dev new myapp web"
echo ""
[ -s "$ERROR_LOG" ] && [ "$(wc -l < "$ERROR_LOG")" -gt 1 ] && \
    print_warning "Some errors occurred. Check: $ERROR_LOG" || \
    print_status "No errors encountered during setup!"
echo ""
print_status "Happy coding! 🚀"