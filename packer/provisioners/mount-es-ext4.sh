#! /bin/bash

set -e
set -o xtrace

sudo sgdisk -Z /dev/xvdf
sudo sgdisk --new=0:0:-32G -t 1:8300 /dev/xvdf
sudo mkfs.ext4 /dev/xvdf1
sudo mkdir -p /mnt/data

sudo /bin/mount /dev/xvdf1 /mnt/data
sudo /bin/bash -c 'echo "/dev/xvdf1 /mnt/data  ext4\n$(cat /etc/fstab)" > /etc/fstab'