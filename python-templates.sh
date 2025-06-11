#!/bin/bash

# Python Development Templates and Environment Setup
# Creates project templates and virtual environment helpers

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🐍 Setting up Python Development Templates...${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Python is available
if ! command_exists python3; then
    echo -e "${RED}✗ Python3 not found. Please install Python first.${NC}"
    exit 1
fi

# Create Templates directory
TEMPLATES_DIR="$HOME/Templates"
PYTHON_TEMPLATES_DIR="$TEMPLATES_DIR/Python"

echo -e "${YELLOW}Creating template directories...${NC}"
mkdir -p "$PYTHON_TEMPLATES_DIR"
echo "✓ Created $PYTHON_TEMPLATES_DIR"

# Flask Web Application Template
echo ""
echo -e "${YELLOW}Creating Flask web application template...${NC}"
FLASK_DIR="$PYTHON_TEMPLATES_DIR/Flask-WebApp"
mkdir -p "$FLASK_DIR"/{app/{templates,static/{css,js}},tests}

# Flask app.py
cat > "$FLASK_DIR/app.py" << 'EOF'
from flask import Flask, render_template, request, jsonify
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key')
app.config['DEBUG'] = os.getenv('DEBUG', 'True').lower() == 'true'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/health')
def health_check():
    return jsonify({'status': 'healthy', 'message': 'Flask app is running'})

@app.route('/api/data')
def get_data():
    # Example API endpoint
    sample_data = {
        'users': [
            {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
            {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'}
        ]
    }
    return jsonify(sample_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=app.config['DEBUG'])
EOF

# Flask HTML template
cat > "$FLASK_DIR/app/templates/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask Web App</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Flask Web Application</h1>
        <p>Welcome to your Flask web application template!</p>
        
        <div class="api-test">
            <h2>API Test</h2>
            <button onclick="testAPI()">Test API Endpoint</button>
            <div id="api-result"></div>
        </div>
    </div>
    
    <script src="{{ url_for('static', filename='js/app.js') }}"></script>
</body>
</html>
EOF

# Flask CSS
cat > "$FLASK_DIR/app/static/css/style.css" << 'EOF'
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background-color: #f5f5f5;
}

.container {
    background: white;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

h1 {
    color: #333;
    text-align: center;
}

.api-test {
    margin-top: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 5px;
}

button {
    background: #007bff;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background: #0056b3;
}

#api-result {
    margin-top: 15px;
    padding: 10px;
    background: #e9ecef;
    border-radius: 3px;
    min-height: 20px;
}
EOF

# Flask JavaScript
cat > "$FLASK_DIR/app/static/js/app.js" << 'EOF'
async function testAPI() {
    const resultDiv = document.getElementById('api-result');
    resultDiv.innerHTML = 'Loading...';
    
    try {
        const response = await fetch('/api/data');
        const data = await response.json();
        resultDiv.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
    } catch (error) {
        resultDiv.innerHTML = `Error: ${error.message}`;
    }
}

// Test health endpoint on page load
window.addEventListener('load', async () => {
    try {
        const response = await fetch('/api/health');
        const data = await response.json();
        console.log('Health check:', data);
    } catch (error) {
        console.error('Health check failed:', error);
    }
});
EOF

# Flask requirements.txt
cat > "$FLASK_DIR/requirements.txt" << 'EOF'
Flask==2.3.3
python-dotenv==1.0.0
requests==2.31.0
pytest==7.4.2
pytest-flask==1.2.0
EOF

# Flask .env template
cat > "$FLASK_DIR/.env.example" << 'EOF'
# Flask Configuration
FLASK_ENV=development
DEBUG=True
SECRET_KEY=your-secret-key-here

# Database (if using)
DATABASE_URL=sqlite:///app.db

# API Keys (if needed)
# API_KEY=your-api-key-here
EOF

# Flask .gitignore
cat > "$FLASK_DIR/.gitignore" << 'EOF'
# Virtual Environment
venv/
env/
.venv/

# Environment Variables
.env

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so
.pytest_cache/

# Flask
instance/
.webassets-cache

# Database
*.db
*.sqlite

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF

# Flask README
cat > "$FLASK_DIR/README.md" << 'EOF'
# Flask Web Application

A simple Flask web application template with modern structure.

## Setup

1. Create virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. Run the application:
   ```bash
   python app.py
   ```

5. Open http://localhost:5000 in your browser

## Project Structure

```
├── app.py              # Main application file
├── app/
│   ├── templates/      # HTML templates
│   └── static/         # CSS, JS, images
├── tests/              # Test files
├── requirements.txt    # Python dependencies
├── .env.example       # Environment variables template
└── README.md          # This file
```

## API Endpoints

- `GET /` - Main page
- `GET /api/health` - Health check
- `GET /api/data` - Sample data endpoint

## Development

- The app runs in debug mode by default
- Templates and static files are automatically reloaded
- Add new routes in `app.py`
- Add tests in the `tests/` directory
EOF

echo "✓ Flask web application template created"

# Django Project Template
echo ""
echo -e "${YELLOW}Creating Django project template...${NC}"
DJANGO_DIR="$PYTHON_TEMPLATES_DIR/Django-Project"
mkdir -p "$DJANGO_DIR"

cat > "$DJANGO_DIR/requirements.txt" << 'EOF'
Django==4.2.7
django-environ==0.11.2
djangorestframework==3.14.0
django-cors-headers==4.3.1
pillow==10.0.1
pytest-django==4.5.2
EOF

cat > "$DJANGO_DIR/.env.example" << 'EOF'
# Django Configuration
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DATABASE_URL=sqlite:///db.sqlite3

# Email (if needed)
# EMAIL_HOST=smtp.gmail.com
# EMAIL_PORT=587
# EMAIL_USE_TLS=True
# EMAIL_HOST_USER=your-email@gmail.com
# EMAIL_HOST_PASSWORD=your-password
EOF

cat > "$DJANGO_DIR/setup_django.sh" << 'EOF'
#!/bin/bash
# Django project setup script

echo "Setting up Django project..."

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create Django project
django-admin startproject myproject .

# Create initial app
python manage.py startapp myapp

# Copy environment file
cp .env.example .env

echo "Django project setup complete!"
echo "Activate virtual environment: source venv/bin/activate"
echo "Run migrations: python manage.py migrate"
echo "Create superuser: python manage.py createsuperuser"
echo "Start server: python manage.py runserver"
EOF

chmod +x "$DJANGO_DIR/setup_django.sh"
echo "✓ Django project template created"

# Data Science Template
echo ""
echo -e "${YELLOW}Creating Data Science project template...${NC}"
DS_DIR="$PYTHON_TEMPLATES_DIR/DataScience-Project"
mkdir -p "$DS_DIR"/{data/{raw,processed},notebooks,src,models,reports,tests}

cat > "$DS_DIR/requirements.txt" << 'EOF'
# Data Science Stack
pandas==2.1.1
numpy==1.24.3
matplotlib==3.7.2
seaborn==0.12.2
scikit-learn==1.3.0
jupyter==1.0.0
ipykernel==6.25.0

# Data Processing
requests==2.31.0
beautifulsoup4==4.12.2
openpyxl==3.1.2

# Visualization
plotly==5.17.0
bokeh==3.2.2

# Development
pytest==7.4.2
black==23.7.0
flake8==6.0.0
EOF

cat > "$DS_DIR/src/data_processor.py" << 'EOF'
"""
Data processing utilities for the project.
"""
import pandas as pd
import numpy as np
from pathlib import Path

class DataProcessor:
    """Handle data loading, cleaning, and preprocessing."""
    
    def __init__(self, data_path: str = "data/raw"):
        self.data_path = Path(data_path)
        
    def load_data(self, filename: str) -> pd.DataFrame:
        """Load data from file."""
        file_path = self.data_path / filename
        
        if filename.endswith('.csv'):
            return pd.read_csv(file_path)
        elif filename.endswith('.xlsx'):
            return pd.read_excel(file_path)
        else:
            raise ValueError(f"Unsupported file type: {filename}")
    
    def clean_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Basic data cleaning operations."""
        # Remove duplicates
        df = df.drop_duplicates()
        
        # Handle missing values (customize as needed)
        df = df.dropna()
        
        return df
    
    def save_processed_data(self, df: pd.DataFrame, filename: str):
        """Save processed data."""
        output_path = Path("data/processed") / filename
        output_path.parent.mkdir(parents=True, exist_ok=True)
        df.to_csv(output_path, index=False)
        print(f"Data saved to {output_path}")

if __name__ == "__main__":
    # Example usage
    processor = DataProcessor()
    # df = processor.load_data("sample_data.csv")
    # cleaned_df = processor.clean_data(df)
    # processor.save_processed_data(cleaned_df, "cleaned_data.csv")
    print("DataProcessor ready to use!")
EOF

cat > "$DS_DIR/notebooks/01_data_exploration.ipynb" << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Data Exploration\n",
    "\n",
    "Initial exploration of the dataset."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n",
    "import seaborn as sns\n",
    "\n",
    "# Set up plotting\n",
    "plt.style.use('default')\n",
    "sns.set_palette(\"husl\")\n",
    "%matplotlib inline"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Load your data here\n",
    "# df = pd.read_csv('../data/raw/your_data.csv')\n",
    "# df.head()"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Data Overview"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Data shape and info\n",
    "# print(f\"Dataset shape: {df.shape}\")\n",
    "# df.info()"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Statistical Summary"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# df.describe()"
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
   "version": "3.8.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

cat > "$DS_DIR/README.md" << 'EOF'
# Data Science Project Template

A structured template for data science projects.

## Project Structure

```
├── data/
│   ├── raw/            # Original, immutable data
│   └── processed/      # Cleaned, transformed data
├── notebooks/          # Jupyter notebooks for exploration
├── src/               # Source code for the project
├── models/            # Trained models
├── reports/           # Generated reports and visualizations
├── tests/             # Test files
└── requirements.txt   # Python dependencies
```

## Setup

1. Create virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Start Jupyter:
   ```bash
   jupyter notebook
   ```

## Workflow

1. Place raw data in `data/raw/`
2. Use notebooks for initial exploration
3. Write reusable code in `src/`
4. Save processed data to `data/processed/`
5. Store trained models in `models/`
6. Generate reports in `reports/`
EOF

echo "✓ Data Science project template created"

# API Template (FastAPI)
echo ""
echo -e "${YELLOW}Creating FastAPI REST API template...${NC}"
API_DIR="$PYTHON_TEMPLATES_DIR/FastAPI-REST"
mkdir -p "$API_DIR"/{app/{api,models,schemas,core},tests}

cat > "$API_DIR/requirements.txt" << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.4.2
python-multipart==0.0.6
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-dotenv==1.0.0
sqlalchemy==2.0.23
alembic==1.12.1
pytest==7.4.2
httpx==0.25.1
EOF

cat > "$API_DIR/main.py" << 'EOF'
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn

# Create FastAPI instance
app = FastAPI(
    title="My API",
    description="A simple REST API built with FastAPI",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    price: float
    in_stock: bool = True

class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    in_stock: bool = True

# In-memory storage (replace with database in production)
items_db = []
next_id = 1

@app.get("/")
async def root():
    """Root endpoint"""
    return {"message": "Welcome to My API", "docs": "/docs"}

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

@app.get("/items", response_model=List[Item])
async def get_items():
    """Get all items"""
    return items_db

@app.get("/items/{item_id}", response_model=Item)
async def get_item(item_id: int):
    """Get a specific item by ID"""
    for item in items_db:
        if item.id == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item not found")

@app.post("/items", response_model=Item)
async def create_item(item: ItemCreate):
    """Create a new item"""
    global next_id
    new_item = Item(id=next_id, **item.dict())
    items_db.append(new_item)
    next_id += 1
    return new_item

@app.put("/items/{item_id}", response_model=Item)
async def update_item(item_id: int, item: ItemCreate):
    """Update an existing item"""
    for i, existing_item in enumerate(items_db):
        if existing_item.id == item_id:
            updated_item = Item(id=item_id, **item.dict())
            items_db[i] = updated_item
            return updated_item
    raise HTTPException(status_code=404, detail="Item not found")

@app.delete("/items/{item_id}")
async def delete_item(item_id: int):
    """Delete an item"""
    for i, item in enumerate(items_db):
        if item.id == item_id:
            del items_db[i]
            return {"message": "Item deleted successfully"}
    raise HTTPException(status_code=404, detail="Item not found")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

cat > "$API_DIR/README.md" << 'EOF'
# FastAPI REST API Template

A modern REST API built with FastAPI.

## Features

- Fast and modern Python web framework
- Automatic API documentation (Swagger/OpenAPI)
- Type hints and validation with Pydantic
- CORS support
- Easy testing

## Setup

1. Create virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the API:
   ```bash
   python main.py
   # or
   uvicorn main:app --reload
   ```

4. Open http://localhost:8000/docs for interactive API documentation

## API Endpoints

- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /items` - Get all items
- `GET /items/{id}` - Get specific item
- `POST /items` - Create new item
- `PUT /items/{id}` - Update item
- `DELETE /items/{id}` - Delete item

## Testing

```bash
pytest tests/
```

## Production Deployment

Replace in-memory storage with a proper database (PostgreSQL, MySQL, etc.)
Configure environment variables for production settings.
EOF

echo "✓ FastAPI REST API template created"

# Create a quick setup script
echo ""
echo -e "${YELLOW}Creating Python project quick-setup script...${NC}"
cat > "$HOME/.local/bin/new-python-project" << 'EOF'
#!/bin/bash
# Quick Python project setup script

if [ -z "$1" ]; then
    echo "Usage: new-python-project <project-name> [template]"
    echo "Templates: flask, django, datascience, fastapi"
    exit 1
fi

PROJECT_NAME="$1"
TEMPLATE="${2:-flask}"
TEMPLATES_DIR="$HOME/Templates/Python"

case "$TEMPLATE" in
    "flask")
        echo "Creating Flask project: $PROJECT_NAME"
        cp -r "$TEMPLATES_DIR/Flask-WebApp" "$PROJECT_NAME"
        ;;
    "django")
        echo "Creating Django project: $PROJECT_NAME"
        cp -r "$TEMPLATES_DIR/Django-Project" "$PROJECT_NAME"
        ;;
    "datascience"|"ds")
        echo "Creating Data Science project: $PROJECT_NAME"
        cp -r "$TEMPLATES_DIR/DataScience-Project" "$PROJECT_NAME"
        ;;
    "fastapi"|"api")
        echo "Creating FastAPI project: $PROJECT_NAME"
        cp -r "$TEMPLATES_DIR/FastAPI-REST" "$PROJECT_NAME"
        ;;
    *)
        echo "Unknown template: $template"
        echo "Available templates: flask, django, datascience, fastapi"
        exit 1
        ;;
esac

cd "$PROJECT_NAME"
echo "Project created! Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. python3 -m venv venv"
echo "3. source venv/bin/activate"
echo "4. pip install -r requirements.txt"
EOF

chmod +x "$HOME/.local/bin/new-python-project"
echo "✓ Quick setup script created at ~/.local/bin/new-python-project"

echo ""
echo -e "${GREEN}✓ Python development templates setup complete!${NC}"
echo ""
echo -e "${BLUE}Created templates:${NC}"
echo "• Flask Web Application  - $PYTHON_TEMPLATES_DIR/Flask-WebApp"
echo "• Django Project        - $PYTHON_TEMPLATES_DIR/Django-Project"
echo "• Data Science Project  - $PYTHON_TEMPLATES_DIR/DataScience-Project"
echo "• FastAPI REST API      - $PYTHON_TEMPLATES_DIR/FastAPI-REST"
echo ""
echo -e "${BLUE}Quick project creation:${NC}"
echo "• new-python-project myapp flask"
echo "• new-python-project myapi fastapi"
echo "• new-python-project analysis datascience"
echo "• new-python-project webapp django"
echo ""
echo -e "${YELLOW}Note: Templates are in your ~/Templates/Python directory${NC}"
echo -e "${YELLOW}Make sure ~/.local/bin is in your PATH for the quick setup script${NC}"