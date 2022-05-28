param(
  [Parameter(Mandatory = $true  )][string] $appName
)

Write-Host "appName   : $appName"
$ipAddress=$(curl --silent https://myip.expectingpain.com)
Write-Host "ipAddress : $ipAddress"
$resourceId=$(az webapp list --query "[?name=='$appName'].id" --output tsv)
Write-Host "resourceId: $resourceId"
$ruleName=(az account show --query "user.name" --output tsv).substring(0,32)
Write-Host "ruleName  : $ruleName"

# https://docs.microsoft.com/en-us/cli/azure/webapp/config/access-restriction?view=azure-cli-latest#az-webapp-config-access-restriction-add
az webapp config access-restriction add `
--ids $resourceId `
--rule-name $ruleName `
--action Allow `
--ip-address $ipAddress/32 `
--priority 100 