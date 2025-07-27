FROM debian:bullseye

RUN apt-get update

RUN apt-get install nginx openssl -y

COPY tools/script.sh .

RUN chmod +x script.sh

ENTRYPOINT [ "./script.sh" ]