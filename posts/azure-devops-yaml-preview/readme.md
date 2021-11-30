# Azure DevOps Pipeline Preview

This [snippet](./getPreview.ps1) uses the [Azure DevOps Pipeline Preview Rest API](https://docs.microsoft.com/en-us/rest/api/azure/devops/pipelines/preview/preview?view=azure-devops-rest-6.1) with [personal access token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) authentication.

*_"Queues a dry run of the pipeline and returns an object containing the final yaml."_*


# Usage
Please set the environment variable

```Powershell
PS> $env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN = "a personal access token with Build(read) permissions"
```

and call the snippet like
```Powershell
PS> ./getPreview.ps1 -organization your_organization -project your_project -pipelineName your_pipeline_name
```

this will create a file named like

```Powershell
"$($organization)__$($project)__$($pipeline.name)__$($pipeline.Id)__$(Get-Date -Format "yyyyMMdd__HHmmss").yaml"
```
that contains a preview of the yaml pipeline.

# References
- https://docs.microsoft.com/en-us/rest/api/azure/devops/pipelines/preview/preview?view=azure-devops-rest-6.1
- https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate
