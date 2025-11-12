# delete metastore

export SUBSCRIPTION="DATABRICKS-PERSONAL"
export RESOURCE_GROUP="rg-databricks-metastore"

az group delete -n "$RESOURCE_GROUP" --subscription "$SUBSCRIPTION"

echo "finished ..."