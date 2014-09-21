#! /bin/bash

### BEGIN INIT INFO
# Provides:          ephemeral
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Should-Start:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Encrypt and mount ephemeral storage
# Description:       No daemon is created or managed. This script is a Lucid
#                    creation that mounts AWS ephemeral volumes as encrypted,
#                    striped devices.
### END INIT INFO

# set -e
# TODO: doesnt work witht the above. needs investigation.

VG_NAME=ephemeral

. /lib/lsb/init-functions

ephemeral_start() {
    PVSCAN_OUT=$(/sbin/pvscan)

    if [ -z "$(/bin/echo "$PVSCAN_OUT" | grep "/dev/xvdb")" ]; then
        /bin/umount "/dev/xvdb"
        /bin/sed -e "/$(basename /dev/xvdb)/d" -i /etc/fstab
        /bin/dd if=/dev/zero of="/dev/xvdb" bs=1M count=10
        /sbin/pvcreate "dev/xvdb"
    fi

    if [ ! -d "/dev/$VG_NAME" ]; then
        /sbin/vgcreate "$VG_NAME" /dev/xvdb
    fi

    VGSIZE=$(/sbin/vgdisplay "$VG_NAME" | grep "Total PE" | sed -e "s/[^0-9]//g")

    # tmp/log should be 50%
    # NO STRIPING ON ANY VOLUMES!!!
    # for some reason, striping ephemeral volumes is slower than not striping.
    # [ ! -e "/dev/$VG_NAME/log" ] && /sbin/lvcreate -l40%VG -nlog "$VG_NAME"
    [ ! -e "/dev/$VG_NAME/tmp" ] && /sbin/lvcreate -l30%VG -ntmp "$VG_NAME"
    [ ! -e "/dev/$VG_NAME/cache" ] && /sbin/lvcreate -l30%VG -ncache "$VG_NAME"

    # Do /tmp
    /sbin/mkfs.xfs /dev/$VG_NAME/tmp
    /bin/mkdir -p /tmp
    [ -z "$(mount | grep " on /tmp ")" ] && rm -rf /tmp/*
    /bin/mount -t xfs /dev/$VG_NAME/tmp /tmp
    /bin/chmod 1777 /tmp

    # # do /var/log
    # /sbin/mkfs.xfs /dev/$VG_NAME/log
    # mv /var/log /var/log-old
    # /bin/mkdir -p /var/log
    # [ -z "$(mount | grep " on /var/log ")" ] && rm -rf /var/log/*
    # /bin/mount -t xfs /dev/$VG_NAME/log /var/log
    # /bin/chmod 755 /var/log
    # cp -fr /var/log-old/* /var/log/
    # rm -fr /var/log-old

    # do /var/cache
    /sbin/mkfs.xfs /dev/$VG_NAME/cache
    mv /var/cache /var/cache-old
    /bin/mkdir -p /var/cache
    [ -z "$(mount | grep " on /var/cache ")" ] && rm -rf /var/cache/*
    /bin/mount -t xfs /dev/$VG_NAME/cache /var/cache
    /bin/chmod 755 /var/cache
    cp -fr /var/cache-old/* /var/cache/
    rm -fr /var/cache-old

    log_end_msg 0
} # ephemeral_start

ephemeral_stop() {
    cp -fr /var/cache /var/cache-old
    /sbin/umount /var/cache
    /bin/mkdir -p /var/cache
    cp -fr /var/cache-old/* /var/cache/
    rm -fr /var/cache-old

    # cp -fr /var/log /var/log-old
    # /sbin/umount /var/log
    # /bin/chmod 755 /var/log
    # cp -fr /var/log-old/* /var/log/
    # rm -fr /var/log-old

    /bin/umount /tmp

    /sbin/vgchange -an "$VG_NAME"

    log_end_msg 0
} # ephemeral_stop


case "$1" in
  start)
  log_daemon_msg "Mounting ephemeral volumes" "ephemeral"
        ephemeral_start
  ;;

  stop)
  log_daemon_msg "Umounting ephemeral volumes" "ephemeral"
        ephemeral_stop
  ;;

  *)
  echo "Usage: /etc/init.d/mount-ephemeral {start|stop}"
  exit 1
esac

exit 0
