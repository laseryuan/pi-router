FROM resin/raspberry-pi-debian:stretch-20180626
RUN apt-get update && apt-get -y upgrade

RUN apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev asciidoc xmlto
RUN apt-get install --no-install-recommends -y libz-dev


ADD ./ssr-libev-2.5.3.tar.gz /tmp/
RUN mv /tmp/shadowsocksr-libev-2.5.3 /root/shadowsocksr-libev

WORKDIR /root/shadowsocksr-libev

RUN ./configure && make
RUN make install

RUN apt-get update
RUN apt-get install -y \
  iptables \
  --no-install-recommends
RUN apt-get install -y \
  iproute2 \
  --no-install-recommends

# Development
# RUN apt-get install -y \
  # curl \
  # dnsutils \
  # netcat \
  # --no-install-recommends

COPY app /root/app
WORKDIR /root/app/

STOPSIGNAL SIGTERM
ENTRYPOINT [ "./start_router.sh" ]
