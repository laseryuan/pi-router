FROM resin/raspberry-pi-debian:stretch-20180626
RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y \
  iptables \
  sudo \
  tor \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Development
# RUN apt-get update
# RUN apt-get install -y \
  # curl \
  # dnsutils \
  # netcat \
  # --no-install-recommends

ENV HOME /home/tor
RUN useradd --uid 109 --create-home --home-dir $HOME tor \
    && chown -R tor:tor $HOME
RUN adduser tor sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY app /home/tor/app

USER tor
WORKDIR /home/tor/app/

# set command as minimal default
CMD [ "./start_server.sh" ]
