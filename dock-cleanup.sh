#!/bin/bash

# Dock Cleanup for Development Environment
# Sets up a clean, minimal dock with essential development apps

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🧹 Cleaning up Dock for Development...${NC}"
echo ""

# Function to check if application is installed
app_exists() {
    if [ -f "/usr/share/applications/$1" ] || [ -f "/var/lib/snapd/desktop/applications/$1" ] || [ -f "$HOME/.local/share/applications/$1" ]; then
        return 0
    else
        return 1
    fi
}

# Essential development applications for dock
DOCK_APPS=()

echo -e "${YELLOW}Checking for installed applications...${NC}"

# Chrome
if app_exists "google-chrome.desktop"; then
    DOCK_APPS+=("'google-chrome.desktop'")
    echo "✓ Chrome found - adding to dock"
elif app_exists "firefox.desktop"; then
    DOCK_APPS+=("'firefox.desktop'")
    echo "✓ Firefox found - adding to dock (Chrome not available)"
else
    echo -e "${RED}✗ No browser found${NC}"
fi

# VS Code
if app_exists "code.desktop"; then
    DOCK_APPS+=("'code.desktop'")
    echo "✓ VS Code found - adding to dock"
else
    echo -e "${RED}✗ VS Code not found${NC}"
fi

# Terminal
DOCK_APPS+=("'org.gnome.Terminal.desktop'")
echo "✓ Terminal added to dock"

# File Manager
DOCK_APPS+=("'org.gnome.Nautilus.desktop'")
echo "✓ File Manager (Nautilus) added to dock"

# Settings (useful for quick system adjustments)
DOCK_APPS+=("'gnome-control-center.desktop'")
echo "✓ Settings added to dock"

# Optional: Add Discord if available (communication for dev teams)
if app_exists "discord.desktop"; then
    DOCK_APPS+=("'discord.desktop'")
    echo "✓ Discord found - adding to dock"
fi

# Build the favorites string
FAVORITES_STRING="[$(IFS=, ; echo "${DOCK_APPS[*]}")]"

echo ""
echo -e "${YELLOW}Configuring dock with clean application set...${NC}"

# Set the new favorites
gsettings set org.gnome.shell favorite-apps "$FAVORITES_STRING"
echo "✓ Dock applications configured"

# Dock behavior settings (ensure they're optimized)
echo ""
echo -e "${YELLOW}Optimizing dock behavior...${NC}"

# Position and size
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
echo "✓ Dock positioned at bottom"

gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
echo "✓ Icon size set to 48px (optimal for development)"

# Auto-hide settings
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
echo "✓ Auto-hide enabled"

gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
echo "✓ Intelligent auto-hide enabled"

gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'FOCUS_APPLICATION_WINDOWS'
echo "✓ Hide when application windows overlap"

# Click behavior
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
echo "✓ Click to minimize/restore windows"

# Show/hide settings
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
echo "✓ Hide mounted drives"

gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
echo "✓ Hide trash can"

gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button true
echo "✓ Show applications button enabled"

# Animation and responsiveness
gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.2
echo "✓ Animation time reduced for responsiveness"

gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.2
echo "✓ Hide delay optimized"

gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.25
echo "✓ Show delay optimized"

# Multi-monitor settings
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor false
echo "✓ Dock on primary monitor only"

echo ""
echo -e "${GREEN}✓ Dock cleaned up and optimized for development!${NC}"
echo ""
echo -e "${BLUE}Dock applications configured:${NC}"
for app in "${DOCK_APPS[@]}"; do
    app_clean=$(echo $app | tr -d "'")
    app_name=$(echo $app_clean | sed 's/.desktop$//' | sed 's/.*\.//' | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
    echo "• $app_name"
done

echo ""
echo -e "${BLUE}Dock behavior optimized:${NC}"
echo "• Auto-hide when windows overlap"
echo "• Optimal icon size for development"
echo "• Fast animations for responsiveness"
echo "• Hidden drives and trash for cleanliness"
echo "• Click to minimize/restore windows"
echo "• Primary monitor only (multi-monitor friendly)"
echo ""
echo -e "${YELLOW}Note: Changes take effect immediately.${NC}"