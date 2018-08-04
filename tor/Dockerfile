FROM resin/raspberry-pi-debian:stretch-20180626
RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y \
  iptables \
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

# COPY torrc /etc/tor/
# RUN chown tor:tor /etc/tor/torrc

COPY app /home/tor/app

USER tor
WORKDIR /home/tor/app/

# set command as minimal default
ENTRYPOINT [ "tor" ]
CMD [ "-f", "/home/tor/app/torrc" ]
