# storage-account.sh

# Define variables for the workspace
SUBSCRIPTION="DATABRICKS-PERSONAL"
RESOURCE_GROUP="rg-databricks-metastore"
LOCATION="southcentralus"
CONTAINER="metastore"
DIRECTORY="metastorepath"
METASTORE_NAME="databricks-metastore-southcentralus"
ACCESS_CONNECTOR="databricks-access-connector"

# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
STORAGEACCOUNT="msdocssa$randomIdentifier"

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

# Create a storage container
echo "Creating storage container" 
az storage container create -n "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode login

# Create a storage container directory
echo "Creating storage container directory"

STORAGE_ACCOUNT_KEY=$(az storage account keys list -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --query "[0].value" --output tsv)
az storage fs directory create -n "$DIRECTORY" -f "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode key --account-key "$STORAGE_ACCOUNT_KEY"

STORAGE_ACCOUNT_ID=$(az storage account show -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" --query "[id]" -o tsv)

# Create a storage account storage blob contributor role membership to the databricks access connector
ACCESS_CONNECTOR_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[id]" -o tsv)
echo $ACCESS_CONNECTOR_ID

ACCESS_CONNECTOR_PRINCIPAL_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[identity.principalId]" -o tsv)
echo $ACCESS_CONNECTOR_PRINCIPAL_ID

az role assignment create \
  --assignee-object-id "$ACCESS_CONNECTOR_PRINCIPAL_ID" \
  --assignee-principal-type "ServicePrincipal" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ACCOUNT_ID"  

# Create the metastore
STORAGE_ROOT="abfss://$CONTAINER@$STORAGEACCOUNT.dfs.core.windows.net/$DIRECTORY/"

databricks metastores create "$METASTORE_NAME" --region "$LOCATION" --storage-root "$STORAGE_ROOT" -o json