#!/bin/bash +x

set -e
set -o xtrace

sudo mv es-mount /etc/init.d/
sudo chmod +x /etc/init.d/es-mount
sudo update-rc.d es-mount defaults 00
