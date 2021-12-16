resourceGroup="$1"
clusterName="$2"

echo "resolving ipAddress"
ipAddress=$(curl --silent https://myip.expectingpain.com)
echo "resolved  ipAddress: $ipAddress"

existingIps=$( \
  az aks show \
  --resource-group $resourceGroup \
  --name $clusterName \
  --query apiServerAccessProfile.authorizedIpRanges \
)

echo "Current api-server-authorized-ip-ranges: $existingIps"

if [[ $existingIps == *"$ipAddress"* ]];
then
  echo "Current api-server-authorized-ip-ranges contains $ipAddress"
else
  echo "Current api-server-authorized-ip-ranges does not contain $ipAddress - adding..."
  newIps="$(jq -r '. | join(",")' <<< $existingIps),$ipAddress/32"
  updatedIps=$( \
    az aks update \
    --resource-group $resourceGroup \
    --name $clusterName \
    --api-server-authorized-ip-ranges "$newIps" \
    --query apiServerAccessProfile.authorizedIpRanges \
  )  
  echo "Updated api-server-authorized-ip-ranges: $updatedIps"
fi