#!/bin/bash

# Give the container a moment to initialize the environment
sleep 2

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    echo "Downloading WordPress..."
    wget https://wordpress.org/latest.tar.gz
    
    mkdir -p /run/php
    tar -xzvf latest.tar.gz
    
    mv /tmp/wp-config.php /var/www/html/wordpress/wp-config.php
    rm -rf latest.tar.gz
fi

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be fully initialized..."
while ! php -r "mysqli_connect('$DB_HOST', '$DB_USER', '$DB_PASSWORD', '$DB_NAME') or exit(1);" 2>/dev/null; do
    echo "MariaDB connection failed. Retrying in 3 seconds..."
    sleep 3
done
echo "MariaDB is up and running!"

cd /var/www/html/wordpress

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="abouzanb.42.fr" \
        --title="Wordpress" \
        --admin_user="${ADMIN_USER}" \
        --admin_password="${ADMIN_PASSWORD}" \
        --admin_email="${ADMIN_EMAIL}" \
        --allow-root

    echo "Creating additional user..."
    wp user create "${USER_NAME}" "${USER_EMAIL}" \
        --role=author \
        --user_pass="${USER_PASSWORD}" \
        --allow-root
else
    echo "WordPress is already installed."
fi

mkdir -p /run/php
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F