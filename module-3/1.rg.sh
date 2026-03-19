#!/bin/bash

set -e

RESOURCE_GROUP="module-3"
LOCATION="eastus"

echo "Checking if resource group exists..."

if az group exists --name $RESOURCE_GROUP | grep true > /dev/null; then
    echo "Resource group $RESOURCE_GROUP already exists"
else
    echo "Creating resource group $RESOURCE_GROUP..."
    az group create \
        --name $RESOURCE_GROUP \
        --location $LOCATION
fi