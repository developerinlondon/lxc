#!/bin/bash +x

set -e
set -o xtrace

# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

# mount ephemereal
# if [ $(whoami) != "root" ]; then
#     echo "Must be run as root. Try:"
#     echo "sudo $*"
#     exit 1
# fi

sudo apt-add-repository -y ppa:ubuntu-lxc/daily
sudo apt-get update
sudo apt-get -y install lvm2 xfsprogs cryptsetup

for module in dm-crypt aes rmd160; do
    sudo [ -z "$(grep "^$module$" /etc/modules)" ] && sudo /bin/echo "$module" | sudo /usr/bin/tee -a /etc/modules
    sudo /sbin/modprobe "$module"
done

sudo wget -O /etc/init.d/ephemereal-mount \
  https://raw.githubusercontent.com/developerinlondon/aws-mounts/master/etc/init.d/ephemereal-mount
sudo chmod +x /etc/init.d/ephemereal-mount
sudo update-rc.d ephemereal-mount defaults 00
