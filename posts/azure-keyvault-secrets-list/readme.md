# Azure KeyVault Secrets - dump to stdout

To list and show the secrets within an [Azure KeyVault](https://azure.microsoft.com/en-us/services/key-vault/#product-overview), the principal (user/serviceprincipal/...) needs to have 
- the [Access Policy](https://docs.microsoft.com/en-us/azure/key-vault/general/security-features#access-model-overview) Secret Get List enabled
- the client ip address needs to be whitelisted (assuming [networking is restricted](https://docs.microsoft.com/en-us/azure/key-vault/general/network-security) to selected Virtual Networks)

# What's happening...
- The [Access Policy](https://docs.microsoft.com/en-us/azure/key-vault/general/security-features#access-model-overview) Secret Get List are set.
- The current ip address is added wrt [Networking](https://docs.microsoft.com/en-us/azure/key-vault/general/network-security).
- The secrets are dumped to the stdout.

# Example usage:

This helper script requires the Azure CLI and the current user logged in.
For ypur convience, you may use the [Azure Shell](https://portal.azure.com/#cloudshell/) in Bash mode.

```
curl -O https://raw.githubusercontent.com/fleckert/notes/main/posts/azure-keyvault-secrets-list/azureKeyVaultSecretsDump.sh
chmod +x azureKeyVaultSecretsDump.sh
./azureKeyVaultSecretsDump.sh keyVaultName
```