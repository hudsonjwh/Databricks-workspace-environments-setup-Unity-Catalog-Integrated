# delete metastore

SUBSCRIPTION="DATABRICKS-PERSONAL"
az group delete -n rg-databricks-metastore --subscription "$SUBSCRIPTION"