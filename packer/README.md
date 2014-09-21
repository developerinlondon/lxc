Install ElasticSearch
=====================

1. get a base ami image. (unless one already exists):

  `packer build -var-file=config/default.json -var-file=config/es-uat.json build-es-base.json`

2. Put in the base image id in build-es-base.json to build a base-es image (for elasticSearch).

3. build the es base image:

  `packer build -var-file=config/default.json -var-file=config/es-uat.json post-build-es-base.json`

4. Update the cloudformation so it uses the base-es image.

5. Run cloudformation create elasticSearch Cluster to build the elasticSearch cluster.


Install LXC Cluster
=====================

1. Run `packer build build-base.json` to get a base ami image. (unless one already exists)
2. Put in the base image id in build-lxc-base.json to build a base-lxc image (for elasticSearch).
3. Run `packerbuild build-lxc-base.json` to build the es base image.
4. Update the cloudformation so it uses the base-lxc image.
5. Run cloudformation create lxc Cluster to build the lxc cluster.

