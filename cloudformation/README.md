Installing cloudformation for es:
=================================

aws cloudformation create-stack --stack-name es-uat --template-body "$(./gen-json.py)" --capabilities CAPABILITY_IAM