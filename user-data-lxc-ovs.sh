a#!/bin/bash
#set -e

wget -O /home/ubuntu/.inputrc http://people.canonical.com/~serge/.inputrc
cat >> /home/ubuntu/.bashrc << EOF
set -o vi
export QUILT_PATCHES=debian/patches
export EDITOR=vim
export VISUAL=vim
EOF
cat > /home/ubuntu/.vimrc << EOF
set et sw=4 ts=4
set ai si sm
set background=dark
set hlsearch
EOF
chown ubuntu:ubuntu /home/ubuntu/{.vimrc,.bashrc,.inputrc}

cat >> /etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu/ trusty main universe
deb-src http://archive.ubuntu.com/ubuntu/ trusty main universe

deb http://archive.ubuntu.com/ubuntu/ trusty-updates main universe
deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates main universe

deb http://security.ubuntu.com/ubuntu trusty-security main universe
deb-src http://security.ubuntu.com/ubuntu trusty-security main universe
EOF

sudo apt-get update && sudo apt-get -y dist-upgrade || true
sudo apt-get -y install ubuntu-dev-tools bzr git vim || true
sudo apt-get -y install linux-headers-virtual openvswitch-datapath-source openvswitch-datapath-dkms openvswitch-common openvswitch-switch openvswitch-brcompat || true
sudo apt-get -y install linux-headers-`uname -r` || true
sudo apt-get -y install --reinstall openvswitch-datapath-dkms || true
sudo apt-get -y install lxc || true
sudo /etc/init.d/openvswitch-switch start
sudo ovs-vsctl add-br br0

wget http://instance-data/latest/meta-data/ami-launch-index
idx=`cat ami-launch-index`
ipidx=$((idx+5))

cat > /etc/lxc/lxc-ovs.conf << EOF
lxc.network.type=veth
lxc.network.link=lxcbr0
lxc.network.flags=up
lxc.network.type=veth
lxc.network.script.up=/etc/lxc/ovsup
lxc.network.ipv4=192.168.100.$ipidx
lxc.network.flags=up
EOF


cat > /etc/lxc/ovsup << EOF
#!/bin/bash

ifconfig \$5 0.0.0.0 up
ovs-vsctl add-port br0 \$5
EOF
chmod ugo+x /etc/lxc/ovsup

lxc-create -t ubuntu -n p1 -f /etc/lxc/lxc-ovs.conf
#
# now on host do sudo ovs-vsctl add-port br0 gre0 -- set interface gre0 type=gre options:remote_ip=x.x.x.x
# where x.x.x.x is the public ip address of eth0 on the other ec2 node
