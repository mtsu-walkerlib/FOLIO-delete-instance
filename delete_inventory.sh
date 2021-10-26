#!/bin/bash
#delete items
# 
cd /home/rwilson/folio_scripting/recordmanipScipts
tenant=$(cat tenant)
okapi_url=$(cat okapi.url)
okapi_token=$(cat okapi.token)
echo "Beginning Delete Script"
while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="item-storage/items"

apicall=$(curl -s -w '\n' -X DELETE -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}/${uuid}")

echo $apicall

done < item_uuids
echo "deleted $(wc -l item_uuids)"

#Holdings Delete
echo "Items finished; Beginning Holdings"
while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="holdings-storage/holdings"

apicall=$(curl -s -w '\n' -X DELETE -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}/${uuid}")

echo $apicall
done < holding_uuids

echo "deleted $(wc -l holding_uuids)"

#SRS Delete
echo "Holdings finished: Beginning SRS"
while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="instance-storage/instances"

apicall=$(curl -s -w '\n' -X DELETE -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}/${uuid}/source-record")

echo $apicall
done < instance_uuids

echo "Finished SRS; Beginning Instances"
##Instance Delete
while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="instance-storage/instances"
echo ${okapi_url}/${recordtype}/${uuid}

apicall=$(curl -s -w '\n' -X DELETE -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}/${uuid}")

echo $apicall
done < instance_uuids
echo "deleted $(wc -l instance_uuids)"



