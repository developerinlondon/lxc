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

VG_NAME=lxc

. /lib/lsb/init-functions

case "$1" in
  start)
    if df | grep /dev/mapper/$VG_NAME then
      log_daemon_msg "Looks like its already mounted!" "lxc-mount"
      .
    else

      /sbin/vgcreate "$VG_NAME" /dev/xvdf

      VGSIZE=$(/sbin/vgdisplay "$VG_NAME" | grep "Total PE" | sed -e "s/[^0-9]//g")

      [ ! -e "/dev/$VG_NAME/share" ] && /sbin/lvcreate -L 10G -nshare "$VG_NAME"
      [ ! -e "/dev/$VG_NAME/log" ] && /sbin/lvcreate -L 25G -nlog "$VG_NAME"
      [ ! -e "/dev/$VG_NAME/lib" ] && /sbin/lvcreate -l100%FREE -nlib "$VG_NAME"


      # Do /usr/share/lxc
      /sbin/mkfs -t ext4 /dev/$VG_NAME/share
      /bin/mkdir -p /usr/share/lxc
      [ -z "$(mount | grep " on /usr/share/lxc ")" ] && rm -rf /usr/share/lxc/*
      /bin/mount /dev/$VG_NAME/share /usr/share/lxc
      /bin/chmod 755 /usr/share/lxc

      # Do /var/log
      /sbin/mkfs -t ext4 /dev/$VG_NAME/log
      /bin/mkdir -p /var/log
      [ -z "$(mount | grep " on /var/log ")" ] && rm -rf /var/log/*
      /bin/mount /dev/$VG_NAME/log /var/log
      /bin/chmod 755 /var/log

      # Do /var/lib/lxc
      /sbin/mkfs -t ext4 /dev/$VG_NAME/lib
      /bin/mkdir -p /var/lib/lxc
      [ -z "$(mount | grep " on /var/lib/lxc ")" ] && rm -rf /var/lib/lxc/*
      /bin/mount /dev/$VG_NAME/lib /var/lib/lxc
      /bin/chmod 755 /var/lib/lxc

      # update fstab for automounting in future
      sudo echo "/dev/$VG_NAME/share /usr/share/lxc  auto  defaults,nobootwait,comment=lxc 0 0" >> /etc/fstab
      sudo echo "/dev/$VG_NAME/log /var/log auto  defaults,nobootwait,comment=lxc 0 0" >> /etc/fstab
      sudo echo "/dev/$VG_NAME/lib /var/lib/lxc  auto  defaults,nobootwait,comment=lxc 0 0" >> /etc/fstab

      # take off the init script
      update-rc.d -f lxc-mount remove
      log_daemon_msg "Mounted lxc volumes" "lxc-mount"
      .
    fi
    ;;
  stop)
    log_daemon_msg "To unmount run /bin/umount /usr/share/lxc" "lxc-mount"
    ;;

  *)
    echo "Usage: /etc/init.d/lxc-mount {start|stop}"
    exit 1
esac

exit 0