#!/bin/bash

# backup current iptables
sudo iptables-save > ~/iptables.backup

# SIGTERM-handler
term_handler() {
  echo "Shutting down the container. Trying to restore iptables ..."
  sudo iptables-restore < ~/iptables.backup
  echo "Done"
  exit 143; # 128 + 15 -- SIGTERM
}
trap 'term_handler' SIGHUP SIGINT SIGTERM

echo "Setting up network..."
sudo /home/tor/app/tor-iptables.sh
echo "Done"

echo "Starting Tor..."
tor -f /home/tor/app/torrc & wait
