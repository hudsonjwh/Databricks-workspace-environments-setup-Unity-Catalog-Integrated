# storage-account.sh

# Define variables for the workspace
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"
export LOCATION="southcentralus"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
# export METASTORE_NAME="databricks-metastore-southcentralus"
export METASTORE_NAME="metastore"
export ACCESS_CONNECTOR="databricks-access-connector"

# # Variable block
# let "randomIdentifier=$RANDOM*$RANDOM"
# STORAGEACCOUNT="msdocssa$randomIdentifier"

export STORAGEACCOUNT="hudsonjwhdbrixmetastore"

# Create a resource group
echo "Creating a resource group $RESOURCE_GROUP"
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"  --output json

# Create a storage account
echo "Creating storage account "$STORAGEACCOUNT" in resource group $RESOURCE_GROUP"
az storage account create \
  --name "$STORAGEACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --output json 

echo "grab the storage account key"
export STORAGE_ACCOUNT_KEY=$(az storage account keys list -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION"  --query "[0].value" --output tsv)
echo $STORAGE_ACCOUNT_KEY

# Create a storage container
echo "Creating storage container" 
az storage container create -n "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION"  --auth-mode key --account-key "$STORAGE_ACCOUNT_KEY"

# Create a storage container directory
echo "Creating storage container directory"
az storage fs directory create -n "$DIRECTORY" -f "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode key --account-key "$STORAGE_ACCOUNT_KEY"

export STORAGE_ACCOUNT_ID=$(az storage account show -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" --query "[id]" -o tsv)


echo "create a databricks access connector"
az databricks access-connector create -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" -l "$LOCATION" --identity-type "SystemAssigned" --subscription "$SUBSCRIPTION" --no-wait false

# Create a storage account storage blob contributor role membership to the databricks access connector

export ACCESS_CONNECTOR_PRINCIPAL_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[identity.principalId]" -o tsv)
echo $ACCESS_CONNECTOR_PRINCIPAL_ID

# enrole the databricks access connector in the storage blob contributor role
az role assignment create \
  --assignee-object-id "$ACCESS_CONNECTOR_PRINCIPAL_ID" \
  --assignee-principal-type "ServicePrincipal" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ACCOUNT_ID"  

# Create the metastore
export STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/"
echo $STORAGE_ROOT

# databricks metastores create "$METASTORE_NAME" --region "$LOCATION" --storage-root "$STORAGE_ROOT" -o json