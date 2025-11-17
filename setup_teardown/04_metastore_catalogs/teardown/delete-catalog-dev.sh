# delete catalog-dev.sh
# forces a delete for the dev catalog

# Define variables
export CATALOG_NAME="catalog-dev"
export PROFILE="DEFAULT"

# delete the catalog
echo "Now deleting catalog $CATALOG_NAME"  
databricks catalogs delete $CATALOG_NAME --force --profile "$PROFILE"

echo "Finished deleting the dev catalog."