FROM debian:bullseye

RUN apt-get update && apt-get install -y wget tar

RUN wget https://github.com/portainer/portainer/releases/download/2.14.2/portainer-2.14.2-linux-amd64.tar.gz

RUN tar -xf portainer-2.14.2-linux-amd64.tar.gz

# -x : Extract a tar.
# -f : File.

ENTRYPOINT ["./portainer/portainer"]
#