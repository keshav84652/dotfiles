#!/bin/bash

# GNOME Desktop Settings Configuration
# Run this script to apply preferred GNOME settings

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎨 Configuring GNOME Desktop Settings...${NC}"
echo ""

# Dock Configuration
echo -e "${YELLOW}Dock Settings:${NC}"
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
echo "✓ Auto-hide dock enabled"

gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false  
echo "✓ Panel mode disabled"

gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
echo "✓ Hide mounted drives from dock"

gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
echo "✓ Hide trash from dock"

# Appearance Settings
echo ""
echo -e "${YELLOW}Appearance Settings:${NC}"
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-blue-dark'
echo "✓ Dark GTK theme applied"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "✓ System-wide dark mode enabled"

gsettings set org.gnome.desktop.wm.preferences theme 'Yaru-blue-dark'
echo "✓ Dark window manager theme applied"

# Hot Corners
echo ""
echo -e "${YELLOW}Interface Settings:${NC}"
gsettings set org.gnome.desktop.interface enable-hot-corners true
echo "✓ Hot corners enabled"

echo ""
echo -e "${GREEN}✓ GNOME settings applied successfully!${NC}"
echo ""
echo -e "${BLUE}Settings applied:${NC}"
echo "• Auto-hide dock"
echo "• Panel mode disabled"
echo "• Drives and trash hidden from dock"
echo "• Dark theme enabled"
echo "• Hot corners enabled"
echo ""
echo -e "${YELLOW}Note: Some changes may require logging out and back in to take full effect.${NC}"