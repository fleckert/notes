# Azure AppService - Add Access Restrictions Allow rule

add your current ip address to the AppService ip whitelist

# Example usage:

This shell script requires the Azure CLI and the current user logged in.

```
curl -O https://raw.githubusercontent.com/fleckert/notes/main/posts/azure-appservice-add-ip/appServiceAddIp.ps1
az login
./appServiceAddIp.sh -appName <appName>
```
