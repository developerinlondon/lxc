#!/bin/bash +x

set -e
set -o xtrace

# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

sudo apt-add-repository -y ppa:ubuntu-lxc/daily
sudo apt-get update
sudo apt-get -y install lvm2 xfsprogs cryptsetup

for module in dm-crypt aes rmd160; do
    sudo [ -z "$(grep "^$module$" /etc/modules)" ] && sudo /bin/echo "$module" | sudo /usr/bin/tee -a /etc/modules
    sudo /sbin/modprobe "$module"
done

sudo mv mount-ephemeral-es /etc/init.d/
sudo chmod +x /etc/init.d/mount-ephemeral-es
sudo update-rc.d mount-ephemeral-es defaults 00
