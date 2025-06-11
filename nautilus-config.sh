#!/bin/bash

# Nautilus File Manager Configuration for Developers
# Optimizes file manager for development workflow

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📁 Configuring Nautilus for Development...${NC}"
echo ""

# View preferences
echo -e "${YELLOW}View Settings:${NC}"
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
echo "✓ List view set as default (better for development)"

gsettings set org.gnome.nautilus.preferences show-hidden-files true
echo "✓ Hidden files shown by default (for dotfiles access)"

gsettings set org.gnome.nautilus.list-view use-tree-view true
echo "✓ Tree view enabled in list mode"

# Sorting preferences
echo ""
echo -e "${YELLOW}Sorting Settings:${NC}"
gsettings set org.gnome.nautilus.preferences sort-directories-first true
echo "✓ Directories sorted before files"

gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
echo "✓ Default sort by name"

gsettings set org.gnome.nautilus.preferences default-sort-in-reverse-order false
echo "✓ Sort in ascending order by default"

# List view columns (show useful info for developers)
echo ""
echo -e "${YELLOW}List View Columns:${NC}"
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'date_modified', 'permissions']"
echo "✓ Show name, size, date modified, and permissions columns"

gsettings set org.gnome.nautilus.list-view default-column-order "['name', 'size', 'date_modified', 'permissions', 'owner', 'group']"
echo "✓ Optimized column order for development"

# Sidebar preferences
echo ""
echo -e "${YELLOW}Sidebar Settings:${NC}"
gsettings set org.gnome.nautilus.window-state sidebar-width 200
echo "✓ Sidebar width optimized"

# Show full path in title bar
gsettings set org.gnome.nautilus.preferences always-use-location-entry true
echo "✓ Show full path in location bar"

# Behavior settings
echo ""
echo -e "${YELLOW}Behavior Settings:${NC}"
gsettings set org.gnome.nautilus.preferences click-policy 'double'
echo "✓ Double-click to open files (standard behavior)"

gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
echo "✓ Ask before executing text files (security)"

gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover true
echo "✓ Open folders on drag-and-drop hover"

# Search settings
echo ""
echo -e "${YELLOW}Search Settings:${NC}"
gsettings set org.gnome.nautilus.preferences recursive-search 'local-only'
echo "✓ Recursive search for local files only"

gsettings set org.gnome.nautilus.preferences search-filter-time-type 'last_modified'
echo "✓ Search filter by last modified time"

# Performance settings
echo ""
echo -e "${YELLOW}Performance Settings:${NC}"
gsettings set org.gnome.nautilus.preferences show-image-thumbnails 'local-only'
echo "✓ Show thumbnails for local files only"

gsettings set org.gnome.nautilus.preferences thumbnail-limit 10
echo "✓ Thumbnail size limit set to 10MB"

gsettings set org.gnome.nautilus.preferences show-directory-item-counts 'local-only'
echo "✓ Show item counts for local directories only"

# Context menu settings
echo ""
echo -e "${YELLOW}Context Menu Settings:${NC}"
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
echo "✓ Show 'Delete Permanently' option in context menu"

# Window settings
echo ""
echo -e "${YELLOW}Window Settings:${NC}"
gsettings set org.gnome.nautilus.window-state initial-size '(900, 600)'
echo "✓ Default window size optimized for development"

gsettings set org.gnome.nautilus.window-state maximized false
echo "✓ Windows open in normal size (not maximized)"

# Icon view settings (for when icon view is used)
echo ""
echo -e "${YELLOW}Icon View Settings:${NC}"
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'
echo "✓ Small icons by default (more files visible)"

gsettings set org.gnome.nautilus.icon-view captions "['size', 'date_modified', 'none']"
echo "✓ Show size and date modified as captions"

echo ""
echo -e "${GREEN}✓ Nautilus configured for development workflow!${NC}"
echo ""
echo -e "${BLUE}Configuration applied:${NC}"
echo "• List view as default with tree navigation"
echo "• Hidden files visible (dotfiles, .env, etc.)"
echo "• Directories sorted before files"
echo "• File permissions visible in list view"
echo "• Full path shown in location bar"
echo "• Optimized for local development (no network thumbnails)"
echo "• Delete permanently option available"
echo "• Performance optimized for large codebases"
echo ""
echo -e "${YELLOW}Note: Changes take effect immediately in new Nautilus windows.${NC}"