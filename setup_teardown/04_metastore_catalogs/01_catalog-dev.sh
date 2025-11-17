# 01_catalog-dev.sh
# creates a dev catalog for the metastore

# Define variables
export STORAGEACCOUNT="hudsonjwhdbrixmetastore"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
export CATALOG_NAME="catalog-dev"
export PROFILE="DEFAULT"

export STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/$CATALOG_NAME"
echo "Storage root path for the $CATALOG_NAME catalog: $STORAGE_ROOT"

# create the catalog  
databricks catalogs create $CATALOG_NAME --storage-root "$STORAGE_ROOT" --profile $PROFILE

echo "Finished creating the dev catalog."