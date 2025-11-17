# 01_create-databricks-prod-assets.sh

# ./01_metastore_storage/storage-account.sh
./02_workspaces/03_databricks-prod.sh
# ./03_metastore/create-metastore.sh
./04_metastore_catalogs/03_catalog-prod.sh
./05_clusters/03_create-cluster-prod.sh

echo "Finished creating all prod environment assets."