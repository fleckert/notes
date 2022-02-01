storageAccountName="$1"

echo "resolving ipAddress"
ipAddress=$(curl --silent https://myip.expectingpain.com)
echo "resolved  ipAddress '$ipAddress'"

echo "adding    ipAddress '$ipAddress' to storageAccount '$storageAccountName' ip whitelisting"

null=$(az storage account network-rule add --account-name $storageAccountName --ip-address $ipAddress)

echo "added     ipAddress '$ipAddress' to storageAccount '$storageAccountName' ip whitelisting" 
