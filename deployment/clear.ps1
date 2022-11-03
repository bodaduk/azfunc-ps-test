param(

    [string]
    $subscription,

    [string]
    $assetPrefix

)

$asset = "$assetPrefix-func"

$account = az account show | ConvertFrom-Json -Depth 2
if (!($account -and $account.name -eq $subscription)) {
    az login
    az account set -s $subscription
}

$principalId = & az functionapp identity show --resource-group $asset --name $asset --query 'principalId' --output tsv
az role assignment delete --assignee $principalId --role 'Reader'

az group delete --name $asset

az logout
