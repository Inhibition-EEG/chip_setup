#!/bin/sh
source /usr/local/bin/gpio.sh
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket
export DISPLAY=:0
PATH=$PATH:/usr/local/bin
cd /home/chip/Inhibition
now=$(date +"%m_%d_%Y")
date >> "log_$now.log"
#jackd -P75 -dalsa -Phw:0 -p8192 -n3 -s -r44100 & #if you use the default audio output
jackd -P75 -dalsa -Phw:1 -p8192 -n3 -s -r44100 & #if you use the usb soundcard
sleep 15
sclang main.scd >> "log_$now.log"
exit 0
