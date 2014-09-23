Installing cloudformation for es:
=================================

aws cloudformation create-stack --stack-name es-uat --template-body "file://es-cluster.json" --capabilities CAPABILITY_IAM