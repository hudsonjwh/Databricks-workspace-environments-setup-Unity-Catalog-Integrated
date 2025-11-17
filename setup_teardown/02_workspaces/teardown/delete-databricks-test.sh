# delete databricks test
# destroys the test workspace by destroying its resource group

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-test --subscription "$SUBSCRIPTION"

echo "Finished tearing down the test databricks workspace."