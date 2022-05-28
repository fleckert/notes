# Azure DevOps Pipeline ServicePrincipal ObjectId

if you need to resolve the [Azure Active Directory ServicePrincipal ObjectId](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/service-accounts-principal) of the [Azure Resource Manager Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints) that you are using in an [Azure DevOps pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines),
the following snippet might be an inspiration how to solve that...

---

## why the heck...
... would I ever need that... my serviceConnection is Owner/Contributor/User Access Administrator/....?

## think about...
... assigning [Role Based Access Control](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview) (RBAC) to enable data plane operations like
- Azure KeyVault secrets access or 
- Azure Storage blob/table/... access
for the servicePrincipal that executes the Azure DevOps pipeline.

---

[RBAC](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview) examples
- [Storage Blob Data Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

the [Microsoft.Authorization roleAssignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments) principalId
<br/>--> is the objectId of the servicPrincipal 
<br/>----> of the Azure DevOps Service Connection
<br/>-------> of the Azure DevOps pipeline


```
resource symbolicname 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  ...
  properties: {
    ...
    principalId: 'string' <-- the snippet uses the name servicePrincipalObjectId for this
    ...
  }
}
```

---

# Snippet


```
pool:
  vmImage: ubuntu-latest

variables:
  - name: serviceConnection
    value: !!!<fill_in>!!!

steps:
- task: AzureCLI@2
  displayName: resolve servicePrincipalObjectId
  inputs:
    azureSubscription: $(serviceConnection)
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      $servicePrincipalAppId=$(az account show --query 'user.name' --output tsv)
      $servicePrincipalObjectId=$(az ad sp list --filter "appId eq '$servicePrincipalAppId'" --query '[0].objectId' --output tsv)
      Write-Host "servicePrincipalAppId[$servicePrincipalAppId] servicePrincipalObjectId[$servicePrincipalObjectId]"
      Write-Host "##vso[task.setvariable variable=servicePrincipalObjectId;]$servicePrincipalObjectId"
```

