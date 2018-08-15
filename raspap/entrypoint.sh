#!/bin/bash

wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
lighttpd -D -f /etc/lighttpd/lighttpd.conf
