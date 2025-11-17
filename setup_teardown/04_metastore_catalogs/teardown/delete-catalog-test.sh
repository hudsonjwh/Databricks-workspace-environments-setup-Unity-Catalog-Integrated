# delete catalog-test.sh
# forces a delete for the test catalog

# Define variables
export CATALOG_NAME="catalog-test"
export PROFILE="DEFAULT"

# delete the catalog
echo "Now deleting catalog $CATALOG_NAME"  
databricks catalogs delete $CATALOG_NAME --force --profile "$PROFILE"

echo "Finished deleting the test catalog."