# delete databricks dev
# destroys the dev workspace by destroying its resource group

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-dev --subscription "$SUBSCRIPTION"

echo "Finished tearing down the dev databricks workspace."