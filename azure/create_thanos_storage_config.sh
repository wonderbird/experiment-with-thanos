 #!/bin/bash
 #
 # Query the storage account key from azure and write it into the
 # thanos-storage-config.yml

if [ "x$RESOURCE_GROUP" = "x" ]; then echo "RESOURCE_GROUP environment variable is required."; exit 1; fi
if [ "x$STORAGE_ACCOUNT" = "x" ]; then echo "STORAGE_ACCOUNT environment variable is required."; exit 1; fi
if [ "x$TARGET_FILE" = "x" ]; then echo "TARGET_FILE environment variable is required."; exit 1; fi

echo "Receiving azure storage account key and writing to thanos storage config ..."
az login --service-principal --tenant $ARM_TENANT_ID -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET > /dev/null

STORAGE_ACCOUNT_KEY=`az storage account keys list -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT \
   | jp '[0].value'`

cat > "$TARGET_FILE" << EOF
type: AZURE
config:
  storage_account: "thanossa"
  storage_account_key: $STORAGE_ACCOUNT_KEY
  container: "thanosc"
EOF
