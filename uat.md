The following machines were cloned for the data during uat migration:
Prod -> UAT
54.243.7.220 -> 54.208.14.24
54.89.43.180 -> 54.165.98.78
54.90.147.255 -> 54.165.253.208

to create a snapshot:
create a bucket called cronycle-es and
run the below from the source:
curl -XPUT http://localhost:9200/_snapshot/backup1?pretty=true -d'
{  "type": "s3", "settings": {
  "bucket": "cronycle-es",
  "base_path": "Production",
  "compress": true
} } '

to backup:
 curl -XPUT "localhost:9200/_snapshot/backup1/public_collections?pretty" -d '
 {
 "indices": "20140701_public_collections",
 "ignore_unavailable": "true",
 "include_global_state": false
 }'

to restore:

curl -XPOST "localhost:9200/_snapshot/backup1/public_collections/_restore?pretty"