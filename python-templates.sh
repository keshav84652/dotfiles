#!/bin/bash

# Python Development Environment Setup
# Sets up UV package manager and creates simple project templates

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/common-functions.sh" ]; then
    source "$SCRIPT_DIR/common-functions.sh"
    init_log
else
    # Fallback color definitions
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    RED='\033[0;31m'
    NC='\033[0m'
    
    print_success() { echo -e "${GREEN}✓${NC} $1"; }
    print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
    print_error() { echo -e "${RED}✗${NC} $1"; }
    print_header() { echo -e "\n${BLUE}=== $1 ===${NC}"; }
fi

print_header "🐍 Python Development Environment Setup"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Python 3.11 is available
if ! command_exists python3.11; then
    print_error "Python 3.11 not found. Please install Python 3.11 first."
    exit 1
fi

# Check if UV is installed, install if not
if ! command_exists uv; then
    print_header "Installing UV Package Manager"
    python3.11 -m pip install --user uv
    
    # Add to PATH if not already there
    UV_PATH="$HOME/.local/bin"
    if [[ ":$PATH:" != *":$UV_PATH:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
        print_success "Added UV to PATH"
    fi
    
    print_success "UV package manager installed"
else
    print_success "UV package manager already available"
fi

# Create Python development directory
DEV_DIR="$HOME/Development/python-projects"
mkdir -p "$DEV_DIR"
print_success "Created Python projects directory: $DEV_DIR"

# Create project creation utility
cat > "$DEV_DIR/new-python-project" << 'EOF'
#!/bin/bash

# Python Project Creator with UV
# Usage: ./new-python-project <project-name> [template]

PROJECT_NAME="$1"
TEMPLATE="${2:-basic}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project-name> [template]"
    echo ""
    echo "Templates:"
    echo "  basic     - Basic Python project with UV"
    echo "  web       - Flask web application"
    echo "  api       - FastAPI application"
    echo "  data      - Data science project"
    echo ""
    echo "Examples:"
    echo "  $0 myapp basic"
    echo "  $0 myapi api"
    echo "  $0 webapp web"
    exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
    echo "❌ Project '$PROJECT_NAME' already exists!"
    exit 1
fi

echo "🚀 Creating Python project: $PROJECT_NAME (template: $template)"

# Create project directory
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize UV project
uv init --name "$PROJECT_NAME"

# Create basic structure
mkdir -p src tests docs

case "$TEMPLATE" in
    "basic")
        # Basic Python project
        cat > src/main.py << 'PYTHON_EOF'
"""
Main module for the application.
"""

def hello(name: str = "World") -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"

def main():
    """Main entry point."""
    print(hello())

if __name__ == "__main__":
    main()
PYTHON_EOF

        cat > tests/test_main.py << 'PYTHON_EOF'
"""
Tests for the main module.
"""
import pytest
from src.main import hello

def test_hello_default():
    assert hello() == "Hello, World!"

def test_hello_with_name():
    assert hello("Python") == "Hello, Python!"
PYTHON_EOF

        # Add pytest to dependencies
        uv add pytest --dev
        ;;
        
    "web")
        # Flask web application
        cat > src/app.py << 'PYTHON_EOF'
"""
Flask web application.
"""
from flask import Flask, render_template, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/hello')
@app.route('/api/hello/<name>')
def api_hello(name="World"):
    return jsonify({"message": f"Hello, {name}!"})

if __name__ == '__main__':
    app.run(debug=True)
PYTHON_EOF

        mkdir -p src/templates src/static
        cat > src/templates/index.html << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Flask App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2196F3; }
    </style>
</head>
<body>
    <h1>🐍 Flask Application</h1>
    <p>Your Flask app is running!</p>
    <p><a href="/api/hello">Test API</a></p>
</body>
</html>
HTML_EOF

        uv add flask pytest --dev
        ;;
        
    "api")
        # FastAPI application
        cat > src/main.py << 'PYTHON_EOF'
"""
FastAPI application.
"""
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="FastAPI Application", version="1.0.0")

class Message(BaseModel):
    text: str

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}

@app.post("/echo")
async def echo_message(message: Message):
    return {"echo": message.text}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
PYTHON_EOF

        uv add fastapi uvicorn pytest httpx --dev
        ;;
        
    "data")
        # Data science project
        cat > src/analysis.py << 'PYTHON_EOF'
"""
Data analysis module.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def load_sample_data():
    """Create sample dataset."""
    np.random.seed(42)
    data = {
        'x': np.random.randn(100),
        'y': np.random.randn(100),
        'category': np.random.choice(['A', 'B', 'C'], 100)
    }
    return pd.DataFrame(data)

def analyze_data(df):
    """Perform basic analysis."""
    print("Dataset Info:")
    print(df.info())
    print("\nSummary Statistics:")
    print(df.describe())
    
    # Create visualization
    plt.figure(figsize=(10, 6))
    for cat in df['category'].unique():
        subset = df[df['category'] == cat]
        plt.scatter(subset['x'], subset['y'], label=f'Category {cat}', alpha=0.7)
    
    plt.xlabel('X values')
    plt.ylabel('Y values')
    plt.title('Sample Data Visualization')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.savefig('analysis_plot.png', dpi=300, bbox_inches='tight')
    plt.show()

def main():
    """Main analysis function."""
    df = load_sample_data()
    analyze_data(df)

if __name__ == "__main__":
    main()
PYTHON_EOF

        mkdir -p notebooks data outputs
        
        cat > notebooks/exploration.ipynb << 'JSON_EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Data Exploration\n",
    "\n",
    "This notebook contains exploratory data analysis."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import sys\n",
    "sys.path.append('../src')\n",
    "\n",
    "from analysis import load_sample_data, analyze_data\n",
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load and explore data\n",
    "df = load_sample_data()\n",
    "analyze_data(df)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
JSON_EOF

        uv add pandas numpy matplotlib seaborn jupyter pytest --dev
        ;;
        
    *)
        echo "❌ Unknown template: $TEMPLATE"
        cd ..
        rm -rf "$PROJECT_NAME"
        exit 1
        ;;
esac

# Create common files for all templates
cat > README.md << README_EOF
# $PROJECT_NAME

A Python project created with UV package manager.

## Setup

1. Install dependencies:
   \`\`\`bash
   uv sync
   \`\`\`

2. Run the application:
   \`\`\`bash
   uv run src/main.py
   \`\`\`

3. Run tests:
   \`\`\`bash
   uv run pytest
   \`\`\`

## Development

- Add dependencies: \`uv add package-name\`
- Add dev dependencies: \`uv add package-name --dev\`
- Update dependencies: \`uv lock\`

## Project Structure

- \`src/\` - Source code
- \`tests/\` - Test files
- \`docs/\` - Documentation
README_EOF

cat > .gitignore << 'GITIGNORE_EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# UV
.uv/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Data files
*.csv
*.json
*.sqlite
*.db

# Jupyter Notebook
.ipynb_checkpoints

# Output files
*.png
*.jpg
*.pdf
outputs/
GITIGNORE_EOF

echo "✅ Project '$PROJECT_NAME' created successfully!"
echo ""
echo "📁 Project location: $(pwd)"
echo ""
echo "🚀 Quick start:"
echo "  cd $PROJECT_NAME"
echo "  uv sync          # Install dependencies"
echo "  uv run src/main.py   # Run the application"
echo "  uv run pytest   # Run tests"
echo ""
EOF

chmod +x "$DEV_DIR/new-python-project"

# Create UV configuration file
cat > "$HOME/.config/uv/uv.toml" << 'EOF' 2>/dev/null || mkdir -p "$HOME/.config/uv" && cat > "$HOME/.config/uv/uv.toml" << 'EOF'
# UV Configuration
# Global settings for UV package manager

[pip]
# Use pre-compiled wheels when available
prefer-binary = true

# Enable faster dependency resolution
resolution = "highest"

[tool.uv]
# Default Python version
python = "3.11"

# Cache directory (optional, UV will use default if not specified)
# cache-dir = "~/.cache/uv"
EOF

print_success "Created project creation utility"
print_success "Configured UV with optimized settings"

# Create global development utilities
cat > "$HOME/.local/bin/python-dev" << 'EOF'
#!/bin/bash

# Python Development Utilities
# Quick commands for Python development with UV

case "$1" in
    "new")
        if [ -z "$2" ]; then
            echo "Usage: python-dev new <project-name> [template]"
            echo "Templates: basic, web, api, data"
            exit 1
        fi
        DEV_DIR="$HOME/Development/python-projects"
        cd "$DEV_DIR" && ./new-python-project "$2" "$3"
        ;;
    "venv")
        echo "🐍 Creating virtual environment with UV..."
        uv venv
        echo "✅ Virtual environment created!"
        echo "💡 Activate with: source .venv/bin/activate"
        ;;
    "install")
        echo "📦 Installing dependencies with UV..."
        uv sync
        ;;
    "add")
        if [ -z "$2" ]; then
            echo "Usage: python-dev add <package-name>"
            exit 1
        fi
        echo "➕ Adding package: $2"
        uv add "$2"
        ;;
    "run")
        shift
        echo "🏃 Running with UV: $*"
        uv run "$@"
        ;;
    "test")
        echo "🧪 Running tests..."
        uv run pytest
        ;;
    "fmt")
        echo "🎨 Formatting code..."
        if uv run black --version >/dev/null 2>&1; then
            uv run black .
        else
            echo "Installing black..."
            uv add black --dev
            uv run black .
        fi
        ;;
    *)
        echo "🐍 Python Development Utilities"
        echo ""
        echo "Usage: python-dev <command> [args]"
        echo ""
        echo "Commands:"
        echo "  new <name> [template]  Create new project"
        echo "  venv                   Create virtual environment"
        echo "  install                Install dependencies"
        echo "  add <package>          Add package"
        echo "  run <command>          Run command with UV"
        echo "  test                   Run tests"
        echo "  fmt                    Format code with black"
        echo ""
        echo "Examples:"
        echo "  python-dev new myapp web"
        echo "  python-dev add fastapi"
        echo "  python-dev run main.py"
        ;;
esac
EOF

chmod +x "$HOME/.local/bin/python-dev"

print_success "Created global python-dev utility"

print_header "🎯 Quick Start Guide"
echo ""
print_success "Python development tools configured!"
echo ""
echo "💡 Quick commands:"
echo "  • Create new project:  python-dev new myapp web"
echo "  • Create basic project: python-dev new myapp basic"
echo "  • Add packages:        python-dev add fastapi"
echo "  • Run tests:           python-dev test"
echo "  • Format code:         python-dev fmt"
echo ""
echo "📁 Project templates available:"
echo "  • basic - Simple Python project"
echo "  • web   - Flask web application"
echo "  • api   - FastAPI REST API"
echo "  • data  - Data science project with Jupyter"
echo ""
echo "🔗 Learn more:"
echo "  • UV documentation: https://docs.astral.sh/uv/"
echo "  • Python packaging: https://packaging.python.org/"
echo ""

print_header "✅ Python Development Environment Setup Complete"

if command_exists finalize_log; then
    finalize_log "Python Development Setup"
fi