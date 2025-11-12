# delete databricks test

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-test --subscription "$SUBSCRIPTION"