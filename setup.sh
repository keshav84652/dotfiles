#!/bin/bash

# Ubuntu 24.04 LTS Development Setup Script
# Enhanced version with Python 3.11, uv, SSH keys, dotfiles, Zsh, Neovim, and VS Code extensions
# Run with: bash setup.sh (NOT as root)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Check if running as root (we don't want that)
if [ "$EUID" -eq 0 ]; then
    print_error "Please run this script as a regular user (not root/sudo)"
    print_error "The script will ask for sudo when needed"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to add user to group if not already in it
add_user_to_group() {
    if ! groups $USER | grep -q "\b$1\b"; then
        sudo usermod -a -G $1 $USER
        print_status "Added $USER to $1 group"
    fi
}

# Function to check if system is a laptop
is_laptop() {
    [ -d /proc/acpi/battery ] || [ -d /sys/class/power_supply ] && ls /sys/class/power_supply/ | grep -q BAT
}

# Ask for automation level
echo -e "${BLUE}Ubuntu 24.04 LTS Enhanced Setup Script${NC}"
echo "This script will set up your system for development and general desktop use."
echo ""
echo "Choose setup mode:"
echo "1) Fully automated (recommended settings)"
echo "2) Interactive (ask for preferences)"
echo ""
read -p "Enter choice (1 or 2): " SETUP_MODE

# Set defaults based on mode
if [ "$SETUP_MODE" = "1" ]; then
    INSTALL_DEVELOPMENT=true
    INSTALL_DESKTOP_APPS=true
    SETUP_THEMING=true
    SETUP_OPTIMIZATIONS=true
    SETUP_FINGERPRINT=true
    CONFIGURE_SYSTEM=true
    SETUP_SSH=true
    SETUP_DOTFILES=true
    INSTALL_ZSH=true
    INSTALL_NEOVIM=true
    INSTALL_VSCODE_EXTENSIONS=true
else
    echo ""
    read -p "Install development tools (Python 3.11, Node.js, Git, VS Code)? (y/n): " -n 1 -r
    echo ""
    INSTALL_DEVELOPMENT=${REPLY,,}
    
    read -p "Install desktop applications (VLC, Discord, Bitwarden, etc.)? (y/n): " -n 1 -r
    echo ""
    INSTALL_DESKTOP_APPS=${REPLY,,}
    
    read -p "Setup theming and UI tweaks? (y/n): " -n 1 -r
    echo ""
    SETUP_THEMING=${REPLY,,}
    
    read -p "Setup system optimizations (TLP, Zram, performance tweaks)? (y/n): " -n 1 -r
    echo ""
    SETUP_OPTIMIZATIONS=${REPLY,,}
    
    read -p "Setup fingerprint authentication (for ASUS laptops)? (y/n): " -n 1 -r
    echo ""
    SETUP_FINGERPRINT=${REPLY,,}
    
    read -p "Configure system settings (lid close, window controls, etc.)? (y/n): " -n 1 -r
    echo ""
    CONFIGURE_SYSTEM=${REPLY,,}
    
    read -p "Setup SSH keys for Git? (y/n): " -n 1 -r
    echo ""
    SETUP_SSH=${REPLY,,}
    
    read -p "Setup dotfiles? (y/n): " -n 1 -r
    echo ""
    SETUP_DOTFILES=${REPLY,,}
    
    read -p "Install Zsh + Oh My Zsh (modern shell)? (y/n): " -n 1 -r
    echo ""
    INSTALL_ZSH=${REPLY,,}
    
    read -p "Install Neovim (modern Vim)? (y/n): " -n 1 -r
    echo ""
    INSTALL_NEOVIM=${REPLY,,}
    
    read -p "Auto-install VS Code extensions? (y/n): " -n 1 -r
    echo ""
    INSTALL_VSCODE_EXTENSIONS=${REPLY,,}
fi

print_section "System Update"
print_status "Updating package lists and upgrading system..."
sudo apt update && sudo apt upgrade -y

print_section "Installing Essential Packages"
print_status "Installing base development and system tools..."

# Essential packages
ESSENTIAL_PACKAGES=(
    curl
    wget
    build-essential
    tree
    git
    vim
    htop
    unzip
    ca-certificates
    gnupg
    lsb-release
    software-properties-common
    dconf-editor
    preload
    ubuntu-restricted-extras
    xclip
)

sudo apt install -y "${ESSENTIAL_PACKAGES[@]}"

# Zsh Installation
if [[ "$INSTALL_ZSH" == "y" || "$INSTALL_ZSH" == "true" ]]; then
    print_section "Installing Zsh + Oh My Zsh"
    
    if ! command_exists zsh; then
        print_status "Installing Zsh..."
        sudo apt install -y zsh
    fi
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        
        # Install useful plugins
        print_status "Installing Zsh plugins..."
        ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
        
        # zsh-autosuggestions
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        fi
        
        # zsh-syntax-highlighting
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        fi
        
        print_status "Oh My Zsh and plugins installed"
    else
        print_status "Oh My Zsh already installed"
    fi
fi

# Neovim Installation
if [[ "$INSTALL_NEOVIM" == "y" || "$INSTALL_NEOVIM" == "true" ]]; then
    print_section "Installing Neovim"
    
    if ! command_exists nvim; then
        print_status "Installing Neovim..."
        sudo apt install -y neovim
        
        # Set up Neovim as default editor
        sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
        
        print_status "Neovim installed and set as default editor"
    else
        print_status "Neovim already installed"
    fi
fi

# Development Tools Installation
if [[ "$INSTALL_DEVELOPMENT" == "y" || "$INSTALL_DEVELOPMENT" == "true" ]]; then
    print_section "Installing Development Tools"
    
    # Python 3.11 + uv
    print_status "Installing Python 3.11 and uv package manager..."
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils
    
    # Install pip for Python 3.11
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
    
    # Install uv (modern Python package manager)
    python3.11 -m pip install --user uv
    
    # Create python alias (only if not already present)
    BASHRC_ALIAS="alias python=python3.11"
    if ! grep -qF "$BASHRC_ALIAS" ~/.bashrc; then
        echo "$BASHRC_ALIAS" >> ~/.bashrc
        print_status "Added python alias to ~/.bashrc"
    fi
    
    # Node.js via NVM (run in user context)
    print_status "Installing Node.js via NVM..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        # Source NVM immediately to make it available in this session
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        # Install LTS Node.js
        nvm install --lts
        nvm use --lts
        nvm alias default 'lts/*'
        print_status "Node.js $(node --version) installed via NVM"
    fi
    
    # VS Code
    print_status "Installing Visual Studio Code..."
    if ! command_exists code; then
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
        sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install -y code
        rm -f /tmp/packages.microsoft.gpg
    fi
    
    # Docker (basic setup)
    print_status "Installing Docker..."
    if ! command_exists docker; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        add_user_to_group docker
    fi
fi

# VS Code Extensions Installation
if [[ "$INSTALL_VSCODE_EXTENSIONS" == "y" || "$INSTALL_VSCODE_EXTENSIONS" == "true" ]] && command_exists code; then
    print_section "Installing VS Code Extensions"
    
    # Essential extensions
    VSCODE_EXTENSIONS=(
        "ms-python.python"
        "ms-python.vscode-pylance"
        "eamodio.gitlens"
        "esbenp.prettier-vscode"
        "PKief.material-icon-theme"
        "formulahendry.auto-rename-tag"
        "ritwickdey.liveserver"
        "rangav.vscode-thunder-client"
        "ms-vscode.vscode-json"
        "yzhang.markdown-all-in-one"
        "CoenraadS.bracket-pair-colorizer-2"
        "christian-kohler.path-intellisense"
        "ms-azuretools.vscode-docker"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
    )
    
    print_status "Installing essential VS Code extensions..."
    for extension in "${VSCODE_EXTENSIONS[@]}"; do
        if ! code --list-extensions | grep -q "$extension"; then
            print_status "Installing $extension..."
            code --install-extension "$extension" --force
        else
            print_status "$extension already installed"
        fi
    done
    
    print_status "VS Code extensions installation complete"
fi

# Git and SSH Setup
if [[ "$INSTALL_DEVELOPMENT" == "y" || "$INSTALL_DEVELOPMENT" == "true" ]] || [[ "$SETUP_SSH" == "y" || "$SETUP_SSH" == "true" ]]; then
    print_section "Git and SSH Configuration"
    
    # Git configuration
    print_status "Setting up Git configuration..."
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor "$(command -v nvim || command -v vim)"
    git config --global color.ui auto
    
    # SSH Key Generation
    if [[ "$SETUP_SSH" == "y" || "$SETUP_SSH" == "true" ]]; then
        print_status "Setting up SSH keys..."
        SSH_KEY="$HOME/.ssh/id_ed25519"
        if [ ! -f "$SSH_KEY" ]; then
            print_status "Generating SSH key..."
            ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N ''
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_ed25519
            
            print_status "SSH key generated! Public key copied to clipboard:"
            cat ~/.ssh/id_ed25519.pub
            cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
            print_warning "Your public key has been copied to clipboard. Add it to GitHub/GitLab!"
            read -p "Press Enter after you've added the key to your Git service..."
        else
            print_status "SSH key already exists."
        fi
    fi
fi

# Dotfiles Setup
if [[ "$SETUP_DOTFILES" == "y" || "$SETUP_DOTFILES" == "true" ]]; then
    print_section "Dotfiles Setup"
    
    # Check if dotfiles are already installed
    if [ -d "$HOME/dotfiles" ]; then
        print_status "Dotfiles directory already exists. Updating..."
        cd "$HOME/dotfiles"
        git pull origin main || true
        bash install.sh
        cd
    else
        echo "Do you have a dotfiles repository?"
        echo "Recommended: https://github.com/keshav84652/dotfiles"
        read -p "Enter your dotfiles repository URL (or press Enter to skip): " dotfiles_url
        
        if [ -n "$dotfiles_url" ]; then
            print_status "Cloning and installing dotfiles..."
            git clone "$dotfiles_url" "$HOME/dotfiles"
            cd "$HOME/dotfiles"
            
            if [ -f "install.sh" ]; then
                print_status "Running dotfiles install script..."
                bash install.sh
            else
                print_warning "No install.sh found in dotfiles repo. Manually linking common files..."
                for file in .bashrc .zshrc .aliases .gitconfig .vimrc; do
                    if [ -f "$HOME/dotfiles/$file" ]; then
                        # Back up existing file if it exists and is not a symlink
                        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
                            mv "$HOME/$file" "$HOME/${file}.bak"
                            print_status "Backed up existing $file to ${file}.bak"
                        fi
                        ln -sf "$HOME/dotfiles/$file" "$HOME/$file"
                        print_status "Linked $file"
                    fi
                done
                
                # Neovim config
                if [ -f "$HOME/dotfiles/.config/nvim/init.vim" ]; then
                    mkdir -p "$HOME/.config/nvim"
                    if [ -f "$HOME/.config/nvim/init.vim" ] && [ ! -L "$HOME/.config/nvim/init.vim" ]; then
                        mv "$HOME/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim.bak"
                        print_status "Backed up existing Neovim config"
                    fi
                    ln -sf "$HOME/dotfiles/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim"
                    print_status "Linked Neovim config"
                fi
            fi
            cd
        else
            print_status "Skipping dotfiles setup."
        fi
    fi
fi

# Desktop Applications
if [[ "$INSTALL_DESKTOP_APPS" == "y" || "$INSTALL_DESKTOP_APPS" == "true" ]]; then
    print_section "Installing Desktop Applications"
    
    # Flatpak setup
    print_status "Setting up Flatpak..."
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Flameshot (screenshot tool)
    print_status "Installing Flameshot..."
    sudo apt install -y flameshot
    
    # CopyQ (clipboard manager)
    print_status "Installing CopyQ..."
    sudo apt install -y copyq
    
    # VLC
    print_status "Installing VLC..."
    sudo apt install -y vlc
    
    # Stacer (system optimizer)
    print_status "Installing Stacer..."
    if ! command_exists stacer; then
        wget -O /tmp/stacer.deb https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb
        sudo dpkg -i /tmp/stacer.deb
        sudo apt-get install -f -y
        rm -f /tmp/stacer.deb
    fi
    
    # TeamViewer
    print_status "Installing TeamViewer..."
    if ! command_exists teamviewer; then
        wget -O /tmp/teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
        sudo dpkg -i /tmp/teamviewer.deb
        sudo apt-get install -f -y
        rm -f /tmp/teamviewer.deb
    fi
    
    # Discord
    print_status "Installing Discord..."
    if ! snap list | grep -q discord 2>/dev/null; then
        sudo snap install discord
    fi
    
    # Bitwarden
    print_status "Installing Bitwarden..."
    if ! snap list | grep -q bitwarden 2>/dev/null; then
        sudo snap install bitwarden
    fi
    
    # Google Chrome (using modern method)
    print_status "Installing Google Chrome..."
    if ! command_exists google-chrome; then
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
        sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb
        rm -f /tmp/google-chrome-stable_current_amd64.deb
    fi
fi

# System Optimizations
if [[ "$SETUP_OPTIMIZATIONS" == "y" || "$SETUP_OPTIMIZATIONS" == "true" ]]; then
    print_section "Setting up System Optimizations"
    
    # TLP for battery optimization (only on laptops)
    if is_laptop; then
        print_status "Installing TLP for battery optimization (laptop detected)..."
        sudo apt install -y tlp tlp-rdw
        sudo systemctl enable tlp
    else
        print_status "Desktop detected - skipping TLP battery optimization"
    fi
    
    # Zram for better memory management
    print_status "Setting up Zram..."
    sudo apt install -y zram-config
    
    # Firewall setup
    print_status "Setting up UFW firewall..."
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    
    # Disable unnecessary services
    print_status "Optimizing system services..."
    sudo systemctl disable cups-browsed.service 2>/dev/null || true
    sudo systemctl disable ModemManager.service 2>/dev/null || true
fi

# Fingerprint Authentication
if [[ "$SETUP_FINGERPRINT" == "y" || "$SETUP_FINGERPRINT" == "true" ]]; then
    print_section "Setting up Fingerprint Authentication"
    if is_laptop; then
        print_status "Installing fingerprint packages (laptop detected)..."
        sudo apt install -y fprintd libpam-fprintd
        print_status "Fingerprint setup complete. Run 'fprintd-enroll' to enroll your fingerprint."
    else
        print_status "Desktop detected - skipping fingerprint authentication setup"
    fi
fi

# System Configuration
if [[ "$CONFIGURE_SYSTEM" == "y" || "$CONFIGURE_SYSTEM" == "true" ]]; then
    print_section "Configuring System Settings"
    
    # Lid close action (don't suspend) - only on laptops
    if is_laptop; then
        print_status "Configuring lid close action..."
        sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
        sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
    fi
    
    # Remove unwanted applications from favorites
    print_status "Cleaning up dock favorites..."
    gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'code.desktop']"
    
    # Configure window buttons (close button accessible)
    print_status "Configuring window controls..."
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
    
    # Faster animations
    print_status "Speeding up animations..."
    gsettings set org.gnome.desktop.interface enable-animations true
    gsettings set org.gnome.desktop.interface gtk-enable-animations true
    
    # Show hidden files in file manager
    print_status "Configuring file manager..."
    gsettings set org.gtk.Settings.FileChooser show-hidden true
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    
    # Better Alt+Tab behavior
    print_status "Configuring Alt+Tab..."
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    
    # Touchpad gestures (if laptop)
    if is_laptop; then
        print_status "Enabling touchpad gestures..."
        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
        gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
        gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    fi
fi

# Theming Setup
if [[ "$SETUP_THEMING" == "y" || "$SETUP_THEMING" == "true" ]]; then
    print_section "Setting up Theming"
    
    # Install GNOME Tweaks and extensions
    print_status "Installing GNOME Tweaks and extensions..."
    sudo apt install -y gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager chrome-gnome-shell
    
    # Install additional themes
    print_status "Installing additional themes..."
    sudo apt install -y yaru-theme-gnome yaru-theme-gtk yaru-theme-icon yaru-theme-sound
    
    # Set dark theme
    print_status "Setting up dark theme..."
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    # Install better fonts for coding
    print_status "Installing coding fonts..."
    sudo apt install -y fonts-firacode
    
    print_status "Theming setup complete. Use GNOME Tweaks for further customization."
fi

# Cleanup
print_section "Cleanup"
print_status "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# Final setup
print_section "Final Setup"

# Set up keyboard shortcuts
print_status "Setting up keyboard shortcuts..."
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "['<Super>Print']"
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot "['<Shift><Super>s']"

# Enable preload for faster app startup
print_status "Enabling preload for faster app startup..."
sudo systemctl enable preload

# Change default shell to Zsh if installed
if [[ "$INSTALL_ZSH" == "y" || "$INSTALL_ZSH" == "true" ]] && command_exists zsh; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_status "Changing default shell to Zsh..."
        chsh -s $(which zsh)
        print_warning "Default shell changed to Zsh. You'll need to log out and back in for this to take effect."
    fi
fi

print_section "Setup Complete!"
print_status "Your Ubuntu 24.04 LTS system has been configured for development and desktop use."
echo ""
echo -e "${GREEN}Installed applications:${NC}"
echo "• Development: Git, Python 3.11 + uv, Node.js (via NVM), VS Code, Docker"
if [[ "$INSTALL_NEOVIM" == "y" || "$INSTALL_NEOVIM" == "true" ]]; then
    echo "• Editors: Vim, Neovim (with config)"
fi
if [[ "$INSTALL_ZSH" == "y" || "$INSTALL_ZSH" == "true" ]]; then
    echo "• Shell: Zsh + Oh My Zsh with plugins"
fi
echo "• Desktop: VLC, Discord, Bitwarden, Chrome, Flameshot, CopyQ, Stacer, TeamViewer"
if is_laptop; then
    echo "• System: TLP (battery), Zram, UFW firewall"
else
    echo "• System: Zram, UFW firewall"
fi
echo "• SSH keys generated and ready for Git services"
if [[ "$INSTALL_VSCODE_EXTENSIONS" == "y" || "$INSTALL_VSCODE_EXTENSIONS" == "true" ]]; then
    echo "• VS Code extensions installed automatically"
fi
echo ""
echo -e "${YELLOW}Important notes:${NC}"
echo "• Restart your system to apply all changes"
if [[ "$INSTALL_ZSH" == "y" || "$INSTALL_ZSH" == "true" ]]; then
    echo "• Log out and back in to use Zsh as default shell, or run 'exec zsh' to try it now"
fi
echo "• Run 'source ~/.bashrc' (or ~/.zshrc) or restart terminal for aliases to work"
echo "• Your SSH public key was copied to clipboard - add it to GitHub/GitLab"
echo "• Run 'fprintd-enroll' to set up fingerprint authentication (if laptop)"
echo "• Docker requires logout/login for group permissions"
echo "• Use GNOME Tweaks for additional customization"
if is_laptop; then
    echo "• TLP installed for battery optimization"
fi
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo "• 'nvm install node' - Install latest Node.js"
echo "• 'nvm use node' - Switch to installed Node.js version"
echo "• 'uv pip install package' - Install Python packages with uv"
if [[ "$INSTALL_NEOVIM" == "y" || "$INSTALL_NEOVIM" == "true" ]]; then
    echo "• 'nvim' - Launch Neovim editor"
fi
if is_laptop; then
    echo "• 'tlp-stat' - Check TLP battery optimization status"
fi
echo "• 'stacer' - Launch system optimizer"
echo "• 'flameshot gui' - Take screenshot with annotations"
echo "• 'copyq' - Launch clipboard manager"
if [[ "$INSTALL_ZSH" == "y" || "$INSTALL_ZSH" == "true" ]]; then
    echo "• Type command and press TAB for Zsh autocompletion"
fi
echo ""
print_warning "Please restart your system to ensure all changes take effect!"