Installing cloudformation for es:
=================================

```
aws cloudformation create-stack --stack-name es-uat --parameters file://config/uat.json --template-body "file://es-cluster.json" --capabilities CAPABILITY_IAM
```

to update:

```
aws cloudformation update-stack --stack-name es-uat --parameters file://config/uat.json --template-body "file://es-cluster.json" --capabilities CAPABILITY_IAM
```