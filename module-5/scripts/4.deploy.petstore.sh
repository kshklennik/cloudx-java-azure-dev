#!/bin/bash

set -e

RESOURCE_GROUP="module-5"
PLAN_NAME="petstore-appservice-plan"
ACR_SERVER="kshpetstoryacr.azurecr.io"
TAG="1.0.0"

services=(
petstoreapp
petstorepetservice
petstoreproductservice
petstoreorderservice
)

for service in "${services[@]}"
do
    WEBAPP_NAME="petstore-${service}"

    IMAGE="$ACR_SERVER/petstore/$service:$TAG"

    echo "Deploying $WEBAPP_NAME using image $IMAGE"

    az webapp create \
        --resource-group $RESOURCE_GROUP \
        --plan $PLAN_NAME \
        --name $WEBAPP_NAME \
        --deployment-container-image-name $IMAGE

done

echo "All services deployed to App Service Plan."