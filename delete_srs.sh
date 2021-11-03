#!/bin/bash
##data export work for instances tagged delete
#1. create CSV 
#2. upload file to data export
#3. select default load profile
#4. download export

#work to get SRS UUIDS from marc file

##Command to turn a mrc into a text file for export of 999$s for srs delete work
#5.
mono cmarcedit.exe -s *.mrc -d srs_ids.txt -break
#6. grep 999$s to another file with just SRS ID
grep '=999' srs_ids.txt | grep -oE '\$s[a-z0-9-]*' | grep -oE '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}' > srs_uuids

#move the marc to a subdirectory called processed
mv *.mrc processed/ 

#delete SRS
# 
echo "Beginning SRS Delete"
tenant=$(cat tenant)
okapi_url=$(cat okapi.url)
okapi_token=$(cat okapi.token)

##Deletes using 999$s srs number

while read -r uuid;do

uuid=$(sed 's/[^0-9a-z\-]//g' <<< $uuid)

recordtype="source-storage/records"

echo "${okapi_url}/${recordtype}/${uuid}"

apicall=$(curl -s -w '\n' -X DELETE -D -H "Accept: application/json" -H "X-Okapi-Tenant: ${tenant}" -H "x-okapi-token: ${okapi_token}" "${okapi_url}/${recordtype}/${uuid}")

echo $apicall
done < srs_uuids

