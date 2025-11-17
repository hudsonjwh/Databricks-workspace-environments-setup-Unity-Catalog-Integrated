# 01_create-databricks-dev-assets.sh

./01_metastore_storage/storage-account.sh
./02_workspaces/01_databricks-dev.sh
./03_metastore/create-metastore.sh
./04_metastore_catalogs/01_catalog-dev.sh
./05_clusters/01_create-cluster-dev.

echo "Finished creating all dev environment assets."