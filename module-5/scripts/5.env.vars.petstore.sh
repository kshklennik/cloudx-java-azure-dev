#!/bin/bash

set -e

RESOURCE_GROUP="module-5"

APP_FRONTEND="petstore-petstoreapp"
APP_PET="petstore-petstorepetservice"
APP_PRODUCT="petstore-petstoreproductservice"
APP_ORDER="petstore-petstoreorderservice"

PET_URL="https://$APP_PET.azurewebsites.net"
PRODUCT_URL="https://$APP_PRODUCT.azurewebsites.net"
ORDER_URL="https://$APP_ORDER.azurewebsites.net"

services=(
petstore-petstoreapp
petstore-petstorepetservice
petstore-petstoreproductservice
petstore-petstoreorderservice
)

echo "Setting environment variables for frontend app..."

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_FRONTEND \
  --settings \
  PETSTOREPETSERVICE_URL=$PET_URL \
  PETSTOREPRODUCTSERVICE_URL=$PRODUCT_URL \
  PETSTOREORDERSERVICE_URL=$ORDER_URL


echo "Setting environment variables for Order Service..."

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $APP_ORDER \
  --settings \
  PETSTOREPRODUCTSERVICE_URL=$PRODUCT_URL


for app in "${services[@]}"
do
  echo "Configuring container settings for $app"

  az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $app \
    --settings \
    WEBSITES_PORT=8080 \
    WEBSITES_CONTAINER_START_TIME_LIMIT=500

done

echo "Environment variables configured successfully."