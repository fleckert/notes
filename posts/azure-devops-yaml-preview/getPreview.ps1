
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

    $responsePipelines = Invoke-WebRequest -Headers @{Authorization = ("Basic $encodedPat") } -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines?api-version=6.1-preview.1"

    $pipelines = (ConvertFrom-Json -InputObject $responsePipelines.Content)

    # todo handle continuation token

    $pipeline = $null

    foreach ($item in $pipelines.value) {
        if ($item.name -ieq $pipelineName) {
            $pipeline = $item
            break
        }
    }

    if ($null -eq $pipeline) {
        Write-Error "Failed to resolve $pipelineName in organization[$organization] and project[$project]."
    }
    else {
        $responsePreview = Invoke-WebRequest `
            -Method "POST" `
            -Uri "https://dev.azure.com/$organization/$project/_apis/pipelines/$($pipeline.Id)/preview?api-version=6.1-preview.1" `
            -Headers @{Authorization = ("Basic $encodedPat") } `
            -ContentType "application/json" `
            -Body "{previewRun: true}"
        
        (ConvertFrom-Json -InputObject $responsePreview.Content).finalYaml | Out-File "$($organization)__$($project)__$($pipeline.name)__$($pipeline.Id)__$(Get-Date -Format "yyyyMMdd__HHmmss").yaml"
    }
}