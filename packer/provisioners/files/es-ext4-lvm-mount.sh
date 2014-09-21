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

VG_NAME=es

. /lib/lsb/init-functions

case "$1" in
  start)
    if [ $(df | grep /dev/mapper/$VG_NAME) ]; then
      log_daemon_msg "Looks like its already mounted!" "es-mount"
      .
    else

      /sbin/vgcreate "$VG_NAME" /dev/xvdf

      VGSIZE=$(/sbin/vgdisplay "$VG_NAME" | grep "Total PE" | sed -e "s/[^0-9]//g")

      [ ! -e "/dev/$VG_NAME/data" ] && /sbin/lvcreate -l80%FREE -ndata "$VG_NAME"
      [ ! -e "/dev/$VG_NAME/log" ] && /sbin/lvcreate -l100%FREE -nlog "$VG_NAME"


      # Do /var/lib/elasticsearch
      /sbin/mkfs -t ext4 /dev/$VG_NAME/data
      /bin/mkdir -p /var/lib/elasticsearch
      [ -z "$(mount | grep " on /var/lib/elasticsearchc ")" ] && rm -rf /var/lib/elasticsearch/*
      /bin/mount /dev/$VG_NAME/data /var/lib/elasticsearch
      /bin/chmod 755 /var/lib/elasticsearch

      # Do /var/log
      /sbin/mkfs -t ext4 /dev/$VG_NAME/log
      /bin/mkdir -p /var/log
      [ -z "$(mount | grep " on /var/log ")" ] && rm -rf /var/log/*
      /bin/mount /dev/$VG_NAME/log /var/log
      /bin/chmod 755 /var/log

      # update fstab for automounting in future
      sudo echo "/dev/$VG_NAME/data /var/lib/elasticsearch  auto  defaults,nobootwait,comment=es 0 0" >> /etc/fstab
      sudo echo "/dev/$VG_NAME/log /var/log auto  defaults,nobootwait,comment=es 0 0" >> /etc/fstab

      # take off the init script
      update-rc.d -f es-mount remove
      log_daemon_msg "Mounted es volumes" "es-mount"
      .
    fi
    ;;
  stop)
    log_daemon_msg "To unmount run /bin/umount /var/lib/elasticsearch" "es-mount"
    ;;

  *)
    echo "Usage: /etc/init.d/es-mount {start|stop}"
    exit 1
esac

exit 0