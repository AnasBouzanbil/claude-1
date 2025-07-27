#!/bin/bash

while true; do
    if mysql -u "$DB_USER" -p --password="$DB_PASSWORD" -h "$DB_HOST" -e "USE "$DB_NAME";" &> /dev/null; then
        break
    else
        sleep 1
    fi
done


sed -i "s/listen/;listen/g" /etc/php/7.4/fpm/pool.d/www.conf
echo "listen = 9000" >> /etc/php/7.4/fpm/pool.d/www.conf


cd /var/www/html

if [ ! -d "wordpress" ]; then

    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
    chmod +x wp-cli.phar;
    mv wp-cli.phar /bin/wp;

    mkdir -p wordpress
    cd  wordpress
    wp core download  --allow-root
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
    sed -i "s/username_here/$DB_USER/g" wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$DB_HOST/g" wp-config.php

    chown -R www-data:www-data /var/www/html/wordpress

    wp core install --allow-root --url=$DOMAIN_NAME --title=$SERVER_NAME --admin_user=$WP_ADMIN \
                --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL
    wp user create $WP_USER $WP_USER_EMAIL --role=editor --first_name=$WP_USER_FIRST_NAME \
            --last_name=$WP_USER_LAST_NAME --user_pass=$WP_USER_PASSWORD --allow-root

    # Redis cache configuration

    wp config set WP_REDIS_HOST $CACHE_HOST --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
    wp config set WP_REDIS_CLIENT php-redis --allow-root

    # Redis cache plugin installation

    wp plugin install redis-cache --activate --allow-root
    wp redis enable  --allow-root

fi

mkdir -p /run/php

php-fpm7.4 -F