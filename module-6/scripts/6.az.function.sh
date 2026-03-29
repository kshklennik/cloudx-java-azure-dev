#!/bin/bash

set -e

RESOURCE_GROUP="module-6"
LOCATION="eastus2"
ACR_SERVER="kshpetstoryacr"
FUNCTION_APP_NAME="order-items-register"
STORAGE_ACCOUNT="orderitemsreserverst"
CONTAINER_NAME="products"
APP_VERSION=1.0.0

CONTAINER_ENVIRONMENT="petstore-ce"

CONNECTION_STRING=$(az storage account show-connection-string \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query connectionString -o tsv)

echo "Creating Blob Container '$CONTAINER_NAME'..."

az storage container create \
  --name $CONTAINER_NAME \
  --connection-string "$CONNECTION_STRING"

echo "Creating Function App..."

az containerapp env create  \
  --name $CONTAINER_ENVIRONMENT \
  --enable-workload-profiles  \
  --resource-group $RESOURCE_GROUP  \
  --location $LOCATION

az functionapp create \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINER_ENVIRONMENT \
  --storage-account $STORAGE_ACCOUNT \
  --workload-profile-name "Consumption" \
  --functions-version 4 \
  --runtime java \
  --image $ACR_SERVER.azurecr.io/petstore/orderitemsreserver:$APP_VERSION \

echo "Setting AZURE_STORAGE_CONNECTION_STRING environment variable..."

az functionapp config appsettings set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings AZURE_STORAGE_CONNECTION_STRING="$CONNECTION_STRING"

az webapp log config \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-container-logging filesystem

echo "Function App created and configured successfully."

az webapp log tail --name order-items-register --resource-group module-6