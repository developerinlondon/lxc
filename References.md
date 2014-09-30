References:
===========
Locale settings fix: http://stackoverflow.com/questions/21816121/ubuntu-server-strange-locale-issue

lwp: https://github.com/claudyus/LXC-Web-Panel

ansible:
  restarting server: https://support.ansible.com/hc/en-us/articles/201958037-Reboot-a-server-and-wait-for-it-to-come-back

sublime:
  mounting remote volume: http://stackoverflow.com/questions/2597712/editing-remote-files-over-ssh-using-textmate
  mkdir /Volumes/lcm
  /usr/local/bin/sshfs ubuntu@lxc:/lcm /Volumes/lcm

lxc:
  backup/restore: http://criu.org/LXC
  pre-created images: http://download.openvz.org/template/precreated/

testing:
  serverspec: http://sharknet.us/2014/02/04/infrastructure-testing-with-ansible-and-serverspec-part-1/
  ansible_spec: http://rubygems.org/gems/ansible_spec


installing elasticsearch 1.3.x on ubuntu 14.04:
  http://blog.bekijkhet.com/2014/06/install-elasticsearch-in-ubuntu-1404.html

elasticsearch aws discovery:
  http://www.markbetz.net/2014/03/18/elasticsearch-discovery-in-ec2/


more references:

- http://blog.scottlowe.org/2013/05/07/using-gre-tunnels-with-open-vswitch/
- http://s3hh.wordpress.com/2012/05/28/connecting-containers-on-several-hosts-with-open-vswitch/


building lxc server:

- building - http://terrarum.net/blog/building-an-lxc-server-1404.html#back_to_zfs
- snapshotting - https://www.stgraber.org/2013/12/27/lxc-1-0-container-storage/
- configuring nat - http://wernerstrydom.com/2013/02/23/configure-ubuntu-server-12-04-to-do-nat/


iptables howto:

- deleting rule: `sudo iptables -t nat -D lxc-nat 1`
- adding rule: `sudo iptables -t nat -A lxc-nat -d 172.31.23.17 -p tcp --dport 40000 -j DNAT --to 10.0.3.95:80`
- configuring firejail: https://www.digitalocean.com/community/tutorials/how-to-use-firejail-to-set-up-a-wordpress-installation-in-a-jailed-environment

IPTABLES ISSUE:

- https://gist.github.com/developerinlondon/36ecd1cf9be0b994f098

```console
$ iptables -A POSTROUTING -d 10.0.3.95/32 -p tcp -m tcp --dport 80 -j MASQUERADE -t nat
$ iptables -A PREROUTING -d 172.31.23.17/32 -p tcp -m tcp --dport 40000 -j DNAT --to-destination 10.0.3.95:80 -t nat
```

Update rc.d:

http://www.jamescoyle.net/cheat-sheets/791-update-rc-d-cheat-sheet

configuring zfs:

http://terrarum.net/blog/building-an-lxc-server.html#creating_a_base_container

octohost:
===========
- octohost - https://github.com/octohost/octohost
