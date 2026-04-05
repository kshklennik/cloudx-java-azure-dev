#!/bin/bash

set -e

RESOURCE_GROUP="module-7"
ENV_NAME="petstore-container-app-env"

APP_FRONTEND="petstore-app-eastus"
APP_PET="petstore-petservice"
APP_PRODUCT="petstore-productservice"
APP_ORDER="petstore-orderservice"

PG_SERVER_NAME="shpetstoredb"
PG_DB_PET="appdb"
PG_USER="pgadmin"
PG_PASSWORD="P@ssword12341775419303"

echo "Retrieving Container Apps environment default domain..."

DEFAULT_DOMAIN=$(az containerapp env show \
  --name $ENV_NAME \
  --resource-group $RESOURCE_GROUP \
  --query properties.defaultDomain \
  -o tsv)

PET_URL="https://$APP_PET.$DEFAULT_DOMAIN"
PRODUCT_URL="https://$APP_PRODUCT.$DEFAULT_DOMAIN"
ORDER_URL="https://$APP_ORDER.$DEFAULT_DOMAIN"

echo "Resolving PostgreSQL host..."

PG_HOST=$(az postgres flexible-server show \
  --name $PG_SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --query fullyQualifiedDomainName \
  -o tsv)

PG_PORT=5432

JDBC_PET="jdbc:postgresql://$PG_HOST:$PG_PORT/$PG_DB_PET"
JDBC_PRODUCT="jdbc:postgresql://$PG_HOST:$PG_PORT/$PG_DB_PET"

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

echo "Updating PetService DB config..."

az containerapp update \
  --name $APP_PET \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
  SPRING_DATASOURCE_URL="$JDBC_PET" \
  SPRING_DATASOURCE_USERNAME="$PG_USER" \
  SPRING_DATASOURCE_PASSWORD="$PG_PASSWORD"

echo "Updating ProductService DB config..."

az containerapp update \
  --name $APP_PRODUCT \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
  SPRING_DATASOURCE_URL="$JDBC_PRODUCT" \
  SPRING_DATASOURCE_USERNAME="$PG_USER" \
  SPRING_DATASOURCE_PASSWORD="$PG_PASSWORD"

echo "All environment variables configured successfully."