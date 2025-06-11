#!/bin/bash

# Node.js Global Development Packages
# Installs essential global npm packages for development

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}📦 Installing Node.js Global Development Packages...${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if npm is available
if ! command_exists npm; then
    echo -e "${RED}✗ NPM not found. Please install Node.js first.${NC}"
    echo "Run the main setup script or install Node.js manually."
    exit 1
fi

# Check if global npm directory is configured properly
if ! npm config get prefix | grep -q "$HOME"; then
    echo -e "${YELLOW}⚠ Global npm directory not configured. Running dev-defaults.sh first...${NC}"
    if [ -f "./dev-defaults.sh" ]; then
        bash ./dev-defaults.sh
    else
        echo -e "${RED}✗ dev-defaults.sh not found. Please run it first to fix npm permissions.${NC}"
        exit 1
    fi
fi

echo -e "${YELLOW}Installing essential development tools...${NC}"
echo ""

# Essential development tools
PACKAGES=(
    "nodemon"                    # Auto-restart Node.js apps during development
    "live-server"               # Static file server with auto-reload
    "http-server"               # Simple HTTP server for static files
    "typescript"                # TypeScript compiler
    "ts-node"                   # TypeScript execution for Node.js
    "eslint"                    # JavaScript/TypeScript linter
    "prettier"                  # Code formatter
    "npm-check-updates"         # Check for package updates
    "serve"                     # Static file serving
    "json-server"               # Mock REST API server
)

# Framework-specific tools (popular choices)
FRAMEWORK_PACKAGES=(
    "create-react-app"          # React project generator
    "@vue/cli"                  # Vue.js project generator
    "express-generator"         # Express.js app generator
    "@angular/cli"              # Angular CLI (commented out by default - uncomment if needed)
)

# Development utilities
UTILITY_PACKAGES=(
    "pm2"                       # Process manager for Node.js
    "concurrently"              # Run multiple commands concurrently
    "cross-env"                 # Cross-platform environment variables
    "dotenv-cli"                # Load .env files
    "rimraf"                    # Cross-platform rm -rf
    "mkdirp"                    # Cross-platform mkdir -p
)

# Install essential packages
echo -e "${BLUE}Installing essential development tools...${NC}"
for package in "${PACKAGES[@]}"; do
    if npm list -g "$package" >/dev/null 2>&1; then
        echo "✓ $package already installed"
    else
        echo "Installing $package..."
        if npm install -g "$package"; then
            echo -e "${GREEN}✓ $package installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install $package${NC}"
        fi
    fi
done

echo ""
echo -e "${BLUE}Installing framework tools...${NC}"
for package in "${FRAMEWORK_PACKAGES[@]}"; do
    # Skip Angular CLI by default (it's large)
    if [[ "$package" == "@angular/cli" ]]; then
        echo "⏭ Skipping $package (uncomment in script if needed)"
        continue
    fi
    
    if npm list -g "$package" >/dev/null 2>&1; then
        echo "✓ $package already installed"
    else
        echo "Installing $package..."
        if npm install -g "$package"; then
            echo -e "${GREEN}✓ $package installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install $package${NC}"
        fi
    fi
done

echo ""
echo -e "${BLUE}Installing utility packages...${NC}"
for package in "${UTILITY_PACKAGES[@]}"; do
    if npm list -g "$package" >/dev/null 2>&1; then
        echo "✓ $package already installed"
    else
        echo "Installing $package..."
        if npm install -g "$package"; then
            echo -e "${GREEN}✓ $package installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install $package${NC}"
        fi
    fi
done

echo ""
echo -e "${GREEN}✓ Node.js global packages installation complete!${NC}"
echo ""
echo -e "${BLUE}Installed tools and their usage:${NC}"
echo ""
echo -e "${YELLOW}Development Servers:${NC}"
echo "• nodemon app.js          - Auto-restart Node.js app on changes"
echo "• live-server             - Static server with auto-reload"
echo "• http-server             - Simple static file server"
echo "• serve build/            - Serve static files from directory"
echo ""
echo -e "${YELLOW}Project Creation:${NC}"
echo "• create-react-app my-app - Create new React application"
echo "• vue create my-app       - Create new Vue.js application"
echo "• express myapp           - Create new Express.js application"
echo ""
echo -e "${YELLOW}Code Quality:${NC}"
echo "• eslint .                - Lint JavaScript/TypeScript files"
echo "• prettier --write .      - Format code files"
echo "• tsc                     - Compile TypeScript"
echo "• ts-node script.ts       - Run TypeScript directly"
echo ""
echo -e "${YELLOW}Development Utilities:${NC}"
echo "• json-server db.json     - Mock REST API from JSON file"
echo "• ncu                     - Check for package updates"
echo "• pm2 start app.js        - Production process management"
echo "• concurrently \"cmd1\" \"cmd2\" - Run multiple commands"
echo ""
echo -e "${YELLOW}Note: Make sure ~/.npm-global/bin is in your PATH${NC}"
echo -e "${YELLOW}Run 'source ~/.profile' or restart terminal if commands not found${NC}"