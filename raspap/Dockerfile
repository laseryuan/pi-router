FROM resin/raspberry-pi-debian:stretch-20180626
RUN apt-get update && apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  nano \
  sudo \
  net-tools \
  wireless-tools \
  lighttpd \
  php-cgi \
  git \
--no-install-recommends \
&& apt-get clean

RUN lighty-enable-mod fastcgi-php
RUN /etc/init.d/lighttpd restart

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  wget \
  unzip \
  hostapd \
  bridge-utils \
  hostap-utils \
  iproute2 \
  iw \
  dnsmasq \
  wpasupplicant \
--no-install-recommends \
&& apt-get clean

# Development
# RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
# --no-install-recommends

RUN echo 'www-data ALL=(ALL) NOPASSWD: ALL\n%www-data ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/www-data

RUN chmod 0440 /etc/sudoers.d/www-data
RUN rm -rf /var/www/html
RUN git clone --depth=1 https://github.com/billz/raspap-webgui /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN mkdir /etc/raspap
RUN mv /var/www/html/raspap.php /etc/raspap/
RUN chown -R www-data:www-data /etc/raspap

RUN mkdir /etc/raspap/hostapd
RUN mv /var/www/html/installers/*log.sh /etc/raspap/hostapd

COPY entrypoint.sh /entrypoint.sh

EXPOSE 80
EXPOSE 100

ENTRYPOINT ["/entrypoint.sh"]

# RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
  # dhcpcd5 \
# --no-install-recommends

# RUN adduser root netdev
