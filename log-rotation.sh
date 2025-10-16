#!/bin/bash

# Bersihin log rotasi lama
rm -f /var/log/*.1
rm -f /var/log/*.gz
rm -rf /var/log/installer
rm -rf /var/log/journal/*

# Truncate log aktif biar tetap ada tapi kosong
truncate -s 0 /var/log/syslog
truncate -s 0 /var/log/kern.log
truncate -s 0 /var/log/auth.log
truncate -s 0 /var/log/dpkg.log
truncate -s 0 /var/log/ufw.log

# Bersihin journal log systemd
journalctl --vacuum-size=100M

# Jalankan logrotate manual pakai config custom (kalau ada)
if [ -f /etc/logrotate.d/custom-cleanup ]; then
    /usr/sbin/logrotate /etc/logrotate.d/custom-cleanup
fi
