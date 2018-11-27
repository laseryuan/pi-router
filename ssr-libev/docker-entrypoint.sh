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
  echo docker run -d --restart always \
    --sysctl net.ipv4.conf.all.route_localnet=1 \
    --net=host \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --name ssr-router \
    -e TPROXY_PORT={19040} \
    -e SERVER_NAME={changeme.com} \
    -e SERVER_PORT={14443} \
    -e SERVER_PASSWORD={MY_SSPASSWORD} \
    lasery/rpi-ssr-libev \
    router
}

main "$@"

