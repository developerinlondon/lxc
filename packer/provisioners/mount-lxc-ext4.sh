#!/bin/bash +x

set -e
set -o xtrace

sudo mv lxc-mount /etc/init.d/
sudo chmod +x /etc/init.d/lxc-mount
sudo update-rc.d lxc-mount defaults 00
