# 🐍 Python Development Guide

This guide covers using the Python development environment with UV package manager.

## Quick Start

After running the setup, you can create Python projects with:

```bash
python-dev new myproject web
cd ~/Development/python-projects/myproject
uv sync
uv run src/main.py
```

## UV Package Manager

UV is a fast Python package manager that replaces pip. It's significantly faster and provides better dependency resolution.

### Basic Commands

```bash
# Install dependencies
uv sync

# Add a package
uv add requests

# Add development dependency
uv add pytest --dev

# Remove a package
uv remove requests

# Run Python with UV
uv run python script.py

# Create virtual environment
uv venv
```

## Project Templates

### Available Templates

1. **basic** - Simple Python project structure
2. **web** - Flask web application
3. **api** - FastAPI REST API
4. **data** - Data science project with Jupyter

### Creating Projects

```bash
# Basic Python project
python-dev new myapp basic

# Flask web application
python-dev new webapp web

# FastAPI API server
python-dev new api-server api

# Data science project
python-dev new analysis data
```

## Template Details

### Basic Template

**Structure:**
```
myapp/
├── src/
│   └── main.py
├── tests/
│   └── test_main.py
├── docs/
├── README.md
├── .gitignore
└── pyproject.toml
```

**Usage:**
```bash
cd myapp
uv sync              # Install dependencies
uv run src/main.py   # Run the application
uv run pytest       # Run tests
```

### Web Template (Flask)

**Structure:**
```
webapp/
├── src/
│   ├── app.py
│   ├── templates/
│   │   └── index.html
│   └── static/
├── tests/
├── README.md
└── pyproject.toml
```

**Usage:**
```bash
cd webapp
uv sync                    # Install Flask and dependencies
uv run src/app.py         # Start development server
# Visit http://localhost:5000
```

**Features:**
- Flask web framework
- HTML templates
- API endpoints
- Development server

### API Template (FastAPI)

**Structure:**
```
api-server/
├── src/
│   └── main.py
├── tests/
├── README.md
└── pyproject.toml
```

**Usage:**
```bash
cd api-server
uv sync                           # Install FastAPI and dependencies
uv run src/main.py               # Start API server
# Visit http://localhost:8000/docs for API documentation
```

**Features:**
- FastAPI framework
- Automatic API documentation
- Type hints and validation
- Async support

### Data Template

**Structure:**
```
analysis/
├── src/
│   └── analysis.py
├── notebooks/
│   └── exploration.ipynb
├── data/
├── outputs/
├── tests/
├── README.md
└── pyproject.toml
```

**Usage:**
```bash
cd analysis
uv sync                      # Install data science packages
uv run src/analysis.py      # Run analysis script
uv run jupyter notebook     # Start Jupyter notebook
```

**Features:**
- Pandas, NumPy, Matplotlib
- Jupyter notebook setup
- Data analysis structure
- Visualization examples

## Development Workflow

### 1. Create and Setup Project

```bash
# Create new project
python-dev new myproject web

# Navigate to project
cd ~/Development/python-projects/myproject

# Install dependencies
uv sync
```

### 2. Development

```bash
# Add new dependencies
uv add requests beautifulsoup4

# Add development tools
uv add black flake8 pytest --dev

# Run your application
uv run src/main.py

# Format code
python-dev fmt

# Run tests
python-dev test
```

### 3. Package Management

```bash
# Update dependencies
uv lock

# Show installed packages
uv pip list

# Show dependency tree
uv pip show --tree

# Export requirements
uv pip compile pyproject.toml
```

## Python Development Utilities

The `python-dev` command provides convenient shortcuts:

```bash
# Create new project
python-dev new <name> [template]

# Create virtual environment
python-dev venv

# Install dependencies
python-dev install

# Add package
python-dev add <package>

# Run command with UV
python-dev run <command>

# Run tests
python-dev test

# Format code
python-dev fmt
```

## Virtual Environments

UV automatically manages virtual environments, but you can control them:

```bash
# Create virtual environment
uv venv

# Activate manually (usually not needed)
source .venv/bin/activate

# Deactivate
deactivate

# Remove virtual environment
rm -rf .venv
```

## Configuration

### UV Configuration

Global UV settings are in `~/.config/uv/uv.toml`:

```toml
[pip]
prefer-binary = true
resolution = "highest"

[tool.uv]
python = "3.11"
```

### Project Configuration

Each project has a `pyproject.toml` file:

```toml
[project]
name = "myproject"
version = "0.1.0"
description = "My Python project"
dependencies = [
    "requests>=2.31.0",
]

[tool.uv]
dev-dependencies = [
    "pytest>=7.0.0",
    "black>=23.0.0",
]
```

## Common Tasks

### Web Development

```bash
# Create Flask app
python-dev new webapp web
cd ~/Development/python-projects/webapp

# Add web dependencies
uv add flask-sqlalchemy flask-login

# Run development server
uv run src/app.py
```

### API Development

```bash
# Create FastAPI app
python-dev new api api
cd ~/Development/python-projects/api

# Add database support
uv add sqlalchemy psycopg2-binary

# Run with auto-reload
uv run uvicorn src.main:app --reload
```

### Data Science

```bash
# Create data project
python-dev new analysis data
cd ~/Development/python-projects/analysis

# Add machine learning libraries
uv add scikit-learn

# Start Jupyter
uv run jupyter notebook
```

## Troubleshooting

### Common Issues

**UV not found:**
```bash
# Ensure UV is in PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

**Permission errors:**
```bash
# Use --user flag for pip installations
python3.11 -m pip install --user uv
```

**Python version issues:**
```bash
# Specify Python version
uv venv --python 3.11

# Check Python version
uv run python --version
```

### Performance Tips

1. **Use UV instead of pip** - Much faster dependency resolution
2. **Enable binary wheels** - Set `prefer-binary = true` in config
3. **Use virtual environments** - Avoid global package conflicts
4. **Cache dependencies** - UV automatically caches downloads

## Learn More

- [UV Documentation](https://docs.astral.sh/uv/)
- [Python Packaging Guide](https://packaging.python.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Jupyter Documentation](https://jupyter.org/documentation)