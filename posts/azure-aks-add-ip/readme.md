# Azure AKS - Update a cluster's API server authorized IP ranges

Following the documentation at [Update a cluster's API server authorized IP ranges](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges#update-a-clusters-api-server-authorized-ip-ranges) and issuing the commands like
```
!!! Don't do this !!!!

# Add another IP address to the approved ranges with the following command.

# Retrieve your IP address
CURRENT_IP=$(dig +short "myip.opendns.com" "@resolver1.opendns.com")
# Add to AKS approved list
az aks update -g $RG -n $AKSNAME --api-server-authorized-ip-ranges $CURRENT_IP/32

!!! Don't do this !!!!
```

this imho **overwrites** any existing `api-server-authorized-ip-ranges` and your fellow developers will be unhappy.

# Therefore....


The sample script reads the existing `api-server-authorized-ip-ranges` and **appends** the currentIp if the currentIP is not within the `api-server-authorized-ip-ranges`.


# Example usage:

This shell script requires the Azure CLI and the current user logged in.

```
az login
az account set --subscription <subscriptionId>
curl -O https://raw.githubusercontent.com/fleckert/notes/main/posts/azure-aks-add-ip/aksApiServerAddCurrentIp.sh
chmod +x ./aksApiServerAddCurrentIp.sh
./aksApiServerAddCurrentIp.sh <resourceGroupName> <aksClusterName>
```