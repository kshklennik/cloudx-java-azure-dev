#!/bin/bash

set -e

RESOURCE_GROUP="module-7"
LOCATION="westus"

SERVER_NAME="shpetstoredb"
DB_NAME="appdb"
ADMIN_USER="pgadmin"
ADMIN_PASSWORD="P@ssword1234$(date +%s)"

SKU_NAME="Standard_B1ms"
TIER="Burstable"

az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name $SERVER_NAME \
  --location $LOCATION \
  --admin-user $ADMIN_USER \
  --admin-password "$ADMIN_PASSWORD" \
  --sku-name $SKU_NAME \
  --tier $TIER \
  --public-access 0.0.0.0

az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $SERVER_NAME \
  --database-name $DB_NAME

HOST=$(az postgres flexible-server show \
  --resource-group $RESOURCE_GROUP \
  --name $SERVER_NAME \
  --query "fullyQualifiedDomainName" \
  -o tsv)

PORT=5432

echo "=============================="
echo "PostgreSQL created successfully!"
echo "=============================="
echo "Host: $HOST"
echo "Port: $PORT"
echo "Database: $DB_NAME"
echo "User: $ADMIN_USER"
echo "Password: $ADMIN_PASSWORD"
echo ""
echo "Connection string:"
echo "postgresql://$ADMIN_USER:$ADMIN_PASSWORD@$HOST:$PORT/$DB_NAME"