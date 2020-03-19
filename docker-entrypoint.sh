#!/bin/bash
# vim: set noswapfile :

main() {
  case "$1" in
    run)
shift
/usr/local/bin/redsocks.sh "$@"
      ;;
    help)
cat /README.md
      ;;
    *)
      exec "$@"
      ;;
  esac
}

main "$@"


