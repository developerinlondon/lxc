Installing cloudformation for es:
=================================

aws s3 cp cloudformation/es-cluster.json s3://cronycle-lxc/es-uat.template.json
aws cloudformation create-stack --stack-name es-uat --template-url https://s3.amazonaws.com/cronycle-lxc/es-uat.template.json