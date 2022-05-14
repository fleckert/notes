# Azure DevOps Pipeline ServicePrincipal ObjectId

if you need to resolve the [Azure Active Directory ServicePrincipal ObjectId](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/service-accounts-principal) of the [Azure Resource Manager Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints) that you are using in an [Azure DevOps pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines),
the following snippet might be an inspiration how to solve that...

---

## why the heck...
... would I ever need that... my serviceConnection is Contributor?

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
- task: AzurePowerShell@5
  displayName: resolve servicePrincipalAppId
  inputs:
    azureSubscription: $(serviceConnection)
    ScriptType: 'InlineScript'
    azurePowerShellVersion: 'LatestVersion'
    Inline: |
      $servicePrincipalAppId = (Get-AzContext).Account.Id
      Write-Host "##vso[task.setvariable variable=servicePrincipalAppId;]$servicePrincipalAppId"

- task: AzureCLI@2
  displayName: resolve servicePrincipalObjectId
  inputs:
    azureSubscription: $(serviceConnection)
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
      $servicePrincipalObjectId=$(az ad sp list --filter "appId eq '$(servicePrincipalAppId)'" --query '[0].objectId' --output tsv)
      echo "##vso[task.setvariable variable=servicePrincipalObjectId;]$servicePrincipalObjectId"

- bash: echo "servicePrincipalObjectId '$(servicePrincipalObjectId)'"
```

## Remarks

- this is an inspiration... for reuse... move it to a re-usable template
- AzurePowerShell@5 and AzureCLI@2 is used due to shortcomings (knowledge/time/...) on my side...
<br/>how to do it in _only_ Azure Cli or _only_ Azure PowerShell -> happy to accept pull requests
