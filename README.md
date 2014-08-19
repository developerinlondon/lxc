adding a new instance on aws:

```
 aws ec2 run-instances --count=2 --user-data=user-data-lxc-ovs.sh --key-name=mesos --instance-type=r3.large --image-id=ami-4aa87722
```

references:
http://blog.scottlowe.org/2013/05/07/using-gre-tunnels-with-open-vswitch/
http://s3hh.wordpress.com/2012/05/28/connecting-containers-on-several-hosts-with-open-vswitch/


building lxc server:
http://terrarum.net/blog/building-an-lxc-server-1404.html#back_to_zfs
snapshotting - https://www.stgraber.org/2013/12/27/lxc-1-0-container-storage/
configuring nat - http://wernerstrydom.com/2013/02/23/configure-ubuntu-server-12-04-to-do-nat/


iptables:
deleting rule: sudo iptables -t nat -D lxc-nat 1
adding rule: sudo iptables -t nat -A lxc-nat -d 172.31.23.17 -p tcp --dport 40000 -j DNAT --to 10.0.3.95:80

