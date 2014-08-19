# turn off interactive mode
DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y --no-install-recommends software-properties-common

# install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends ansible
