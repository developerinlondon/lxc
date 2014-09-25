#!/bin/bash +x

set -e
set -o xtrace

sudo mv mount-es /etc/init.d/
sudo chmod +x /etc/init.d/mount-es
sudo update-rc.d mount-es defaults 00
