# 🐳 Docker Development Guide

This guide covers using the Docker development environment created by the dotfiles setup.

## Quick Start

After running the setup, you'll have Docker examples in `~/Development/docker-examples/`:

```bash
cd ~/Development/docker-examples
./docker-dev start
```

## Available Services

### PostgreSQL Database
- **Host**: localhost:5432
- **Database**: devdb
- **User**: developer
- **Password**: devpass123

### Redis Cache
- **Host**: localhost:6379
- **No authentication required**

### Nginx Web Server
- **URL**: http://localhost:8080
- **Serves static files and acts as reverse proxy**

## Docker Commands

### Using the docker-dev utility:

```bash
# Start all services
./docker-dev start

# Stop all services
./docker-dev stop

# View running services
./docker-dev ps

# View logs
./docker-dev logs

# Connect to PostgreSQL
./docker-dev postgres

# Connect to Redis
./docker-dev redis

# Clean up (removes containers and volumes)
./docker-dev clean
```

### Using Docker Compose directly:

```bash
# Start individual services
docker compose -f postgres-dev.yml up -d
docker compose -f redis-dev.yml up -d

# Full development stack
docker compose -f dev-stack.yml up -d

# Stop services
docker compose -f dev-stack.yml down

# View logs
docker compose -f dev-stack.yml logs -f
```

## Database Usage Examples

### PostgreSQL

#### Connect with psql:
```bash
# Via docker-dev utility
./docker-dev postgres

# Or directly
docker exec -it dev-postgres psql -U developer -d devdb
```

#### Sample queries:
```sql
-- List tables
\dt

-- Query users table
SELECT * FROM users;

-- Add a new user
INSERT INTO users (name, email) VALUES ('Alice Johnson', 'alice@example.com');
```

#### Connect from Python:
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="devdb",
    user="developer",
    password="devpass123",
    port="5432"
)

cursor = conn.cursor()
cursor.execute("SELECT * FROM users;")
results = cursor.fetchall()
print(results)
```

### Redis

#### Connect with redis-cli:
```bash
# Via docker-dev utility
./docker-dev redis

# Or directly
docker exec -it dev-redis redis-cli
```

#### Sample commands:
```bash
# Set a key
SET mykey "Hello World"

# Get a key
GET mykey

# Set with expiration (60 seconds)
SETEX session:user123 60 "user_data"

# List all keys
KEYS *
```

#### Connect from Python:
```python
import redis

r = redis.Redis(host='localhost', port=6379, db=0)
r.set('key', 'value')
print(r.get('key'))
```

## Project Integration

### Adding Docker to Your Projects

1. **Create a docker-compose.yml in your project:**
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://developer:devpass123@postgres:5432/devdb
      - REDIS_URL=redis://redis:6379

  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass123
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres_data:
```

2. **Environment Variables:**
```bash
# .env file
DATABASE_URL=postgresql://developer:devpass123@localhost:5432/devdb
REDIS_URL=redis://localhost:6379
```

## Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using the port
sudo lsof -i :5432

# Stop conflicting services
sudo systemctl stop postgresql
```

**Container won't start:**
```bash
# Check Docker status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker

# Check container logs
docker logs dev-postgres
```

**Permission denied:**
```bash
# Add user to docker group (logout/login required)
sudo usermod -a -G docker $USER

# Or run with sudo (not recommended)
sudo docker compose up -d
```

### Data Persistence

**Backup Database:**
```bash
docker exec dev-postgres pg_dump -U developer devdb > backup.sql
```

**Restore Database:**
```bash
docker exec -i dev-postgres psql -U developer devdb < backup.sql
```

**Reset Everything:**
```bash
./docker-dev clean
./docker-dev start
```

## Best Practices

1. **Use named volumes** for data persistence
2. **Set resource limits** in production
3. **Use .env files** for environment variables
4. **Regular backups** of important data
5. **Monitor container logs** for issues

## Learn More

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)