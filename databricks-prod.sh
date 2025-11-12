# dbricks-prod.sh

# Define variables for the workspace
SUBSCRIPTION="DATABRICKS-PERSONAL"
WORKSPACE_NAME="databricks-prod"
RESOURCE_GROUP="rg-databricks-prod"
MANAGED_RESOURCE_GROUP="rg-databricks-prod-managed"
LOCATION="southcentralus"
SKU="premium"
DEFAULT_CATALOG_NAME="catalog-dev"
CATALOG_NAME="catalog-prod"
PROFILE="prod"

az account set -n "$SUBSCRIPTION"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "now displaying the created resource group"

az group list --query "[?contains(name,'$RESOURCE_GROUP')].name"

echo "now creating the databricks workspace"

az databricks workspace create -n "$WORKSPACE_NAME" -l "$LOCATION" -g "$RESOURCE_GROUP" --sku "$SKU" --managed-resource-group "$MANAGED_RESOURCE_GROUP" --public-network-access Enabled

echo "now displaying the created databricks workspace"

WORKSPACE_INFO=$(az databricks workspace list -g "$RESOURCE_GROUP" --query "[].{name:name,resourceGroup:resourceGroup,managedRG:managedResourceGroupId,publicNetworkAccess:publicNetworkAccess,provisioningState:provisioningState,sku:sku.name,isUcEnabled:isUcEnabled,workspaceURL:workspaceUrl,workspaceId:workspaceId}" -o json)

WORKSPACE_NAME=$(echo "$WORKSPACE_INFO" | jq -r '[0].name')
WORKSPACE_URL=$(echo "$WORKSPACE_INFO" | jq -r '.[0].workspaceURL')
WORKSPACE_ID=$(echo "$WORKSPACE_INFO" | jq -r '.[0].workspaceId')

echo "RESOURCE GROUP: $RESOURCE_GROUP"
echo "Workspace Name: $WORKSPACE_NAME"
echo "Workspace URL: $WORKSPACE_URL"

databricks auth login --host "$WORKSPACE_URL" --profile "$PROFILE"

METASTORE_INFO=$(databricks metastores list -o json)
METASTORE_ID=$(echo "$METASTORE_INFO" | jq -r '.[0].metastore_id')

databricks metastores assign $WORKSPACE_ID $METASTORE_ID $DEFAULT_CATALOG_NAME

databricks catalogs create "$CATALOG_NAME"

databricks clusters create --json @./clusters/my_cluster.json --profile "$PROFILE"