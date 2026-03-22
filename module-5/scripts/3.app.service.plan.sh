#!/bin/bash

set -e

RESOURCE_GROUP="module-5"
PLAN_NAME="petstore-appservice-plan"
LOCATION="eastus2"
SKU="S1"

echo "Checking if App Service Plan exists..."

PLAN_EXISTS=$(az appservice plan show \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "name" \
  -o tsv 2>/dev/null || echo "")

if [ -z "$PLAN_EXISTS" ]; then
  echo "Creating App Service Plan..."

  az appservice plan create \
    --name $PLAN_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku $SKU \
    --is-linux

else
  echo "App Service Plan $PLAN_NAME already exists"
fi

echo "App Service Plan ready."