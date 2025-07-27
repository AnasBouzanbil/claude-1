#!/bin/bash

openssl req -newkey rsa:2048 -nodes -x509 \
    -out $CERTS_ \
    -keyout $PRIVKEY_ \
    -subj "/C=$COUNTRY/L=$LOCATION/CN=$DOMAIN_NAME"

# newkey : is used to create a new private key
# nodes : is used to skip the option to secure our certificate with a passphrase
# x509 : is used to make a self-signed certificate instead of generating a certificate request

echo "
server {
    listen 443 ssl;

    server_name $DOMAIN_NAME;
    root /var/www/html/wordpress;
    index index.php;

    ssl    on;
    ssl_certificate    $CERTS_;
    ssl_certificate_key    $PRIVKEY_;
    ssl_protocols TLSv1.2 TLSv1.3;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
" > /etc/nginx/sites-available/default

nginx -g 'daemon off;'