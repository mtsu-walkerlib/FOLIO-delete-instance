# FOLIO-delete-instance
Bash scripts to delete instance, holding, item, srs. 

The get_deletetagUUIDS.sh script will get all Instance UUIDs tagged 'delete'. Using that list, it will then get holdings IDs and item IDs. 
    usage -- ./get_deletetagUUIDS.sh

The delete_inventory.sh script deletes in this order, items, holding, srs, and instance
    usage -- ./delete_inventory.sh
These scripts all built off record-delete script at https://github.com/banerjek/folio-utils 

These notes and requirements are based off those at the above repo created by Kyle Banerjee.

Like many of those scripts, you need to have the following files in your working directory:

    tenant -- contains the ID of your FOLIO tenant
    okapi.url -- contains the okapi URL for your tenant
    okapi.token -- contains a valid okapi token

To get an okapi token, you will first need to run the auth script. The auth script requires one additional file called okapi-login.json found in this directory which can be modified for your credentials.

API operations are allowed based on the permissions assigned to the user, so you'll need to make sure you've assigned yourself what you need. Most can be added through FOLIO front-end, but if not, the permission scripts at the repo linked will assist. 
