# 🔧 PHPMyAdmin Service

**Purpose**: Web-based database administration tool that provides an easy interface to manage your MariaDB database.

## 🎯 What This Service Does

PHPMyAdmin is your **database control panel**:
- 🖥️ Provides a web interface to manage databases
- 📊 Browse and edit database tables visually
- 💻 Execute SQL queries with syntax highlighting
- 👥 Manage database users and permissions
- 📋 Import/export database backups
- 📈 Monitor database performance

## 📁 Files Explained

### `Dockerfile`
```dockerfile
FROM debian:bullseye

# Install required packages
RUN apt-get update -y && apt-get install -y \
    nginx \                      # Web server for PHPMyAdmin
    php7.4 \                     # PHP runtime
    php7.4-fpm \                 # FastCGI Process Manager
    php7.4-mysql \               # MySQL database extension
    php7.4-json \                # JSON support
    php7.4-mbstring \            # Multibyte string support
    php7.4-zip \                 # ZIP archive support
    php7.4-gd \                  # Image processing
    php7.4-xml \                 # XML processing
    php7.4-curl \                # HTTP client support
    wget                         # Download tool

# Download and install PHPMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
RUN tar xzf phpMyAdmin-latest-all-languages.tar.gz
RUN mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin

# Copy configuration files
COPY conf/config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY conf/nginx.conf /etc/nginx/sites-available/default

CMD ["/bin/bash", "/tmp/script.sh"]
```

### `conf/config.inc.php` - PHPMyAdmin Configuration
```php
<?php
/**
 * PHPMyAdmin configuration
 */

// Encryption key for cookies
$cfg['blowfish_secret'] = 'H2OxcGXxflSd8JwrwVlh6KW6s2rER63j';

// Server configuration
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';        # Use cookie authentication
$cfg['Servers'][$i]['host'] = 'mariadb';            # MariaDB container name
$cfg['Servers'][$i]['port'] = '3306';               # Standard MySQL port
$cfg['Servers'][$i]['connect_type'] = 'tcp';        # TCP connection
$cfg['Servers'][$i]['compress'] = false;            # No compression
$cfg['Servers'][$i]['AllowNoPassword'] = false;     # Require passwords

// Security settings
$cfg['VersionCheck'] = false;                       # Don't check for updates
$cfg['AllowArbitraryServer'] = false;              # Only connect to configured server
$cfg['LoginCookieValidity'] = 1800;                # Session timeout (30 minutes)
```

### `conf/nginx.conf` - Nginx Configuration for PHPMyAdmin
```nginx
server {
    listen 80;                                       # Listen on port 80
    root /var/www/html/phpmyadmin;                  # PHPMyAdmin document root
    index index.php index.html;                     # Default files

    # PHP processing
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Deny access to sensitive files
    location ~ /\. {
        deny all;                                    # Block hidden files
    }
    
    location ~ /(config|temp|libraries) {
        deny all;                                    # Block config directories
    }
}
```

### `tools/script.sh` - Startup Script
```bash
#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! timeout 1 bash -c "echo > /dev/tcp/mariadb/3306" 2>/dev/null; do
    echo "MariaDB is not ready yet..."
    sleep 2
done
echo "MariaDB is ready!"

# Create necessary directories
mkdir -p /run/php                                    # PHP-FPM socket directory
mkdir -p /var/log/nginx                             # Nginx log directory

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm7.4 -D                                      # Start in daemon mode

# Start nginx in foreground
echo "Starting nginx..."
nginx -g "daemon off;"                              # Keep container running
```

## 🔧 How It Works

### **PHPMyAdmin Access Flow**
1. **User visits** `https://abouzanb.42.fr:8080`
2. **Nginx (main)** proxies request to PHPMyAdmin container
3. **PHPMyAdmin nginx** receives request on port 80
4. **PHP-FPM** processes PHPMyAdmin PHP code
5. **PHPMyAdmin** connects to MariaDB container
6. **Database operations** performed through PHPMyAdmin interface

### **Authentication Process**
1. **User opens** PHPMyAdmin in browser
2. **Login form** appears (cookie-based authentication)
3. **User enters** database credentials (wp_user/wp_pass)
4. **PHPMyAdmin** validates credentials with MariaDB
5. **Session established** with encrypted cookie

## 🚀 Usage

### **Build and Run**
```bash
# Build PHPMyAdmin container
docker compose build phpmyadmin

# Start PHPMyAdmin service
docker compose up phpmyadmin

# Check if running
docker ps | grep phpmyadmin
```

### **Access PHPMyAdmin**
1. **Open browser** and go to `https://abouzanb.42.fr:8080`
2. **Login with database credentials**:
   - Server: `mariadb` (auto-filled)
   - Username: `wp_user`
   - Password: `wp_pass`
3. **Manage your database** through the web interface

### **Common PHPMyAdmin Operations**
```
Database Management:
├── Browse Tables     → View/edit table data
├── Structure        → View table structure and indexes
├── SQL              → Execute custom SQL queries
├── Search           → Search across tables
├── Operations       → Database operations (copy, rename, etc.)
├── Privileges       → Manage user permissions
├── Export           → Create database backups
└── Import           → Restore database backups
```

## 🔧 Customization

### **Change PHPMyAdmin Theme**
Edit `conf/config.inc.php`:
```php
// Set theme
$cfg['ThemeDefault'] = 'metro';      # Available: original, metro, pmahomme

// Custom colors
$cfg['NaviColor'] = '#1f1f1f';       # Navigation color
$cfg['MainColor'] = '#ffffff';       # Main content color
```

### **Increase Upload Limits**
Edit PHP configuration in `Dockerfile`:
```dockerfile
# Add PHP configuration for larger uploads
RUN echo "upload_max_filesize = 64M" >> /etc/php/7.4/fpm/php.ini
RUN echo "post_max_size = 64M" >> /etc/php/7.4/fpm/php.ini
RUN echo "max_execution_time = 300" >> /etc/php/7.4/fpm/php.ini
RUN echo "memory_limit = 256M" >> /etc/php/7.4/fpm/php.ini
```

### **Add SSL to PHPMyAdmin**
Edit `conf/nginx.conf`:
```nginx
server {
    listen 443 ssl;                                  # Enable SSL
    ssl_certificate /etc/ssl/certs/ssl-cert.pem;    # SSL certificate
    ssl_certificate_key /etc/ssl/private/ssl-cert.key;
    
    # Rest of configuration...
}
```

### **Enable Advanced Features**
Add to `conf/config.inc.php`:
```php
// Control user (for advanced features)
$cfg['Servers'][$i]['controlhost'] = 'mariadb';
$cfg['Servers'][$i]['controluser'] = 'pma';
$cfg['Servers'][$i]['controlpass'] = 'pmapass';

// Enable advanced features
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';        # PHPMyAdmin database
$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
$cfg['Servers'][$i]['relation'] = 'pma__relation';
$cfg['Servers'][$i]['userpreferences'] = 'pma__userconfig';
```

## 🚨 Troubleshooting

### **PHPMyAdmin Won't Load**
```bash
# Check PHPMyAdmin logs
docker logs phpmyadmin

# Check nginx logs inside container
docker exec phpmyadmin tail -f /var/log/nginx/error.log

# Check PHP-FPM logs
docker exec phpmyadmin tail -f /var/log/php7.4-fpm.log

# Common issues:
# - PHP-FPM not running
# - Database connection issues
# - Permission problems
```

### **Can't Connect to Database**
```bash
# Test database connection from PHPMyAdmin container
docker exec phpmyadmin mysql -h mariadb -u wp_user -p

# Check if MariaDB is accessible
docker exec phpmyadmin ping mariadb

# Verify database credentials in .env file
cat .env | grep DB_
```

### **Login Issues**
```bash
# Check PHPMyAdmin configuration
docker exec phpmyadmin cat /var/www/html/phpmyadmin/config.inc.php

# Verify blowfish secret is set
docker exec phpmyadmin grep blowfish /var/www/html/phpmyadmin/config.inc.php

# Clear browser cookies and try again
```

### **Upload/Import Failures**
```bash
# Check PHP upload limits
docker exec phpmyadmin php -i | grep upload_max_filesize
docker exec phpmyadmin php -i | grep post_max_size

# Check available disk space
docker exec phpmyadmin df -h

# Check file permissions
docker exec phpmyadmin ls -la /var/www/html/phpmyadmin/tmp/
```

## 🔍 Monitoring

### **PHPMyAdmin Health**
```bash
# Check if web server is responding
curl -I http://localhost:8081

# Monitor resource usage
docker stats phpmyadmin

# Check process status
docker exec phpmyadmin ps aux | grep -E "(nginx|php-fpm)"
```

### **Database Connection Status**
```bash
# Test connection from PHPMyAdmin
docker exec phpmyadmin mysqladmin -h mariadb -u wp_user -p ping

# Check connection count
docker exec mariadb mysql -u root -p -e "SHOW STATUS LIKE 'Connections';"
```

## 🔧 Database Operations

### **Common Tasks in PHPMyAdmin**

#### **Export Database**
1. Select `wordpress_db` database
2. Click **Export** tab
3. Choose **Quick** method for simple backup
4. Choose **Custom** method for advanced options
5. Click **Go** to download backup

#### **Import Database**
1. Select `wordpress_db` database
2. Click **Import** tab
3. Choose your SQL file
4. Click **Go** to restore

#### **Browse WordPress Tables**
```
wp_posts         → View all blog posts and pages
wp_users         → Manage user accounts
wp_options       → WordPress configuration settings
wp_comments      → Post comments and moderation
wp_postmeta      → Post custom fields and metadata
```

#### **Execute SQL Queries**
1. Click **SQL** tab
2. Enter your query:
```sql
-- View all users
SELECT * FROM wp_users;

-- Count posts
SELECT COUNT(*) FROM wp_posts WHERE post_status = 'publish';

-- Find large tables
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'wordpress_db'
ORDER BY (data_length + index_length) DESC;
```

## 🔒 Security Features

- ✅ **Cookie-based authentication** - Secure session management
- ✅ **No direct internet access** - Only accessible through nginx proxy
- ✅ **Database credential validation** - Must use valid database user
- ✅ **Session timeout** - Automatic logout after inactivity
- ✅ **File access restrictions** - Sensitive files blocked by nginx
- ✅ **No arbitrary server connections** - Only connects to configured database

## 📊 PHPMyAdmin Interface Guide

### **Main Navigation**
- 🏠 **Home** - Server overview and statistics
- 📊 **Databases** - List all databases
- 👥 **User accounts** - Manage database users
- 📈 **Status** - Server status and variables
- 🔧 **Variables** - Server configuration variables

### **Database Operations**
- 📋 **Structure** - View tables and relationships
- 🔍 **Search** - Search across all tables
- 💻 **SQL** - Execute custom queries
- 📤 **Export** - Create backups
- 📥 **Import** - Restore backups
- ⚙️ **Operations** - Database maintenance

---

🔧 **PHPMyAdmin provides a powerful web interface to manage your MariaDB database with ease and security!**
