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

if [ -n $Gateway ]; then
    echo "Set the gateway ..."
    echo "Disalbe the eth0 gateway..."
    ip route delete default via 192.168.8.1
    echo "Done"
fi

if [ -z $SERVER_IP ]; then
    echo "Get server ip..."
    SERVER_IP=`curl http://119.29.29.29/d?dn=$SERVER_NAME`
    echo "$SERVER_NAME: $SERVER_IP"
    export SERVER_IP
fi

echo "Setting up network..."
/root/app/ssr-iptables.sh
echo "Done"

echo "Starting SSR client..."
echo VERBOSE: $VERBOSE SERVER_NAME:$SERVER_NAME SERVER_IP:$SERVER_IP SERVER_PORT:$SERVER_PORT SERVER_PASSWORD:$SERVER_PASSWORD TPROXY_PORT:$TPROXY_PORT
ss-redir \
-u \
`[ "$VERBOSE" = "TRUE"  ] && echo "-v"` \
-l $TPROXY_PORT -m aes-256-cfb -b 0.0.0.0 \
-O origin \
-s $SERVER_IP -p $SERVER_PORT -k $SERVER_PASSWORD & wait
