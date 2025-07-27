FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx

COPY ./conf/index.html /var/www/html/index.html
COPY ./conf/style.css /var/www/html/style.css
COPY ./conf/default etc/nginx/sites-available/default

ENTRYPOINT ["nginx", "-g", "daemon off;"]