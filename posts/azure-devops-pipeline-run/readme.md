# Azure DevOps Pipeline Run

This [snippet](./runPipeline.ps1) uses the [Azure DevOps Pipeline Preview Rest API](https://docs.microsoft.com/en-us/rest/api/azure/devops/pipelines/runs/run-pipeline) with [personal access token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) authentication.

*_"Queues a run of the pipeline with detailed repository settings."_*


# Usage
Please set the environment variable

```Powershell
PS> $env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN = "a personal access token with Build(read + execute) permissions"
```

and call the snippet with specific repository references
```Powershell
PS> ./runPipeline.ps1 -organization your_organization -project your_project -pipelineName your_pipeline_name -repositories "repositoryNameA::refs/heads/main::repositoryNameB:refs/tags/v1"
```
or without the `-repositories` parameter
```Powershell
PS> ./runPipeline.ps1 -organization your_organization -project your_project -pipelineName your_pipeline_name
```


```
Syntax:    repository:ref::repository:ref
```

```YAML
resources:
  repositories:
    - repository: repositoryNameA
      type: git
      name: repositoryA
      ref: refs/tags/v2

    - repository: repositoryNameB
      type: git
      name: repositoryB
      ref: main
```

the syntax with double colons `::` and single colons `:` as seperators is based on [git check-ref-format](https://git-scm.com/docs/git-check-ref-format) defining that colon `:` is an invalid character in references.


> Git imposes the following rules on how references are named:
>
> 4. They cannot have ASCII control characters (i.e. bytes whose values are lower than \040, or \177 DEL), space, tilde ~, caret ^, or colon : anywhere.






# References
- https://docs.microsoft.com/en-us/rest/api/azure/devops/pipelines/runs/run-pipeline?view=azure-devops-rest-7.1
- https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate
- https://git-scm.com/docs/git-check-ref-format