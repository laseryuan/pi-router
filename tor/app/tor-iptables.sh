#!/bin/bash
# Most of this is credited to
# https://blog.jessfraz.com/post/routing-traffic-through-tor-docker-container/
# https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy
# With a few minor edits

# to run iptables commands you need to be root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    return 1
fi

### set variables
# destinations you don't want routed through Tor
_non_tor="192.168.1.0/24 192.168.0.0/24"

# get the UID that Tor runs as
_tor_uid=$(id -u tor)

# Tor's TransPort
_trans_port="9040"
_dns_port="15353"

### route all trafic to local port
iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to 127.0.0.1:$_dns_port
iptables -t nat -A PREROUTING -p tcp --syn ! --dport 22 -j DNAT --to 127.0.0.1:$_trans_port

### set iptables *nat

# local requests
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports $_dns_port

# allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/9 127.128.0.0/10; do
   iptables -t nat -A OUTPUT -d $_clearnet -j RETURN
done

# redirect all other output to Tor's TransPort
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port

### set iptables *filter
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/8; do
   iptables -A OUTPUT -d $_clearnet -j ACCEPT
done

# allow only Tor output
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
# iptables -A OUTPUT -j REJECT
