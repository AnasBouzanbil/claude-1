FROM debian:bullseye

RUN apt-get update 

RUN apt-get install php-fpm php-mysql mariadb-client php-redis wget -y

COPY tools/script.sh /script.sh

RUN chmod +x script.sh

ENTRYPOINT [ "./script.sh" ]