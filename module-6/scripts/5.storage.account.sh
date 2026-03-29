#!/bin/bash

set -e

RESOURCE_GROUP="module-6"
LOCATION="eastus"
STORAGE_ACCOUNT="orderitemsreserverst"

echo "Creating Storage Account..."

az storage account create \
  --name $STORAGE_ACCOUNT \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_LRS

echo "Blob container '$CONTAINER_NAME' created successfully."