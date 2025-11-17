# 01_databricks-dev.sh
# creates the dev workspace and associates an az login profile for it (DEFAULT)

# Define variables for the workspace
export SUBSCRIPTION="DATABRICKS-PERSONAL"
export WORKSPACE_NAME="databricks-dev"
export RESOURCE_GROUP="rg-databricks-dev"
export MANAGED_RESOURCE_GROUP="rg-databricks-dev-managed"
export LOCATION="southcentralus"
export SKU="premium"
export DEFAULT_CATALOG_NAME="catalog-dev"
export CATALOG_NAME="catalog-dev"
export PROFILE="DEFAULT"

az account set -n "$SUBSCRIPTION"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "now displaying the created resource group: $RESOURCE_GROUP"

az group list --query "[?contains(name,'$RESOURCE_GROUP')].name"

echo "now creating the databricks workspace"

az databricks workspace create -n "$WORKSPACE_NAME" -l "$LOCATION" -g "$RESOURCE_GROUP" --sku "$SKU" --managed-resource-group "$MANAGED_RESOURCE_GROUP" --public-network-access Enabled

echo "now displaying the created databricks workspace"

export WORKSPACE_INFO=$(az databricks workspace list -g "$RESOURCE_GROUP" --query "[].{name:name,resourceGroup:resourceGroup,managedRG:managedResourceGroupId,publicNetworkAccess:publicNetworkAccess,provisioningState:provisioningState,sku:sku.name,isUcEnabled:isUcEnabled,workspaceURL:workspaceUrl,workspaceId:workspaceId}" -o json)

export WORKSPACE_NAME=$(echo "$WORKSPACE_INFO" | jq -r '.[0].name')
export WORKSPACE_URL=$(echo "$WORKSPACE_INFO" | jq -r '.[0].workspaceURL')
export WORKSPACE_ID=$(echo "$WORKSPACE_INFO" | jq -r '.[0].workspaceId')

echo "RESOURCE GROUP: $RESOURCE_GROUP"
echo "Workspace Name: $WORKSPACE_NAME"
echo "Workspace URL: $WORKSPACE_URL"

databricks auth login --host "$WORKSPACE_URL" --profile "$PROFILE"

echo "Finished creating the dev databricks workspace."