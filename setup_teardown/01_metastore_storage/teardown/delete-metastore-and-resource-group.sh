# delete-metastore-and-resource-group
# destroys the metastore, databricks access connector and storage account by destroying the resource groups.

# Define variables
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"
export METASTORE_NAME="databricks-metastore-southcentralus"

# delete the metastore

echo "Now deleting the metastore $METASTORE_NAME"

export METASTORE_ID=$(databricks metastores list --output json | jq -r '.[0].metastore_id')
echo "metastore id: $METASTORE_ID"

databricks metastores delete "$METASTORE_ID" --force

# delete all resources in the resource group

echo "now deleting all resources in resource group: $RESOURCE_GROUP"
az group delete -n "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION"

echo "finished tearing down the metastore..."