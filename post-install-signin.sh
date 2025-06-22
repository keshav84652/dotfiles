#!/bin/bash

# Post-Installation Sign-in Helper
# Opens all necessary URLs for account setup

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_header "🚀 Post-Installation Sign-in Helper"

# Display SSH key if available
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    print_header "🔑 SSH Key Ready"
    echo "Your SSH public key (copied to clipboard):"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    
    # Copy to clipboard if xclip is available
    if command -v xclip >/dev/null 2>&1; then
        cat "$HOME/.ssh/id_ed25519.pub" | xclip -selection clipboard
        print_success "SSH key copied to clipboard"
    fi
else
    print_warning "SSH key not found. Generate one with: ssh-keygen -t ed25519 -C 'your@email.com'"
fi

# Function to open URLs in both browsers
open_urls() {
    local description="$1"
    shift
    local urls=("$@")
    
    print_info "Opening $description..."
    
    # Open in Chrome
    if command -v google-chrome >/dev/null 2>&1; then
        google-chrome "${urls[@]}" >/dev/null 2>&1 &
        print_success "Opened in Chrome"
    fi
    
    # Small delay
    sleep 1
    
    # Open in Firefox
    if command -v firefox >/dev/null 2>&1; then
        firefox "${urls[@]}" >/dev/null 2>&1 &
        print_success "Opened in Firefox"
    fi
    
    sleep 2  # Brief delay before next batch
}

print_header "🔗 Opening Sign-in Pages"

# Development accounts
open_urls "Development accounts" \
    "https://github.com/settings/keys" \
    "https://github.com/login" \
    "https://gitlab.com/users/sign_in"

# Password manager
open_urls "Password manager" \
    "https://vault.bitwarden.com"

# Email accounts
open_urls "Email accounts" \
    "https://accounts.google.com" \
    "https://account.proton.me"

# Communication
open_urls "Communication apps" \
    "https://discord.com/login" \
    "https://web.whatsapp.com" \
    "https://teams.microsoft.com"

# Microsoft account (without OneDrive focus)
open_urls "Microsoft services" \
    "https://login.microsoftonline.com"

# Thunderbird setup helper
open_urls "Email client setup" \
    "https://support.mozilla.org/en-US/kb/automatic-account-configuration"

print_header "📋 Guided Setup Checklist"

cat << 'EOF'
Complete these steps in the opened browser tabs:

🔑 STEP 1: GitHub Setup
   □ Go to GitHub → Settings → SSH and GPG keys
   □ Click "New SSH key"
   □ Paste your SSH key (already copied to clipboard)
   □ Give it a title (e.g., "Ubuntu Laptop")
   □ Click "Add SSH key"
   □ Test with: ssh -T git@github.com

🔐 STEP 2: Bitwarden Setup
   □ Sign in to Bitwarden vault
   □ Install Bitwarden browser extension in both browsers
   □ Enable browser integration in Bitwarden settings

📧 STEP 3: Email Accounts
   □ Google: Sign in to Gmail, Drive, Calendar
   □ Proton: Sign in to ProtonMail
   □ Thunderbird: Follow the automatic setup guide

💬 STEP 4: Communication
   □ Discord: Sign in and join your servers
   □ WhatsApp Web: Scan QR code with your phone
   □ Teams: Sign in with work/personal Microsoft account

⚙️ STEP 5: VS Code Sync
   □ Open VS Code
   □ Press Ctrl+Shift+P
   □ Type "sync" and select "Turn on Settings Sync"
   □ Sign in with GitHub account

🌐 STEP 6: Browser Extensions (Install in both browsers)
   Essential extensions:
   □ Bitwarden Password Manager
   □ uBlock Origin (ad blocker)
   □ JSON Viewer
   □ React Developer Tools (if you do web dev)
   □ Vue.js devtools (if you use Vue)

EOF

print_header "🔧 Quick Reference Commands"

cat << 'EOF'
After completing the setup above, use these commands:

Development:
• ssh -T git@github.com          # Test GitHub SSH
• python-dev new myproject web   # Create Python project
• docker-dev start               # Start development stack
• dev-urls github               # Quick open GitHub

Browser development:
• setup-browser-dev             # Start browser with dev flags
• dev-urls react               # Open React dev server
• dev-urls docs                # Open MDN documentation

System:
• sudo apt update && sudo apt upgrade  # Update system
• htop                         # System monitor
• neofetch                     # System info

EOF

# Start VS Code for sync setup
if command -v code >/dev/null 2>&1; then
    print_header "🔄 Starting VS Code"
    print_info "Opening VS Code for settings sync setup..."
    code >/dev/null 2>&1 &
    print_success "VS Code started - enable Settings Sync in the welcome screen"
fi

print_header "✅ Setup Complete"

echo "All sign-in pages have been opened in both Chrome and Firefox."
echo "Follow the guided checklist above to complete your account setup."
echo ""
print_success "Happy coding! 🚀"