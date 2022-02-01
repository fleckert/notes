# Azure StorageAccount - add your ip to the networking whitelist

this might be a very small helper... but it solves one more repetitive task...

add your current ip to the Azure Storage Account networking white list

# Example usage:

This helper script requires the Azure CLI and the current user logged in.

For your convience, you may use the [Azure Shell](https://portal.azure.com/#cloudshell/) in Bash mode.

```
curl -O https://raw.githubusercontent.com/fleckert/notes/main/posts/azure-storage-account-add-ip/azureStorageAddIp.sh
chmod +x ./azureStorageAddIp.sh
./azureStorageAddIpsh storageAccountName
```