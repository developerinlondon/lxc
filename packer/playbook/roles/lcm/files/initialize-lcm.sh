#!/bin/bash

set -e
set -o xtrace

cd /lcm

\curl -sSL https://get.rvm.io | sudo bash -s stable

echo "source /etc/profile.d/rvm.sh" >> /etc/bash.bashrc

source /etc/profile.d/rvm.sh

rvm install ruby-2.1.2

rvm use 2.1.2

bundle install

# prepare the git info
git config --global user.name "Nayeem Syed"
git config --global user.email developerinlondon@gmail.com

# just so that user ubuntu can operate lcm
chown -R ubuntu:ubuntu /usr/local/rvm
chown -R ubuntu:ubuntu /lcm
chown -R ubuntu:ubuntu /lcm/.git
