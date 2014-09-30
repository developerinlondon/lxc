Install ElasticSearch
=====================

1. get a base ami image. (unless one already exists):

  `packer build build-es-base.json`

2. Put in the base image id in build-es-base.json to build a base-es image (for elasticSearch).

3. build the es base image:

  `packer build -var 'base_es_ami=<new_image_id>' post-build-es-base.json`

4. Update the cloudformation (config/uat.json) so it uses the base-es image.

5. Run cloudformation create elasticSearch Cluster to build the elasticSearch cluster.

  `aws cloudformation create-stack --stack-name es-uat --parameters file://config/uat.json --template-body "file://es-cluster.json" --capabilities CAPABILITY_IAM`


Install LXC Cluster
===================

1. Run `packer build build-base.json` to get a base ami image. (unless one already exists)
2. Put in the base image id in build-lxc-base.json to build a base-lxc image (for elasticSearch).
3. Run `packer build build-lxc-base.json` to build the es base image.
4. Update the cloudformation so it uses the base-lxc image.
5. Run `./build.sh <ami-id> to create an instance for the cluster.

