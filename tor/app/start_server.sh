#!/bin/bash

# backup current iptables
sudo iptables-save > ~/iptables.backup

sudo /home/tor/app/tor-iptables.sh
tor -f /home/tor/app/torrc
