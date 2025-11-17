# create-metastore.sh
# creates the (unity catalog) metastore, associates the dev workspace to it, 
# and creates a file credential and external location to be shared later my MANAGED catalogs for the workspace for each environment. 

# Define variables for the workspace
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"
export ACCESS_CONNECTOR="databricks-access-connector"
export CREDENTIAL_NAME="databricks-access-connector-credential"
export EXTERNAL_LOCATION_NAME="databricks-access-connector-location"
export STORAGEACCOUNT="hudsonjwhdbrixmetastore"

export LOCATION="southcentralus"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
export METASTORE_NAME="databricks-metastore-southcentralus"
# export METASTORE_NAME="metastore"
export DEFAULT_CATALOG_NAME='catalog-dev'

export ACCESS_CONNECTOR_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[id]" -o tsv)
echo "Access Connector ID: $ACCESS_CONNECTOR_ID"
 
# Create the metastore
echo "Now creating metastore: $METASTORE_NAME"
export STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/"
echo "Storage root: $STORAGE_ROOT"

databricks metastores create --json "{
  \"name\": \"$METASTORE_NAME\", 
  \"region\": \"$LOCATION\"}"

echo "Now sleeping 10 seconds"
sleep 10

export WORKSPACE_ID=$(az databricks workspace list --query "[?contains(name, 'databricks-dev')].workspaceId" -o tsv)
echo "Workspace id: $WORKSPACE_ID"

export METASTORE_ID=$(databricks metastores list --output json | jq -r '.[0].metastore_id')
echo "Metastore id: $METASTORE_ID"

databricks metastores assign $WORKSPACE_ID $METASTORE_ID $DEFAULT_CATALOG_NAME --profile DEFAULT

echo "Now sleeping 5 seconds"
sleep 5

# create the credential
echo "creating credential $CREDENTIAL_NAME"

#TODO: refactor credential for purpose and name
databricks storage-credentials create --json "{
  \"azure_managed_identity\": {
    \"access_connector_id\": \"$ACCESS_CONNECTOR_ID\"
  },
  \"name\": \"$CREDENTIAL_NAME\"
}" --profile DEFAULT 
  
echo "Now sleeping 10 seconds"
sleep 10

# create the external location

echo "Now creating the external location"
databricks external-locations create "$EXTERNAL_LOCATION_NAME" "$STORAGE_ROOT" "$CREDENTIAL_NAME" --profile DEFAULT

echo "Finished creating the metastore."