
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true )][string]$organization,
    [Parameter(Mandatory = $true )][string]$project,
    [Parameter(Mandatory = $true )][string]$pipelineName
)

$pat = $env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN

if ($null -eq $pat -or "" -eq $pat) {
    Write-Error "Please set the environment variable 'AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN' to a personal access token with Build(read) permissions. Please see https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate."
}
else {
    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$pat"))

    $continuationtokenHeaderKey="x-ms-continuationtoken"
    $continuationToken=$null
    $pipeline = $null

    while ($null -eq $pipeline) {
        $responsePipelines = Invoke-WebRequest -Headers @{Authorization = ("Basic $encodedPat") } -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines?orderby=name&`$top=100&continuationToken=$continuationToken&api-version=6.1-preview.1"
        $responsePipelinesParsed = (ConvertFrom-Json -InputObject $responsePipelines.Content)
        
        foreach($item in $responsePipelinesParsed.value){
            if($item.name -ieq $pipelineName)
            {
                $pipeline=$item
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
        $responsePreview = Invoke-WebRequest `
            -Method "POST" `
            -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines/$($pipeline.Id)/preview?api-version=6.1-preview.1" `
            -Headers @{Authorization = ("Basic $encodedPat") } `
            -ContentType "application/json" `
            -Body "{previewRun: true}"
        $filename="$($organization)__$($project)__$($pipeline.name)__$($pipeline.Id)__$(Get-Date -Format "yyyyMMdd__HHmmss").yaml"

        (ConvertFrom-Json -InputObject $responsePreview.Content).finalYaml | Out-File $filename

        Write-Host "Persisted final yaml preview of $organization/$project/$pipelineName to $filename."
    }
}