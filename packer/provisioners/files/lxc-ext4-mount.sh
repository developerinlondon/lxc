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

VG_NAME=lxc-mount

. /lib/lsb/init-functions

case "$1" in
  start)
    if df | grep /dev/xvdf; then
      log_daemon_msg "Looks like its already mounted!" "lxc-mount"
      .
    else
      mkfs -t ext4 /dev/xvdf
      mkdir -p /usr/share/lxc
      mount /dev/xvdf /usr/share/lxc
      sudo echo "/dev/xvdf  /usr/share/lxc  auto  defaults,nobootwait,comment=lxc 0 0" >> /etc/fstab
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