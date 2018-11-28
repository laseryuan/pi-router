#!/bin/bash
# vim: set noswapfile :

main() {
  case "$1" in
    router)
      run-router
      ;;
    help)
      run-help
      ;;
    *)
      exec "$@"
      ;;
  esac
}

run-router() {
    . ./start_router.sh
}

run-help() {
  echo "* Step 1: Router IP (eth0):"
  echo `ip address show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
  echo "* Step 2: Run following command to start the router:"
  echo docker run -d --restart always \
    --sysctl net.ipv4.conf.all.route_localnet=1 \
    --net=host \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --name pi-router \
    -e TPROXY_PORT=19040 \
    -e SERVER_NAME={changeme.com} \
    -e SERVER_PORT={14443} \
    -e SERVER_PASSWORD={MY_SSPASSWORD} \
    lasery/pi-router \
    router
}

main "$@"

