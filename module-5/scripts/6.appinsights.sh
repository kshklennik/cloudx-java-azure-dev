#!/bin/bash

set -e

RESOURCE_GROUP="module-5"
LOCATION="eastus2"

WORKSPACE_NAME="petstore-log-workspace"
APPINSIGHTS_NAME="petstore-appinsights"

echo "Checking Log Analytics workspace..."

WORKSPACE_EXISTS=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --query name -o tsv 2>/dev/null || echo "")

if [ -z "$WORKSPACE_EXISTS" ]; then
  echo "Creating Log Analytics workspace..."

  az monitor log-analytics workspace create \
    --resource-group $RESOURCE_GROUP \
    --workspace-name $WORKSPACE_NAME \
    --location $LOCATION
else
  echo "Workspace already exists."
fi

echo "Creating Application Insights..."

az monitor app-insights component create \
  --app $APPINSIGHTS_NAME \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --workspace $WORKSPACE_NAME \
  --application-type web

echo "Application Insights created successfully."