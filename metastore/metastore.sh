 # metastore.sh

# Define variables for the workspace
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"
export LOCATION="southcentralus"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
# export METASTORE_NAME="databricks-metastore-southcentralus"
export METASTORE_NAME="metastore"
export ACCESS_CONNECTOR="databricks-access-connector"

export STORAGEACCOUNT="hudsonjwhdbrixmetastore"

export STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/"
echo $STORAGE_ROOT

databricks metastores create metastore --region "$LOCATION" --storage-root "$STORAGE_ROOT" -o json

echo "finished ..."