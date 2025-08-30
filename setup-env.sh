#!/bin/bash

# Dynamic environment setup script
# Works for any user on any host

# Get current user and home directory
CURRENT_USER=$(whoami)
CURRENT_HOME=$(eval echo ~$CURRENT_USER)

echo "Setting up environment for user: $CURRENT_USER"
echo "Home directory: $CURRENT_HOME"

# Create .env file with dynamic values
cat > inception/.env << EOF
# Environment variables for inception project
# Generated dynamically for user: $CURRENT_USER

# System Configuration
HOME=$CURRENT_HOME
USER=$CURRENT_USER

# Database
DB_NAME=wordpress_db
DB_USER=wp_user
DB_PASSWORD=wp_pass
DB_HOST=mariadb
DB_CHARSET=utf8
DB_COLLATE=

# Wordpress
WORDPRESS_DB_NAME=wordpress_db
WORDPRESS_DB_USER=wp_user
WORDPRESS_DB_PASSWORD=wp_pass
WORDPRESS_DB_HOST=mariadb

# Nginx
NGINX_PORT=443
NGINX_CONTAINER=nginx

# MariaDB
MARIADB_CONTAINER=mariadb
MARIADB_PORT=3306
MARIADB_ROOT_PASSWORD=yourpassword

# WordPress Admin Configuration
ADMIN_USER=admin
ADMIN_PASSWORD=admin123!
ADMIN_EMAIL=admin@${CURRENT_USER}.local

# Additional user for WordPress
USER_NAME=${CURRENT_USER}
USER_PASSWORD=${CURRENT_USER}123!
USER_EMAIL=${CURRENT_USER}@${CURRENT_USER}.local
EOF

echo "✅ Environment file created at inception/.env"
echo "✅ Configured for user: $CURRENT_USER"
echo "✅ Data will be stored in: $CURRENT_HOME/data/"

# Make the script executable
chmod +x setup-env.sh
