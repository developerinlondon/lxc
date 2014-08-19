# Generic AMI for mesos cluster instance

## Packer

Install [Packer](http://www.packer.io/docs/installation.html).

## Way to go.

Two main files are to be created here: `playbook.yml` and `build.json`.
We're going to use Packer with the Ansible provider to gain an AMI with
mesos and marathon built in.

Machine should be very similar to [this ami](http://thecloudmarket.com/image/ami-a8ca06c0--thefactory-mesos-2014-07-16t20-15-36z).

For the setup details feel free to visit the actual master and slave
by ssh.

Ubuntu 14.04, runit, docker. redis, nodejs, hipache.
Scripts to call from userdata like `runit-service`.

Should have a parameter to choose whether to create [HVM image](https://console.aws.amazon.com/ec2/v2/home?region=ap-northeast-1#LaunchInstanceWizard:ami=ami-ffd79dfe) or not.

Learn more from sshing to machines and checking CloudInit and userdata
from files `cfn/master.json` and `cfn/slave.json`.

Also we must mount EBS `/dev/xvda` to `/var` and configure `fstab` to
do this on boot, most likely in user data. We can avoid having to
`makefs` by doing it once, creating a snapshot and referencing it in
cloud formation templates.

Anyway, ssh on those machines and current template definition files
are your friends.

To run:
`packer build build.json`

then
`vagrant up`
`vagrant ssh`

