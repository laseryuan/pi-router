#!/bin/bash
# vim: set noswapfile :

main() {
  case "$1" in
    redsocks)
shift
run-redsocks "$@"
      ;;
    ipt2socks)
shift
run-ipt2socks "$@"
      ;;
    sstproxy)
shift
run-sstproxy
      ;;
    help)
cat /README.md
      ;;
    *)
      exec "$@"
      ;;
  esac
}

run-sstproxy() {
  ss-tproxy-config

  # setup handlers
  trap 'usr_handler' SIGUSR1
  trap 'term_handler_sstp' SIGTERM

  echo "Starting ss-tproxy ..."
  ss-tproxy start

  # wait indefinetely
  echo wait indefinetely
  tail -f /dev/null & wait
  echo ending ...
}

ss-tproxy-config-valid() {
  if test $# -eq 2
  then
      socks_ip=$1
      socks_port=$2
  else
      echo "No proxy URL defined. Using default."
      exit 125
  fi
}

ss-tproxy-config() {
  socks_ip=${SOCKS_IP}
  socks_port=${SOCKS_PORT}
  if_debug=${VERBOSE}
  # ss-tproxy-config-valid

  [[ "${if_debug}" == "true" ]] && ipt2socks_verbose='-v' || ipt2socks_verbose=''

  echo "Creating ss-tproxy configuration file ..."
  sed \
    -e "s|\${host_address}|${HOST_ADDRESS}|" \
    -e "s|\${DEBUG}|${if_debug}|" \
    -e "s|\${proxy_startcmd}|start_ipt2socks|" \
    -e "s|\${proxy_stopcmd}|kill -9 \$(pidof ipt2socks)|" \
      /etc/ss-tproxy/tmpl/ss-tproxy.conf.tmpl > /etc/ss-tproxy/ss-tproxy.conf

  echo "Creating ipt2socks configuration file using ${socks_ip}:${socks_port}..."
  sed \
    -e "s|\${socks_ip}|${socks_ip}|" \
    -e "s|\${socks_port}|${socks_port}|" \
    -e "s|\${verbose}|${ipt2socks_verbose}|" \
      /etc/ss-tproxy/tmpl/start_ipt2socks.tmpl >> /etc/ss-tproxy/ss-tproxy.conf

  cat /etc/ss-tproxy/ss-tproxy.conf
}

run-ipt2socks() {
  if test $# -eq 2
  then
      proxy_ip=$1
      proxy_port=$2
  else
      echo "No proxy URL defined. Using default."
      exit 125
  fi

  echo "Activating iptables rules..."
  /usr/local/bin/redsocks-fw.sh start

  pid=0

  # setup handlers
  trap 'kill ${!}; usr_handler' SIGUSR1
  trap 'kill ${!}; term_handler' SIGTERM

  echo "Starting ipt2socks using proxy ${proxy_ip}:${proxy_port}..."
  ipt2socks -R -s ${proxy_ip} -p ${proxy_port} &
  pid="$!"

  # wait indefinetely
  while true
  do
      tail -f /dev/null & wait ${!}
  done
}

run-redsocks() {
  if test $# -eq 2
  then
      proxy_ip=$1
      proxy_port=$2
  else
      echo "No proxy URL defined. Using default."
      exit 125
  fi

  echo "Creating redsocks configuration file using proxy ${proxy_ip}:${proxy_port}..."
  sed -e "s|\${proxy_ip}|${proxy_ip}|" \
      -e "s|\${proxy_port}|${proxy_port}|" \
      /etc/redsocks.tmpl > /tmp/redsocks.conf

  echo "Generated configuration:"
  cat /tmp/redsocks.conf

  echo "Activating iptables rules..."
  /usr/local/bin/redsocks-fw.sh start

  pid=0

  # setup handlers
  trap 'kill ${!}; usr_handler' SIGUSR1
  trap 'kill ${!}; term_handler' SIGTERM

  echo "Starting redsocks..."
  redsocks -c /tmp/redsocks.conf &
  pid="$!"

  # wait indefinetely
  while true
  do
      tail -f /dev/null & wait ${!}
  done
}


# SIGUSR1 handler
usr_handler() {
  echo "usr_handler"
}

# SIGTERM-handler
term_handler() {
    if [ $pid -ne 0 ]; then
        echo "Term signal catched. Shutdown redsocks and disable iptables rules..."
        kill -SIGTERM "$pid"
        wait "$pid"
        /usr/local/bin/redsocks-fw.sh stop
    fi
    exit 143; # 128 + 15 -- SIGTERM
}

term_handler_sstp() {
  echo "Term signal catched. Shutdown ss-tproxy ..."
  ss-tproxy stop
  exit 143; # 128 + 15 -- SIGTERM
}

main "$@"
