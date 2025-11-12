# delete databricks dev

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-dev --subscription "$SUBSCRIPTION"