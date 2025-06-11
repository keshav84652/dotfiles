#!/bin/bash

# Terminal Configuration for Development
# Optimizes terminal settings for coding and debugging

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}💻 Configuring Terminal for Development...${NC}"
echo ""

# Get the default terminal profile
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
PROFILE_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/"

if [ -z "$PROFILE" ]; then
    echo -e "${RED}✗ Could not find terminal profile. Using fallback configuration.${NC}"
    exit 1
fi

echo -e "${YELLOW}Profile ID: $PROFILE${NC}"
echo ""

# Scrollback settings
echo -e "${YELLOW}Scrollback Configuration:${NC}"
gsettings set $PROFILE_PATH scrollback-unlimited true
echo "✓ Unlimited scrollback enabled (essential for build logs)"

gsettings set $PROFILE_PATH scrollback-lines 50000
echo "✓ Fallback scrollback set to 50,000 lines"

# Cursor settings
echo ""
echo -e "${YELLOW}Cursor Settings:${NC}"
gsettings set $PROFILE_PATH cursor-blink-mode 'off'
echo "✓ Cursor blinking disabled (better for focus)"

gsettings set $PROFILE_PATH cursor-shape 'block'
echo "✓ Block cursor shape (easier to see)"

# Bell settings
echo ""
echo -e "${YELLOW}Bell Settings:${NC}"
gsettings set $PROFILE_PATH audible-bell false
echo "✓ Audible bell disabled"

gsettings set $PROFILE_PATH visible-bell true
echo "✓ Visual bell enabled (less disruptive)"

# Text and font settings
echo ""
echo -e "${YELLOW}Text Settings:${NC}"
gsettings set $PROFILE_PATH allow-bold true
echo "✓ Bold text allowed (syntax highlighting)"

gsettings set $PROFILE_PATH bold-is-bright false
echo "✓ Bold text uses actual bold (not bright colors)"

# Check if custom font is needed
if gsettings get $PROFILE_PATH use-system-font | grep -q "true"; then
    gsettings set $PROFILE_PATH use-system-font false
    gsettings set $PROFILE_PATH font 'Ubuntu Mono 11'
    echo "✓ Font set to Ubuntu Mono 11pt (good for development)"
else
    echo "✓ Custom font already configured"
fi

# Window and tab settings
echo ""
echo -e "${YELLOW}Window Settings:${NC}"
gsettings set $PROFILE_PATH default-size-columns 120
echo "✓ Default width set to 120 columns (good for code)"

gsettings set $PROFILE_PATH default-size-rows 30
echo "✓ Default height set to 30 rows"

gsettings set $PROFILE_PATH login-shell false
echo "✓ Login shell disabled (faster startup)"

# Palette and color settings (already configured via other scripts, but ensure consistency)
echo ""
echo -e "${YELLOW}Color Settings:${NC}"
gsettings set $PROFILE_PATH use-theme-colors false
echo "✓ Custom colors enabled (not using theme colors)"

# Text selection settings
gsettings set $PROFILE_PATH copy-selection true
echo "✓ Auto-copy text selection enabled"

# Scrolling behavior
echo ""
echo -e "${YELLOW}Scrolling Behavior:${NC}"
gsettings set $PROFILE_PATH scroll-on-keystroke true
echo "✓ Scroll to bottom on keystroke"

gsettings set $PROFILE_PATH scroll-on-output false
echo "✓ Don't scroll on output (maintain position when reading logs)"

# Exit behavior
echo ""
echo -e "${YELLOW}Exit Behavior:${NC}"
gsettings set $PROFILE_PATH exit-action 'close'
echo "✓ Close tab when command exits"

# Word characters (for double-click selection)
gsettings set $PROFILE_PATH word-chars '-A-Za-z0-9,./?%&#:_=+@~'
echo "✓ Word characters configured for code selection"

# Advanced settings
echo ""
echo -e "${YELLOW}Advanced Settings:${NC}"
gsettings set $PROFILE_PATH delete-binding 'delete-sequence'
echo "✓ Delete key behavior optimized"

gsettings set $PROFILE_PATH backspace-binding 'ascii-delete'
echo "✓ Backspace key behavior standardized"

# Encoding
gsettings set $PROFILE_PATH encoding 'UTF-8'
echo "✓ UTF-8 encoding set (international character support)"

echo ""
echo -e "${GREEN}✓ Terminal configured for development workflow!${NC}"
echo ""
echo -e "${BLUE}Configuration applied:${NC}"
echo "• Unlimited scrollback for long build outputs"
echo "• Cursor optimized for coding (block, no blinking)"
echo "• Visual bell instead of audible (less disruptive)"
echo "• 120x30 default size (good for code viewing)"
echo "• Auto-copy selection for easy copying"
echo "• Optimized scrolling behavior for log reading"
echo "• UTF-8 encoding for international support"
echo "• Word selection optimized for code"
echo ""
echo -e "${YELLOW}Note: Changes apply to new terminal windows/tabs.${NC}"
echo -e "${YELLOW}Current terminal may need restart to see all changes.${NC}"