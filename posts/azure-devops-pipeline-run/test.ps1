# $organization = "schwarzit"
# $project = "lidl.wawi-core"
# $pipelineName = "lidl-wawi-ivm-inbound-deploy"
# $pat = "htl5pzd3lv3j7jc2kmoagsytiywj7plarajsgd4d5zwgrafma23q"


# $repositories ="globalConfiguration:refs/heads/main::deploymentConfiguration:refs/tags/v2.3"

$env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN = "htl5pzd3lv3j7jc2kmoagsytiywj7plarajsgd4d5zwgrafma23q"
$env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN = "f76etokgf4qd45duvrixtqxsjosluefwtebky4bi34rzd3wvj63a"

./runPipeline.ps1 -organization schwarzit -project "lidl.wawi-core" -pipelineName "lidl-wawi-ivm-inbound-deploy" #-repositories "globalConfiguration:refs/heads/main::deploymentConfiguration:refs/tags/v2.3"