#!/bin/bash

# Performance Tweaks for Ubuntu Development Environment
# Optimizes animations and system responsiveness

set -e  # Exit on any error

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/common-functions.sh" ]; then
    source "$SCRIPT_DIR/common-functions.sh"
else
    echo "Error: common-functions.sh not found"
    exit 1
fi

# Initialize logging
init_log

print_header "⚡ Performance Tweaks for Ubuntu Development"

# Check system requirements
if ! check_system_requirements; then
    print_error "System requirements not met"
    exit 1
fi

# Validate dependencies
if ! validate_dependencies "performance-tweaks.sh" "gsettings"; then
    print_error "Missing required dependencies"
    add_manual_task "Install missing dependencies: gsettings (part of GNOME)"
    finalize_log "Performance Tweaks"
    exit 1
fi

# Faster animations
print_info "Configuring animation settings..."
if safe_run "Enable optimized animations" gsettings set org.gnome.desktop.interface enable-animations true; then
    safe_run "Optimize GTK animations" gsettings set org.gnome.desktop.interface gtk-enable-animations true
else
    print_warning "Could not configure animations - continuing with other tweaks"
fi

# Disable web search in application launcher (faster search)
print_info "Optimizing application launcher search..."
safe_run "Disable web search in launcher" gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Epiphany.desktop']"
safe_run "Disable external search providers" gsettings set org.gnome.desktop.search-providers disable-external true
safe_run "Prioritize local app search results" gsettings set org.gnome.desktop.search-providers sort-order "['org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop']"

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

# Add summary to log
print_header "Performance Improvements Applied"
add_manual_task "Open a new application (Super key) to test faster search"
add_manual_task "Test window tiling with Super+Arrow keys"
add_next_step "Restart session if animations don't feel faster"
add_next_step "Run other configuration scripts for complete setup"

print_info "Performance improvements include:"
print_info "• Faster application search (no web results)"
print_info "• Optimized animations and transitions" 
print_info "• Reduced thumbnail generation overhead"
print_info "• Better window management for development"
print_info "• Disabled unnecessary screen dimming/screensaver"

finalize_log "Performance Tweaks"