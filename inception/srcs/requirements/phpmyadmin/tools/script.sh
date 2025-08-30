#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! timeout 1 bash -c "echo > /dev/tcp/mariadb/3306" 2>/dev/null; do
    echo "MariaDB is not ready yet..."
    sleep 2
done
echo "MariaDB is ready!"

# Create necessary directories
echo "Creating directories..."
mkdir -p /run/php
mkdir -p /var/log/nginx

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm7.4 -D

# Start nginx
echo "Starting nginx..."
nginx -g "daemon off;"
