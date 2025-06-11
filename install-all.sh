#!/bin/bash

# Master Installation Script for Dotfiles
# Runs all phases with comprehensive error handling and reporting

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/common-functions.sh" ]; then
    source "$SCRIPT_DIR/common-functions.sh"
else
    echo "Error: common-functions.sh not found"
    exit 1
fi

# Initialize master log
MASTER_LOG_FILE="$HOME/dotfiles-complete-install-$(date +%Y%m%d_%H%M%S).md"
TOTAL_SUCCESS=0
TOTAL_WARNINGS=0
TOTAL_ERRORS=0

# Create master log
cat > "$MASTER_LOG_FILE" << EOF
# Complete Dotfiles Installation Report
**Date:** $(date)
**User:** $USER
**System:** $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown Linux")

## Installation Overview

This report covers the complete installation of the dotfiles system including all phases.

EOF

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
    echo -e "\n## $1\n" >> "$MASTER_LOG_FILE"
}

# Function to run a script and capture results
run_script() {
    local script_name="$1"
    local description="$2"
    local optional="${3:-false}"
    
    print_header "Running $description"
    
    if [ ! -f "$script_name" ]; then
        if [ "$optional" = "true" ]; then
            print_warning "$script_name not found - skipping optional component"
            echo "- ⏭️ **SKIPPED:** $description (file not found)" >> "$MASTER_LOG_FILE"
            return 0
        else
            print_error "$script_name not found - required component missing"
            echo "- ❌ **ERROR:** $description (file not found)" >> "$MASTER_LOG_FILE"
            return 1
        fi
    fi
    
    if [ ! -x "$script_name" ]; then
        print_warning "$script_name is not executable - fixing permissions"
        chmod +x "$script_name"
    fi
    
    echo "### $description" >> "$MASTER_LOG_FILE"
    echo "" >> "$MASTER_LOG_FILE"
    
    if bash "$script_name"; then
        print_success "$description completed successfully"
        echo "- ✅ **SUCCESS:** $description completed" >> "$MASTER_LOG_FILE"
        
        # Capture individual script log if it exists
        local script_log=$(find "$HOME" -name "dotfiles-*$(date +%Y%m%d)*" -newer "$MASTER_LOG_FILE" 2>/dev/null | head -1)
        if [ -n "$script_log" ] && [ -f "$script_log" ]; then
            echo "- 📄 Individual report: \`$(basename "$script_log")\`" >> "$MASTER_LOG_FILE"
        fi
        
        return 0
    else
        print_error "$description failed"
        echo "- ❌ **FAILED:** $description" >> "$MASTER_LOG_FILE"
        
        if [ "$optional" = "true" ]; then
            print_warning "Continuing with installation (optional component failed)"
            return 0
        else
            return 1
        fi
    fi
}

# Function to ask user about installation phases
ask_installation_preferences() {
    echo -e "${BLUE}Dotfiles Installation System${NC}"
    echo ""
    echo "This installer will set up your complete development environment."
    echo ""
    echo "Available installation phases:"
    echo ""
    echo -e "${GREEN}Core Installation:${NC}"
    echo "• Basic dotfiles (shell, git, vim configurations)"
    echo ""
    echo -e "${GREEN}Phase 1 - System Configuration:${NC}"
    echo "• GNOME desktop settings"
    echo "• Performance optimizations"
    echo "• Keyboard shortcuts"
    echo "• Developer defaults"
    echo "• File manager optimization"
    echo "• Terminal configuration"
    echo "• Dock cleanup"
    echo ""
    echo -e "${GREEN}Phase 2 - Development Environment:${NC}"
    echo "• Node.js global packages"
    echo "• Python project templates"
    echo "• Browser developer setup"
    echo "• Docker development containers"
    echo ""
    
    read -p "Install everything? (y/N): " install_all
    
    if [[ "$install_all" =~ ^[Yy]$ ]]; then
        INSTALL_CORE=true
        INSTALL_PHASE1=true
        INSTALL_PHASE2=true
    else
        read -p "Install core dotfiles? (Y/n): " core_response
        INSTALL_CORE=${core_response:-y}
        
        read -p "Install Phase 1 (system configuration)? (Y/n): " phase1_response
        INSTALL_PHASE1=${phase1_response:-y}
        
        read -p "Install Phase 2 (development environment)? (y/N): " phase2_response
        INSTALL_PHASE2=${phase2_response:-n}
    fi
}

# Main installation function
main() {
    cd "$SCRIPT_DIR"
    
    print_header "🚀 Dotfiles Complete Installation System"
    
    # Check system requirements
    if ! check_system_requirements; then
        print_error "System requirements not met - aborting installation"
        exit 1
    fi
    
    # Ask user preferences
    ask_installation_preferences
    
    echo "" >> "$MASTER_LOG_FILE"
    echo "**Installation choices:**" >> "$MASTER_LOG_FILE"
    echo "- Core dotfiles: $([[ "$INSTALL_CORE" =~ ^[Yy]$ ]] && echo "Yes" || echo "No")" >> "$MASTER_LOG_FILE"
    echo "- Phase 1 (System): $([[ "$INSTALL_PHASE1" =~ ^[Yy]$ ]] && echo "Yes" || echo "No")" >> "$MASTER_LOG_FILE"
    echo "- Phase 2 (Development): $([[ "$INSTALL_PHASE2" =~ ^[Yy]$ ]] && echo "Yes" || echo "No")" >> "$MASTER_LOG_FILE"
    echo "" >> "$MASTER_LOG_FILE"
    
    # Core Installation
    if [[ "$INSTALL_CORE" =~ ^[Yy]$ ]]; then
        print_header "📦 Core Dotfiles Installation"
        if ! run_script "./install.sh" "Core Dotfiles Installation"; then
            print_error "Core installation failed - this is required"
            exit 1
        fi
    fi
    
    # Phase 1: System Configuration
    if [[ "$INSTALL_PHASE1" =~ ^[Yy]$ ]]; then
        print_header "⚙️ Phase 1: System Configuration"
        
        run_script "./gnome-settings.sh" "GNOME Desktop Settings" true
        run_script "./performance-tweaks.sh" "Performance Optimizations" true
        run_script "./keyboard-shortcuts.sh" "Windows-Style Keyboard Shortcuts" true
        run_script "./dev-defaults.sh" "Developer Application Defaults" true
        run_script "./nautilus-config.sh" "File Manager Configuration" true
        run_script "./terminal-config.sh" "Terminal Optimization" true
        run_script "./dock-cleanup.sh" "Dock Cleanup" true
    fi
    
    # Phase 2: Development Environment
    if [[ "$INSTALL_PHASE2" =~ ^[Yy]$ ]]; then
        print_header "🛠️ Phase 2: Development Environment"
        
        run_script "./node-global-packages.sh" "Node.js Global Packages" true
        run_script "./python-templates.sh" "Python Project Templates" true
        run_script "./browser-dev-setup.sh" "Browser Developer Setup" true
        run_script "./docker-basics.sh" "Docker Development Setup" true
    fi
    
    # Generate final report
    generate_final_report
}

# Function to generate comprehensive final report
generate_final_report() {
    print_header "📊 Installation Complete - Generating Report"
    
    cat >> "$MASTER_LOG_FILE" << EOF

---

## 🎉 Installation Summary

### What Was Installed
EOF

    if [[ "$INSTALL_CORE" =~ ^[Yy]$ ]]; then
        cat >> "$MASTER_LOG_FILE" << EOF
- ✅ **Core Dotfiles:** Shell configurations, Git settings, Vim/Neovim, VS Code extensions
EOF
    fi
    
    if [[ "$INSTALL_PHASE1" =~ ^[Yy]$ ]]; then
        cat >> "$MASTER_LOG_FILE" << EOF
- ✅ **System Configuration:** GNOME settings, performance tweaks, keyboard shortcuts, developer defaults
EOF
    fi
    
    if [[ "$INSTALL_PHASE2" =~ ^[Yy]$ ]]; then
        cat >> "$MASTER_LOG_FILE" << EOF
- ✅ **Development Environment:** Node.js tools, Python templates, browser setup, Docker containers
EOF
    fi
    
    cat >> "$MASTER_LOG_FILE" << EOF

### 🔄 Next Steps

1. **Restart your terminal** or run \`exec zsh\` to apply shell changes
2. **Test keyboard shortcuts** (Super+E, Super+L, Alt+F4)
3. **Open VS Code** to verify extensions are installed
4. **Check browser bookmarks** for development resources
5. **Test project templates**: \`new-python-project myapp flask\`
6. **Verify Docker setup**: \`docker --version\`

### 🚨 Important Notes

- **Logout/login** may be required for some changes to take full effect
- **Individual script reports** are saved in your home directory
- **Delete these reports** after reviewing them
- **Run scripts individually** if you need to reconfigure specific parts

### 📋 Manual Tasks Remaining

Check individual script reports for specific manual tasks like:
- Adding SSH keys to GitHub/GitLab
- Installing browser extensions
- Configuring additional VS Code settings
- Setting up project-specific configurations

### 🆘 Troubleshooting

If something isn't working:
1. Check individual script reports for specific errors
2. Run scripts individually to isolate issues
3. Verify system requirements (Ubuntu 20.04+, internet connection)
4. Check file permissions on scripts

### 📄 Generated Reports

- **Master Report:** \`$(basename "$MASTER_LOG_FILE")\`
- **Individual Reports:** Check your home directory for \`dotfiles-*\` files

---

**Installation completed on:** $(date)

*You can delete this report file after reviewing it.*
EOF

    print_success "Complete installation finished!"
    print_info "📄 Comprehensive report saved to: $MASTER_LOG_FILE"
    
    echo ""
    print_header "🎯 Quick Start Guide"
    print_info "1. Restart terminal: exec zsh"
    print_info "2. Test shortcuts: Super+E (file manager)"
    print_info "3. Create project: new-python-project myapp flask"
    print_info "4. Start development: dev-urls react"
    
    echo ""
    print_warning "Review the complete report for any manual tasks or errors!"
    print_info "Report location: $MASTER_LOG_FILE"
}

# Error handling
trap 'print_error "Installation interrupted"; exit 1' INT TERM

# Run main installation
main "$@"