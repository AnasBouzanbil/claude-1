#!/bin/bash

mkdir -p /var/www/html/

wget https://www.adminer.org/latest.php -O /var/www/html/index.php

cd /var/www/html/

php -S "0.0.0.0:8080"