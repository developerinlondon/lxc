#!/bin/bash +x

### BEGIN INIT INFO
# Provides:          lxc-mount
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Should-Start:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Encrypt and mount lxc storage
# Description:       No daemon is created or managed. This script is a Lucid
#                    creation that mounts AWS lxc volumes as encrypted,
#                    striped devices.
### END INIT INFO

set -e
set -o xtrace

VG_NAME=log

. /lib/lsb/init-functions

case "$1" in
  start)
    if [ $(df | grep /dev/mapper/$VG_NAME) ]; then
      log_daemon_msg "Looks like its already mounted!" "mount-log"
      .
    else

      /sbin/vgcreate "$VG_NAME" /dev/xvde

      VGSIZE=$(/sbin/vgdisplay "$VG_NAME" | grep "Total PE" | sed -e "s/[^0-9]//g")

      [ ! -e "/dev/$VG_NAME" ] && /sbin/lvcreate -l100%FREE -nlog "$VG_NAME"

      # Do /var/log
      /sbin/mkfs -t ext4 /dev/$VG_NAME
      /bin/mkdir -p /var/log
      [ -z "$(mount | grep " on /var/log ")" ] && rm -rf /var/log/*
      /bin/mount /dev/$VG_NAME /var/log
      /bin/chmod 755 /var/log

      # update fstab for automounting in future
      sudo echo "/dev/$VG_NAME /var/log auto  defaults,nobootwait,comment=es 0 0" >> /etc/fstab

      # take off the init script
      update-rc.d -f mount-log remove
      log_daemon_msg "Mounted log volumes" "mount-log"
      .
    fi
    ;;
  stop)
    log_daemon_msg "To unmount run /bin/umount /var/log" "mount-log"
    ;;

  *)
    echo "Usage: /etc/init.d/mount-log {start|stop}"
    exit 1
esac

exit 0