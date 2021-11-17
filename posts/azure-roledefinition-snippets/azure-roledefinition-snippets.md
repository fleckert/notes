Whenever doing [role assignments on Azure resources](https://docs.microsoft.com/en-us/azure/role-based-access-control/) I find myself [looking up the roleDefinition id](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

Querying the role definitions can **also** be done with the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/role/definition?view=azure-cli-latest#az_role_definition_list)
```
az role definition list
```

sample output for the Contributor role
```
{
  "assignableScopes": [
    "/"
  ],
  "description": "Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.",
  "id": "/subscriptions/<redacted>/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c",
  "name": "b24988ac-6180-42a0-ab88-20f7382dd24c",
  "permissions": [
    {
      "actions": [
        "*"
      ],
      "dataActions": [],
      "notActions": [
        "Microsoft.Authorization/*/Delete",
        "Microsoft.Authorization/*/Write",
        "Microsoft.Authorization/elevateAccess/Action",
        "Microsoft.Blueprint/blueprintAssignments/write",
        "Microsoft.Blueprint/blueprintAssignments/delete",
        "Microsoft.Compute/galleries/share/action"
      ],
      "notDataActions": []
    }
  ],
  "roleName": "Contributor",
  "roleType": "BuiltInRole",
  "type": "Microsoft.Authorization/roleDefinitions"
}
```

Reducing the output with `--query` syntax ...

```
az role definition list --query 'sort_by([].{roleName:roleName, name:name}, &roleName)' --output tsv > az-role-definition-list--roleName-name.txt
```

... makes looking up the information easier, please see [az-role-definition-list--roleName-name.txt](az-role-definition-list--roleName-name.txt).

```
API Management Service Contributor   312a565d-c81f-4fd8-895a-4e21e48d571c
API Management Service Operator Role e022efe7-f5ba-4159-bbe4-b44f577e9b61
API Management Service Reader Role   71522526-b88f-4d52-b57f-d31fc3546d0d
AcrDelete                            c2f4ef07-c644-48eb-af81-4b1b4947fb11
AcrImageSigner                       6cef56e8-d556-48e5-a04f-b8e64114680f
...                                  ...
..                                    ..
.                                    .
```

The following [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) example assigns [Azure role-based access control](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview) for an [AppService Managed Identity](https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity) in the [Storage Blob Data Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) role on an [Azure Storage Account](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview) .


```
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appServiceName"    : { "type": "String" },
        "storageAccountName": { "type": "String" }
    },
    "variables": {
        "resourceId_StorageAccount"                  : "[resourceId('Microsoft.Storage/storageAccounts'       , parameters('storageAccountName'      ))]",
        "resourceId_AppService"                      : "[resourceId('Microsoft.Web/sites'                     , parameters('appServiceName'          ))]",
        "roleDefinition_StorageBlobDataContributor"  : "[resourceId('Microsoft.Authorization/roleDefinitions/', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')]"
    },
    "resources": [
        {
            "type": "Microsoft.Authorization/roleAssignments",
            "apiVersion": "2020-03-01-preview",
            "name": "[guid(concat(variables('resourceId_StorageAccount'), variables('resourceId_AppService'), variables('roleDefinition_StorageBlobDataContributor')))]",
            "scope": "[variables('resourceId_StorageAccount')]",
            "properties": {
                "roleDefinitionId": "[variables('roleDefinition_StorageBlobDataContributor')]",
                "principalId": "[reference(variables('resourceId_AppService'),'2020-12-01', 'full').identity.principalId]",
                "principalType": "ServicePrincipal"            
            },
            "dependsOn": [
                ...
            ]
        },
        ...
        ..
        .
    ]
}
```

Copy-pasting the lines from [snippets-variables.txt](snippets-variables.txt) into the `variables` provides enough 'reusability/dry-ness/...' for *my* usecase.<br/>
But... several ways to do it... use [outputs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/outputs) in a [linked template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?#linked-template) to 'define' the `roleDefinition_xxx`'s

**I find it more and more challenging to find the sweet spot between 'easy/simple/straightForward/...' and 'so clever that I screw it up... sooner or later...'.**

my current thinking: not all refactorings that you are used to from high level programming languages make the developer experience better when it comes to CI/CD with ARM/Bicep/YAML/Terraform/... be it declarative or imperative... 

