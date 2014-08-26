a#!/bin/bash
#set -e

sudo apt-get update && sudo apt-get -y dist-upgrade || true
sudo apt-get -y install ubuntu-dev-tools bzr git vim htop || true
sudo apt-get -y install linux-headers-virtual || true
sudo apt-get -y install linux-headers-`uname -r` || true
sudo apt-get -y install lxc || true

