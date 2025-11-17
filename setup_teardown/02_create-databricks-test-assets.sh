# 01_create-databricks-test-assets.sh

# ./01_metastore_storage/storage-account.sh
./02_workspaces/02_databricks-test.sh
# ./03_metastore/create-metastore.sh
./04_metastore_catalogs/02_catalog-test.sh
./05_clusters/02_create-cluster-test.sh

echo "Finished creating all test environment assets."