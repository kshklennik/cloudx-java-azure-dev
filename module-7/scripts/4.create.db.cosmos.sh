#!/bin/bash
set -e

RESOURCE_GROUP="module-7"
LOCATION="westus"

COSMOS_ACCOUNT="cosmos-$RANDOM"
DATABASE_NAME="petstore-db"

echo "Creating Cosmos DB account..."

az cosmosdb create \
  --name $COSMOS_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --locations regionName=$LOCATION \
  --default-consistency-level Session

echo "Creating database..."

az cosmosdb sql database create \
  --account-name $COSMOS_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --name $DATABASE_NAME

echo "Creating container..."

COSMOS_ENDPOINT=$(az cosmosdb show \
  --name $COSMOS_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query "documentEndpoint" -o tsv)

COSMOS_KEY=$(az cosmosdb keys list \
  --name $COSMOS_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --type keys \
  --query "primaryMasterKey" -o tsv)

# ===== OUTPUT =====
echo "=============================="
echo "Cosmos DB setup complete"
echo "=============================="
echo "Account: $COSMOS_ACCOUNT"
echo "Database: $DATABASE_NAME"
echo "Endpoint: $COSMOS_ENDPOINT"
echo "Key: $COSMOS_KEY"