# 03_catalog-prod.sh
# creates a prod catalog for the metastore

# Define variables
export STORAGEACCOUNT="hudsonjwhdbrixmetastore"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
export CATALOG_NAME="catalog-prod"
export DEFAULT_CATALOG_NAME='catalog-prod'
export PROFILE="prod"

# assign the workspace to the metastore

export WORKSPACE_ID=$(az databricks workspace list --query "[?contains(name, 'databricks-prod')].workspaceId" -o tsv)
echo "Workspace id: $WORKSPACE_ID"

export METASTORE_ID=$(databricks metastores list --output json | jq -r '.[0].metastore_id')
echo "Metastore id: $METASTORE_ID"

databricks metastores assign $WORKSPACE_ID $METASTORE_ID $DEFAULT_CATALOG_NAME --profile $PROFILE

# create the catalog 

export STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/$CATALOG_NAME"
echo "Storage root path for the $CATALOG_NAME catalog: $STORAGE_ROOT"
 
databricks catalogs create $CATALOG_NAME --storage-root "$STORAGE_ROOT" --profile $PROFILE

echo "Finished creating the prod catalog."