# My Dotfiles 🚀

Personal configuration files for Ubuntu 24.04 development setup with enhanced shell and editor configurations.

## 🎯 What's Included

### Shell Configurations
- **`.bashrc`** - Enhanced Bash configuration with useful aliases and prompt
- **`.zshrc`** - Modern Zsh configuration with Oh My Zsh integration
- **`.aliases`** - Shared aliases for both Bash and Zsh

### Editor Configurations  
- **`.vimrc`** - Vim configuration with syntax highlighting and better defaults
- **`.config/nvim/init.vim`** - Neovim configuration for modern editing

### Development Tools
- **`.gitconfig`** - Git configuration with colors, aliases, and better defaults
- **`vscode-extensions.txt`** - List of recommended VS Code extensions
- **`.gitignore_global`** - Global gitignore for all projects

### Installation Scripts
- **`install-all.sh`** - Complete automated installation with error handling and reporting
- **`install.sh`** - Core dotfiles installation with backup and shell detection
- **`common-functions.sh`** - Shared utilities for error handling and logging
- **`gnome-settings.sh`** - GNOME desktop configuration (dock, theme, hot corners)

### Phase 1 - Core Configuration
- **`performance-tweaks.sh`** - Faster animations, optimized search
- **`keyboard-shortcuts.sh`** - Windows-style shortcuts for Ubuntu
- **`dev-defaults.sh`** - VS Code/Chrome defaults, NPM permissions
- **`nautilus-config.sh`** - File manager optimized for development
- **`terminal-config.sh`** - Unlimited scrollback, optimized settings
- **`dock-cleanup.sh`** - Clean dock with essential development apps

### Phase 2 - Development Environment
- **`node-global-packages.sh`** - Essential npm packages (nodemon, live-server, etc.)
- **`python-templates.sh`** - Project templates (Flask, Django, FastAPI, Data Science)
- **`browser-dev-setup.sh`** - Chrome developer configuration and bookmarks
- **`docker-basics.sh`** - Docker containers and development databases

### Phase 3 - Advanced (Not Configured Yet)
- Database cluster setup
- SSL certificates for local development  
- Advanced Docker development environments
- CI/CD pipeline templates

## 🚀 Quick Installation

### Option 1: Complete Automated Installation (Recommended)
```bash
git clone https://github.com/keshav84652/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install-all.sh
```

### Option 2: Manual Phase-by-Phase Installation
```bash
git clone https://github.com/keshav84652/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Core installation
bash install.sh

# Phase 1: Core system configuration
bash gnome-settings.sh       # GNOME desktop settings
bash performance-tweaks.sh   # System performance optimizations
bash keyboard-shortcuts.sh   # Windows-style keyboard shortcuts
bash dev-defaults.sh         # Developer application defaults
bash nautilus-config.sh      # File manager configuration
bash terminal-config.sh      # Terminal optimization
bash dock-cleanup.sh         # Clean, minimal dock

# Phase 2: Development environment (optional)
bash node-global-packages.sh # Node.js development tools
bash python-templates.sh     # Python project templates
bash browser-dev-setup.sh    # Browser developer configuration
bash docker-basics.sh        # Docker development setup
```

## 📊 Installation Reports

Each script generates detailed reports showing:
- ✅ **Successful operations**
- ⚠️ **Warnings and issues**
- ❌ **Errors requiring attention**
- 📋 **Manual tasks to complete**
- 🔄 **Next steps**

Reports are saved as `~/dotfiles-install-TIMESTAMP.md` files.

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