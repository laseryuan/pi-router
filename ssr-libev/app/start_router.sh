#!/bin/bash

# backup current iptables
iptables-save > ~/iptables.backup

# SIGTERM-handler
term_handler() {
  echo "Shutting down the container. Trying to restore iptables ..."
  iptables-restore < ~/iptables.backup
  echo "Done"
  exit 143; # 128 + 15 -- SIGTERM
}
trap 'term_handler' SIGHUP SIGINT SIGTERM

echo "Setting up network..."
/root/app/ssr-iptables.sh
echo "Done"

echo "Starting SSR client..."
echo -s SERVER_NAME:$SERVER_NAME SERVER_PORT:$SERVER_PORT SERVER_PASSWORD:$SERVER_PASSWORD TPROXY_PORT:$TPROXY_PORT
ss-local \
-l $TPROXY_PORT -m aes-256-cfb -b 0.0.0.0 \
-O origin \
-s $SERVER_NAME -p $SERVER_PORT -k $SERVER_PASSWORD & wait
