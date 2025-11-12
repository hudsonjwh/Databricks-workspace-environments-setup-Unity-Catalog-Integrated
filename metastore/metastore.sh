# # storage-account.sh

# # Define variables for the workspace
# SUBSCRIPTION="DATABRICKS-PERSONAL"
# RESOURCE_GROUP="rg-databricks-metastore"
# LOCATION="southcentralus"
# CONTAINER="metastore"
# DIRECTORY="metastorepath"
# METASTORE_NAME="databricks-metastore-southcentral"
# ACCESS_CONNECTOR="databricks-access-connector-1"

# # Variable block
# let "randomIdentifier=$RANDOM*$RANDOM"
# STORAGEACCOUNT="msdocssa$randomIdentifier"

# # Create a resource group
# echo "Creating a resource group $RESOURCE_GROUP"
# az group create --name "$RESOURCE_GROUP" --location "$LOCATION"  --output json

# # Create a storage account
# echo "Creating storage account "$STORAGEACCOUNT" in resource group $RESOURCE_GROUP"
# STORAGE_ACCOUNT_INFO=$(az storage account create \
#   --name "$STORAGEACCOUNT" \
#   --resource-group "$RESOURCE_GROUP" \
#   --location "$LOCATION" \
#   --sku Standard_LRS \
#   --kind StorageV2 \
#   --output json )  


# az storage container create -n "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode login
# az storage fs directory create -n "$DIRECTORY" -f "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode login

# STORAGE_ACCOUNT_ID=$(echo "$STORAGE_ACCOUNT_INFO" | jq -r '.[0].id')

# ACCESS_CONNECTOR_INFO=$(az databricks access-connector create -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" -l "$LOCATION" --subscription "$SUBSCRIPTION" --output json --query "[]")

# ACCESS_CONNECTOR_PRINCIPAL_ID=$(echo "$ACCESS_CONNECTOR_INFO" | jq -r '.[0].identity.principalId')

# az role assignment create \
#   --assignee "$ACCESS_CONNECTOR_PRINCIPAL_ID" \
#   --role "Storage Blob Data Contributor" \
#   --scope "$STORAGE_ACCOUNT_ID"   

# STORAGE_ROOT="abfss://$CONTAINER@$STORAGE_ACCOUNT.dfs.core.windows.net/$DIRECTORY/"

# databricks metastores create "$METASTORE_NAME" --region "$LOCATION" --storage-root "$STORAGE_ROOT" --output json