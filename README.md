# Usage
```
docker run --rm lasery/rpi-router help
```

# Development

## Set enviornment
```
export REPO=rpi-router && export VERSION=$(date "+%y.%m")
cd ~/projects/rpi-router
```

```
DEV_SERVER=\

sshfs ${DEV_SERVER}:projects/${REPO} ~/projects/sshfs
cd ~/projects/sshfs

Mount docker volume
sudo vim /etc/fuse.conf # uncomment user_allow_other in /etc/fuse.conf
sshfs -o allow_other ${DEV_SERVER}:projects/${REPO} ~/projects/sshfs
```

## Build image
```
./build.sh docker
docker buildx bake
```

```
  -e DOCKER_NET \

  -v $(pwd)/redsocks/redsocks-fw.sh:/usr/local/bin/redsocks-fw.sh
  -v $(pwd)/redsocks/redsocks.tmpl:/etc/redsocks.tmpl
  -v $(pwd)/docker-entrypoint.sh:/docker-entrypoint.sh

docker run --rm --privileged=true --net=host --sysctl net.ipv4.conf.all.route_localnet=1 --name rpi-router \
  rpi-router \
  run \
  ${PROXY_IP} ${PROXY_PORT}

curl ipinfo.io/ip

sudo watch -d iptables -t nat -L --line-numbers -v -n

sudo iptables -t nat -D PREROUTING 2
sudo iptables -t nat -D OUTPUT 2
```

## Test
Credit: https://github.com/fphammerle/docker-tor-proxy
test proxies:
```
$ curl --proxy socks5h://localhost:9050 ipinfo.io
$ torsocks wget -O - ipinfo.io
$ torsocks lynx -dump https://check.torproject.org/
$ dig @localhost fabian.hammerle.me
$ ssh -o 'ProxyCommand nc -x localhost:9050 -v %h %p' abcdefghi.onion
# no anonymity!
$ chromium-browser --proxy-server=socks5://localhost:9050 ipinfo.io
```

isolate:
```
iptables -A OUTPUT ! -o lo -j REJECT --reject-with icmp-admin-prohibited
```

change SocksTimeout option:
```
$ docker run -e SOCKS_TIMEOUT_SECONDS=60 …
```

## Tunnel router
1. Start router container
- ShadowsocksR
```
docker run --rm lasery/pi-router help

read -p 'Server IP (optional): ' SERVER_IP && echo $SERVER_IP
```

- Tor
```
read -p 'Network Interface: ' NIC && NIC=${NIC:-wlan0} && echo $NIC
docker run --restart=always --sysctl net.ipv4.conf.$NIC.route_localnet=1 --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW -d --name=tor lasery/rpi-tor:18.07
```

1. Set ethnet devices' gateway to the ip of the pi-router

Always use "docker stop tor" to stop the router container. Don't use "docker rm -f tor" to stop the container, since that would leave a trail to the network configuration

## Raspap
1. Start container
```
docker run -d --restart always --privileged --pid=host --net=host --name raspap -v /etc/wpa_supplicant/wpa_supplicant.conf:/etc/wpa_supplicant/wpa_supplicant.conf lasery/raspap:18.08
```

1. Stop raspap
```
docker rm -f raspap
```

# TODO
1. Run without "--net=host"
How to deal with "ip rule add" and "ip route add" in ssr-iptables.sh

1. Duplicate rules got added by "ip" command

1. How to resovle ssr server ip?
