#!/bin/bash

# Enhanced Dotfiles Installation Script
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Functions for colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Detect current shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        # Fallback to user's default shell
        basename "$SHELL"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_header "🚀 Enhanced Dotfiles Installation"
echo "This script will install and configure your development environment."
echo ""

# Detect environment
CURRENT_SHELL=$(detect_shell)
print_info "Detected shell: $CURRENT_SHELL"

# Create backup directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_info "Backup directory: $BACKUP_DIR"

# Files to install based on shell
if [ "$CURRENT_SHELL" = "zsh" ]; then
    SHELL_CONFIG=".zshrc"
    print_info "Installing Zsh configuration"
else
    SHELL_CONFIG=".bashrc"
    print_info "Installing Bash configuration"
fi

# List of dotfiles to install
DOTFILES=(
    "$SHELL_CONFIG"
    ".aliases"
    ".gitconfig"
    ".vimrc"
)

print_header "📁 Installing Configuration Files"

# Install dotfiles
for file in "${DOTFILES[@]}"; do
    if [ -f "$file" ]; then
        # Backup existing file if it exists and is not a symlink
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            cp "$HOME/$file" "$BACKUP_DIR/"
            print_warning "Backed up existing $file"
        fi
        
        # Create symlink
        ln -sf "$PWD/$file" "$HOME/$file"
        print_success "Installed $file"
    else
        print_warning "$file not found, skipping"
    fi
done

# Install global gitignore
if [ -f ".gitignore_global" ]; then
    if [ -f "$HOME/.gitignore_global" ] && [ ! -L "$HOME/.gitignore_global" ]; then
        cp "$HOME/.gitignore_global" "$BACKUP_DIR/"
        print_warning "Backed up existing .gitignore_global"
    fi
    
    ln -sf "$PWD/.gitignore_global" "$HOME/.gitignore_global"
    git config --global core.excludesfile ~/.gitignore_global
    print_success "Installed global gitignore"
fi

# Install Neovim config if Neovim is installed
if command_exists nvim; then
    print_header "📝 Setting up Neovim"
    mkdir -p "$HOME/.config/nvim"
    
    if [ -f ".config/nvim/init.vim" ]; then
        if [ -f "$HOME/.config/nvim/init.vim" ] && [ ! -L "$HOME/.config/nvim/init.vim" ]; then
            cp "$HOME/.config/nvim/init.vim" "$BACKUP_DIR/"
            print_warning "Backed up existing Neovim config"
        fi
        
        ln -sf "$PWD/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim"
        print_success "Installed Neovim configuration"
    fi
else
    print_info "Neovim not found, skipping Neovim config"
fi

# Install VS Code extensions if VS Code is installed
if command_exists code; then
    print_header "🔧 Installing VS Code Extensions"
    
    if [ -f "vscode-extensions.txt" ]; then
        print_info "Installing VS Code extensions..."
        
        # Read extensions and install them
        while IFS= read -r extension; do
            # Skip comments and empty lines
            if [[ ! "$extension" =~ ^#.*$ ]] && [[ -n "$extension" ]]; then
                if code --list-extensions | grep -q "$extension"; then
                    print_info "$extension already installed"
                else
                    print_info "Installing $extension..."
                    code --install-extension "$extension" --force
                fi
            fi
        done < vscode-extensions.txt
        
        print_success "VS Code extensions installation complete"
    else
        print_warning "vscode-extensions.txt not found"
    fi
else
    print_info "VS Code not found, skipping extension installation"
fi

# Zsh specific setup
if [ "$CURRENT_SHELL" = "zsh" ]; then
    print_header "🐚 Zsh Enhancement Setup"
    
    # Check for Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh My Zsh not found. Install it with:"
        echo "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    else
        print_success "Oh My Zsh already installed"
        
        # Install useful plugins
        ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
        
        # zsh-autosuggestions
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
            print_info "Installing zsh-autosuggestions..."
            git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
            print_success "zsh-autosuggestions installed"
        fi
        
        # zsh-syntax-highlighting
        if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
            print_info "Installing zsh-syntax-highlighting..."
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
            print_success "zsh-syntax-highlighting installed"
        fi
    fi
fi

# Create necessary directories
print_header "📂 Setting up Directories"

# Vim undo directory
if [ ! -d "$HOME/.vim/undo" ]; then
    mkdir -p "$HOME/.vim/undo"
    print_success "Created Vim undo directory"
fi

# Development directories
DEV_DIRS=("$HOME/Projects" "$HOME/Scripts" "$HOME/.local/bin")
for dir in "${DEV_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_success "Created $dir"
    fi
done

print_header "🎉 Installation Complete!"
print_success "Dotfiles have been installed successfully"
echo ""
print_info "Backup created in: $BACKUP_DIR"
print_info "Current shell: $CURRENT_SHELL"
echo ""
print_warning "To apply changes, run one of the following:"
if [ "$CURRENT_SHELL" = "zsh" ]; then
    echo "  source ~/.zshrc"
    echo "  exec zsh"
else
    echo "  source ~/.bashrc"
    echo "  exec bash"
fi
echo ""
print_info "Useful next steps:"
echo "  • Install Oh My Zsh (if using Zsh): sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
echo "  • Install vim-plug for Neovim: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
echo "  • Restart your terminal or run 'exec \$SHELL' to reload configuration"
echo ""
print_success "Happy coding! 🚀"