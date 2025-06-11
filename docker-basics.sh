#!/bin/bash

# Docker Development Environment Setup
# Sets up Docker with common development containers and templates

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🐳 Setting up Docker Development Environment...${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
    echo -e "${RED}✗ Docker not found. Please install Docker first.${NC}"
    echo "Install with: sudo apt install docker.io docker-compose"
    exit 1
fi

# Check if user is in docker group
if ! groups $USER | grep -q "\bdocker\b"; then
    echo -e "${YELLOW}⚠ User not in docker group. Adding user to docker group...${NC}"
    sudo usermod -aG docker $USER
    echo "✓ User added to docker group"
    echo -e "${YELLOW}Note: You need to log out and back in for group changes to take effect${NC}"
fi

# Create Docker templates directory
DOCKER_TEMPLATES_DIR="$HOME/Templates/Docker"
mkdir -p "$DOCKER_TEMPLATES_DIR"
echo "✓ Created Docker templates directory"

# Node.js Development Container
echo ""
echo -e "${YELLOW}Creating Node.js development container template...${NC}"
NODE_DIR="$DOCKER_TEMPLATES_DIR/nodejs-app"
mkdir -p "$NODE_DIR"

cat > "$NODE_DIR/Dockerfile" << 'EOF'
# Node.js Development Container
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install development dependencies
RUN apk add --no-cache git

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Development command (use nodemon for auto-reload)
CMD ["npm", "run", "dev"]
EOF

cat > "$NODE_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    depends_on:
      - db
      - redis
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - app-network

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
EOF

cat > "$NODE_DIR/package.json" << 'EOF'
{
  "name": "nodejs-docker-app",
  "version": "1.0.0",
  "description": "Node.js application with Docker",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.3",
    "redis": "^4.6.8"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.7.0"
  }
}
EOF

cat > "$NODE_DIR/index.js" << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ 
    message: 'Hello from Dockerized Node.js!',
    environment: process.env.NODE_ENV,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
EOF

cat > "$NODE_DIR/.dockerignore" << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
.coverage
.pytest_cache
EOF

echo "✓ Node.js Docker template created"

# Python Flask Development Container
echo ""
echo -e "${YELLOW}Creating Python Flask development container template...${NC}"
PYTHON_DIR="$DOCKER_TEMPLATES_DIR/python-flask"
mkdir -p "$PYTHON_DIR"

cat > "$PYTHON_DIR/Dockerfile" << 'EOF'
# Python Flask Development Container
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Expose port
EXPOSE 5000

# Development command
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000", "--debug"]
EOF

cat > "$PYTHON_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/app
    environment:
      - FLASK_ENV=development
      - FLASK_DEBUG=1
      - DATABASE_URL=postgresql://developer:devpass123@db:5432/myapp
    depends_on:
      - db
      - redis
    networks:
      - app-network

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - app-network

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
EOF

cat > "$PYTHON_DIR/requirements.txt" << 'EOF'
Flask==2.3.3
Flask-SQLAlchemy==3.0.5
psycopg2-binary==2.9.7
redis==5.0.1
python-dotenv==1.0.0
gunicorn==21.2.0
EOF

cat > "$PYTHON_DIR/app.py" << 'EOF'
from flask import Flask, jsonify
import os
import redis
import psycopg2
from datetime import datetime

app = Flask(__name__)

# Redis connection
try:
    r = redis.Redis(host='redis', port=6379, decode_responses=True)
except:
    r = None

@app.route('/')
def hello():
    return jsonify({
        'message': 'Hello from Dockerized Flask!',
        'environment': os.getenv('FLASK_ENV', 'production'),
        'timestamp': datetime.now().isoformat()
    })

@app.route('/health')
def health():
    status = {'status': 'healthy', 'services': {}}
    
    # Check Redis
    try:
        if r:
            r.ping()
            status['services']['redis'] = 'connected'
        else:
            status['services']['redis'] = 'unavailable'
    except:
        status['services']['redis'] = 'error'
    
    # Check PostgreSQL
    try:
        conn = psycopg2.connect(os.getenv('DATABASE_URL'))
        conn.close()
        status['services']['postgres'] = 'connected'
    except:
        status['services']['postgres'] = 'error'
    
    return jsonify(status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

echo "✓ Python Flask Docker template created"

# Database Development Containers
echo ""
echo -e "${YELLOW}Creating database development containers...${NC}"
DB_DIR="$DOCKER_TEMPLATES_DIR/databases"
mkdir -p "$DB_DIR"

cat > "$DB_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    networks:
      - db-network

  # MySQL Database
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass123
      MYSQL_DATABASE: devdb
      MYSQL_USER: developer
      MYSQL_PASSWORD: devpass123
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - db-network

  # MongoDB Database
  mongodb:
    image: mongo:7
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: adminpass123
      MONGO_INITDB_DATABASE: devdb
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    networks:
      - db-network

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - db-network

  # Adminer (Database Management UI)
  adminer:
    image: adminer:4
    ports:
      - "8080:8080"
    networks:
      - db-network

volumes:
  postgres_data:
  mysql_data:
  mongodb_data:
  redis_data:

networks:
  db-network:
    driver: bridge
EOF

mkdir -p "$DB_DIR/init-scripts"
cat > "$DB_DIR/init-scripts/01-init.sql" << 'EOF'
-- Initial database setup
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email) VALUES 
    ('john_doe', 'john@example.com'),
    ('jane_smith', 'jane@example.com')
ON CONFLICT DO NOTHING;
EOF

echo "✓ Database development containers created"

# Create Docker utility scripts
echo ""
echo -e "${YELLOW}Creating Docker utility scripts...${NC}"

# Docker development helper script
cat > "$HOME/.local/bin/docker-dev" << 'EOF'
#!/bin/bash
# Docker development helper script

case "$1" in
    "start"|"up")
        echo "Starting development containers..."
        docker-compose up -d
        ;;
    "stop"|"down")
        echo "Stopping development containers..."
        docker-compose down
        ;;
    "logs")
        docker-compose logs -f "${2:-}"
        ;;
    "shell"|"bash")
        container="${2:-app}"
        echo "Opening shell in $container container..."
        docker-compose exec "$container" /bin/bash 2>/dev/null || docker-compose exec "$container" /bin/sh
        ;;
    "db")
        echo "Connecting to PostgreSQL database..."
        docker-compose exec postgres psql -U developer -d devdb
        ;;
    "redis")
        echo "Connecting to Redis..."
        docker-compose exec redis redis-cli
        ;;
    "clean")
        echo "Cleaning up Docker resources..."
        docker system prune -f
        docker volume prune -f
        ;;
    "status")
        echo "Container status:"
        docker-compose ps
        ;;
    *)
        echo "Docker Development Helper"
        echo "Usage: docker-dev <command>"
        echo ""
        echo "Commands:"
        echo "  start, up    - Start development containers"
        echo "  stop, down   - Stop development containers"
        echo "  logs [name]  - Show container logs"
        echo "  shell [name] - Open shell in container"
        echo "  db          - Connect to PostgreSQL"
        echo "  redis       - Connect to Redis"
        echo "  status      - Show container status"
        echo "  clean       - Clean up Docker resources"
        ;;
esac
EOF

chmod +x "$HOME/.local/bin/docker-dev"
echo "✓ Docker development helper script created"

# Quick database launcher
cat > "$HOME/.local/bin/dev-db" << 'EOF'
#!/bin/bash
# Quick database development setup

DB_DIR="$HOME/Templates/Docker/databases"

if [ ! -f "$DB_DIR/docker-compose.yml" ]; then
    echo "Database templates not found. Run docker-basics.sh first."
    exit 1
fi

case "$1" in
    "start")
        echo "Starting development databases..."
        cd "$DB_DIR" && docker-compose up -d
        echo ""
        echo "Available services:"
        echo "• PostgreSQL: localhost:5432 (user: developer, pass: devpass123)"
        echo "• MySQL:      localhost:3306 (user: developer, pass: devpass123)"
        echo "• MongoDB:    localhost:27017 (user: admin, pass: adminpass123)"
        echo "• Redis:      localhost:6379"
        echo "• Adminer UI: http://localhost:8080"
        ;;
    "stop")
        echo "Stopping development databases..."
        cd "$DB_DIR" && docker-compose down
        ;;
    "status")
        cd "$DB_DIR" && docker-compose ps
        ;;
    *)
        echo "Development Database Manager"
        echo "Usage: dev-db <command>"
        echo ""
        echo "Commands:"
        echo "  start   - Start all development databases"
        echo "  stop    - Stop all development databases"
        echo "  status  - Show database container status"
        ;;
esac
EOF

chmod +x "$HOME/.local/bin/dev-db"
echo "✓ Development database launcher created"

echo ""
echo -e "${GREEN}✓ Docker development environment setup complete!${NC}"
echo ""
echo -e "${BLUE}Created templates:${NC}"
echo "• Node.js application  - $DOCKER_TEMPLATES_DIR/nodejs-app"
echo "• Python Flask app     - $DOCKER_TEMPLATES_DIR/python-flask"
echo "• Development databases - $DOCKER_TEMPLATES_DIR/databases"
echo ""
echo -e "${BLUE}Utility commands:${NC}"
echo "• docker-dev start     - Start project containers"
echo "• docker-dev shell     - Open container shell"
echo "• docker-dev db        - Connect to PostgreSQL"
echo "• dev-db start         - Start development databases"
echo "• dev-db stop          - Stop development databases"
echo ""
echo -e "${BLUE}Quick start:${NC}"
echo "1. Copy a template: cp -r ~/Templates/Docker/nodejs-app my-project"
echo "2. Go to project: cd my-project"
echo "3. Start containers: docker-dev start"
echo "4. View logs: docker-dev logs"
echo ""
echo -e "${YELLOW}Database access:${NC}"
echo "• PostgreSQL: localhost:5432 (developer/devpass123)"
echo "• MySQL:      localhost:3306 (developer/devpass123)"
echo "• MongoDB:    localhost:27017 (admin/adminpass123)"
echo "• Redis:      localhost:6379"
echo "• Database UI: http://localhost:8080 (Adminer)"
echo ""
if ! groups $USER | grep -q "\bdocker\b"; then
    echo -e "${YELLOW}⚠ Remember to log out and back in for Docker group changes to take effect${NC}"
fi