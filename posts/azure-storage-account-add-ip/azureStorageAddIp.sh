resourceGroup="$1"
storageAccountName="$2"

resourceGroup="intwawiivm00-dev-rg"
storageAccountName="intwawiivm00d"

echo "resolving ipAddress"
ipAddress=$(curl --silent https://myip.expectingpain.com)

echo "storageAccount '$storageAccountName' - ipAddress '$ipAddress/32' - checking whitelisting"

ipExists=$(az storage account network-rule list --resource-group $resourceGroup --account-name $storageAccountName | jq -r '.ipRules[].ipAddressOrRange | select( . | contains("$ipAddress"))')

if [ -z "$ipExists" ]; 
then
  echo "storageAccount '$storageAccountName' - ipAddress '$ipAddress/32' - adding   whitelisting"

  az storage account network-rule add --resource-group $resourceGroup --account-name $storageAccountName --ip-address "$ipAddress/32"

  echo "storageAccount '$storageAccountName' - ipAddress '$ipAddress/32' - added    whitelisting"
else 

  echo "storageAccount '$storageAccountName' - ipAddress '$ipAddress/32' - checked  whitelisting" 
fi
