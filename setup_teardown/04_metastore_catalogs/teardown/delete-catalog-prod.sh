# delete catalog-prod.sh
# forces a delete for the prod catalog

# Define variables
export CATALOG_NAME="catalog-prod"
export PROFILE="DEFAULT"

# delete the catalog
echo "Now deleting catalog $CATALOG_NAME"  
databricks catalogs delete $CATALOG_NAME --force --profile "$PROFILE"

echo "Finished deleting the prod catalog."