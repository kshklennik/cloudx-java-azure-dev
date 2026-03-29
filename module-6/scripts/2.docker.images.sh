#!/bin/bash

set -e

RESOURCE_GROUP="module-6"
ACR_NAME="kshpetstoryacr"
VERSION="1.0.1"
LOCATION="eastus"

AZ_FUNC_APP_NAME="order-items-register"
AZ_SERVICE_PLAN_NAME="order-items-register-sp"
FUNCTION_OS="docker"
FUNCTION_JAVA_VERSION="17"
AZ_PRICING_TIER="EP1"

echo "Checking if container registry exists..."

ACR_EXISTS=$(az acr show \
    --name $ACR_NAME \
    --resource-group $RESOURCE_GROUP \
    --query "name" \
    --output tsv 2>/dev/null || echo "")

if [ -z "$ACR_EXISTS" ]; then
    echo "Creating Azure Container Registry $ACR_NAME..."
    az acr create \
        --name $ACR_NAME \
        --resource-group $RESOURCE_GROUP \
        --location $LOCATION \
        --sku Basic \
        --admin-enabled true
else
    echo "Container registry $ACR_NAME already exists"
fi

az acr update \
  --name $ACR_NAME \
  --admin-enabled true

echo "ACR login server:"
az acr show --name $ACR_NAME --query loginServer -o tsv

echo "Building and pushing images to $ACR_NAME..."

az acr build \
  --registry $ACR_NAME \
  --image petstore/petstoreapp:$VERSION \
  --file ./petstore/petstoreapp/Dockerfile \
  ./petstore/petstoreapp

az acr build \
  --registry $ACR_NAME \
  --image petstore/petstoreorderservice:$VERSION \
  --file ./petstore/petstoreorderservice/Dockerfile \
  ./petstore/petstoreorderservice

az acr build \
  --registry $ACR_NAME \
  --image petstore/petstorepetservice:$VERSION \
  --file ./petstore/petstorepetservice/Dockerfile \
  ./petstore/petstorepetservice

az acr build \
  --registry $ACR_NAME \
  --image petstore/petstoreproductservice:$VERSION \
  --file ./petstore/petstoreproductservice/Dockerfile \
  ./petstore/petstoreproductservice

az acr build \
    --registry $ACR_NAME \
    --image petstore/orderitemsreserver:$VERSION \
    --file ./petstore/orderitemsreserver/Dockerfile \
    --build-arg AZ_FUNC_APP_NAME=${AZ_FUNC_APP_NAME} \
    --build-arg AZ_FUNC_RG=$RESOURCE_GROUP \
    --build-arg AZ_FUNC_REGION=$LOCATION \
    --build-arg AZ_FUNC_OS=$FUNCTION_OS \
    --build-arg AZ_FUNC_JAVA_VERSION=$FUNCTION_JAVA_VERSION \
    --build-arg AZ_FUNC_JAVA_VERSION=$AZ_SERVICE_PLAN_NAME \
    --build-arg AZ_PRICING_TIER=$AZ_PRICING_TIER \
    ./petstore/orderitemsreserver

echo "All images successfully built and pushed to $ACR_NAME"