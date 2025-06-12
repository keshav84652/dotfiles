# Ubuntu 24.04 Development Environment Setup 🚀

Complete automated Ubuntu development environment with dotfiles, applications, theming, and GNOME extensions.

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
- **Development Tools**: Python 3.11, Node.js (via NVM), VS Code, Docker
- **Desktop Apps**: Google Chrome, Discord, Bitwarden, VLC, Flameshot
- **System Tools**: GNOME Tweaks, CopyQ, Stacer, TeamViewer

### Shell & Terminal
- **Zsh + Oh My Zsh** with plugins (syntax highlighting, autosuggestions)
- **Enhanced `.bashrc`** and `.zshrc` with useful aliases
- **Terminal optimization** (unlimited scrollback, better colors)

### GNOME Desktop Theming
- **Papirus icon theme** (dark variant)
- **Modern cursor theme** (Bibata)
- **GNOME Extensions**: Blur my Shell, Burn My Windows
- **Dark theme** with blue accent colors
- **Enhanced dock** (auto-hide, clean layout)

### Development Environment
- **Git configuration** with SSH keys and better defaults
- **VS Code extensions** (Python, GitLens, Prettier, Docker, etc.)
- **Docker setup** with development containers
- **Performance optimizations** and keyboard shortcuts

## ⏱️ Installation Time

- **Full setup**: ~15-20 minutes
- **Download size**: ~2-3 GB (applications, themes, extensions)
- **Disk space**: ~5-6 GB after installation

## 🎛️ Installation Options

The setup script offers two modes:

1. **Fully Automated** (recommended) - Installs everything with sensible defaults
2. **Interactive** - Choose what to install (development tools, applications, theming, etc.)

## 🔧 What Happens During Installation

1. **System Update** - Updates packages and upgrades system
2. **Essential Packages** - Installs build tools, curl, wget, git, etc.
3. **Development Tools** - Python 3.11, Node.js (via NVM), VS Code, Docker
4. **Desktop Applications** - Chrome, Discord, Bitwarden, media tools
5. **Shell Setup** - Zsh + Oh My Zsh with plugins and enhanced configs
6. **GNOME Theming** - Dark theme, Papirus icons, extensions
7. **System Optimization** - Performance tweaks, keyboard shortcuts
8. **Dotfiles** - Symlinks shell configs, git setup, VS Code extensions

## ✨ Key Features

### Enhanced Terminal Experience
- **Zsh with Oh My Zsh** - Modern shell with autocompletion and syntax highlighting
- **Smart aliases** - `gs` (git status), `ll` (detailed listing), `..` (go up)
- **NVM integration** - Node.js version management built-in
- **Git integration** - Branch info in prompt, better git colors

### Beautiful Desktop
- **Dark theme** with Yaru-blue-dark and Papirus icons
- **Window animations** - Smooth open/close effects with Burn My Windows
- **Terminal transparency** - Blur effects with Blur my Shell extension
- **Auto-hide dock** - Clean, minimal desktop layout

### Developer-Focused
- **VS Code ready** - Pre-configured with essential extensions
- **Docker integration** - Development containers and databases
- **Python 3.11** - Latest Python with pip and venv
- **Git optimized** - SSH keys, better diffs, useful aliases

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

## 📦 VS Code Extensions Included

- **Python** - Python language support
- **GitLens** - Enhanced Git capabilities
- **Prettier** - Code formatting
- **Material Icon Theme** - Beautiful file icons
- **Auto Rename Tag** - HTML/XML tag renaming
- **Live Server** - Local development server
- **Thunder Client** - API testing
- **Path Intellisense** - Autocomplete file paths
- **Docker** - Docker support

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

## 🚀 Works Great With

This dotfiles setup is designed to work perfectly with:
- **Ubuntu Setup Script** - Automated Ubuntu 24.04 development environment setup
- **Oh My Zsh** - Enhanced Zsh shell experience
- **Neovim** - Modern Vim editor
- **VS Code** - With auto-installed extensions

## 🤝 Contributing

Feel free to fork this repo and customize it for your needs! If you have improvements, submit a PR.

## 📝 License

Free to use and modify. Share the knowledge! 🎉

## 🔗 Related

- [Ubuntu Setup Script](https://github.com/keshav84652/ubuntu-setup) - Complete Ubuntu development environment setup
- [Oh My Zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor