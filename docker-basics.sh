#!/bin/bash

# Docker Development Environment Setup
# Sets up Docker with essential development containers

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

print_header "🐳 Docker Development Environment Setup"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
    print_error "Docker not found. Please install Docker first."
    print_info "Install with: sudo apt install docker.io docker-compose-plugin"
    exit 1
fi

# Check if user is in docker group
if ! groups $USER | grep -q "\bdocker\b"; then
    print_warning "User not in docker group. Please log out and back in after setup completes."
fi

# Create development directory
DEV_DIR="$HOME/Development"
mkdir -p "$DEV_DIR"
print_success "Created development directory: $DEV_DIR"

# Create Docker examples directory
DOCKER_DIR="$DEV_DIR/docker-examples"
mkdir -p "$DOCKER_DIR"

print_header "Creating Essential Docker Compose Examples"

# PostgreSQL Development Database
cat > "$DOCKER_DIR/postgres-dev.yml" << 'EOF'
# PostgreSQL Development Database
# Usage: docker compose -f postgres-dev.yml up -d
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: dev-postgres
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    restart: unless-stopped

volumes:
  postgres_data:
EOF

# Redis Development Cache
cat > "$DOCKER_DIR/redis-dev.yml" << 'EOF'
# Redis Development Cache
# Usage: docker compose -f redis-dev.yml up -d
version: '3.8'

services:
  redis:
    image: redis:7-alpine
    container_name: dev-redis
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    restart: unless-stopped

volumes:
  redis_data:
EOF

# Complete Development Stack
cat > "$DOCKER_DIR/dev-stack.yml" << 'EOF'
# Complete Development Stack
# Usage: docker compose -f dev-stack.yml up -d
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: dev-postgres
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    container_name: dev-redis
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    container_name: dev-nginx
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/usr/share/nginx/html:ro
    depends_on:
      - postgres
      - redis

volumes:
  postgres_data:
  redis_data:
EOF

# Create sample nginx config
mkdir -p "$DOCKER_DIR/html"
cat > "$DOCKER_DIR/nginx.conf" << 'EOF'
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        # Proxy to local development server (if needed)
        location /api/ {
            proxy_pass http://host.docker.internal:3000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF

# Create sample HTML page
cat > "$DOCKER_DIR/html/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Docker Development Environment</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        h1 { color: #2196F3; }
        .service { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Docker Development Environment</h1>
        <p>Your development stack is running!</p>
        
        <div class="service">
            <h3>PostgreSQL Database</h3>
            <p>Host: localhost:5432<br>
            Database: devdb<br>
            User: developer<br>
            Password: devpass123</p>
        </div>
        
        <div class="service">
            <h3>Redis Cache</h3>
            <p>Host: localhost:6379</p>
        </div>
        
        <div class="service">
            <h3>Nginx Web Server</h3>
            <p>This page: <a href="http://localhost:8080">localhost:8080</a></p>
        </div>
    </div>
</body>
</html>
EOF

# Create PostgreSQL init script
mkdir -p "$DOCKER_DIR/init-scripts"
cat > "$DOCKER_DIR/init-scripts/01-init.sql" << 'EOF'
-- Sample initialization script for PostgreSQL
-- This runs automatically when the container starts for the first time

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com')
ON CONFLICT (email) DO NOTHING;
EOF

# Create Docker utility script
cat > "$DOCKER_DIR/docker-dev" << 'EOF'
#!/bin/bash

# Docker Development Utility Script
# Provides easy commands for managing development containers

DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$1" in
    "start")
        echo "🚀 Starting development stack..."
        docker compose -f "$DOCKER_DIR/dev-stack.yml" up -d
        echo "✅ Development stack started!"
        echo "📊 Services:"
        echo "  • PostgreSQL: localhost:5432"
        echo "  • Redis: localhost:6379" 
        echo "  • Nginx: http://localhost:8080"
        ;;
    "stop")
        echo "🛑 Stopping development stack..."
        docker compose -f "$DOCKER_DIR/dev-stack.yml" down
        echo "✅ Development stack stopped!"
        ;;
    "restart")
        echo "🔄 Restarting development stack..."
        docker compose -f "$DOCKER_DIR/dev-stack.yml" restart
        echo "✅ Development stack restarted!"
        ;;
    "logs")
        docker compose -f "$DOCKER_DIR/dev-stack.yml" logs -f
        ;;
    "ps")
        docker compose -f "$DOCKER_DIR/dev-stack.yml" ps
        ;;
    "clean")
        echo "🧹 Cleaning up development containers and volumes..."
        docker compose -f "$DOCKER_DIR/dev-stack.yml" down -v
        echo "✅ Cleanup complete!"
        ;;
    "postgres")
        echo "🐘 Connecting to PostgreSQL..."
        docker exec -it dev-postgres psql -U developer -d devdb
        ;;
    "redis")
        echo "📮 Connecting to Redis..."
        docker exec -it dev-redis redis-cli
        ;;
    *)
        echo "🐳 Docker Development Utility"
        echo ""
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  start     Start the development stack"
        echo "  stop      Stop the development stack"
        echo "  restart   Restart the development stack"
        echo "  logs      View logs from all services"
        echo "  ps        Show running services"
        echo "  clean     Stop and remove all containers and volumes"
        echo "  postgres  Connect to PostgreSQL shell"
        echo "  redis     Connect to Redis shell"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 postgres"
        echo "  $0 logs"
        ;;
esac
EOF

chmod +x "$DOCKER_DIR/docker-dev"

print_success "Created PostgreSQL development setup"
print_success "Created Redis development setup" 
print_success "Created complete development stack"
print_success "Created Nginx web server configuration"
print_success "Created Docker utility script"

print_header "🎯 Quick Start Guide"
echo ""
print_success "Docker examples created in: $DOCKER_DIR"
echo ""
echo "💡 Quick commands:"
echo "  • Start full stack:    cd $DOCKER_DIR && ./docker-dev start"
echo "  • View services:       cd $DOCKER_DIR && ./docker-dev ps"
echo "  • Connect to PostgreSQL: cd $DOCKER_DIR && ./docker-dev postgres"
echo "  • Connect to Redis:    cd $DOCKER_DIR && ./docker-dev redis"
echo "  • Stop everything:     cd $DOCKER_DIR && ./docker-dev stop"
echo ""
echo "🔗 Access points:"
echo "  • Web interface: http://localhost:8080"
echo "  • PostgreSQL: localhost:5432 (user: developer, password: devpass123)"
echo "  • Redis: localhost:6379"
echo ""

# Add utility to PATH
if ! grep -q "$DOCKER_DIR" ~/.bashrc; then
    echo "export PATH=\"\$PATH:$DOCKER_DIR\"" >> ~/.bashrc
    print_success "Added docker-dev to PATH (restart terminal to use)"
fi

print_header "✅ Docker Development Environment Setup Complete"

if command_exists finalize_log; then
    finalize_log "Docker Development Setup"
fi