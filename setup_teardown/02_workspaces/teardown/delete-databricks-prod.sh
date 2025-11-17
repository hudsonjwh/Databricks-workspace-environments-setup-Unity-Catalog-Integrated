# delete databricks prod
# destroys the prod workspace by destroying its resource group

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-prod --subscription "$SUBSCRIPTION"

echo "Finished tearing down the prod databricks workspace."