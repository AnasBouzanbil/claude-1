FROM debian:bullseye

# Install PHP, nginx and required extensions for PHPMyAdmin
RUN apt-get update -y && apt-get install -y \
    nginx \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-json \
    php7.4-mbstring \
    php7.4-zip \
    php7.4-gd \
    
    php7.4-xml \
    php7.4-curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/www/html

# Download and install phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && tar xzf phpMyAdmin-latest-all-languages.tar.gz \
    && mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin \
    && rm phpMyAdmin-latest-all-languages.tar.gz

# Copy configuration
COPY conf/config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

# Create necessary directories and set permissions
RUN mkdir -p /var/www/html/phpmyadmin/tmp && \
    chmod 777 /var/www/html/phpmyadmin/tmp && \
    chown -R www-data:www-data /var/www/html/phpmyadmin

EXPOSE 80

CMD ["/script.sh"]
