# 🚀 Dotfiles Usage Guide

Complete guide to using your newly configured Ubuntu development environment.

## 🎯 Quick Start After Installation

### 1. Terminal Setup
Choose your preferred terminal:
- **GNOME Terminal**: Default, works out of the box
- **Kitty**: Fast GPU-accelerated terminal
- **Alacritty**: Minimal and lightning-fast
- **Warp**: Modern AI-powered terminal (if pre-installed)

### 2. Shell Configuration
Your shell is now enhanced with:
```bash
# Switch to Zsh (if not default)
exec zsh

# Reload shell configuration
source ~/.zshrc
# or
source ~/.bashrc
```

## ⌨️ Keyboard Shortcuts

### System Shortcuts
- **Super + E**: Open file manager (Nautilus)
- **Super + L**: Lock screen
- **Super + Print**: Screenshot (Flameshot)
- **Shift + Super + S**: Area screenshot
- **Alt + F4**: Close window
- **Alt + Tab**: Switch between windows
- **Super + Tab**: Switch between applications

### Terminal Shortcuts
- **Ctrl + Shift + T**: New terminal tab
- **Ctrl + Shift + N**: New terminal window
- **Ctrl + Alt + T**: Open terminal

## 🐚 Shell Features

### Useful Aliases
```bash
# Navigation
ll          # Detailed file listing
la          # List all files including hidden
..          # Go up one directory
...         # Go up two directories

# Git shortcuts
gs          # git status
ga .        # git add all
gc "msg"    # git commit with message
gp          # git push
gl          # git log (pretty format)

# Development
serve       # Start local Python HTTP server
myip        # Show external IP address
ports       # Show open ports

# System
update      # Update system packages
cleanup     # Clean package cache and temp files
```

### Zsh Features (if using Zsh)
- **Tab completion**: Enhanced with menu selection
- **Syntax highlighting**: Commands highlighted as you type
- **Auto-suggestions**: Suggestions based on history
- **Git integration**: Branch info in prompt

## 💻 Development Workflow

### Python Projects
```bash
# Create new project
python-dev new myapp web

# Navigate to project
cd ~/Development/python-projects/myapp

# Install dependencies
uv sync

# Run application
uv run src/main.py

# Run tests
python-dev test

# Format code
python-dev fmt
```

### Docker Development
```bash
# Start development stack
cd ~/Development/docker-examples
./docker-dev start

# Connect to PostgreSQL
./docker-dev postgres

# Connect to Redis
./docker-dev redis

# View web interface
# Open http://localhost:8080 in browser
```

### VS Code Setup
Launch VS Code with pre-installed extensions:
```bash
code .                    # Open current directory
code myproject/          # Open specific project
```

**Installed Extensions:**
- Python (with IntelliSense)
- GitLens (Git integration)
- Prettier (Code formatting)
- Material Icon Theme
- Auto Rename Tag
- Live Server
- Thunder Client (API testing)

## 🎨 Customization

### GNOME Theming
- **Dark theme**: Automatically applied
- **Papirus icons**: Dark variant installed
- **Extension Manager**: Available for additional extensions

**Recommended Extensions (install via Extension Manager):**
- Blur my Shell - Window transparency
- Burn My Windows - Window animations
- Vitals - System monitoring
- AppIndicator Support - System tray

### Terminal Customization

#### For Kitty:
Edit `~/.config/kitty/kitty.conf` (if needed):
```bash
font_family Fira Code
font_size 11
background_opacity 0.9
```

#### For Alacritty:
Edit `~/.config/alacritty/alacritty.yml` (if needed):
```yaml
font:
  normal:
    family: Fira Code
  size: 11
```

## 📁 Directory Structure

Your development environment is organized as:
```
~/
├── .local/bin/          # User binaries (python-dev, etc.)
├── Development/
│   ├── docker-examples/ # Docker development templates
│   └── python-projects/ # Python project templates
├── .config/
│   ├── uv/             # UV package manager config
│   └── [terminals]/    # Terminal configurations
└── dotfiles/           # This repository
```

## 🔧 Maintenance

### Update System
```bash
# Update packages
sudo apt update && sudo apt upgrade

# Update dotfiles
cd ~/dotfiles && git pull

# Update UV
uv self update

# Update VS Code extensions
code --update-extensions
```

### Cleanup
```bash
# Clean package cache
sudo apt autoremove && sudo apt autoclean

# Clean Docker (if needed)
docker system prune

# Clean pip cache
uv cache clean
```

## 🐛 Troubleshooting

### Common Issues

**Terminal not showing Zsh features:**
```bash
# Ensure Zsh is default shell
chsh -s $(which zsh)
# Logout and login again
```

**VS Code extensions not working:**
```bash
# Reload VS Code
Ctrl + Shift + P -> "Developer: Reload Window"

# Or restart VS Code
code --new-window
```

**Docker permission denied:**
```bash
# Ensure user is in docker group
sudo usermod -a -G docker $USER
# Logout and login again
```

**UV not found:**
```bash
# Ensure UV is in PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Performance Issues

**Slow terminal startup:**
```bash
# Check shell startup time
time zsh -i -c exit

# Disable unused Oh My Zsh plugins
# Edit ~/.zshrc and modify plugins array
```

**High memory usage:**
```bash
# Check system resources
htop

# Disable animations if needed
gsettings set org.gnome.desktop.interface enable-animations false
```

## 🎓 Learn More

### Essential Commands to Remember
```bash
# File operations
find . -name "*.py"      # Find Python files
grep -r "search" .       # Search in files
rsync -av src/ dest/     # Sync directories

# System information
neofetch                 # System info
df -h                    # Disk usage
free -h                  # Memory usage
lsof -i :8000           # Check port usage

# Process management
ps aux | grep python     # Find Python processes
kill -9 PID             # Force kill process
nohup command &         # Run in background
```

### Development Resources

**Documentation:**
- [DOCKER_GUIDE.md](./DOCKER_GUIDE.md) - Docker usage
- [PYTHON_GUIDE.md](./PYTHON_GUIDE.md) - Python development

**Online Resources:**
- [Oh My Zsh](https://ohmyz.sh/) - Shell enhancement
- [UV Documentation](https://docs.astral.sh/uv/) - Package manager
- [VS Code Tips](https://code.visualstudio.com/docs/getstarted/tips-and-tricks)

## 💡 Pro Tips

1. **Use tab completion extensively** - Save time typing
2. **Learn keyboard shortcuts** - Faster than mouse navigation
3. **Customize your prompt** - Make it show what you need
4. **Use virtual environments** - Keep projects isolated
5. **Regular backups** - Backup your dotfiles and projects
6. **Stay updated** - Regular system and tool updates
7. **Explore extensions** - Both VS Code and GNOME extensions
8. **Terminal multiplexing** - Consider tmux or screen for advanced workflows

---

**Need help?** Check the troubleshooting section or create an issue in the repository!