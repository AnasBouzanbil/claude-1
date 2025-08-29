# 🏗️ Inception - WordPress Infrastructure

This folder contains the complete Docker-based WordPress infrastructure. It creates 4 interconnected services that work together to host a WordPress website.

## 🎯 What's Inside

### 🐳 **Docker Services**
- **nginx** - Web server that handles incoming requests and SSL
- **wordpress** - The actual WordPress application 
- **mariadb** - Database that stores all website data
- **phpmyadmin** - Web interface to manage the database

### 📁 **Key Files**
- `docker-compose.yml` - Defines how all services work together
- `.env` - Contains passwords and configuration settings
- `Makefile` - Simple commands to build and run everything

## 🔧 Configuration Files

### 🌍 Environment Variables (`.env`)
```bash
# Database settings
DB_NAME=wordpress_db          # Name of the WordPress database
DB_USER=wp_user              # Database username
DB_PASSWORD=wp_pass          # Database password

# WordPress admin user
ADMIN_USER=admin             # WordPress admin username
ADMIN_PASSWORD=admin123!     # WordPress admin password
ADMIN_EMAIL=admin@domain.com # Admin email address

# Additional WordPress user
USER_NAME=user1              # Regular user username
USER_EMAIL=user1@domain.com  # Regular user email
USER_PASSWORD=user123!       # Regular user password
```

### 🐳 Docker Compose Overview
```yaml
services:
  nginx:        # Web server (ports 443, 8080)
  wordpress:    # WordPress app (no external ports)
  mariadb:      # Database (no external ports)
  phpmyadmin:   # DB manager (port 8081)
```

## 🚀 How to Use

### **Quick Commands**
```bash
# Build everything from scratch
make build

# Start all services
make up

# Stop everything
make down

# Rebuild and restart everything
make re

# Complete cleanup (⚠️ deletes all data!)
make rmall
```

### **Manual Docker Commands**
```bash
# Build all containers
docker compose build

# Start in background
docker compose up -d

# View running containers
docker ps

# View logs
docker logs wordpress
docker logs nginx
docker logs mariadb
```

## 🏗️ Service Architecture

```
📱 User Request (browser)
    ↓
🛡️ Nginx (Port 443)
    ├── WordPress requests → WordPress container
    └── /phpmyadmin → PHPMyAdmin container
                        ↓
                    🗄️ MariaDB (internal network only)
```

## 📂 Data Storage

All important data is stored on your host machine:

```bash
/home/anas/data/
├── wordpress/     # WordPress files, themes, uploads
└── mariadb/       # Database files
```

This means your website data survives even if containers are deleted!

## 🔒 Security Features

### ✅ **Network Security**
- MariaDB has **no external ports** (only accessible from other containers)
- Internal Docker network isolates services
- SSL certificates encrypt all web traffic

### ✅ **Access Control**
- Database requires username/password authentication
- WordPress admin interface protected by login
- PHPMyAdmin requires database credentials

## 🐳 Individual Services

Each service has its own folder with detailed documentation:

- 📋 [Nginx Configuration](./srcs/requirements/nginx/README.md)
- 📋 [WordPress Setup](./srcs/requirements/wordpress/README.md) 
- 📋 [MariaDB Database](./srcs/requirements/mariadb/README.md)
- 📋 [PHPMyAdmin Interface](./srcs/requirements/phpmyadmin/README.md)

## 🔧 Customization

### **Change Domain Name**
1. Edit `srcs/requirements/nginx/conf/default`
2. Update `server_name` to your domain
3. Rebuild: `make re`

### **Change Passwords**
1. Edit `.env` file
2. Update database and user passwords
3. Rebuild: `make re`

### **Add SSL Certificate**
1. Replace certificates in nginx container
2. Update nginx configuration
3. Restart: `make down && make up`

## 🚨 Troubleshooting

### **Container Won't Start**
```bash
# Check what's wrong
docker logs <container_name>

# Common fixes
docker compose down
make build
make up
```

### **Database Connection Issues**
```bash
# Check if MariaDB is running
docker exec -it mariadb mysql -u wp_user -p

# Reset database
make rmall  # ⚠️ This deletes all data!
make re
```

### **Permission Problems**
```bash
# Fix data directory ownership
sudo chown -R $USER:$USER /home/anas/data/

# Check directory exists
ls -la /home/anas/data/
```

### **Port Already in Use**
```bash
# Check what's using the port
sudo lsof -i :443
sudo lsof -i :8080

# Stop conflicting services
sudo systemctl stop apache2  # if Apache is running
sudo systemctl stop nginx    # if system nginx is running
```

## 📊 Monitoring

### **Check Service Health**
```bash
# See all running containers
docker ps

# Check resource usage
docker stats

# View service logs in real-time
docker logs -f wordpress
```

### **Database Status**
```bash
# Connect to database
docker exec -it mariadb mysql -u root -p

# Check WordPress database
USE wordpress_db;
SHOW TABLES;
```

## 🔄 Backup & Restore

### **Backup Data**
```bash
# Backup WordPress files
tar -czf wordpress_backup.tar.gz /home/anas/data/wordpress/

# Backup database
docker exec mariadb mysqldump -u root -p wordpress_db > backup.sql
```

### **Restore Data**
```bash
# Restore WordPress files
tar -xzf wordpress_backup.tar.gz -C /

# Restore database
docker exec -i mariadb mysql -u root -p wordpress_db < backup.sql
```

---

✨ **Your WordPress infrastructure is now ready to host websites reliably!**
