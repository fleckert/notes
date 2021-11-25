#!/bin/sh

set -e

subscriptionId=$(az account show --output tsv --query id)
resourceGroupName="$1"
functionAppName="$2"
 
url="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$functionAppName/functions?api-version=2021-03-01"

echo "---------------------------------------------------------------------------------"
echo "function access key                                      | functionName"
echo "---------------------------------------------------------|-----------------------"
for functionName in $(az rest --url $url --query "value[].properties.name" --output tsv);
do 
  url="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$functionAppName/functions/$functionName/listkeys?api-version=2021-03-01"
  
  key=$(az rest --method POST --url $url --query "default" --output tsv)

  echo "$key | $functionName"
done
echo "---------------------------------------------------------------------------------"