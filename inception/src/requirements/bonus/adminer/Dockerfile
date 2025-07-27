FROM debian:bullseye

RUN apt-get update

RUN apt-get -y install php php-mysqli wget -y

COPY tools/script.sh /

RUN chmod +x script.sh

ENTRYPOINT [ "./script.sh" ]