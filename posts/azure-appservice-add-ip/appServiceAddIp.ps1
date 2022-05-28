
param(
  [string] $appName
)

Write-Host "resolving ipAddress"
$ipAddress=$(curl --silent https://myip.expectingpain.com)
Write-Host "resolved  ipAddress: $ipAddress"

Write-Host "resolving resourceId"
$resourceId=$(az webapp list --query "[?name=='$appName'].id" --output tsv)
Write-Host "resolved  resourceId: $resourceId"
  

# https://docs.microsoft.com/en-us/cli/azure/webapp/config/access-restriction?view=azure-cli-latest#az-webapp-config-access-restriction-add
  az webapp config access-restriction add `
  --ids $resourceId `
  --rule-name developers `
  --action Allow `
  --ip-address $ipAddress/32 `
  --priority 200

