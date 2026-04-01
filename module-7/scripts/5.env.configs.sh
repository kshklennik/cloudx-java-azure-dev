#!/bin/bash

set -e

RESOURCE_GROUP="module-4"
ENV_NAME="petstore-container-app-env"

APP_FRONTEND="petstore-app-eastus"
APP_PET="petstore-petservice"
APP_PRODUCT="petstore-productservice"
APP_ORDER="petstore-orderservice"

PORT="8080"

echo "Retrieving Container Apps environment default domain..."

DEFAULT_DOMAIN=$(az containerapp env show \
  --name $ENV_NAME \
  --resource-group $RESOURCE_GROUP \
  --query properties.defaultDomain \
  -o tsv)

PET_URL="https://$APP_PET.$DEFAULT_DOMAIN"
PRODUCT_URL="https://$APP_PRODUCT.$DEFAULT_DOMAIN"
ORDER_URL="https://$APP_ORDER.$DEFAULT_DOMAIN"

echo "PetService URL: $PET_URL"
echo "ProductService URL: $PRODUCT_URL"
echo "OrderService URL: $ORDER_URL"

echo "Updating frontend environment variables..."

az containerapp update \
  --name $APP_FRONTEND \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
  PETSTOREPETSERVICE_URL=$PET_URL \
  PETSTOREPRODUCTSERVICE_URL=$PRODUCT_URL \
  PETSTOREORDERSERVICE_URL=$ORDER_URL

echo "Updating OrderService environment variables..."

az containerapp update \
  --name $APP_ORDER \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
  PETSTOREPRODUCTSERVICE_URL=$PRODUCT_URL

echo "Environment variables configured successfully."

https://petstore-orderservice.livelydesert-8d8d978f.westus2.azurecontainerapps.io