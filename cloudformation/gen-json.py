#!/usr/bin/env python
import json
import os

template = json.load(open("es-cluster.json",'r'))

with open('cloud-init.yml','r') as f:
  lines = f.readlines()

template['Resources']['ElasticSearchServer']['Properties']['UserData']['Fn::Base64']['Fn::Join'] = [ '', lines ]

print json.dumps(template, indent=4)
