 #!/bin/bash
 #
 # Query the storage account key from azure and write it into the
 # thanos-storage-config.yml
RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
TARGET_FILE=$3

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
