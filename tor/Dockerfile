FROM resin/raspberry-pi-debian:stretch-20180626
RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y \
  tor \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

ENV HOME /home/tor
RUN useradd --uid 109 --create-home --home-dir $HOME tor \
    && chown -R tor:tor $HOME

# RUN adduser -Ds /bin/sh tor
# RUN mkdir /home/tor/.tor && chown tor:tor /home/tor/.tor -R

COPY torrc /etc/tor/
RUN chown tor:tor /etc/tor/torrc

# Development
RUN apt-get update && apt-get install -y \
  netcat \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

USER tor

# set command as minimal default
ENTRYPOINT [ "tor" ]
CMD [ "-f", "/etc/tor/torrc" ]
