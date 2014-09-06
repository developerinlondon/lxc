#!/bin/bash +x

set -e
set -o xtrace

# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y --no-install-recommends software-properties-common

# install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends ansible

# overwrite the ansible hosts file
rm -f /etc/ansible/hosts
echo "localhost" > /etc/ansible/hosts