#!/bin/bash

set -e

RESOURCE_GROUP="module-4"
LOCATION="westus2"

APP_NAME="petstore-app-eastus"
ENV_NAME="petstore-container-app-env"

LOG_WORKSPACE="workspacemodule4a886"

ACR_NAME="kshpetstoryacr"
IMAGE="$ACR_NAME.azurecr.io/petstore/petstoreapp:1.0.0"

CPU="0.5"
MEMORY="1.0Gi"
PORT="8080"

echo "Creating Log Analytics workspace if not exists..."

az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_WORKSPACE \
  --location $LOCATION

WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_WORKSPACE \
  --query customerId \
  -o tsv)

WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $LOG_WORKSPACE \
  --query primarySharedKey \
  -o tsv)

echo "Creating Container Apps environment..."

az containerapp env create \
  --name $ENV_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --logs-workspace-id $WORKSPACE_ID \
  --logs-workspace-key $WORKSPACE_KEY

echo "Creating Container App..."

az containerapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENV_NAME \
  --image $IMAGE \
  --target-port $PORT \
  --ingress external \
  --cpu $CPU \
  --memory $MEMORY \
  --registry-server $ACR_NAME.azurecr.io \
  --query properties.configuration.ingress.fqdn


echo "Container App deployed successfully."