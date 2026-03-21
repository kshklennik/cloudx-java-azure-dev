#!/bin/bash

set -e

RESOURCE_GROUP="module-4"

services=(
petstore-app-eastus
petstore-petservice
petstore-productservice
petstore-orderservice
)

for app in "${services[@]}"
do
  echo "Setting revision mode to multiple for $app..."

  az containerapp revision set-mode \
    --name $app \
    --resource-group $RESOURCE_GROUP \
    --mode multiple

done

echo "All apps configured to use multiple revisions."