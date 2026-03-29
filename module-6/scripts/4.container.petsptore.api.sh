#!/bin/bash

set -e

RESOURCE_GROUP="module-6"
ENV_NAME="petstore-container-app-env"
ACR_SERVER="kshpetstoryacr.azurecr.io"
VERSION="1.0.0"

CPU="0.5"
MEMORY="1.0Gi"
PORT="8080"

services=(
petservice
productservice
orderservice
)

for service in "${services[@]}"
do
  APP_NAME="petstore-${service}"
  IMAGE="$ACR_SERVER/petstore/petstore${service}:$VERSION"

  echo "Deploying $APP_NAME using image $IMAGE"

  az containerapp create \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --environment $ENV_NAME \
    --image $IMAGE \
    --target-port $PORT \
    --ingress external \
    --cpu $CPU \
    --memory $MEMORY \
    --registry-server $ACR_SERVER

done