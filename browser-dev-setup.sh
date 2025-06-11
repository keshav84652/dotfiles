#!/bin/bash

# Browser Developer Setup
# Configures Chrome/Firefox for web development

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🌐 Configuring Browser for Web Development...${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Chrome Developer Setup
if command_exists google-chrome; then
    echo -e "${YELLOW}Configuring Google Chrome for development...${NC}"
    
    # Create Chrome developer profile directory
    CHROME_DEV_DIR="$HOME/.config/google-chrome/Developer"
    mkdir -p "$CHROME_DEV_DIR"
    
    # Chrome developer flags (create a desktop entry)
    cat > "$HOME/.local/share/applications/chrome-dev.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Name=Chrome Developer
Comment=Google Chrome with developer flags
Exec=google-chrome --disable-web-security --disable-features=VizDisplayCompositor --user-data-dir=/tmp/chrome-dev --allow-running-insecure-content --disable-extensions --no-first-run --disable-default-apps
Icon=google-chrome
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
EOF
    
    echo "✓ Chrome developer profile configured"
    echo "✓ Chrome developer launcher created"
    
    # Create bookmarks file with development resources
    CHROME_BOOKMARKS_DIR="$HOME/.config/google-chrome/Default"
    mkdir -p "$CHROME_BOOKMARKS_DIR"
    
    cat > "$CHROME_BOOKMARKS_DIR/developer_bookmarks.html" << 'EOF'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Developer Bookmarks</TITLE>
<H1>Developer Bookmarks</H1>
<DL><p>
    <DT><H3>Development Tools</H3>
    <DL><p>
        <DT><A HREF="http://localhost:3000">React Dev Server</A>
        <DT><A HREF="http://localhost:8000">Python Dev Server</A>
        <DT><A HREF="http://localhost:5000">Flask App</A>
        <DT><A HREF="http://localhost:8080">Vue Dev Server</A>
        <DT><A HREF="http://localhost:4200">Angular Dev Server</A>
    </DL><p>
    <DT><H3>Documentation</H3>
    <DL><p>
        <DT><A HREF="https://developer.mozilla.org/">MDN Web Docs</A>
        <DT><A HREF="https://devdocs.io/">DevDocs</A>
        <DT><A HREF="https://caniuse.com/">Can I Use</A>
        <DT><A HREF="https://regex101.com/">Regex101</A>
        <DT><A HREF="https://jsonformatter.org/">JSON Formatter</A>
    </DL><p>
    <DT><H3>Tools</H3>
    <DL><p>
        <DT><A HREF="https://github.com/">GitHub</A>
        <DT><A HREF="https://codepen.io/">CodePen</A>
        <DT><A HREF="https://jsfiddle.net/">JSFiddle</A>
        <DT><A HREF="https://stackoverflow.com/">Stack Overflow</A>
        <DT><A HREF="https://npmjs.com/">NPM Registry</A>
    </DL><p>
</DL><p>
EOF
    
    echo "✓ Developer bookmarks template created"
    
else
    echo -e "${RED}✗ Google Chrome not found${NC}"
fi

# Firefox Developer Setup
if command_exists firefox; then
    echo ""
    echo -e "${YELLOW}Firefox Developer Edition information...${NC}"
    echo "Consider installing Firefox Developer Edition for:"
    echo "• Advanced developer tools"
    echo "• CSS Grid inspector"
    echo "• Experimental web features"
    echo "• Download: https://www.mozilla.org/firefox/developer/"
    echo ""
fi

# Browser Extensions Recommendations
echo ""
echo -e "${YELLOW}Recommended Browser Extensions for Web Development:${NC}"
echo ""

echo -e "${BLUE}Essential Extensions:${NC}"
cat << 'EOF'
• React Developer Tools - Debug React components
  Chrome: https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi
  
• Vue.js devtools - Debug Vue.js applications
  Chrome: https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd
  
• Angular DevTools - Debug Angular applications
  Chrome: https://chrome.google.com/webstore/detail/angular-devtools/ienfalfjdbdpebioblfackkekamfmbnh
  
• Web Developer - Web development tools
  Chrome: https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm
  
• JSON Viewer - Pretty print JSON
  Chrome: https://chrome.google.com/webstore/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh
EOF

echo ""
echo -e "${BLUE}Productivity Extensions:${NC}"
cat << 'EOF'
• ColorZilla - Color picker and eyedropper
  Chrome: https://chrome.google.com/webstore/detail/colorzilla/bhlhnicpbhignbdhedgjhgdocnmhomnp
  
• WhatFont - Identify fonts on web pages
  Chrome: https://chrome.google.com/webstore/detail/whatfont/jabopobgcpjmedljpbcaablpmlmfcogm
  
• Window Resizer - Test responsive designs
  Chrome: https://chrome.google.com/webstore/detail/window-resizer/kkelicaakdanhinjdeammmilcgefonfh
  
• Lighthouse - Performance and SEO auditing
  (Built into Chrome DevTools)
  
• WAVE Web Accessibility Evaluator - Accessibility testing
  Chrome: https://chrome.google.com/webstore/detail/wave-evaluation-tool/jbbplnpkjmmeebjpijfedlgcdilocofh
EOF

# Create a script to open development URLs
echo ""
echo -e "${YELLOW}Creating development URL launcher...${NC}"
cat > "$HOME/.local/bin/dev-urls" << 'EOF'
#!/bin/bash
# Quick launcher for common development URLs

case "$1" in
    "react"|"r")
        google-chrome http://localhost:3000 >/dev/null 2>&1 &
        echo "Opening React dev server (http://localhost:3000)"
        ;;
    "vue"|"v")
        google-chrome http://localhost:8080 >/dev/null 2>&1 &
        echo "Opening Vue dev server (http://localhost:8080)"
        ;;
    "angular"|"ng"|"a")
        google-chrome http://localhost:4200 >/dev/null 2>&1 &
        echo "Opening Angular dev server (http://localhost:4200)"
        ;;
    "flask"|"f")
        google-chrome http://localhost:5000 >/dev/null 2>&1 &
        echo "Opening Flask app (http://localhost:5000)"
        ;;
    "python"|"py"|"p")
        google-chrome http://localhost:8000 >/dev/null 2>&1 &
        echo "Opening Python dev server (http://localhost:8000)"
        ;;
    "express"|"node"|"n")
        google-chrome http://localhost:3000 >/dev/null 2>&1 &
        echo "Opening Express/Node server (http://localhost:3000)"
        ;;
    "docs"|"d")
        google-chrome https://developer.mozilla.org/en-US/ >/dev/null 2>&1 &
        echo "Opening MDN Web Docs"
        ;;
    "github"|"gh"|"g")
        google-chrome https://github.com >/dev/null 2>&1 &
        echo "Opening GitHub"
        ;;
    "stackoverflow"|"so"|"s")
        google-chrome https://stackoverflow.com >/dev/null 2>&1 &
        echo "Opening Stack Overflow"
        ;;
    *)
        echo "Development URL Launcher"
        echo "Usage: dev-urls <shortcut>"
        echo ""
        echo "Available shortcuts:"
        echo "  react, r     - http://localhost:3000 (React)"
        echo "  vue, v       - http://localhost:8080 (Vue)"
        echo "  angular, ng  - http://localhost:4200 (Angular)"
        echo "  flask, f     - http://localhost:5000 (Flask)"
        echo "  python, py   - http://localhost:8000 (Python)"
        echo "  express, n   - http://localhost:3000 (Express/Node)"
        echo "  docs, d      - MDN Web Docs"
        echo "  github, gh   - GitHub"
        echo "  stackoverflow, so - Stack Overflow"
        ;;
esac
EOF

chmod +x "$HOME/.local/bin/dev-urls"
echo "✓ Development URL launcher created"

# Developer Tools Setup Script
echo ""
echo -e "${YELLOW}Creating browser developer tools setup script...${NC}"
cat > "$HOME/.local/bin/setup-browser-dev" << 'EOF'
#!/bin/bash
# Setup browser for development session

echo "Setting up browser for development..."

# Kill existing Chrome processes to start fresh
pkill -f "chrome" 2>/dev/null

# Start Chrome with development flags
google-chrome \
  --disable-web-security \
  --disable-features=VizDisplayCompositor \
  --user-data-dir=/tmp/chrome-dev-session \
  --allow-running-insecure-content \
  --disable-default-apps \
  --no-first-run \
  --disable-background-timer-throttling \
  --disable-backgrounding-occluded-windows \
  --disable-renderer-backgrounding \
  --new-window \
  "http://localhost:3000" \
  "http://localhost:8000" \
  "http://localhost:5000" \
  "https://developer.mozilla.org/" >/dev/null 2>&1 &

echo "Chrome started with development configuration"
echo "Opened tabs for common development ports"
EOF

chmod +x "$HOME/.local/bin/setup-browser-dev"
echo "✓ Browser development setup script created"

echo ""
echo -e "${GREEN}✓ Browser development environment configured!${NC}"
echo ""
echo -e "${BLUE}Configuration completed:${NC}"
echo "• Chrome developer profile and launcher created"
echo "• Developer bookmarks template ready"
echo "• Quick URL launcher: dev-urls <shortcut>"
echo "• Development session script: setup-browser-dev"
echo ""
echo -e "${BLUE}Quick commands:${NC}"
echo "• dev-urls react      - Open React dev server"
echo "• dev-urls docs       - Open MDN documentation"
echo "• dev-urls github     - Open GitHub"
echo "• setup-browser-dev   - Start browser with dev flags"
echo ""
echo -e "${YELLOW}Recommended next steps:${NC}"
echo "1. Install browser extensions from the list above"
echo "2. Import developer bookmarks in your browser"
echo "3. Configure browser DevTools settings"
echo "4. Set up browser sync if using multiple devices"
echo ""
echo -e "${YELLOW}Note: Development shortcuts require Chrome to be installed${NC}"