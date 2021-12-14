keyVaultName="$1"

userObjectid=$(az ad signed-in-user show --output tsv --query 'objectId')

echo "assigning secret premissions [get, list] for userObjectid '$userObjectid' wrt keyVault '$keyVaultName'"
null=$(az keyvault set-policy --name $keyVaultName --object-id $userObjectid --secret-permissions get list)

echo "resolving ipAddress"
ipAddress=$(curl --silent https://myip.expectingpain.com)

echo "adding ipAddress '$ipAddress/32' whitelisting wrt keyVault '$keyVaultName'"
null=$(az keyvault network-rule add --name $keyVaultName --ip-address "$ipAddress/32" --only-show-errors)
echo "waiting for networking rules to update"
null=$(az keyvault network-rule wait --name $keyVaultName --updated)
echo "networking rules updated"

echo "resolving secrets wrt keyVault '$keyVaultName'"
secretNames=$(az keyvault secret list --vault-name $keyVaultName --output tsv --query [].name)

echo "-----------------------------------------------"
for secretName in $secretNames
do
  value=$(az keyvault secret show --vault-name $keyVaultName --name $secretName --output tsv  --query 'value')

  echo $secretName $value
done
echo "-----------------------------------------------"



