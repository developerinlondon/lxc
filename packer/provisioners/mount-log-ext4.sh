#!/bin/bash +x

set -e
set -o xtrace

sudo mv mount-log /etc/init.d/
sudo chmod +x /etc/init.d/mount-log
sudo update-rc.d mount-log defaults 00
