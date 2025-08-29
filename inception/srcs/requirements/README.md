# 🐳 Docker Services Documentation

This folder contains 4 custom-built Docker services that work together to create a complete WordPress hosting environment.

## 🏗️ Service Overview

| Service | Purpose | Ports | Dependencies |
|---------|---------|-------|--------------|
| **nginx** | Web server & SSL termination | 443, 8080 | wordpress, phpmyadmin |
| **wordpress** | WordPress application | Internal only | mariadb |
| **mariadb** | Database server | Internal only | None |
| **phpmyadmin** | Database management | Internal only | mariadb |

## 🔗 Service Communication

```
🌐 Internet (Port 443/8080)
    ↓
🛡️ NGINX (Reverse Proxy)
    ├── WordPress requests → 📱 WordPress Container
    │                          ↓
    │                      🗄️ MariaDB Container
    │                          ↑
    └── PHPMyAdmin requests → 🔧 PHPMyAdmin Container
```

## 📁 Service Details

### 🛡️ **Nginx Service**
**Purpose**: Web server that handles incoming requests and provides SSL encryption

**What it does**:
- Receives all web requests from the internet
- Provides SSL/HTTPS encryption
- Routes WordPress requests to WordPress container
- Routes database admin requests to PHPMyAdmin
- Serves static files (images, CSS, JavaScript)

**Key files**:
- `Dockerfile` - How to build the nginx container
- `conf/default` - Nginx configuration (routing rules)
- `tools/script.sh` - SSL certificate generation script

**Exposed ports**:
- `443` - Main WordPress website (HTTPS)
- `8080` - PHPMyAdmin interface (HTTPS)

---

### 📱 **WordPress Service**
**Purpose**: The actual WordPress application that powers your website

**What it does**:
- Runs the WordPress PHP application
- Handles user requests (viewing pages, admin panel)
- Connects to database to read/write data
- Processes PHP code and generates web pages
- Manages file uploads and media

**Key files**:
- `Dockerfile` - How to build WordPress container
- `conf/wp-config.php` - WordPress database configuration
- `conf/www.conf` - PHP-FPM configuration
- `tools/script_wp.sh` - WordPress installation and user setup

**Features**:
- ✅ Latest WordPress version
- ✅ WP-CLI for command-line management
- ✅ Automatic admin user creation
- ✅ Automatic database configuration

---

### 🗄️ **MariaDB Service**
**Purpose**: Database server that stores all website data

**What it stores**:
- User accounts and passwords
- Blog posts and pages
- Comments and metadata
- Website settings and options
- Plugin and theme data

**Key files**:
- `Dockerfile` - How to build MariaDB container
- `conf/50-server.cnf` - Database server configuration
- `tools/scrpit_db.sh` - Database and user creation script

**Security features**:
- ✅ No external ports (only accessible from other containers)
- ✅ Custom database and user creation
- ✅ Password-protected access
- ✅ Data persistence across restarts

---

### 🔧 **PHPMyAdmin Service**
**Purpose**: Web-based interface to manage the database

**What it provides**:
- Easy database browsing and editing
- SQL query interface
- Database backup and restore
- User and permission management
- Visual database structure viewing

**Key files**:
- `Dockerfile` - How to build PHPMyAdmin container
- `conf/config.inc.php` - PHPMyAdmin configuration
- `conf/nginx.conf` - Internal nginx configuration
- `tools/script.sh` - Service startup script

**Access**: Available through nginx proxy at `https://your-domain:8080`

## 🔧 Building and Managing Services

### **Build Individual Services**
```bash
# Build specific service
docker compose build nginx
docker compose build wordpress
docker compose build mariadb
docker compose build phpmyadmin

# Build all services
docker compose build
```

### **Start/Stop Individual Services**
```bash
# Start specific service
docker compose up nginx
docker compose up wordpress

# Stop specific service
docker compose stop nginx
docker compose stop wordpress
```

### **View Service Logs**
```bash
# View logs for specific service
docker logs nginx
docker logs wordpress
docker logs mariadb
docker logs phpmyadmin

# Follow logs in real-time
docker logs -f wordpress
```

### **Execute Commands Inside Containers**
```bash
# Access WordPress container
docker exec -it wordpress bash

# Access database
docker exec -it mariadb mysql -u wp_user -p

# Check nginx configuration
docker exec -it nginx nginx -t
```

## 🔍 Service Health Monitoring

### **Check Service Status**
```bash
# See all running containers
docker ps

# Check resource usage
docker stats

# Check service health
docker compose ps
```

### **Test Service Connectivity**
```bash
# Test if services can communicate
docker exec nginx ping wordpress
docker exec wordpress ping mariadb

# Test database connection
docker exec wordpress wp db check --allow-root --path=/var/www/html/wordpress
```

## 🛠️ Customization Guide

### **Modify Nginx Configuration**
1. Edit `nginx/conf/default`
2. Change server settings, SSL, or routing
3. Rebuild: `docker compose build nginx`
4. Restart: `docker compose restart nginx`

### **Update WordPress Settings**
1. Edit `wordpress/conf/wp-config.php`
2. Modify database connection or WordPress settings
3. Rebuild: `docker compose build wordpress`
4. Restart: `docker compose restart wordpress`

### **Change Database Configuration**
1. Edit `mariadb/conf/50-server.cnf`
2. Modify database server settings
3. Rebuild: `docker compose build mariadb`
4. Restart: `docker compose restart mariadb`

### **Customize PHPMyAdmin**
1. Edit `phpmyadmin/conf/config.inc.php`
2. Change PHPMyAdmin settings or security
3. Rebuild: `docker compose build phpmyadmin`
4. Restart: `docker compose restart phpmyadmin`

## 🔒 Security Configuration

### **Nginx Security**
- SSL/TLS encryption with modern protocols
- Security headers for protection
- Rate limiting (can be configured)
- Access logging for monitoring

### **WordPress Security**
- No direct database access from internet
- Environment variables for configuration
- Secure file permissions
- Regular security updates possible

### **Database Security**
- No external ports exposed
- User-specific database access
- Password authentication required
- Data encryption at rest (configurable)

### **PHPMyAdmin Security**
- Only accessible through nginx proxy
- Requires database credentials
- Cookie-based authentication
- Configurable session timeout

## 🚨 Troubleshooting Services

### **Service Won't Start**
```bash
# Check why service failed
docker logs <service-name>

# Check port conflicts
sudo lsof -i :<port-number>

# Verify configuration syntax
docker exec <service-name> <config-test-command>
```

### **Service Communication Issues**
```bash
# Test network connectivity
docker network ls
docker network inspect inception_anas

# Check if services are on same network
docker inspect nginx | grep NetworkMode
docker inspect wordpress | grep NetworkMode
```

### **Performance Issues**
```bash
# Check resource usage
docker stats

# Check system resources
free -h
df -h

# Optimize container resources
# Edit docker-compose.yml to add resource limits
```

### **Data Persistence Issues**
```bash
# Check volume mounts
docker inspect wordpress | grep Mounts
docker inspect mariadb | grep Mounts

# Verify data directories exist
ls -la /home/anas/data/wordpress/
ls -la /home/anas/data/mariadb/
```

## 📊 Performance Optimization

### **Container Resource Limits**
Add to docker-compose.yml:
```yaml
services:
  wordpress:
    mem_limit: 512m
    cpus: 0.5
```

### **Database Optimization**
Edit `mariadb/conf/50-server.cnf`:
```ini
# Increase buffer sizes for better performance
innodb_buffer_pool_size = 256M
query_cache_size = 32M
```

### **Nginx Performance**
Edit `nginx/conf/default`:
```nginx
# Enable gzip compression
gzip on;
gzip_types text/css application/javascript;

# Enable caching
location ~* \.(jpg|jpeg|png|gif|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

---

🎯 **Each service is designed to work independently but function perfectly together as a complete WordPress hosting solution!**
