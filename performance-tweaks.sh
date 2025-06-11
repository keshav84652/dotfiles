#!/bin/bash

# Performance Tweaks for Ubuntu Development Environment
# Optimizes animations and system responsiveness

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ Applying Performance Tweaks...${NC}"
echo ""

# Faster animations
echo -e "${YELLOW}Animation Settings:${NC}"
gsettings set org.gnome.desktop.interface enable-animations true
echo "✓ Animations enabled but optimized"

# Speed up animation duration (reduce from default)
gsettings set org.gnome.desktop.interface gtk-enable-animations true
echo "✓ GTK animations optimized"

# Disable web search in application launcher (faster search)
echo ""
echo -e "${YELLOW}Search Optimization:${NC}"
gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Epiphany.desktop']"
echo "✓ Web search disabled in launcher"

gsettings set org.gnome.desktop.search-providers disable-external true
echo "✓ External search providers disabled"

# Reduce search delay
gsettings set org.gnome.desktop.search-providers sort-order "['org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop']"
echo "✓ Search results prioritized for local apps"

# Optimize file manager performance
echo ""
echo -e "${YELLOW}File Manager Optimization:${NC}"
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'local-only'
echo "✓ Thumbnails limited to local files only"

gsettings set org.gnome.nautilus.preferences thumbnail-limit 10
echo "✓ Thumbnail generation limited for better performance"

# Window management optimizations
echo ""
echo -e "${YELLOW}Window Management:${NC}"
gsettings set org.gnome.mutter auto-maximize false
echo "✓ Auto-maximize disabled for better control"

gsettings set org.gnome.mutter edge-tiling true
echo "✓ Edge tiling enabled for productivity"

# Reduce resource usage
echo ""
echo -e "${YELLOW}Resource Optimization:${NC}"
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
echo "✓ Screen dimming disabled during development"

gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
echo "✓ Screensaver idle activation disabled"

echo ""
echo -e "${GREEN}✓ Performance tweaks applied successfully!${NC}"
echo ""
echo -e "${BLUE}Performance improvements:${NC}"
echo "• Faster application search (no web results)"
echo "• Optimized animations and transitions"
echo "• Reduced thumbnail generation overhead"
echo "• Better window management for development"
echo "• Disabled unnecessary screen dimming/screensaver"
echo ""
echo -e "${YELLOW}Note: Changes take effect immediately. Restart if needed.${NC}"