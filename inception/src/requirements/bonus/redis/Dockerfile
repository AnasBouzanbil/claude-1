FROM  debian:bullseye

RUN   apt-get update

RUN   apt-get install redis-server -y

ENTRYPOINT ["redis-server", "--protected-mode", "no"]


# By default, Redis only listens on port 6379 on localhost.
# --protected-mode no : Disable protected mode.
# Protected mode is a layer of security protection, that by default prevents Redis from accepting connections from remote hosts