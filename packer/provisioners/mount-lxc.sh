#!/bin/bash +x

set -e
set -o xtrace

# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

# install zfs
sudo apt-add-repository ppa:zfs-native/stable -y
sudo apt-get update -y
sudo apt-get install ubuntu-zfs -y

# prepare for zfs to be mounted on next boot
sudo wget -O /etc/init.d/lxc-mount \
  https://raw.githubusercontent.com/developerinlondon/aws-mounts/master/etc/init.d/lxc-mount
sudo chmod +x /etc/init.d/lxc-mount
sudo update-rc.d lxc-mount defaults 00