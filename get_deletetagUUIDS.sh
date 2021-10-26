#!/bin/bash

##Step 1
##GET instance UUIDs
rm instance_uuids
tenant=$(cat tenant)
okapi_url=$(cat okapi.url)
okapi_token=$(cat okapi.token)

recordtype="instance-storage/instances"
query="?query=(tags.tagList="delete")"

#the curl GET request using variables defined above
echo "Getting Instance UUIDs"
apicall=$(curl -s -w GET -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}${query}&limit=100000")
#echos the apicall and using jq just grabs the instance uuid and send to instance_uuids file.
echo $apicall | jq -r '.instances[].id' >> instance_uuids

echo "returned: $(wc -l instance_uuids)"
##Step 2
##GET holding_uuids

rm holding_uuids 
echo "Getting Holdings IDs"
while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="holdings-storage/holdings"
query="?query=instanceId=="
limit="&limit=10000"
apicall=$(curl -s -w '\n' -X GET -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}${query}${uuid}${limit}")
echo $apicall | jq -r '.holdingsRecords[].id' >> holding_uuids
done < instance_uuids

echo "returned: $(wc -l holding_uuids)"
##Step 3
##GET item_uuids
rm items_uuids
echo "Getting Item IDs"

while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="inventory/items"
query="?query=instance.id=="
limit="&limit=10000"
apicall=$(curl -s -w '\n' -X GET -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}${query}${uuid}${limit}")
echo $apicall | jq -r '.items[].id' >> item_uuids 
done < instance_uuids
echo "returned: $(wc -l item_uuids)"
cat instance_uuids >> deleteduuids.rpt
