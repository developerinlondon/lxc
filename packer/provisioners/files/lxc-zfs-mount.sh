#! /bin/bash

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

VG_NAME=lxc-mount
KEYDIR=/var/cache/lxc-mount

. /lib/lsb/init-functions

lxc_start() {
    if zpool list | grep -q "no pools available"; then
        # create and mount the lxc volume
        zpool create -f lxc /dev/xvdf
        ln -s /lxc /usr/share/

        # turn on deduplication and compression
        zfs set dedup=on lxc
        zfs set compression=on lxc

        # use native snapshots
        zpool set listsnapshots=on lxc

        echo 'lxc zfs mounted on /usr/share/lxc. Deduplication, compression and native snapshots have been turned on!'
        # remove it from auto-startup list
        update-rc.d -f lxc-mount remove
        .
    else
        echo 'zfs already mounted!'
        echo $(zpool list)
        .
    fi
} # lxc_start



lxc_stop() {
 #   /bin/umount /usr/share/lxc
    echo 'unmounting is not implemented yet!'
} # lxc_stop


case "$1" in
  start)
        log_daemon_msg "Mounting lxc volumes" "lxc-mount"
        lxc_start
        ;;

  stop)
        log_daemon_msg "Umounting lxc volumes" "lxc-mount"
        lxc_stop
        ;;

  *)
        echo "Usage: /etc/init.d/lxc-mount {start|stop}"
        exit 1
esac

exit 0
