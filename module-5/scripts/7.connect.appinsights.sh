#!/bin/bash

set -e

RESOURCE_GROUP="module-5"
APPINSIGHTS_NAME="petstore-appinsights"

services=(
petstore-petstoreapp
petstore-petstorepetservice
petstore-petstoreproductservice
petstore-petstoreorderservice
)

echo "Retrieving Application Insights connection string..."

CONNECTION_STRING=$(az monitor app-insights component show \
  --app $APPINSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query connectionString \
  -o tsv)

for app in "${services[@]}"
do
  echo "Enabling Application Insights for $app..."

  az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $app \
    --settings \
      APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING" \
      ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
      XDT_MicrosoftApplicationInsights_Mode="recommended"

done

echo "Application Insights enabled for all Web Apps."