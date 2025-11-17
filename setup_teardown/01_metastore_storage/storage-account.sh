# storage-account.sh
# creates the and permissions the unity catalog metastore storage account using a databricks access connector to be used by the workspace for each environment (dev, test and prod). 
# integration into the unity catalog metastore will occur after the first databricks workspace (dev) is created.

# Define variables for the workspace
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"
export ACCESS_CONNECTOR="databricks-access-connector"
export STORAGEACCOUNT="hudsonjwhdbrixmetastore"

export LOCATION="southcentralus"
export CONTAINER="metastore"
export DIRECTORY="metastorepath"
export METASTORE_NAME="databricks-metastore-southcentralus"

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
  --hns true \
  --output json 

echo "grab the storage account key"
export STORAGE_ACCOUNT_KEY=$(az storage account keys list -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION"  --query "[0].value" --output tsv)
# echo $STORAGE_ACCOUNT_KEY

# Create a storage container
echo "Creating storage container" 
az storage container create -n "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION"  --auth-mode key --account-key "$STORAGE_ACCOUNT_KEY"

# Create a storage container directory
echo "Creating storage container directory"
az storage fs directory create -n "$DIRECTORY" -f "$CONTAINER" --account-name "$STORAGEACCOUNT" --subscription "$SUBSCRIPTION" --auth-mode key --account-key "$STORAGE_ACCOUNT_KEY"

export STORAGE_ACCOUNT_ID=$(az storage account show -n "$STORAGEACCOUNT" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" --query "[id]" -o tsv)

# Create a storage account storage blob contributor role membership to the databricks access connector

export ACCESS_CONNECTOR_INFO=$(az databricks access-connector create -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" --location "$LOCATION" --identity-type "SystemAssigned" -o json)
echo "Access Connector INFO:"
echo "$ACCESS_CONNECTOR_INFO"

export ACCESS_CONNECTOR_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[id]" -o tsv)
echo "Access Connector ID: $ACCESS_CONNECTOR_ID"

export ACCESS_CONNECTOR_PRINCIPAL_ID=$(az databricks access-connector show -n "$ACCESS_CONNECTOR" -g "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION" -o json --query "[identity.principalId]" -o tsv)
echo "Access Connector Principal ID: $ACCESS_CONNECTOR_PRINCIPAL_ID"

# enrole the databricks access connector in the storage blob contributor role
az role assignment create \
  --assignee-object-id "$ACCESS_CONNECTOR_PRINCIPAL_ID" \
  --assignee-principal-type "ServicePrincipal" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ACCOUNT_ID"  

echo "Finished creating and permissioning the unity catalog metastore storage infrastructure. "