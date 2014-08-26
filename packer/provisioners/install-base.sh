# turn off interactive mode
DEBIAN_FRONTEND=noninteractive

# mount ephemereal
sudo wget \
  https://raw.githubusercontent.com/developerinlondon/aws-mounts/master/install-ephemereal.sh
sudo chmod +x install-ephemereal.sh
sudo ./install-ephemereal.sh
sudo wget -O /etc/init.d/ephemereal-mount \
  https://raw.githubusercontent.com/developerinlondon/aws-mounts/master/etc/init.d/ephemereal-mount
sudo chmod +x /etc/init.d/ephemereal-mount
sudo update-rc.d ephemereal-mount defaults 00

# mount the lxc volume
sudo wget -O /etc/init.d/lxc-mount \
  https://raw.githubusercontent.com/developerinlondon/aws-mounts/master/etc/init.d/lxc-mount
sudo chmod +x /etc/init.d/lxc-mount
sudo update-rc.d lxc-mount defaults 00


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

