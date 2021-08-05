#!/usr/bin/env bash

cp daily_backup.service /etc/systemd/system/
cp daily_backup.timer /etc/systemd/system/
cp daily_backup.sh /usr/local/bin/