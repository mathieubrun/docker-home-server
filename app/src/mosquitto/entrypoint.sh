#!/bin/sh

set -eu

MOSQUITTO_PASSWORD_FILE=/mosquitto/config/passwords

echo "Generating password file"
touch $MOSQUITTO_PASSWORD_FILE
mosquitto_passwd -b $MOSQUITTO_PASSWORD_FILE $MOSQUITTO_USERNAME $MOSQUITTO_PASSWORD

/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf