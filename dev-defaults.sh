#!/bin/bash

# Developer Default Applications Setup
# Sets VS Code, Chrome as defaults and fixes NPM permissions

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🛠️  Configuring Developer Default Applications...${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Set VS Code as default text editor
echo -e "${YELLOW}Text Editor Defaults:${NC}"
if command_exists code; then
    # Set VS Code as default for various text file types
    xdg-mime default code.desktop text/plain
    xdg-mime default code.desktop text/x-chdr
    xdg-mime default code.desktop text/x-csrc
    xdg-mime default code.desktop text/x-c++hdr
    xdg-mime default code.desktop text/x-c++src
    xdg-mime default code.desktop text/x-java
    xdg-mime default code.desktop text/x-makefile
    xdg-mime default code.desktop text/x-python
    xdg-mime default code.desktop application/x-shellscript
    xdg-mime default code.desktop text/x-tex
    xdg-mime default code.desktop application/json
    xdg-mime default code.desktop application/javascript
    xdg-mime default code.desktop text/css
    xdg-mime default code.desktop text/html
    xdg-mime default code.desktop application/xml
    xdg-mime default code.desktop text/markdown
    echo "✓ VS Code set as default text editor for development files"
else
    echo -e "${RED}✗ VS Code not found. Install it first.${NC}"
fi

# Set Chrome as default browser
echo ""
echo -e "${YELLOW}Browser Defaults:${NC}"
if command_exists google-chrome; then
    xdg-mime default google-chrome.desktop text/html
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/about
    xdg-mime default google-chrome.desktop x-scheme-handler/unknown
    echo "✓ Chrome set as default browser"
    
    # Set Chrome as default for development URLs
    xdg-settings set default-web-browser google-chrome.desktop
    echo "✓ Chrome set as system default browser"
else
    echo -e "${RED}✗ Chrome not found. Install it first.${NC}"
fi

# Fix NPM global permissions (avoid sudo for global packages)
echo ""
echo -e "${YELLOW}NPM Configuration:${NC}"
if command_exists npm; then
    # Create global directory in home folder
    mkdir -p ~/.npm-global
    
    # Configure npm to use the new directory path
    npm config set prefix '~/.npm-global'
    echo "✓ NPM global prefix set to ~/.npm-global"
    
    # Add to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.npm-global/bin"; then
        echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
        echo "✓ Added ~/.npm-global/bin to PATH in ~/.profile"
    fi
    
    # Set npm registry to default (in case it was changed)
    npm config set registry https://registry.npmjs.org/
    echo "✓ NPM registry set to default"
    
    # Set npm to use exact versions by default (better for development)
    npm config set save-exact true
    echo "✓ NPM configured to save exact versions"
    
else
    echo -e "${RED}✗ NPM not found. Install Node.js first.${NC}"
fi

# Configure Git for better development workflow
echo ""
echo -e "${YELLOW}Git Configuration:${NC}"
if command_exists git; then
    # Useful Git aliases for development
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.cm commit
    git config --global alias.cp cherry-pick
    git config --global alias.lg "log --oneline --graph --decorate --all"
    git config --global alias.last "log -1 HEAD"
    git config --global alias.unstage "reset HEAD --"
    echo "✓ Git aliases configured for faster workflow"
    
    # Better diff and merge tools
    git config --global diff.tool vimdiff
    git config --global merge.tool vimdiff
    echo "✓ Git diff and merge tools configured"
    
    # Auto-setup remote tracking
    git config --global push.autoSetupRemote true
    echo "✓ Git auto-setup remote tracking enabled"
    
    # Better git log format
    git config --global log.oneline true
    git config --global log.abbrevCommit true
    echo "✓ Git log format optimized"
    
    # Configure SSH known hosts for Git services (if SSH directory exists)
    if [ -d "$HOME/.ssh" ]; then
        echo ""
        echo -e "${YELLOW}SSH Configuration:${NC}"
        
        # Add GitHub to known hosts
        if ! grep -q "github.com" ~/.ssh/known_hosts 2>/dev/null; then
            ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2>/dev/null
            echo "✓ Added GitHub to SSH known hosts"
        fi
        
        # Add GitLab to known hosts  
        if ! grep -q "gitlab.com" ~/.ssh/known_hosts 2>/dev/null; then
            ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts 2>/dev/null
            echo "✓ Added GitLab to SSH known hosts"
        fi
        
        # Add Bitbucket to known hosts
        if ! grep -q "bitbucket.org" ~/.ssh/known_hosts 2>/dev/null; then
            ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null
            echo "✓ Added Bitbucket to SSH known hosts"
        fi
        
        chmod 644 ~/.ssh/known_hosts 2>/dev/null
        echo "✓ SSH known hosts configured for seamless Git operations"
    fi
else
    echo -e "${RED}✗ Git not found. This should be installed.${NC}"
fi

# Set terminal as default for shell scripts
echo ""
echo -e "${YELLOW}Terminal Defaults:${NC}"
xdg-mime default org.gnome.Terminal.desktop application/x-shellscript
echo "✓ Terminal set as default for shell scripts"

# Set file manager defaults
echo ""
echo -e "${YELLOW}File Manager Defaults:${NC}"
xdg-mime default org.gnome.Nautilus.desktop inode/directory
echo "✓ Nautilus set as default file manager"

echo ""
echo -e "${GREEN}✓ Developer defaults configured successfully!${NC}"
echo ""
echo -e "${BLUE}Configuration applied:${NC}"
echo "• VS Code - Default editor for code files"
echo "• Chrome - Default browser for web development"  
echo "• NPM - Global packages in ~/.npm-global (no sudo needed)"
echo "• Git - Useful aliases and better defaults"
echo "• Terminal - Default for shell scripts"
echo "• Nautilus - Default file manager"
echo ""
echo -e "${YELLOW}Note: NPM PATH changes require logout/login or run 'source ~/.profile'${NC}"
echo -e "${YELLOW}Test NPM fix with: npm install -g nodemon (should work without sudo)${NC}"