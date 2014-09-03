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
