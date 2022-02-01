
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true )][string]$organization,
    [Parameter(Mandatory = $true )][string]$project,
    [Parameter(Mandatory = $true )][string]$pipelineName,
    [Parameter(Mandatory = $false)][string]$repositories
)

Write-Host "-------------------------------------------------"
Write-Host "Starting pipeline run for organization[$organization] project[$project] pipeline[$pipelineName] repositories[$repositories]"

$pat = $env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN

if ($repositories) {
    $repositoriesSplit = $repositories -split "::"

    $repositoryResources = @{}

    foreach ($item in $repositoriesSplit) {

        $itemSplit = $item -split ":"

        $repositoryResources += @{
            "$($itemSplit[0])" = @{
                refName = "$($itemSplit[1])"
            }
        }
    }
}

if ($null -eq $pat -or "" -eq $pat) {
    Write-Error "Please set the environment variable 'AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN' to a personal access token with Build(read) permissions. Please see https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate."
}
else {
    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$pat"))

    $continuationtokenHeaderKey = "x-ms-continuationtoken"
    $continuationToken = $null
    $pipeline = $null

    while ($null -eq $pipeline) {
        $responsePipelines = Invoke-WebRequest `
                             -Headers @{Authorization = ("Basic $encodedPat") } `
                             -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines?orderby=name&`$top=100&continuationToken=$continuationToken&api-version=6.1-preview.1"

        $responsePipelinesParsed = (ConvertFrom-Json -InputObject $responsePipelines.Content)
        
        foreach ($item in $responsePipelinesParsed.value) {
            if ($item.name -ieq $pipelineName) {
                $pipeline = $item
            }
        }

        if ($responsePipelines.Headers.ContainsKey($continuationtokenHeaderKey) -eq $true -and $responsePipelines.Headers[$continuationtokenHeaderKey].length -gt 0) {
            $continuationToken = $responsePipelines.Headers[$continuationtokenHeaderKey][0]
        }
        else {
            break
        }
    }

    if ($null -eq $pipeline) {
        Write-Error "Failed to resolve pipeline[$pipelineName] in organization[$organization] and project[$project]."
    }
    else {
       

        if ($repositoryResources) {
            $requestBody = @{
                resources = @{
                    repositories = $repositoryResources
                }
            }
        }
        else {
            $requestBody = @{
            }
        }

        $body = ConvertTo-Json -Depth 100 $requestBody


        $responsePreview = Invoke-WebRequest `
                           -Method "POST" `
                           -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines/$($pipeline.Id)/runs?api-version=7.1-preview.1" `
                           -Headers @{Authorization = ("Basic $encodedPat") } `
                           -ContentType "application/json" `
                           -Body $body
      
        if ($responsePreview.StatusCode -ne 200) {
            throw "Starting pipeline run failed."
        }
        
        Write-Host "-------------------------------------------------"
        Write-Host "Started  pipeline run for organization[$organization] project[$project] pipeline[$pipelineName]"
        if ($repositoryResources) {
            Write-Host "with"
            Write-Host  $body        
        }
        Write-Host "-------------------------------------------------"
        Write-Host $responsePreview.Content        
        Write-Host "-------------------------------------------------"
    }
}