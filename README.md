# Ubuntu 24.04 Development Environment Setup 🚀

Clean, reliable Ubuntu development environment setup with essential tools, applications, and GNOME theming.

## 🚀 Quick Start

**Fresh Ubuntu 24.04 installation? Run this one command:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/keshav84652/dotfiles/main/setup.sh)
```

**Or clone and run:**

```bash
git clone https://github.com/keshav84652/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

Choose option `1` for fully automated setup, then enter your password when prompted.

## 📦 What Gets Installed

### Essential Applications
- **Development Tools**: Python 3.11 + UV, Node.js (via NVM), Docker
- **Desktop Apps**: Google Chrome, Discord, Bitwarden, VLC, Flameshot, CopyQ
- **Terminal Options**: GNOME Terminal (default), Kitty, Alacritty

### Shell & Terminal
- **Zsh + Oh My Zsh** with plugins (syntax highlighting, autosuggestions)
- **Enhanced shell configs** with useful aliases and optimizations
- **Multiple terminal emulators** for different preferences

### GNOME Desktop Configuration
- **Dark theme** with Yaru-blue styling
- **Papirus icon theme** (dark variant)
- **Essential keyboard shortcuts** (Super+D, Super+E, etc.)
- **Traditional touchpad scrolling** (laptop-friendly)
- **Privacy-focused settings** and clean dock

### Development Environment
- **Git configuration** with SSH keys and seamless authentication
- **Docker development stack** (PostgreSQL, Redis, Nginx examples)
- **Python project templates** with UV package manager
- **Performance optimizations** and developer shortcuts
- **VS Code Settings Sync ready** (no extensions auto-installed)

## ⏱️ Installation Time

- **Full setup**: ~10-15 minutes
- **Download size**: ~1.5-2 GB (applications, themes)
- **Disk space**: ~4-5 GB after installation

## 🎛️ Installation Options

The setup script offers two modes:

1. **Fully Automated** (recommended) - Installs everything with sensible defaults
2. **Interactive** - Choose what to install (development tools, applications, theming, etc.)

## 🔧 What Happens During Installation

1. **System Update** - Updates packages and upgrades system
2. **Essential Packages** - Installs build tools, curl, wget, git, etc.
3. **Shell Setup** - Zsh + Oh My Zsh with plugins and enhanced configs
4. **Development Tools** - Python 3.11 + UV, Node.js (via NVM), Docker
5. **Desktop Applications** - Chrome, Discord, Bitwarden, VLC, terminals (Kitty, Alacritty)
6. **Git & SSH Setup** - Git configuration and SSH key generation
7. **Dotfiles Installation** - Symlinks shell configs and development tools
8. **GNOME Configuration** - Dark theme, Papirus icons, keyboard shortcuts, traditional touchpad scrolling
9. **System Optimization** - Performance tweaks, firewall, cleanup
10. **Post-Install Helper** - Browser sign-in pages via `post-install-signin.sh`

## ✨ Key Features

### Enhanced Terminal Experience
- **Multiple terminal options** - GNOME Terminal, Kitty, Alacritty installed
- **Zsh with Oh My Zsh** - Modern shell with autocompletion and syntax highlighting
- **Smart aliases** - `gs` (git status), `ll` (detailed listing), `..` (go up)
- **NVM integration** - Node.js version management built-in
- **Git integration** - Branch info in prompt, better git colors

### Beautiful Desktop
- **Dark theme** with Yaru-blue styling and Papirus icons
- **Privacy-focused** - Enhanced privacy and security settings
- **Extension Manager** - Safe extension installation via package manager
- **Auto-hide dock** - Clean, minimal desktop layout
- **Traditional scrolling** - Touchpad configured for familiar scroll behavior

### Developer-Focused
- **VS Code Settings Sync ready** - No extensions auto-installed (user preference)
- **Docker development stack** - PostgreSQL, Redis, Nginx examples with utilities
- **Python 3.11 + UV** - Modern Python with UV package manager
- **Python project templates** - Flask, FastAPI, data science templates
- **Git optimized** - SSH keys, seamless authentication, useful aliases

## 🛠️ System Requirements

- **Ubuntu 20.04+** (tested on 22.04 and 24.04)
- **Internet connection** for downloads
- **2GB+ free disk space**
- **Regular user account** (not root)
- **GNOME desktop environment**

## 🛠️ What the installer does:

1. **Detects your shell** (Bash/Zsh) and installs appropriate configs
2. **Backs up existing dotfiles** to `~/dotfiles_backup_TIMESTAMP`
3. **Creates symlinks** to keep configs in sync with the repo
4. **Installs VS Code extensions** (if VS Code is detected)
5. **Sets up Neovim config** (if Neovim is installed)
6. **Installs Zsh plugins** (if Oh My Zsh is available)

## 🎨 Features

### Shell Enhancements
- **Smart aliases** for git, navigation, and development
- **Colorized output** for ls, grep, and git commands
- **Enhanced history** with better search and deduplication
- **Custom prompt** with git branch info (Zsh) or clean colored prompt (Bash)
- **NVM integration** for Node.js version management

### Development Tools
- **Git shortcuts** and better diff colors
- **Python/pip aliases** for easier package management
- **Quick server** alias for local development
- **Network utilities** (IP check, port listing)

### Editor Improvements
- **Syntax highlighting** and line numbers
- **Smart indentation** and better search
- **Clipboard integration** between system and editor
- **Modern defaults** for both Vim and Neovim

## 🔄 VS Code Configuration

**Settings Sync Approach:**
- **No extensions auto-installed** - Use VS Code Settings Sync instead
- **Manual extension management** - Install what you need through VS Code
- **Sync across devices** - Enable Settings Sync in VS Code for consistent setup
- **Post-install helper** - Opens VS Code for easy sync setup

**Why this approach?**
- More reliable than automated extension installation
- Respects user preferences and existing VS Code setup
- Avoids extension conflicts and installation failures
- Easier to maintain and customize

## 🔧 Manual Setup (Alternative)

If you prefer manual installation:

```bash
# Copy files to home directory
cp .bashrc ~/.bashrc          # For Bash users
cp .zshrc ~/.zshrc            # For Zsh users  
cp .aliases ~/.aliases        # Shared aliases
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc

# Create Neovim config directory
mkdir -p ~/.config/nvim
cp .config/nvim/init.vim ~/.config/nvim/

# Reload shell
source ~/.bashrc    # or source ~/.zshrc
```

## 🎯 Usage Tips

### Useful Aliases
```bash
ll          # Detailed file listing
gs          # Git status
ga .        # Git add all
gc "msg"    # Git commit with message
gp          # Git push
gl          # Git log (pretty)
..          # Go up one directory
...         # Go up two directories
serve       # Start local Python server
myip        # Show external IP
```

### Zsh Features (if using Zsh)
- **Tab completion** with menu selection
- **Git branch** shown in prompt
- **Syntax highlighting** for commands
- **Auto-suggestions** based on history

### Development Utilities
```bash
# Python development with UV
python-dev new myapp web    # Create Flask web app
python-dev new api api      # Create FastAPI app
python-dev add requests     # Add Python package
python-dev test            # Run tests
python-dev fmt             # Format code

# Docker development
docker-dev start           # Start dev stack (PostgreSQL, Redis, Nginx)
docker-dev postgres        # Connect to PostgreSQL
docker-dev redis           # Connect to Redis
docker-dev stop            # Stop all services

# Post-installation
post-install-signin.sh     # Open sign-in pages in browsers
```

## 🔄 Keeping Updated

Since the installer creates symlinks, you can update your configs by:

```bash
cd ~/dotfiles
git pull
```

Changes will be reflected immediately!

Or use the update script:
```bash
cd ~/dotfiles
bash scripts/update-dotfiles.sh
```

## 🛡️ Backup & Recovery

The installer automatically backs up your existing dotfiles. To restore:

```bash
# Find your backup
ls ~/dotfiles_backup_*

# Restore specific file
cp ~/dotfiles_backup_*/OLD_FILE ~/
```

You can also create manual backups:
```bash
bash scripts/backup-dotfiles.sh
```

## 🖥️ Terminal Recommendations

The setup installs multiple terminal emulators. Choose based on your needs:

### **GNOME Terminal** (Default)
- **Best for**: General use, beginners, system integration
- **Features**: Good GNOME integration, reliable, easy configuration
- **Use when**: You want something that "just works"

### **Kitty** 
- **Best for**: Power users, GPU acceleration enthusiasts
- **Features**: GPU-accelerated rendering, advanced features, highly configurable
- **Use when**: You want the fastest rendering and advanced terminal features

### **Alacritty**
- **Best for**: Minimalists, performance-focused users
- **Features**: Extremely fast, minimal, YAML configuration
- **Use when**: You want maximum speed with minimal resource usage

### **Warp** (If Already Installed)
- **Best for**: Modern developers, AI-assisted workflows
- **Features**: Built-in AI, modern UI, collaborative features
- **Note**: Enable "Honor user color scheme" in settings for dark mode

## 🚀 Works Great With

This dotfiles setup is designed to work perfectly with:
- **Ubuntu Setup Script** - Automated Ubuntu 24.04 development environment setup
- **Oh My Zsh** - Enhanced Zsh shell experience
- **Neovim** - Modern Vim editor
- **VS Code** - With auto-installed extensions

## 📚 Documentation

After installation, check out these guides:

- **[USAGE.md](./USAGE.md)** - Complete post-installation usage guide
- **[DOCKER_GUIDE.md](./DOCKER_GUIDE.md)** - Docker development environment guide
- **[PYTHON_GUIDE.md](./PYTHON_GUIDE.md)** - Python development with UV guide

## 📁 Repository Structure

```
dotfiles/
├── setup.sh                 # Main installation script
├── post-install-signin.sh    # Browser sign-in helper
├── install.sh               # Dotfiles symlink installer
├── common-functions.sh      # Shared utility functions
├── python-templates.sh      # Python project templates
├── docker-basics.sh         # Docker development setup
├── browser-dev-setup.sh     # Browser development tools
├── gnome-theming.sh         # GNOME theme configuration
└── README.md               # This file
```

**Clean Architecture:** 7 essential scripts, each with a specific purpose, no redundancy.

## 🛡️ Reliability & Security

This setup prioritizes reliability and maintainability:

- **Error handling** - Continues installation even if individual components fail
- **Error logging** - All failures logged to `/tmp/dotfiles-errors.log`
- **Security-hardened** - No unsafe external downloads or script execution
- **Non-fresh friendly** - Works on existing Ubuntu installations
- **Simplified architecture** - 7 essential scripts, no redundant functionality
- **VS Code sync approach** - No automated extensions, use Settings Sync instead

## 🤝 Contributing

Feel free to fork this repo and customize it for your needs! If you have improvements, submit a PR.

## 📝 License

Free to use and modify. Share the knowledge! 🎉

## 🔗 Related

- [Ubuntu Setup Script](https://github.com/keshav84652/ubuntu-setup) - Complete Ubuntu development environment setup
- [Oh My Zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor