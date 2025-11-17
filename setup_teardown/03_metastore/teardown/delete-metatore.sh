# delete-metastor.sh
# deletes the metastore

# Define variables for the workspace
export METASTORE_NAME="databricks-metastore-southcentralus"

# delete the metastore

echo "Now deleting the metastore $METASTORE_NAME"

export METASTORE_ID=$(databricks metastores list --output json | jq -r '.[0].metastore_id')
echo "metastore id: $METASTORE_ID"

databricks metastores delete "$METASTORE_ID" --force

echo "Finished deleting the metastore."