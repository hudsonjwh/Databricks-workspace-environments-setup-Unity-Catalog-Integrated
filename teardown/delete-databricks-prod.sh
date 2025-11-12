# delete databricks prod

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-prod --subscription "$SUBSCRIPTION"