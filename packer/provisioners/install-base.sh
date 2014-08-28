#!/bin/bash +x

set -e
set -o xtrace

# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

# disable ssh usedns
if [ -f /etc/ssh/sshd_config ]; then
  sudo sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
fi

sudo apt-get install -y --no-install-recommends software-properties-common

# install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends ansible

# fix locale
sudo apt-get install language-pack-en -y