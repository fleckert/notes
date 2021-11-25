#!/bin/sh

set -e

subscriptionId=$(az account show --output tsv --query id)
resourceGroupName="$1"
functionAppName="$2"
 
url="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$functionAppName/functions?api-version=2021-03-01"

echo "---------------------------------------------------------------------------------"
echo "key                                                      |   functionName"
echo "---------------------------------------------------------|-----------------------"
for functionName in $(az rest --url $url | jq -r .value[].properties.name);
do 
  key=$(\
    az functionapp function keys list --resource-group $resourceGroupName --name $functionAppName --function-name $functionName | jq -r .default
  )

  echo "$key | $functionName"
done
echo "---------------------------------------------------------------------------------"