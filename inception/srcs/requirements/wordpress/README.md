# 📱 WordPress Service

**Purpose**: The heart of your website - runs the actual WordPress application that powers your blog/website.

## 🎯 What This Service Does

WordPress is the **brain** of your website:
- 🖥️ Runs the WordPress PHP application
- 📝 Handles creating/editing posts and pages
- 👥 Manages users and permissions
- 🎨 Handles themes and plugins
- 📁 Processes file uploads and media

## 📁 Files Explained

### `Dockerfile`
```dockerfile
FROM debian:bullseye                # Base Linux system
RUN apt-get install php php-fpm    # Install PHP and FastCGI
RUN apt-get install php-mysql      # Install MySQL PHP extension

# Install WP-CLI (WordPress command line tool)
RUN curl -O wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files
COPY ./conf/wp-config.php /tmp/
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Copy startup script
COPY ./tools/script_wp.sh /tmp/script_db.sh

CMD ["/bin/bash", "/tmp/script_db.sh"]  # Run WordPress setup
```

### `conf/wp-config.php` - WordPress Configuration
```php
<?php
// Database connection settings
define('DB_NAME', 'wordpress_db');      # Database name
define('DB_USER', 'wp_user');           # Database username  
define('DB_PASSWORD', 'wp_pass');       # Database password
define('DB_HOST', 'mariadb');           # Database server (container name)

// Security keys (for encryption)
define('AUTH_KEY', 'random-string');
define('SECURE_AUTH_KEY', 'random-string');
// ... more security keys

// WordPress database table prefix
$table_prefix = 'wp_';

// WordPress debug mode (off in production)
define('WP_DEBUG', false);
```

### `conf/www.conf` - PHP-FPM Configuration
```ini
[www]
user = www-data                    # User that runs PHP
group = www-data                   # Group that runs PHP
listen = 9000                      # Port that PHP listens on
listen.owner = www-data            # Socket ownership
listen.group = www-data
pm = dynamic                       # Process management mode
pm.max_children = 5                # Maximum PHP processes
pm.start_servers = 2               # Initial PHP processes
```

### `tools/script_wp.sh` - WordPress Setup Script
```bash
#!/bin/bash
sleep 10                           # Wait for database to be ready
cd /var/www/html

# Download latest WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz           # Extract WordPress files

# Copy configuration
mv /tmp/wp-config.php /var/www/html/wordpress/wp-config.php

# Install WordPress using WP-CLI
wp core install \
    --url="abouzanb.42.fr" \
    --title="WordPress" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --allow-root \
    --path=/var/www/html/wordpress

# Create additional user
wp user create $USER_NAME $USER_EMAIL \
    --role=author \
    --user_pass=$USER_PASSWORD \
    --allow-root \
    --path=/var/www/html/wordpress

# Start PHP-FPM
/usr/sbin/php-fpm7.4 -F
```

## 🔧 How It Works

### **WordPress Installation Process**
1. **Container starts** and waits for database
2. **Downloads** latest WordPress from official site
3. **Extracts** WordPress files to `/var/www/html/wordpress`
4. **Configures** database connection
5. **Installs** WordPress using WP-CLI
6. **Creates** admin user and additional user
7. **Starts** PHP-FPM to handle web requests

### **Request Processing**
1. **Nginx forwards** PHP requests to WordPress container
2. **PHP-FPM receives** request on port 9000
3. **WordPress processes** the request (database queries, etc.)
4. **PHP generates** HTML response
5. **Response sent back** through Nginx to user

## 🚀 Usage

### **Build and Run**
```bash
# Build WordPress container
docker compose build wordpress

# Start WordPress service
docker compose up wordpress

# Check if running
docker ps | grep wordpress
```

### **WordPress Management with WP-CLI**
```bash
# Access WordPress container
docker exec -it wordpress bash

# Check WordPress status
wp core version --allow-root --path=/var/www/html/wordpress

# List users
wp user list --allow-root --path=/var/www/html/wordpress

# Install a plugin
wp plugin install akismet --allow-root --path=/var/www/html/wordpress

# Install a theme
wp theme install twentytwentythree --allow-root --path=/var/www/html/wordpress
```

### **Database Operations**
```bash
# Check database connection
wp db check --allow-root --path=/var/www/html/wordpress

# Create database backup
wp db export backup.sql --allow-root --path=/var/www/html/wordpress

# Update WordPress core
wp core update --allow-root --path=/var/www/html/wordpress
```

## 🔧 Customization

### **Change WordPress Users**
Edit environment variables in `.env`:
```bash
# WordPress admin user
ADMIN_USER=your_admin
ADMIN_PASSWORD=secure_password
ADMIN_EMAIL=admin@your-domain.com

# Additional user
USER_NAME=editor
USER_EMAIL=editor@your-domain.com
USER_PASSWORD=another_password
```

### **Install Plugins/Themes Automatically**
Add to `tools/script_wp.sh`:
```bash
# Install popular plugins
wp plugin install elementor --activate --allow-root --path=/var/www/html/wordpress
wp plugin install yoast --activate --allow-root --path=/var/www/html/wordpress

# Install a theme
wp theme install astra --activate --allow-root --path=/var/www/html/wordpress
```

### **Configure PHP Settings**
Edit `conf/www.conf`:
```ini
# Increase memory limit
php_admin_value[memory_limit] = 256M

# Increase upload size
php_admin_value[upload_max_filesize] = 64M
php_admin_value[post_max_size] = 64M

# Increase execution time
php_admin_value[max_execution_time] = 300
```

### **Enable WordPress Debug Mode**
Edit `conf/wp-config.php`:
```php
// Enable debugging
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
```

## 🚨 Troubleshooting

### **WordPress Won't Install**
```bash
# Check if database is accessible
docker exec wordpress ping mariadb

# Check database connection manually
docker exec wordpress mysql -h mariadb -u wp_user -p

# View WordPress installation logs
docker logs wordpress

# Check WP-CLI status
docker exec wordpress wp --info --allow-root
```

### **PHP Errors**
```bash
# Check PHP-FPM logs
docker exec wordpress tail -f /var/log/php7.4-fpm.log

# Check PHP configuration
docker exec wordpress php -m  # List PHP modules
docker exec wordpress php -v  # Check PHP version

# Test PHP-FPM status
docker exec wordpress php-fpm7.4 -t
```

### **File Permission Issues**
```bash
# Fix WordPress file permissions
docker exec wordpress chown -R www-data:www-data /var/www/html/wordpress
docker exec wordpress chmod -R 755 /var/www/html/wordpress
```

### **Database Connection Issues**
```bash
# Test database connection with WP-CLI
docker exec wordpress wp db check --allow-root --path=/var/www/html/wordpress

# Check database credentials
docker exec wordpress wp config get DB_NAME --allow-root --path=/var/www/html/wordpress
```

## 🔍 Monitoring

### **WordPress Health**
```bash
# Check WordPress status
docker exec wordpress wp core verify-checksums --allow-root --path=/var/www/html/wordpress

# Check for updates
docker exec wordpress wp core check-update --allow-root --path=/var/www/html/wordpress

# View WordPress info
docker exec wordpress wp --info --allow-root
```

### **Performance Monitoring**
```bash
# Check PHP processes
docker exec wordpress ps aux | grep php

# Monitor resource usage
docker stats wordpress

# Check slow queries
docker exec wordpress wp db query "SHOW PROCESSLIST" --allow-root --path=/var/www/html/wordpress
```

## 📁 File Structure

```
/var/www/html/wordpress/
├── wp-admin/           # WordPress admin interface
├── wp-content/         # Themes, plugins, uploads
│   ├── themes/        # Website themes
│   ├── plugins/       # WordPress plugins
│   └── uploads/       # User uploaded files
├── wp-includes/       # WordPress core files
├── wp-config.php      # WordPress configuration
└── index.php          # Main WordPress file
```

## 🔒 Security Features

- ✅ **No direct internet access** (behind nginx proxy)
- ✅ **Environment variables** for sensitive data
- ✅ **Secure file permissions** (www-data user)
- ✅ **Database isolation** (container network only)
- ✅ **Regular updates** possible with WP-CLI

## 🎯 WordPress Admin Access

Once WordPress is running:
- **Admin URL**: `https://abouzanb.42.fr/wp-admin`
- **Username**: `admin` (from ADMIN_USER)
- **Password**: `admin123!` (from ADMIN_PASSWORD)

---

📱 **Your WordPress application is now ready to power your website with full PHP processing and database connectivity!**
