# Redsocks docker image.
FROM debian:stretch-20200224

ENV DEBIAN_FRONTEND noninteractive

ENV DOCKER_NET docker0

# Install packages
RUN apt-get update && apt-get install -y redsocks iptables

# Redsocks configuration files...
COPY ./redsocks/redsocks.tmpl /etc/redsocks.tmpl
COPY ./redsocks/whitelist.txt /etc/redsocks-whitelist.txt
COPY ./redsocks/redsocks-fw.sh /usr/local/bin/redsocks-fw.sh

RUN chmod +x /usr/local/bin/*

COPY docker-entrypoint.sh /
COPY README.md /

ENTRYPOINT ["/docker-entrypoint.sh"]
